Config = {}

Config.Keys = {
    ['SPACE'] = 0xD9D0E1C0
}

local banks = {
    {name = 'Valentine Bank', sprite = -2128054417, id = 108, x = -308.49, y = 775.99, z = 117.8},--Valentine
    {name = 'Rhodes Bank', sprite = -2128054417, id = 108, x = 1292.48, y = -1301.74, z = 77.04},--Rhodes
    {name = 'Saint Denis Bank', sprite = -2128054417, id = 108, x = 2644.29, y = -1292.43, z = 52.24},--Saint Denis
    {name = 'Blackwater Bank', sprite = -2128054417, id = 108, x = -813.34, y = -1277.52, z = 43.63},--Saint Denis
}

RegisterCommand('bank', function(source)
    inMenu = false
    SetNuiFocus(false, false)
    SendNUIMessage({type = 'closeAll'})
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if(IsNearBank()) then
            local nearestBank = GetNearestBank()
            if nearestBank ~= nil then
                if not inMenu then
                    DrawTxt("Press [SPACE] to open the ~g~bank~s~ menu", 0.50, 0.90, 0.7, 0.7, true, 255, 255, 255, 255, true)
                end
            end
            
            atBank = true

            if IsControlJustReleased(0, Config.Keys["SPACE"]) then
                if (IsInVehicle()) then
                    TriggerEvent('chatMessage', "", {255, 0, 0}, "^1You cannot use the bank in a vehicle!");
                else
                    if inMenu then
                        inMenu = false
                        SetNuiFocus(false, false)
                        SendNUIMessage({type = 'closeAll'})
                    else
                        inMenu = true
                        SetNuiFocus(true, true)
                        SendNUIMessage({type = 'openGeneral'})
                        TriggerServerEvent('redemrp_banking:balance2')
                    end
                end
            end
        else
            if(inMenu) then
                inMenu = false
                SetNuiFocus(false, false)
                SendNUIMessage({type = 'closeAll'})
            end
            atBank = false
            inMenu = false
        end
    end
end)

-- Check if player is in a vehicle
function IsInVehicle()
    local ply = GetPlayerPed(-1)
    if IsPedSittingInAnyVehicle(ply) then
        return true
    else
        return false
    end
end

function IsNearBank()
    local ply = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(ply, 0)
    for _, item in ipairs(banks) do
        local pos = GetEntityCoords(PlayerPedId())
        local distance = Vdist(pos.x, pos.y, pos.z, item.x, item.y, item.z)
        if(distance < 1.5) then
            return true
        end
    end
end

-- Check if player is near a bank
function GetNearestBank()
    local ply = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(ply, 0)
    
    local bankDist = 1.5
    local nearestBank = nil

    for _, bank in pairs(banks) do
        local pos = GetEntityCoords(PlayerPedId())
        local distance = Vdist(pos.x, pos.y, pos.z, bank.x, bank.y, bank.z)
        if(distance < bankDist) then
            bankDist = distance
            nearestBank = bank
        end
    end

    return nearestBank
end

function DrawTxt(str, x, y, w, h, enableShadow, col1, col2, col3, a, centre)
    local str = CreateVarString(10, "LITERAL_STRING", str)
    SetTextScale(w, h)
    SetTextColor(math.floor(col1), math.floor(col2), math.floor(col3), math.floor(a))
	SetTextCentre(centre)
    if enableShadow then SetTextDropshadow(1, 0, 0, 0, 255) end
	Citizen.InvokeNative(0xADA9255D, 1);
    DisplayText(str, x, y)
end

--=================Deposit Event===================
local l_ 
local f_ 
RegisterNetEvent('currentbalance1')
AddEventHandler('currentbalance1', function(balance, namel, namef)
if namel ~= nil then
 l_ = namel
 f_ = namef
 end
	local playerName = f_.." "..l_

	SendNUIMessage({
		type = "balanceHUD",
		balance = balance,
		player = playerName
		})
end)

--=================Deposit Event======================

RegisterNUICallback('deposit', function(data)
	TriggerServerEvent('redemrp_banking:deposit', tonumber(data.amount))
end)


--==================Withdraw Event====================

RegisterNUICallback('withdrawl', function(data)
	TriggerServerEvent('redemrp_banking:withdraw', tonumber(data.amountw))
	
end)

RegisterNUICallback('transfer1', function(data)
print("poszlo")
print(data.firstname)
print(data.lastname)
	TriggerServerEvent('redemrp_banking:transfer1', tonumber(data.amountw) , data.firstname, data.lastname)
	
end)
--======================Balance Event======================

RegisterNUICallback('balance', function()
	TriggerServerEvent('redemrp_banking:balance')
end)


--======================NUIFocusoff======================

RegisterNUICallback('NUIFocusOff', function()
	inMenu = false
	SetNuiFocus(false, false)
	SendNUIMessage({type = 'closeAll'})
end)
