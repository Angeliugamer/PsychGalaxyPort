function onCreate()
    addLuaScript('hx/GalaxyLoader')

    addHScript('hx/GalaxyMechanics/Core/GalaxyCore.hx')
    addHScript('hx/GalaxyBootstrap.hx')
end

function onCreatePost()
    callOnHScript('galaxy_Bootstrap_init', {})

    -- Registrar las tres mecanicas.
    callOnHScript('galaxyCore_registerPath', {
        'PruebaIndependencia',
        'hx/GalaxyMechanics/Notes/PruebaIndependencia.hx'
    })

    callOnHScript('galaxyCore_registerPath', {
        'PruebaIndependenciaB',
        'hx/GalaxyMechanics/Notes/PruebaIndependenciaB.hx'
    })

    callOnHScript('galaxyCore_registerPath', {
        'PruebaError',
        'hx/GalaxyMechanics/Notes/PruebaError.hx'
    })

    -- Cargar las tres mecanicas.
    callOnLuas('galaxyLoadMechanic', {'PruebaIndependencia'})
    callOnLuas('galaxyLoadMechanic', {'PruebaIndependenciaB'})
    callOnLuas('galaxyLoadMechanic', {'PruebaError'})

    -- Reiniciar los contadores de las mecanicas funcionales.
    callOnHScript('galaxy_PruebaIndependencia_init', {})
    callOnHScript('galaxy_PruebaIndependenciaB_init', {})

    -- Obtener el numero de errores antes del despacho.
    local errorsBefore = callOnHScript(
        'galaxyCore_getDispatchErrors',
        {}
    )

    -- Despachar un callback: PruebaError debe fallar.
    callOnHScript('galaxyCore_dispatch', {
        'onUpdate',
        {0.016}
    })

    -- Consultar los contadores.
    local countA = callOnHScript(
        'galaxy_PruebaIndependencia_getUpdateCount',
        {}
    )

    local countB = callOnHScript(
        'galaxy_PruebaIndependenciaB_getUpdateCount',
        {}
    )

    -- Consultar el registro de errores.
    local errorsAfter = callOnHScript(
        'galaxyCore_getDispatchErrors',
        {}
    )

    local lastError = callOnHScript(
        'galaxyCore_getLastDispatchError',
        {}
    )

    debugPrint(
        '[ERROR ISOLATION] A=' .. tostring(countA) ..
        ' | B=' .. tostring(countB) ..
        ' | errores=' .. tostring(errorsAfter - errorsBefore)
    )

    debugPrint(
        '[ERROR DETAILS] ' .. tostring(lastError)
    )

    debugPrint('[CATCH TEST] ' ..
        tostring(callOnHScript('galaxyCore_testCatch', {}))
    )

    debugPrint('[EXTERNAL CATCH TEST] ' ..
        tostring(callOnHScript('galaxyCore_testExternalCatch', {}))
    )

    debugPrint('[EXTERNAL SAFE TEST] ' ..
        tostring(callOnHScript('galaxyCore_testExternalSafe', {}))
    )
end