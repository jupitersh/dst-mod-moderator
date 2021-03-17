local tonumber = GLOBAL.tonumber
local whitelist_enable=GetModConfigData("whitelist")

if not (GLOBAL.TheNet and GLOBAL.TheNet:GetIsServer()) then return end

modimport("moderator")

local function DoNotEscape(str)
    str=str:gsub("%s","")
    return str:gsub('[%^%$%(%)%%%.%[%]%*%+%-%?]',function(s) return '%'..s end)
end

local function ismoderator(userid)
    for k,v in pairs(moderator) do
        if v == userid then
            return true
        end
    end
    return GLOBAL.TheNet:IsWhiteListed(userid) or GLOBAL.UserToClient(userid).admin
end

local function NotInList(str)
	if ismoderator(str) then
		GLOBAL.TheNet:SystemMessage("指令对其他管理者无效！")
		return false
	else
		return true
	end
end

local function Kill(shard,userid)
	for k,v in pairs(GLOBAL.AllPlayers) do
		if v and v.userid == userid and v.components and v.components.health then
			v.components.health:Kill()
		end
	end
end

AddShardModRPCHandler("MODERATOR","Kill",Kill)

local _Networking_Say = GLOBAL.Networking_Say

GLOBAL.Networking_Say = function(guid, userid, name, prefab, message, colour, whisper, isemote, ...)
    _Networking_Say(guid, userid, name, prefab, message, colour, whisper, isemote, ...)
    if not whisper and GLOBAL.TheWorld.ismastershard then
        if string.sub(message,1,1) == "+" then
            if ismoderator(userid) then
            	local clients = GLOBAL.TheNet:GetClientTable()
            	if not GLOBAL.TheNet:GetServerIsClientHosted() then
            		table.remove(clients,1)
            	end
                --回档默认
                if  string.sub(message,1,9) == "+rollback" and string.len(message) == 9 then
                    GLOBAL.TheWorld:DoTaskInTime(5, function(world)
                        if world.ismastersim and not GLOBAL.TheShard:IsSecondary() then
                            GLOBAL.TheNet:SendWorldRollbackRequestToServer(0)
                        end
                    end)
                --回档按天数
                elseif  string.sub(message,1,9) == "+rollback" and string.len(message) == 10 and string.sub(message,10,10) ~= "0" and tonumber(string.sub(message,10,10)) ~= nil then
                    if tonumber(string.sub(message,10,10)) <= 5 then
                        GLOBAL.TheWorld:DoTaskInTime(5, function(world)
                            if world.ismastersim and not GLOBAL.TheShard:IsSecondary() then
                                GLOBAL.TheNet:SendWorldRollbackRequestToServer(tonumber(string.sub(message,10,10)))
                            end
                        end)
                    end
                --Ban人
                elseif  string.sub(message,1,4) == "+ban" and string.len(message) >= 5 and string.sub(message,5,-1) ~= nil then
                    for i, j in ipairs(clients) do
                        if string.find(j.name, DoNotEscape(string.sub(message,5,-1))) and NotInList(j.userid) then
                            GLOBAL.TheWorld:DoTaskInTime(0, function(world)
                                if world.ismastersim then
                                    GLOBAL.TheNet:Ban(j.userid)
                                end
                            end)
                        end
                    end
                --Kick
                elseif  string.sub(message,1,5) == "+kick" and string.len(message) >= 6 and string.sub(message,6,-1) ~= nil then
                    for i, j in ipairs(clients) do
                        if string.find(j.name, DoNotEscape(string.sub(message,6,-1))) and NotInList(j.userid) then
                            GLOBAL.TheWorld:DoTaskInTime(0, function(world)
                                if world.ismastersim then
                                    GLOBAL.TheNet:Kick(j.userid)
                                end
                            end)
                        end
                    end
                --kill
                elseif  string.sub(message,1,5) == "+kill" and string.len(message) >= 6 and string.sub(message,6,-1) ~= nil then
                    for i, j in ipairs(clients) do
                        if string.find(j.name, DoNotEscape(string.sub(message,6,-1))) and NotInList(j.userid) then
                        	GLOBAL.TheWorld:DoTaskInTime(0, function(world)
                            	SendModRPCToShard(GetShardModRPC("MODERATOR","Kill"),nil,j.userid)
                        	end)
                        end
                    end
                --先kill再ban
                elseif  string.sub(message,1,5) == "+kban" and string.len(message) >= 6 and string.sub(message,6,-1) ~= nil then
                    for i, j in ipairs(clients) do
                        if string.find(j.name, DoNotEscape(string.sub(message,6,-1))) and NotInList(j.userid) then
                            GLOBAL.TheWorld:DoTaskInTime(0, function(world)
                            	SendModRPCToShard(GetShardModRPC("MODERATOR","Kill"),nil,j.userid)
                        	end)
                            GLOBAL.TheWorld:DoTaskInTime(5, function(world)
                                if world.ismastersim then
                                    GLOBAL.TheNet:Ban(j.userid)
                                end
                            end)
                        end
                    end
                --Ban人
                elseif  string.sub(message,1,5) == "++ban" and string.len(message) >= 6 then
                    local num = tonumber(string.sub(message,6,-1))
                    if num ~= nil and num > 0 and num <= #clients then
                        GLOBAL.TheWorld:DoTaskInTime(0, function(world)
                            if world.ismastersim then
                                GLOBAL.TheNet:Ban(GLOBAL.AllPlayers[num].userid)
                            end
                        end)
                    end
                --Kick
                elseif  string.sub(message,1,6) == "++kick" and string.len(message) >= 7 then
                    local num = tonumber(string.sub(message,7,-1))
                    if num ~= nil and num > 0 and num <= #clients then
                        GLOBAL.TheWorld:DoTaskInTime(0, function(world)
                            if world.ismastersim then
                                GLOBAL.TheNet:Kick(clients[num].userid)
                            end
                        end)
                    end
                --kill
                elseif  string.sub(message,1,6) == "++kill" and string.len(message) >= 7 then
                    local num = tonumber(string.sub(message,7,-1))
                    if num ~= nil and num > 0 and num <= #clients then
                        local j = clients[num]
                        GLOBAL.TheWorld:DoTaskInTime(0, function(world)
                            	SendModRPCToShard(GetShardModRPC("MODERATOR","Kill"),nil,j.userid)
                        end)
                    end
                --先kill再ban
                elseif  string.sub(message,1,6) == "++kban" and string.len(message) >= 7 then
                    local num = tonumber(string.sub(message,7,-1))
                    if num ~= nil and num > 0 and num <= #clients then
                        local j = clients[num]
                        GLOBAL.TheWorld:DoTaskInTime(0, function(world)
                            	SendModRPCToShard(GetShardModRPC("MODERATOR","Kill"),nil,j.userid)
                        end)
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