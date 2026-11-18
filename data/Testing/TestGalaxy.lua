function onCreate()
    addLuaScript('hx/GalaxyLoader')

    addHScript('hx/GalaxyMechanics/Core/GalaxyCore.hx')
    addHScript('hx/GalaxyBootstrap.hx')
end

function onCreatePost()
    callOnHScript('galaxy_Bootstrap_init', {})

    callOnLuas('galaxyLoadMechanic', {'MoverNotas'})

    -- Prueba directa del helper.
    debugPrint('[MOVERNOTAS PROTECTION] ' ..
        tostring(callOnHScript('galaxy_MoverNotas_testProtection', {}))
    )

    -- Guardar errores antes del despacho.
    local errorsBefore = callOnHScript(
        'galaxyCore_getDispatchErrors',
        {}
    )

    -- Ejecutar manualmente onUpdate una vez.
    callOnHScript('galaxyCore_dispatch', {
        'onUpdate',
        {0.016}
    })

    -- Consultar estado del módulo.
    debugPrint('[MOVERNOTAS STATUS] ' ..
        tostring(callOnHScript('galaxy_MoverNotas_getStatus', {}))
    )

    local errorsAfter = callOnHScript(
        'galaxyCore_getDispatchErrors',
        {}
    )

    debugPrint('[MOVERNOTAS DISPATCH] Errores nuevos: ' ..
        tostring(errorsAfter - errorsBefore)
    )
    
    debugPrint('[MOVERNOTAS ERROR DETAILS] ' ..
        tostring(callOnHScript('galaxyCore_getLastDispatchError', {}))
    )
end