import paho.mqtt.client as mqtt
from datetime import datetime

subscribe_topics = ["sensors/movement", "sensors/light"]
movement_values = []
light_values = []

# Toggles to choose which sensors will be analysed.
analyse_light_data = True
analyse_movement_data = True

# Function that sends control-commands to the light-controller.
def set_light_mode(client, light_mode):
    print(f"Setting lights to mode: {light_mode}")
    client.publish("control/lights", light_mode)


start_time = datetime.now()
def start_timer():
    global start_time # This is not a good way to do it, but it works
    start_time = datetime.now()
    print(f"(Re)Started timer - {start_time.strftime("%X")}")

# Function that checks if the timer has expired
def timer_expired():
    current_time = datetime.now()
    elapsed_time = current_time - start_time

    print(f"Elapsed time: {elapsed_time.seconds}")

    if elapsed_time.seconds >= 60:
        start_timer()
        return True
    else:
        return False

motion_detected = False
def analyze_movement_data(client, data):

    global motion_detected # Again, not a good way to do it, but it works
    if sum(data) >= 2:
        set_light_mode(client, 0)
        motion_detected = True
        start_timer()

    elif timer_expired():
        set_light_mode(client, 1)
        motion_detected = False


def analyze_light_data(client, data):

    avg = sum(data) / len(data)

    if avg <= 7:
        set_light_mode(client, 0)

    elif not motion_detected:
        set_light_mode(client, 1)


# The on_subscribe, on_unsubscribe, on_message and on_connect functions are based on / taken from
# the paho-mqtt PyPI page, under "Subscriber Example". URL: https://pypi.org/project/paho-mqtt/

def on_subscribe(client, userdata, mid, reason_code_list, properties):
        if reason_code_list[0].is_failure:
            print(f"Broker rejected you subscription: {reason_code_list[0]}")
        else:
            print(f"Broker granted the following QoS: {reason_code_list[0].value}")


def on_unsubscribe(client, userdata, mid, reason_code_list, properties):
    if len(reason_code_list) == 0 or not reason_code_list[0].is_failure:
        print("unsubscribe succeeded (if SUBACK is received in MQTTv3 it success)")
    else:
        print(f"Broker replied with failure: {reason_code_list[0]}")
        
    client.disconnect()

# Most of the contents of this function has been changed from the example code
def on_message(client, userdata, message):

    # Add message values to respective lists only if analysis is enabled
    if (message.topic == "sensors/movement") and analyse_movement_data:
        movement_values.append(int(message.payload))
    
    elif (message.topic == "sensors/light") and analyse_light_data:
        light_values.append(int(message.payload))
    
    # Run analysis functions and then clear lists when there are 10 elements in the lists
    if len(movement_values) >= 10:
        analyze_movement_data(client, movement_values)
        movement_values.clear()

    if len(light_values) >= 10:
        analyze_light_data(client, light_values)
        light_values.clear()



def on_connect(client, userdata, flags, reason_code, properties):
    if reason_code.is_failure:
        print(f"Failed to connect: {reason_code}. loop_forever() will retry connection")
    else:
        client.subscribe(subscribe_topics[0])
        client.subscribe(subscribe_topics[1])


def main():
    try:
        mqttc = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)
        mqttc.on_connect = on_connect
        mqttc.on_message = on_message
        mqttc.on_subscribe = on_subscribe
        mqttc.on_unsubscribe = on_unsubscribe

        mqttc.connect("test.mosquitto.org")
        mqttc.loop_forever()

    except:
        print("Exiting.")
        mqttc.unsubscribe(subscribe_topics)


if __name__ == "__main__":
    main()