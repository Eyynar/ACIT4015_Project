module = {}

function module.get_sensor_reading()
    value = gpio.read(GLOBAL.config.PIN.sensor_pin)

    return value
end

return module