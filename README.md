# Click Bot

The new Click Bot for [Click Converse](http://clickwiki.net/wiki/Click_Converse), the Official [Clickteam](https://www.clickteam.com/) [Discord](https://discord.gg) server. 

ClickBot uses [Luvit](https://luvit.io/) and the [Discordia](https://github.com/SinisterRectus/Discordia) library in order to function. 

Made by [@Uppernate](https://github.com/Uppernate) ([BartekB](https://community.clickteam.com/members/14816-BartekB)), with help from [@lumezian](https://github.com/lumezian) (Lumez, [colm44](https://community.clickteam.com/members/18843-colm44)) and [@advaith1](https://github.com/advaith1) ([advaith](https://community.clickteam.com/members/21114-advaith)).

It is planned to make this bot quite extensive, mostly for moderation purposes.

To chat about development and vote on features, [join Click Converse](https://discord.gg/B6rGfGA) and type `.devroom`. Note: The devroom command is currently inactive, ask Uppernate for access.

Click Bot is currently being rewritten to be modular, with different commands in different addons. Because of this, you can add Click Bot to any server. Note: Since the bot is being rewritten, some former commands currently don't work.

You can invite Click Bot to your server [here](https://discordapp.com/oauth2/authorize?client_id=252487915538612224&scope=bot&permissions=8).<br>
Note: Currently, Click Bot needs to be restarted to recognize new servers. In the devroom, ask Uppernate to restart it.

Click Bot's prefix is `.`

## Commands and addons

Click Bot has a built-in `config` command. Use `.config addons add <addon>` to add addons, substituting `<addon>` with the addon you want to add. Use `.config addons remove <addon>` to remove addons.

`ping`<br>
Commands:<br>
`ping`: Returns pong. Used to check if bot is responding.

`rolesStay`: Remembers user roles, so if a user leaves and re-joins, they will keep their roles.<br>
Commands: none

`help`<br>
Commands:<br>
`help` DMs user a list of commands enabled for the server.

`fusionLinks`: Adds commands that send Fusion-related links.<br>
Commands:<br>
`extlist`: Sends links for CEM, Darkwire, and ClickWiki extension lists.<br>
Coming soon: `shaders`

`botLog`: Posts when a message is edited or deleted. You must create a `bot_log` channel.<br>
Commands: none

### Addons in development
`message`: Allows you to send messages as the bot.<br>
Commands:<br>
`msg`
 
`activityBoard` Records how many messages are sent by each user.<br>
Commands:<br>
`board`: Posts the activity board.
