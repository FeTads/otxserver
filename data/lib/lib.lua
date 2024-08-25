local files = {

    'internal/000-constant.lua',
    'internal/001-class.lua',
    'internal/002-wait.lua',
    'internal/004-database.lua',
    'internal/011-string.lua',
    'internal/012-table.lua',
    'internal/013-math.lua',
    'internal/031-vocations.lua',
    'internal/032-position.lua',
    'internal/033-ip.lua',
    'internal/034-exhaustion.lua',
    'internal/050-function.lua',
    '100-shortcut.lua',
    'internal/101-compat.lua',
	'killuaslib.lua',
	'deletebra_lib.lua',
	'reset_system.lua',
	'market_system.lua'
}

for _, file in ipairs(files) do
    dofile(('data/lib/%s'):format(file))
end