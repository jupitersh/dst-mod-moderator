name = "Moderator"
description = ""
author = "辣椒小皇纸"
version = "1.3.1"

forumthread = ""

api_version = 10

all_clients_require_mod = false
client_only_mod = false
dst_compatible = true

icon_atlas = "modicon.xml"
icon = "modicon.tex"

configuration_options={
	{
		name="whitelist",
		label="白名单成员视为管理员",
		hover="make the members of the whitelist as moderators",
		options={
			{description="启用|enable",data=true},
			{description="禁用|disable",data=false}
		},
		default=false
	}
}
