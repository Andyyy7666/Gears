------------------------------------------------------------------------
------------------------------------------------------------------------
--			DO NOT EDIT IF YOU DON'T KNOW WHAT YOU'RE DOING			  --
--     							 									  --
--	   For support join my discord: https://discord.gg/Z9Mxu72zZ6	  --
------------------------------------------------------------------------
------------------------------------------------------------------------

gearText = config.Ptext
gear = 1
toggle = GetResourceKvpInt("gears")

function SetGear(gearOption)
    spd = GetEntitySpeed(veh) * 2.236936
    rpm = GetVehicleCurrentRpm(veh)
    if gearOption == 1 then
        gearText = config.Ptext
        SetVehicleHandbrake(veh, true)
    else
        SetVehicleHandbrake(veh, false)
    end
    if gearOption == 2 then
        gearText = config.Rtext
        if IsControlPressed(0, 72) or IsControlPressed(0, 71) or IsControlPressed(0, 133) or IsControlPressed(0, 134) then -- S
            SetVehicleControlsInverted(veh, true)
        else
            SetVehicleControlsInverted(veh, false)
        end
        if spd < 1.0 and IsControlPressed(0, 72) then
            SetVehicleCurrentRpm(veh, rpm - rpm)
            SetVehicleBrake(veh, true)
            SetVehicleForwardSpeed(GetVehiclePedIsIn(ped, false), 0)
        end
    elseif gearOption == 3 then
        SetVehicleControlsInverted(veh, false)
        gearText = config.Ntext
        DisableControlAction(0, 71, true) -- W
        if spd < 1.0 and IsControlPressed(0, 72) then
            SetVehicleCurrentRpm(veh, rpm - rpm)
            SetVehicleBrake(veh, true)
            SetVehicleForwardSpeed(GetVehiclePedIsIn(ped, false), 0)
        end
    elseif gearOption == 4 then
        SetVehicleControlsInverted(veh, false)
        gearText = config.Dtext
        if not IsControlPressed(0, 71) then -- W
            if (spd < 3.5) and (not IsControlPressed(0, 72)) and config.enableCarAutoRollOnDrive then
                SetVehicleForwardSpeed(GetVehiclePedIsIn(ped, false), 1.5)
            end
        end
        if spd < 1.0 and IsControlPressed(0, 72) then
            SetVehicleCurrentRpm(veh, rpm - rpm)
            SetVehicleBrake(veh, true)
            SetVehicleForwardSpeed(GetVehiclePedIsIn(ped, false), 0)
        end
    elseif gearOption == 5 then
        SetVehicleControlsInverted(veh, false)
        gearText = config.Stext
        if not IsControlPressed(0, 71) then -- W
            if (spd < 3.5) and (not IsControlPressed(0, 72)) and config.enableCarAutoRollOnDrive then
                SetVehicleForwardSpeed(GetVehiclePedIsIn(ped, false), 1.5)
            end
        else
            if spd > 3.5 then
                SetVehicleCurrentRpm(veh, rpm - 0.002)
                SetVehicleCurrentRpm(veh, rpm + 0.01)
                SetVehicleCheatPowerIncrease(veh, 2.0)
            end
        end
        if spd < 1.0 and IsControlPressed(0, 72) then
            SetVehicleCurrentRpm(veh, rpm - rpm)
            SetVehicleBrake(veh, true)
            SetVehicleForwardSpeed(GetVehiclePedIsIn(ped, false), 0)
        end
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(50)
        if toggle == 1 then
            ped = PlayerPedId()
            veh = GetVehiclePedIsIn(ped, false)
            inVeh = IsPedInVehicle(ped, veh, false)
            
            if inVeh then
                SetGear(gear)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if toggle == 1 then
            if inVeh then
                Text(gearText, config.textX, config.textY, config.textScale)
            end
        end
    end
end)

RegisterCommand('+gear1', function()
    if inVeh and toggle == 1 then
        if gear == 1 then
            gear = gear
        else
            gear = gear - 1
        end
    end
end, false)
RegisterCommand('+gear2', function()
    if inVeh and toggle == 1 then
        if gear == 5 then
            gear = gear
        else
            gear = gear + 1
        end
    end
end, false)

RegisterKeyMapping('+gear1', 'Change Gear (up)', 'keyboard', 'pageup')
RegisterKeyMapping('+gear2', 'Change Gear (down)', 'keyboard', 'pagedown')

RegisterCommand("gears", function(source, args, rawCommand)
    if toggle == 1 then
        SetResourceKvpInt("gears", 0)
    else
        SetResourceKvpInt("gears", 1)
    end
    toggle = GetResourceKvpInt("gears")
end, false)

TriggerEvent('chat:addSuggestion', '/gears', 'Toggle Gears', {})

function Text(text, x, y, scale)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextOutline()
	SetTextJustification(0)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end
