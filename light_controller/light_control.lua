local module = {}

function module.set_light_mode(mode)
    if (mode ~= GLOBAL.config.PIN.light_mode) then
        print("Writing value: " .. mode .. " to pin " ..  GLOBAL.config.PIN.light_pin)
        gpio.write(GLOBAL.config.PIN.light_pin, mode)
    else
        print("New light mode is the same as previous mode, doing nothing.")
    end
end

return module