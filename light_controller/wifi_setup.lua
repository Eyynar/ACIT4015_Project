-- WiFi

local module = {}

MQTT = require("mqtt_setup")

function module.wifi_init()

    wifi.setmode(GLOBAL.config.WIFI.mode)
    wifi.sta.config(GLOBAL.config.WIFI.CONFIG)
    wifi.sta.sleeptype(wifi.NONE_SLEEP)

end


--- Events for printing statuses, and for initializing MQTT when the device gets an IP
wifi.eventmon.register(wifi.eventmon.STA_CONNECTED, function(T)
    print("\n\tSTA - CONNECTED".."\n\tSSID: "..T.SSID.."\n\tBSSID: "..
    T.BSSID.."\n\tChannel: "..T.channel)
end)

wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, function(T)
    print("\n\tSTA - DISCONNECTED".."\n\tSSID: "..T.SSID.."\n\tBSSID: "..
    T.BSSID.."\n\treason: "..T.reason)
end)

wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, function(T)
    print("\n\tSTA - GOT IP".."\n\tStation IP: "..T.IP.."\n\tSubnet mask: "..
    T.netmask.."\n\tGateway IP: "..T.gateway)

    MQTT.mqtt_init()
end)

return module