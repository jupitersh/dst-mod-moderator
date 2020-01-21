local tonumber = GLOBAL.tonumber

if not (GLOBAL.TheNet and GLOBAL.TheNet:GetIsServer()) then return end

modimport("moderator")

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
                            if world.ismastersim and not GLOBAL.TheShard:IsSlave() then
                                GLOBAL.TheNet:SendWorldRollbackRequestToServer(0)
                            end
                        end)
                    end
                    --回档按天数
                    if  string.sub(message,1,9) == "+rollback" and string.len(message) == 10 and string.sub(message,10,10) ~= "0" and tonumber(string.sub(message,10,10)) ~= nil then
                        if tonumber(string.sub(message,10,10)) <= 5 then
                            GLOBAL.TheWorld:DoTaskInTime(5, function(world)
                                if world.ismastersim and not GLOBAL.TheShard:IsSlave() then
                                    GLOBAL.TheNet:SendWorldRollbackRequestToServer(tonumber(string.sub(message,10,10)))
                                end
                            end)
                        end
                    end
                    --Ban人
                    if  string.sub(message,1,4) == "+ban" and string.len(message) >= 5 and string.sub(message,5,-1) ~= nil then
                        for i, v in ipairs(GLOBAL.AllPlayers) do
                            if string.find(v.name, string.sub(message,5,-1)) then
                                GLOBAL.TheWorld:DoTaskInTime(0, function(world)
                                    if world.ismastersim then
                                        GLOBAL.TheNet:Ban(v.userid)
                                    end
                                end)
                            end
                        end
                    end
                    --kill
                    if  string.sub(message,1,5) == "+kill" and string.len(message) >= 6 and string.sub(message,6,-1) ~= nil then
                        for i, v in ipairs(GLOBAL.AllPlayers) do
                            if string.find(v.name, string.sub(message,6,-1)) then
                                v:PushEvent('death')
                            end
                        end
                    end
                    --先kill再ban
                    if  string.sub(message,1,5) == "+kban" and string.len(message) >= 6 and string.sub(message,6,-1) ~= nil then
                        for i, v in ipairs(GLOBAL.AllPlayers) do
                            if string.find(v.name, string.sub(message,6,-1)) then
                                v:PushEvent('death')
                                GLOBAL.TheWorld:DoTaskInTime(5, function(world)
                                    if world.ismastersim then
                                        GLOBAL.TheNet:Ban(v.userid)
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