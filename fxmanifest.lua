fx_version 'cerulean'
game 'gta5'

description 'bbv-nos'
version '1.0.0'

this_is_a_map 'yes'

client_scripts {
    'config.lua',
    'wrapper/cl_wrapper.lua',
    'wrapper/cl_wp_callback.lua',
    'client/client.lua',
}

server_scripts {
    'wrapper/sv_wrapper.lua',
    'wrapper/sv_wp_callback.lua',
    'server/server.lua',
}

lua54 'yes'

ui_page('html/index.html')
      
files {
    'html/index.html',
    'html/sounds/**'
}
