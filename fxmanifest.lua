fx_version 'adamant'

game 'gta5'

description 'AI-Doctor-EMS by benpazzo'

version '0.1.0'


client_scripts {
    '@es_extended/locale.lua',
    'config.lua',
    'locales/en.lua',
    'client.lua',
}

server_scripts {
    '@es_extended/locale.lua',
    'config.lua',
    'locales/en.lua',
    'server.lua',
}

dependencies {
    'es_extended'
}