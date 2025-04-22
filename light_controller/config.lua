--- Basic WiFi and MQTT configuration. This is the same for all of the microcontrollers, and is therefore collected in the same file to be run on all of them.

local module = {}

--- WiFi configuration
module.WIFI = {}
module.WIFI.mode = wifi.STATION
module.WIFI.CONFIG = {}
module.WIFI.CONFIG.ssid = "<SSID>"
module.WIFI.CONFIG.pwd = GLOBAL.secrets.WIFIPASS

--- MQTT configuration
module.MQTT = {}
module.MQTT.host = "test.mosquitto.org"
module.MQTT.port = 1883
module.MQTT.user = ""
module.MQTT.passwd = GLOBAL.secrets.MQTTPASS

-- Pin configuration

module.PIN = {}
module.PIN.light_pin = 4
module.PIN.light_mode = 1 -- Light-PIN initially HIGH, lights start turned off.

return module