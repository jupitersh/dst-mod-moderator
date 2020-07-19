local tonumber = GLOBAL.tonumber

if not (GLOBAL.TheNet and GLOBAL.TheNet:GetIsServer()) then return end

modimport("moderator")

local function NotInList(str)
    for k,v in pairs(moderator) do
        if str == v then
            return false
        end
    end
    return true
end

local _Networking_Say = GLOBAL.Networking_Say

GLOBAL.Networking_Say = function(guid, userid, name, prefab, message, colour, whisper, isemote, ...)
    _Networking_Say(guid, userid, name, prefab, message, colour, whisper, isemote, ...)
    if not whisper then
        if string.sub(message,1,1) == "+" then
            for k,v in pairs(moderator) do
                if v == userid then
                    --回档默认
                    if  string.sub(message,1,9) == "+rollback" and string.len(message) == 9 then
                        GLOBAL.TheWorld:DoTaskInTime(5, function(world)
                            if world.ismastersim and not GLOBAL.TheShard:IsSecondary() then
                                GLOBAL.TheNet:SendWorldRollbackRequestToServer(0)
                            end
                        end)
                    end
                    --回档按天数
                    if  string.sub(message,1,9) == "+rollback" and string.len(message) == 10 and string.sub(message,10,10) ~= "0" and tonumber(string.sub(message,10,10)) ~= nil then
                        if tonumber(string.sub(message,10,10)) <= 5 then
                            GLOBAL.TheWorld:DoTaskInTime(5, function(world)
                                if world.ismastersim and not GLOBAL.TheShard:IsSecondary() then
                                    GLOBAL.TheNet:SendWorldRollbackRequestToServer(tonumber(string.sub(message,10,10)))
                                end
                            end)
                        end
                    end
                    --Ban人
                    if  string.sub(message,1,4) == "+ban" and string.len(message) >= 5 and string.sub(message,5,-1) ~= nil then
                        for i, j in ipairs(GLOBAL.AllPlayers) do
                            if string.find(j.name, string.sub(message,5,-1)) and NotInList(j.userid) then
                                GLOBAL.TheWorld:DoTaskInTime(0, function(world)
                                    if world.ismastersim then
                                        GLOBAL.TheNet:Ban(j.userid)
                                    end
                                end)
                            end
                        end
                    end
                    --kill
                    if  string.sub(message,1,5) == "+kill" and string.len(message) >= 6 and string.sub(message,6,-1) ~= nil then
                        for i, j in ipairs(GLOBAL.AllPlayers) do
                            if string.find(j.name, string.sub(message,6,-1)) and NotInList(j.userid) then
                                if j.components and j.components.health then
                                    j.components.health:Kill()
                                end
                            end
                        end
                    end
                    --先kill再ban
                    if  string.sub(message,1,5) == "+kban" and string.len(message) >= 6 and string.sub(message,6,-1) ~= nil then
                        for i, j in ipairs(GLOBAL.AllPlayers) do
                            if string.find(j.name, string.sub(message,6,-1)) and NotInList(j.userid) then
                                if j.components and j.components.health then
                                    j.components.health:Kill()
                                end
                                GLOBAL.TheWorld:DoTaskInTime(5, function(world)
                                    if world.ismastersim then
                                        GLOBAL.TheNet:Ban(j.userid)
                                    end
                                end)
                            end
                        end
                    end
                end
            end
        end
    end
end
