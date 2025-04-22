--- Main file to run the entire configuration and setup of both WiFi, MQTT and setup of sensors/lights.

GLOBAL = {}

GLOBAL.secrets = require("secrets")
GLOBAL.config = require("config")
GLOBAL.wifi = require("wifi_setup")

gpio.mode(GLOBAL.config.PIN.light_pin, gpio.OUTPUT)
gpio.write(GLOBAL.config.PIN.light_pin, GLOBAL.config.PIN.light_mode)
GLOBAL.wifi.wifi_init()