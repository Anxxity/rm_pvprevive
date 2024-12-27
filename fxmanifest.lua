fx_version 'cerulean'
game "gta5"

author "Remin Moahmmed"
description 'A revive System for pvp'
lua54 'yes'



client_script {
    'client.lua'
}

server_script {
    'server.lua'
}

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}