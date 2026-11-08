-- =========================================================
-- GALAXY MECHANIC LOADER
-- Cargador central de mecanicas HScript
-- =========================================================

-- Estados y errores persistentes durante la ejecucion.
galaxyMechanicLoadStates = {}
galaxyMechanicLoadErrors = {}

-- Ejecuta una llamada a HScript de forma protegida.
function galaxyLoaderCall(functionName, args)
    local success, result = pcall(callOnHScript, functionName, args or {})

    if not success then
        return false, nil, tostring(result)
    end

    return true, result, nil
end

-- Obtiene el ultimo error reportado por Bootstrap.
function galaxyLoaderGetBootstrapError()
    local success, result, err = galaxyLoaderCall('galaxy_Bootstrap_getLastError', {})

    if not success then
        return 'No se pudo consultar Bootstrap: ' .. tostring(err)
    end

    if result == nil or result == '' then
        return 'Bootstrap no proporciono detalles adicionales.'
    end

    return tostring(result)
end

-- =========================================================
-- FUNCION PRINCIPAL
-- =========================================================

function galaxyLoadMechanic(name)
    -- 1. Validar el nombre.
    if type(name) ~= 'string' or name == '' then
        debugPrint('[Galaxy Loader ERROR] Nombre de mecanica invalido.')
        return false
    end

    -- Preparar el registro de estado.
    galaxyMechanicLoadStates[name] = 'checking'
    galaxyMechanicLoadErrors[name] = nil

    -- 2. Comprobar si Core ya la tiene registrada.
    local callOK, loaded, callError = galaxyLoaderCall(
        'galaxy_Bootstrap_isMechanicLoaded', {name})

    if not callOK then
        galaxyMechanicLoadStates[name] = 'failed'
        galaxyMechanicLoadErrors[name] = 'Error consultando el estado: ' .. tostring(callError)

        debugPrint('[Galaxy Loader ERROR] ' .. galaxyMechanicLoadErrors[name])
        return false
    end

    if loaded == true then
        galaxyMechanicLoadStates[name] = 'loaded'
        debugPrint('[Galaxy Loader] ' .. name .. ' ya estaba cargada.')
        return true
    end

    -- 3. Obtener la ruta registrada en Core.
    local pathOK, path, pathError = galaxyLoaderCall(
        'galaxy_Bootstrap_getMechanicPath', {name})

    if not pathOK then
        galaxyMechanicLoadStates[name] = 'failed'
        galaxyMechanicLoadErrors[name] = 'Error consultando la ruta: ' .. tostring(pathError)

        debugPrint('[Galaxy Loader ERROR] ' .. galaxyMechanicLoadErrors[name])
        return false
    end

    if type(path) ~= 'string' or path == '' then
        galaxyMechanicLoadStates[name] = 'failed'
        galaxyMechanicLoadErrors[name] = galaxyLoaderGetBootstrapError()

        debugPrint('[Galaxy Loader ERROR] Ruta inexistente: ' .. galaxyMechanicLoadErrors[name])
        return false
    end

    -- 4. Comprobar si el HScript ya esta fisicamente cargado.
    local runningOK, running, runningError = pcall(isRunning, path)

    if not runningOK then
        galaxyMechanicLoadStates[name] = 'failed'
        galaxyMechanicLoadErrors[name] = 'No en isRunning(): ' .. tostring(runningError)

        debugPrint('[Galaxy Loader ERROR] ' .. galaxyMechanicLoadErrors[name])
        return false
    end

    -- 5. Cargar fisicamente el HScript si hace falta.
    if not running then
        galaxyMechanicLoadStates[name] = 'loading'

        local addOK, addError = pcall(addHScript, path)

        if not addOK then
            galaxyMechanicLoadStates[name] = 'failed'
            galaxyMechanicLoadErrors[name] = 'Error en addHScript(): ' .. tostring(addError)

            debugPrint('[Galaxy Loader ERROR] ' .. galaxyMechanicLoadErrors[name])
            return false
        end

        -- addHScript puede no lanzar una excepcion aunque
        -- Psych Engine no haya registrado el archivo.
        local verifyOK, verifyRunning, verifyError = pcall(isRunning, path)

        if not verifyOK or not verifyRunning then
            galaxyMechanicLoadStates[name] = 'failed'
            galaxyMechanicLoadErrors[name] = 'Psych Engine no registro el HScript: ' .. path
            
            if not verifyOK then
                galaxyMechanicLoadErrors[name] =
                    galaxyMechanicLoadErrors[name] ..
                    ' | ' .. tostring(verifyError)
            end

            debugPrint('[Galaxy Loader ERROR] ' .. galaxyMechanicLoadErrors[name])
            return false
        end
    end

    -- En este punto el HScript existe fisicamente.
    galaxyMechanicLoadStates[name] = 'physical_loaded'

    -- 6. Inicializar y registrar la mecanica mediante Bootstrap.
    local confirmOK, confirmed, confirmError = galaxyLoaderCall(
        'galaxy_Bootstrap_confirmMechanic', {name})

    if not confirmOK then
        galaxyMechanicLoadStates[name] = 'init_failed'
        galaxyMechanicLoadErrors[name] = 'Error ejecutando init(): ' .. tostring(confirmError)

        debugPrint('[Galaxy Loader ERROR] ' .. galaxyMechanicLoadErrors[name])
        return false
    end

    if confirmed ~= true then
        galaxyMechanicLoadStates[name] = 'init_failed'
        galaxyMechanicLoadErrors[name] = galaxyLoaderGetBootstrapError()

        debugPrint('[Galaxy Loader ERROR] Fallo de inicializacion: ' .. galaxyMechanicLoadErrors[name])
        return false
    end

    -- 7. Carga completada.
    galaxyMechanicLoadStates[name] = 'loaded'
    galaxyMechanicLoadErrors[name] = nil

    return true
end

-- =========================================================
-- CONSULTA DEL ESTADO DEL CARGADOR
-- =========================================================

function galaxyGetMechanicLoadState(name)
    if name == nil then
        return 'unknown'
    end

    return galaxyMechanicLoadStates[name] or 'not_loaded'
end

function galaxyGetMechanicLoadError(name)
    if name == nil then
        return 'Nombre de mecanica invalido.'
    end

    return galaxyMechanicLoadErrors[name] or ''
end