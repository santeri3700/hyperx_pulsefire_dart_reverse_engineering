ngenuity2_proto = Proto("ngenuity2", "NGenuity2 protocol")

pkt_direction = Field.new("usb.endpoint_address.direction")

local pkt_types = {
    [0xD0] = "Set polling rate",
    [0xD1] = "Set low-power warning threshold"
    [0xD2] = "Set LED data",
    [0xD3] = "Set DPI data",
    [0xD4] = "Set button assignment",
    [0xD5] = "Set macro assignment",
    [0xD6] = "Set macro data",
    [0xDE] = "Save settings",
    [0x46] = "Connectivity status",
    [0x50] = "Hardware information",
    [0x51] = "Status",
    [0x52] = "LED data",
    [0xFF] = "Event"
}

local pkt_dirs = {
    [0] = "Request",
    [1] = "Response"
}

local battery_statuses = {
    [0x00] = "Discharging",
    [0x01] = "Charging"
}

local connectivity_statuses = {
    [0x00] = "Wireless connection not established (mouse is off or sleeping)",
    [0x01] = "Wireless connection established"
}

local led_zones = {
    [0x00] = "Logo",
    [0x10] = "Scroll",
    [0x20] = "Both"
}

local led_effects = {
    [0x00] = "Static",
    [0x10] = "Spectrum Cycle (unofficial)",
    [0x12] = "Spectrum Cycle (official)",
    [0x20] = "Breathing",
    [0x30] = "Trigger Fade"
}

local dpi_profile_settings = {
    [0x00] = "Select active DPI profile",
    [0x01] = "Set enabled DPI profiles",
    [0x02] = "Set DPI profile value",
    [0x03] = "Set DPI profile change effect color"
}

local physical_buttons = {
    [0x00] = "Left mouse button",
    [0x01] = "Right mouse button",
    [0x02] = "Middle mouse button",
    [0x03] = "Forward button",
    [0x04] = "Back button",
    [0x05] = "DPI button"
}

local button_assignment_types = {
    [0x01] = "Mouse function",
    [0x02] = "Keyboard function",
    [0x03] = "Media function",
    [0x04] = "Macro function",
    [0x07] = "DPI switcher"
}

local vendor_ids = {
    [0x0951] = "Kingston Technology"
}

local product_ids = {
    [0x16e1] = "HyperX Pulsefire Dart (Wireless dongle)",
    [0x16e2] = "HyperX Pulsefire Dart (Wired connection)"
}

local fields = ngenuity2_proto.fields

-- Fields
fields.pkt_type = ProtoField.uint8("ngenuity2.pkt_type", "Packet type", base.HEX, pkt_types)
fields.pkt_dir = ProtoField.uint8("ngenuity2.pkt_dir", "Packet direction", base.DEC, pkt_dirs)
fields.props_len = ProtoField.uint8("ngenuity2.props_len", "Properties length", base.DEC)
--- Hardware fields
fields.hardware_product_id = ProtoField.uint8("ngenuity2.hardware.product_id", "Product ID", base.HEX, product_ids)
fields.hardware_vendor_id = ProtoField.uint8("ngenuity2.hardware.vendor_id", "Vendor ID", base.HEX, vendor_ids)
fields.hardware_product_name = ProtoField.string("ngenuity2.hardware.product_name", "Product Name", base.STR)
--- Firmware fields
fields.firmware_version_major = ProtoField.uint8("ngenuity2.firmware_version.major", "Firmware Major Version", base.DEC)
fields.firmware_version_minor = ProtoField.uint8("ngenuity2.firmware_version.minor", "Firmware Minor Version", base.DEC)
fields.firmware_version_revision = ProtoField.uint8("ngenuity2.firmware_version.revision", "Firmware Revision", base.DEC)
fields.firmware_version_build = ProtoField.uint8("ngenuity2.firmware_version.build", "Firmware Build", base.DEC)
--- Status fields
fields.status_battery_level = ProtoField.uint8("ngenuity2.status.battery.level", "Battery level", base.DEC)
fields.status_battery_status = ProtoField.uint8("ngenuity2.status.battery.status", "Battery status", base.DEC, battery_statuses)
fields.status_connectivity_status = ProtoField.uint8("ngenuity2.status.connectivity.status", "Connectivity status", base.DEC, connectivity_statuses)
--- 
--- LED fields
fields.led_color_red1 = ProtoField.uint8("ngenuity2.led.color.red1", "LED Red1", base.DEC)
fields.led_color_green1 = ProtoField.uint8("ngenuity2.led.color.green1", "LED Green1", base.DEC)
fields.led_color_blue1 = ProtoField.uint8("ngenuity2.led.color.blue1", "LED Blue1", base.DEC)
fields.led_color_red2 = ProtoField.uint8("ngenuity2.led.color.red2", "LED Red2", base.DEC)
fields.led_color_green2 = ProtoField.uint8("ngenuity2.led.color.green2", "LED Green2", base.DEC)
fields.led_color_blue2 = ProtoField.uint8("ngenuity2.led.color.blue2", "LED Blue2", base.DEC)
fields.led_zone = ProtoField.uint8("ngenuity2.led.zone", "LED Zone", base.DEC, led_zones)
fields.led_effect = ProtoField.uint8("ngenuity2.led.effect", "LED Effect", base.DEC, led_effects)
fields.led_brightness = ProtoField.uint8("ngenuity2.led.brightness", "LED Brightness", base.DEC)
fields.led_effect_speed = ProtoField.uint8("ngenuity2.led.effect.speed", "LED Effect Speed", base.DEC)
--- DPI fields
fields.dpi_profile_num = ProtoField.uint8("ngenuity2.dpi.profile.number", "DPI Profile Number", base.DEC)
fields.dpi_profile_value = ProtoField.uint8("ngenuity2.dpi.profile.value", "DPI Profile Value", base.DEC)
fields.dpi_setting = ProtoField.uint8("ngenuity2.dpi.profile.setting", "DPI Profile Setting", base.DEC, dpi_profile_settings)
-- Button fields
fields.physical_button = ProtoField.uint8("ngenuity.button.physical", "Physical button", base.DEC, physical_buttons)
fields.button_assignment_type = ProtoField.uint8("ngenuity.button.assignment.type", "Button assignment type", base.DEC, button_assignment_types)
fields.button_assignment_value = ProtoField.uint8("ngenuity.button.assignment.value", "Button assignment value", base.DEC)
fields.button_assignment_value2 = ProtoField.uint8("ngenuity.button.assignment.value2", "Button assignment value2/Unknown", base.DEC)

local function tobinarystring(number)
	binary_string = ""
	while number~=1 and number~=0 do
		binary_string = tostring(number % 2) .. binary_string
		number = math.modf(number / 2)
	end
	return tostring(number) .. binary_string
end

function ngenuity2_proto.dissector(buffer, pinfo, tree)
    -- NGenuity2 packets contain 64 bytes.
    if buffer:len() ~= 64 then
        return
    end

    local pkt_dir = pkt_direction().value
    local pkt_type = buffer(0, 1)
    local props_len = buffer(3, 1)
    pinfo.cols["protocol"] = "NGenuity2"

    local t_ngenuity2 = tree:add(ngenuity2_proto, buffer())

    t_ngenuity2:add(fields.pkt_dir, pkt_dir)
    t_ngenuity2:add(fields.pkt_type, pkt_type)

    pkt_type = pkt_type:uint()
    if pkt_types[pkt_type] ~= nil then
        pinfo.cols["info"] = tostring(pkt_types[pkt_type]) .. " " .. tostring(pkt_dirs[pkt_dir])
        if props_len:uint() > 0 then
            t_ngenuity2:add_le(fields.props_len, props_len)
            pinfo.cols["info"]:append(": ")
        end
    else
        pinfo.cols["info"] = "Unknown " .. tostring(pkt_dirs[pkt_dir]) .. " (" .. string.format("%02X", pkt_type) .. ")"
    end

    
    -- Packet type = Connectivity status (0x46)
    if pkt_type == 0x46 then
        if props_len:uint() == 0 then
            return -- No data
        end
        
        if props_len:uint() == 1 then
            -- Wireless
            local connection_status = buffer(4, 1)
            t_ngenuity2:add_le(fields.status_connectivity_status, connection_status)
            pinfo.cols["info"]:append(tostring(connectivity_statuses[connection_status:uint()]))
        elseif props_len:uint() == 2 then
            -- Wired
            local connection_status = buffer(4, 2)
            pinfo.cols["info"]:append("Wired connection (" .. tostring(connection_status) .. ")")
        else
            -- Unknown
            pinfo.cols["info"]:append("Unknown data")
        end
    -- Packet type = Hardware information (0x50)
    elseif pkt_type == 0x50 then
        if props_len:uint() == 0 then
            return -- No data
        end

        if buffer(1, 1):uint() ~= 0x00 then
            pinfo.cols["info"]:append("Unknown data")
            return -- Unknown data
        end

        local product_id = buffer(4, 2)
        local vendor_id = buffer(6, 2)
        local firmware_build = buffer(8, 1)
        local firmware_revision = buffer(9, 1)
        local firmware_minor = buffer(10, 1)
        local firmware_major = buffer(11, 1)
        local product_name = buffer(12, (props_len:uint() - 8)) -- FIXME: Do offset calc

        t_ngenuity2:add_le(fields.hardware_product_id, product_id)
        t_ngenuity2:add_le(fields.hardware_vendor_id, vendor_id)
        t_ngenuity2:add_le(fields.firmware_version_build, firmware_build)
        t_ngenuity2:add_le(fields.firmware_version_revision, firmware_revision)
        t_ngenuity2:add_le(fields.firmware_version_minor, firmware_minor)
        t_ngenuity2:add_le(fields.firmware_version_major, firmware_major)
        t_ngenuity2:add(fields.hardware_product_name, product_name)

        pinfo.cols["info"]:append("Model: " .. product_name:string() .. ", Vendor ID: " .. string.format('%04x', vendor_id:le_int()) .. ", Product ID: " .. string.format('%04x', product_id:le_int()) .. ", Firmware version: " .. table.concat({firmware_major:uint(), firmware_minor:uint(), firmware_revision:uint(), firmware_build:uint()}, ".")) -- Packet type = Status (0x51)
    elseif pkt_type == 0x51 then
        if props_len:uint() == 0 then
            return -- No data
        end

        local battery_level = buffer(4, 1):uint()
        local battery_status = buffer(5, 1):uint()
        t_ngenuity2:add_le(fields.status_battery_level, battery_level)
        t_ngenuity2:add_le(fields.status_battery_status, battery_status)
        pinfo.cols["info"]:append("Battery " .. tostring(battery_level) .. "% (" .. tostring(battery_statuses[battery_status]) .. ")")
    -- Packet type = Set LED (0xD2)
    elseif pkt_type == 0xD2 then
        if props_len:uint() == 0 then
            return -- No data
        end

        local led_zone = buffer(1, 1)
        local led_effect = buffer(2, 1)
        local red1 = buffer(4, 1)
        local green1 = buffer(5, 1)
        local blue1 = buffer(6, 1)
        local red2 = buffer(7, 1)
        local green2 = buffer(8, 1)
        local blue2 = buffer(9, 1)
        local led_brightness = buffer(10, 1)
        local led_effect_speed = buffer(11, 1)

        t_ngenuity2:add_le(fields.led_zone, led_zone)
        t_ngenuity2:add_le(fields.led_effect, led_effect)
        t_ngenuity2:add_le(fields.led_effect_speed, led_effect_speed)
        t_ngenuity2:add_le(fields.led_brightness, led_brightness)

        t_ngenuity2:add_le(fields.led_color_red1, red1)
        t_ngenuity2:add_le(fields.led_color_green1, green1)
        t_ngenuity2:add_le(fields.led_color_blue1, blue1)
        t_ngenuity2:add_le(fields.led_color_red2, red2)
        t_ngenuity2:add_le(fields.led_color_green2, green2)
        t_ngenuity2:add_le(fields.led_color_blue2, blue2)

        pinfo.cols["info"]:append(tostring(led_zones[led_zone:uint()]) .. " = " .. tostring(led_effects[led_effect:uint()]) .. " " .. string.format( "#%02X%02X%02X", red1:uint(), green1:uint(), blue1:uint()) .. ", Brightness: " .. tostring(led_brightness:uint()) .. "%, Speed: " .. tostring(led_effect_speed:uint()) .. "%")
    -- Packet type = Set DPI (0xD3)
    elseif pkt_type == 0xD3 then
        local mode = buffer(1, 1)
        t_ngenuity2:add_le(fields.dpi_setting, mode)
        if mode:uint() == 0 then
            -- Select current DPI profile
            profile_num = buffer(4, 1)
            t_ngenuity2:add_le(fields.dpi_profile_num, profile_num)

            pinfo.cols["info"]:append(tostring(dpi_profile_settings[mode:uint()]) .. ": Profile \"" .. tostring(profile_num:uint()) .. "\"")

        elseif mode:uint() == 1 then
            -- Enabled DPI profiles
            -- TODO: Implement easier to understand value.
            enabled_profiles = buffer(4, 2)
            enabled_profiles = tobinarystring(enabled_profiles:le_uint())
            pinfo.cols["info"]:append("Enable DPI profiles: " .. tostring(enabled_profiles))
        elseif mode:uint() == 2 then
            value = buffer(4, 2)
            value = (value:le_int() * 50) -- Convert raw value to DPI number.
            profile_num = buffer(2, 1)
            t_ngenuity2:add_le(fields.dpi_profile_num, profile_num)
            t_ngenuity2:add(fields.dpi_profile_value, value)

            pinfo.cols["info"]:append(tostring(dpi_profile_settings[mode:uint()]) .. ": Profile \"" .. tostring(profile_num:uint()) .. "\" = " .. tostring(value) .. " DPI")
        elseif mode:uint() == 3 then
            profile_num = buffer(2, 1)
            red = buffer(4, 1)
            green = buffer(5, 1)
            blue = buffer(6, 1)
            pinfo.cols["info"]:append(tostring(dpi_profile_settings[mode:uint()]) .. ": Profile \"" .. tostring(profile_num:uint()) .. "\" = " .. string.format( "#%02X%02X%02X", red:uint(), green:uint(), blue:uint()))
        end
    -- Packet type = Set button assignment (0xD4)
    elseif pkt_type == 0xD4 then
        local physical_btn = buffer(1, 1)
        t_ngenuity2:add_le(fields.physical_button, physical_btn)

        local btn_assignment_type = buffer(2, 1)
        t_ngenuity2:add_le(fields.button_assignment_type, btn_assignment_type)

        local btn_assignment_value = buffer(4, 1)
        t_ngenuity2:add_le(fields.button_assignment_value, btn_assignment_value)

        local btn_assignment_value2 = buffer(5, 1)
        t_ngenuity2:add_le(fields.button_assignment_value2, btn_assignment_value2)

        pinfo.cols["info"]:append("Physical button \"" .. tostring(physical_buttons[physical_btn:uint()]) .. "\" = " .. tostring(button_assignment_types[btn_assignment_type:uint()]) .. " \"" .. tostring(btn_assignment_value) .. "\"")
    end
end

usb_table = DissectorTable.get("usb.interrupt")
usb_table:add(0x03, ngenuity2_proto)
usb_table:add(0xffff, ngenuity2_proto)
--usb_table:add(0xff00, ngenuity2_proto)
--usb_table:add(0xff13, ngenuity2_proto)