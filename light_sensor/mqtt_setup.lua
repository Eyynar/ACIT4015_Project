--- MQTT client config

local module = {}

sensor_readings = require("sensor_readings")

broker = GLOBAL.config.MQTT.host
broker_port = GLOBAL.config.MQTT.port
secure_connection = false

local function publish_sensor_data(client)
    publish_topic = "sensors/light"
    message = sensor_readings.get_sensor_reading()

    client:publish(publish_topic, message, 0, 0, function(client) 
        print("Message sent: " .. message .. " on topic: " .. publish_topic .. "\n") 
    end)

end

function module.mqtt_init()
    mqtt_client = mqtt.Client("ClientPublishLight", 120)

    mqtt_client:connect(broker, broker_port, secure_connection, function(client)
        print("MQTT client connected.")

        timer = tmr.create()
        timer:alarm(330, tmr.ALARM_AUTO, function(timer) publish_sensor_data(client) end)

    end,
    function(client, reason)
        print("Connection  failed for reason: " .. reason)
    end)

end

return module