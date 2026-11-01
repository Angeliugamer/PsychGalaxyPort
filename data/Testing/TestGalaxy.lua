function onCreate()
    addHScript('hx/GalaxyMechanics/Core/GalaxyCore.hx')
end

function onCreatePost()
    local path = 'hx/GalaxyBootstrap.hx'

    debugPrint('[TEST] Ruta: ' .. path)
    debugPrint('[TEST] Antes: ' .. tostring(isRunning(path)))

    addHScript(path, true)

    debugPrint('[TEST] Despues: ' .. tostring(isRunning(path)))

    local result = callOnHScript('galaxy_Bootstrap_ping', {})
    debugPrint('[TEST] Ping: ' .. tostring(result))
end