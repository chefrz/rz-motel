fx_version 'cerulean'
lua54 'yes'
game 'gta5'

client_scripts {
    'client/client.lua',
}

server_scripts {
    'server/server.lua',
}

shared_scripts {
    '@qb-core/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua',
    'config.lua'
}
