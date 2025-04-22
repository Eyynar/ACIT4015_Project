--- MQTT client config

local module = {}

light_control = require("light_control")

broker = GLOBAL.config.MQTT.host
broker_port = GLOBAL.config.MQTT.port
secure_connection = false

function module.mqtt_init()
    mqtt_client = mqtt.Client("ClientSubscribe", 120)

    mqtt_client:connect(broker, broker_port, secure_connection, function(client)
        print("MQTT client connected.")

        client:subscribe("control/lights", 0, function(client)
            print("Subscribed sucessfully.")
        end)

        client:on("message",  function(client, topic, message)  
            print("Revieved message: " .. message .. " on topic: " .. topic)
            
            if ((message == '1') or (message == '0')) then
                light_control.set_light_mode(message)
                GLOBAL.config.PIN.light_mode = message
            end
        end)

    end,
    function(client, reason)
        print("Connection  failed for reason: " .. reason)
    end)

end

return module