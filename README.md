# Moderator

![](https://steamuserimages-a.akamaihd.net/ugc/773983150587869329/8AC01E4728FA65A1A8FFB842480AEC392BAD05F2/)

## Overview

This is a mod for the game of Don't Starve Together which is available in the Steam Workshop. 

If you are holding a dedicated server, but you are not always available for managing the server. You may want add some people as the server administrators. But the servers administrator have so much power that may cheat in the game, such as spawning thing for themeselve.

This mod can add some people as moderator that have a certain previlige such as rolling back server and bannig people.

**Usage:**


- Edit `moderator.lua` in this mod folder. Add the user id of the moderator inside the table `moderator`
- Restart you server to make it working.
- In the game, the moderator just type the following commands to excute it in the chatting window:
	- `+rollback`
		> For example, if you want to rollback 1 day, type `+rollback` or `+rollback1`; if 2 days. type `+rollback2`, etc. The max number is `5`.
    - `+ban`
    	> For example, if you want to ban some named `Jupiter`, type `+banJupiter` or `+banJup` are both okay.
    - `+kill`
        > The usage is the same as `+ban`. Just replace the `ban` with `kill`.
    - `+kban`
        > Kill and then ban someone. The usage is the same as `+ban`. Just replace the `ban` with `kban`.

**Backup your `moderator.lua` because it will be emptied after mod update.**

## Changelog

**Version 1.3.0**

- Fixed a bug of escape character of Lua.
- Added the feature of kicking.

**Version 1.2.0**

- Now the moderator can not ban, kill or kban each other.

## License

Released under the [GNU GENERAL PUBLIC LICENSE](https://www.gnu.org/licenses/gpl-3.0.en.html)