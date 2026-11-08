function onCreate()
    addLuaScript('hx/GalaxyLoader')

    addHScript('hx/GalaxyMechanics/Core/GalaxyCore.hx')
    addHScript('hx/GalaxyBootstrap.hx')
end

function onCreatePost()
    callOnHScript('galaxy_Bootstrap_init', {})

    -- Registrar ambas mecanicas.
    callOnHScript('galaxyCore_registerPath', {
        'PruebaIndependencia',
        'hx/GalaxyMechanics/Notes/PruebaIndependencia.hx'
    })

    callOnHScript('galaxyCore_registerPath', {
        'PruebaIndependenciaB',
        'hx/GalaxyMechanics/Notes/PruebaIndependenciaB.hx'
    })

    -- Cargar ambas mecanicas.
    local loadA = callOnLuas('galaxyLoadMechanic', {
        'PruebaIndependencia'
    })

    local loadB = callOnLuas('galaxyLoadMechanic', {
        'PruebaIndependenciaB'
    })

    -- Desactivar solamente la mecanica B.
    callOnHScript('galaxy_Bootstrap_disableMechanic', {
        'PruebaIndependenciaB'
    })

    -- Primer despacho: A recibe el callback, B no.
    callOnHScript('galaxyCore_dispatch', {
        'onUpdate',
        {0.016}
    })

    local countA1 = callOnHScript(
        'galaxy_PruebaIndependencia_getUpdateCount',
        {}
    )

    local countB1 = callOnHScript(
        'galaxy_PruebaIndependenciaB_getUpdateCount',
        {}
    )

    -- Reactivar B.
    callOnHScript('galaxy_Bootstrap_enableMechanic', {
        'PruebaIndependenciaB'
    })

    -- Segundo despacho: ambas reciben el callback.
    callOnHScript('galaxyCore_dispatch', {
        'onUpdate',
        {0.016}
    })

    local countA2 = callOnHScript(
        'galaxy_PruebaIndependencia_getUpdateCount',
        {}
    )

    local countB2 = callOnHScript(
        'galaxy_PruebaIndependenciaB_getUpdateCount',
        {}
    )

    debugPrint(
        '[MULTI CALLBACK TEST] A=' .. tostring(countA1) ..
        '->' .. tostring(countA2) ..
        ' | B=' .. tostring(countB1) ..
        '->' .. tostring(countB2)
    )
end