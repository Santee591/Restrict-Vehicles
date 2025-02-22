fx_version 'cerulean'
game 'gta5'

author 'SanteeDesigns'
description 'Restricts vehicles based on Discord roles using zDiscord'
version '1.1.0'

server_scripts {
    '@zDiscord/**/client.lua', -- Ensure zDiscord is running
    'server.lua'
}

client_scripts {
    'client.lua'
}
