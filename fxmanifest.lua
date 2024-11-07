shared_script '@narko/shared_fg-obfuscated.lua'
fx_version "bodacious"

games {"gta5"}
lua54 'yes'
author 'rever'
description 'rev_script'
version '1.0'

shared_scripts {
	'@es_extended/imports.lua',
	'@ox_lib/init.lua'
	}

server_scripts {
	'config.lua',
	'server/*.lua'
}

client_scripts {
	'config.lua',
	'@ox_lib/init.lua',
	'client/*.lua'
}

server_scripts { '@oxmysql/lib/MySQL.lua' }

dependencies {
	'es_extended',
	'many-base'
}

exports {
}
