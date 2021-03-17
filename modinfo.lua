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
		hover="白名单成员可以使用指令且指令对其无效",
		options={
			{description="启用",data=true},
			{description="禁用",data=false}
		},
		default=false
	}
}