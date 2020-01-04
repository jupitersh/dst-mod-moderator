local tonumber = GLOBAL.tonumber

if not (GLOBAL.TheNet and GLOBAL.TheNet:GetIsServer()) then return end

modimport("moderator")

local _Networking_Say = GLOBAL.Networking_Say

GLOBAL.Networking_Say = function(guid, userid, name, prefab, message, colour, whisper, isemote, ...)
    _Networking_Say(guid, userid, name, prefab, message, colour, whisper, isemote, ...)
    if not whisper then
        for k,v in pairs(moderator) do
            if v == userid then
                if string.sub(message,1,1) == "+" then
                    --回档默认
                    if  string.sub(message,1,9) == "+rollback" and string.len(message) == 9 then
                        GLOBAL.TheWorld:DoTaskInTime(5, function(world)
                            if world.ismastersim then
                                GLOBAL.TheNet:SendWorldRollbackRequestToServer(1)
                            end
                        end)
                    end
                    --回档按天数
                    if  string.sub(message,1,9) == "+rollback" and string.len(message) == 10 and string.sub(message,10,10) ~= "0" and tonumber(string.sub(message,10,10)) ~= nil then
                        if tonumber(string.sub(message,10,10)) <= 5 then
                            GLOBAL.TheWorld:DoTaskInTime(5, function(world)
                                if world.ismastersim then
                                    GLOBAL.TheNet:SendWorldRollbackRequestToServer(tonumber(string.sub(message,10,10)))
                                end
                            end)
                        end
                    end
                    --踢人
                    if  string.sub(message,1,5) == "+kick" then
                        if string.len(message) == 6 and string.sub(message,6,6) ~= "0" and tonumber(string.sub(message,6,6)) ~= nil then
                            GLOBAL.TheWorld:DoTaskInTime(1, function(world)
                                if world.ismastersim then
                                    GLOBAL.TheNet:Kick(GLOBAL.UserToClientID(tonumber(string.sub(message,6,6))))
                                end
                            end)
                        end
                        if string.len(message) == 7 and string.sub(message,6,7) ~= "00" and tonumber(string.sub(message,6,7)) ~= nil then
                            GLOBAL.TheWorld:DoTaskInTime(1, function(world)
                                if world.ismastersim then
                                    GLOBAL.TheNet:Kick(GLOBAL.UserToClientID(tonumber(string.sub(message,6,7))))
                                end
                            end)
                        end
                    end
                    --Ban人
                    if  string.sub(message,1,4) == "+ban" then
                        if string.len(message) == 5 and string.sub(message,5,5) ~= "0" and tonumber(string.sub(message,5,5)) ~= nil then
                            GLOBAL.TheWorld:DoTaskInTime(1, function(world)
                                if world.ismastersim then
                                    GLOBAL.TheNet:Ban(GLOBAL.UserToClientID(tonumber(string.sub(message,5,5))))
                                end
                            end)
                        end
                        if string.len(message) == 6 and string.sub(message,5,6) ~= "00" and tonumber(string.sub(message,5,6)) ~= nil then
                            GLOBAL.TheWorld:DoTaskInTime(1, function(world)
                                if world.ismastersim then
                                    GLOBAL.TheNet:Ban(GLOBAL.UserToClientID(tonumber(string.sub(message,5,6))))
                                end
                            end)
                        end
                    end
                end
            end
        end
    end
end