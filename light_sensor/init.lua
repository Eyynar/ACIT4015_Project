--- Main file to run the entire configuration and setup of both WiFi, MQTT and setup of sensors/lights.

-- Initialize ADC, then restart if neccesary
if adc.force_init_mode(adc.INIT_ADC)
then
    node.restart()
    return 
end

GLOBAL = {}

GLOBAL.secrets = require("secrets")
GLOBAL.config = require("config")
GLOBAL.wifi = require("wifi_setup")

gpio.mode(GLOBAL.config.PIN.sensor_pin, gpio.INPUT)

GLOBAL.wifi.wifi_init()