
/*
 * GalaxyBootstrap.hx
 * Coordinador principal de PsychGalaxyPort.
 *
 * Lua conserva la responsabilidad de cargar físicamente los HScript
 * mediante addHScript(). Bootstrap coordina el resto del proceso.
 *
 * Dependencia:
 * hx/GalaxyMechanics/Core/GalaxyCore.hx
 */

var galaxyBootstrapInitialized:Bool = false;
var galaxyBootstrapLastError:String = '';
var galaxyBootstrapLastMechanic:String = '';

function galaxy_Bootstrap_init():Bool
{
    galaxyBootstrapLastError = '';

    var coreResult:Dynamic = null;

    try
    {
        coreResult = callOnHScript('galaxyCore_init', []);
    }
    catch (e:Dynamic)
    {
        galaxyBootstrapLastError =
            'Error al inicializar GalaxyCore: ' + Std.string(e);
        return false;
    }

    if (coreResult != true)
    {
        galaxyBootstrapLastError =
            'GalaxyCore no respondió correctamente a init().';
        return false;
    }

    galaxyBootstrapInitialized = true;
    return true;
}

function galaxy_Bootstrap_getMechanicPath(name:String):String
{
    galaxyBootstrapLastError = '';

    if (!galaxyBootstrapInitialized)
    {
        galaxyBootstrapLastError = 'Bootstrap no inicializado.';
        return '';
    }

    if (name == null || name == '')
    {
        galaxyBootstrapLastError = 'Nombre de mecánica vacío.';
        return '';
    }

    var path:Dynamic = callOnHScript('galaxyCore_getPath', [name]);

    if (path == null || path == false || Std.string(path) == '')
    {
        galaxyBootstrapLastError = 'No existe una ruta registrada para: ' + name;
        return '';
    }

    galaxyBootstrapLastMechanic = name;
    return Std.string(path);
}

function galaxy_Bootstrap_confirmMechanic(name:String):Bool
{
    if (!galaxyBootstrapInitialized)
    {
        galaxyBootstrapLastError = 'Bootstrap no inicializado.';
        return false;
    }

    if (name == null || name == '')
    {
        galaxyBootstrapLastError = 'Nombre de mecánica vacío.';
        return false;
    }

    var alreadyLoaded:Dynamic =
        callOnHScript('galaxyCore_isLoaded', [name]);

    if (alreadyLoaded == true)
        return true;

    var initResult:Dynamic = null;

    try
    {
        initResult = callOnHScript(
            'galaxyCore_functionName',
            [name, 'init']
        );

        if (initResult == null)
        {
            galaxyBootstrapLastError =
                'No se pudo construir el nombre de inicialización.';
            return false;
        }

        initResult = callOnHScript(Std.string(initResult), []);
    }
    catch (e:Dynamic)
    {
        galaxyBootstrapLastError =
            'Error inicializando ' + name + ': ' + Std.string(e);
        return false;
    }

    if (initResult != true)
    {
        galaxyBootstrapLastError =
            'La inicialización de ' + name + ' falló o no devolvió true.';
        return false;
    }

    var registered:Dynamic =
        callOnHScript('galaxyCore_markLoaded', [name]);

    if (registered != true)
    {
        galaxyBootstrapLastError =
            'No se pudo registrar la mecánica: ' + name;
        return false;
    }

    galaxyBootstrapLastMechanic = name;
    galaxyBootstrapLastError = '';
    return true;
}

function galaxy_Bootstrap_isMechanicLoaded(name:String):Bool
{
    if (!galaxyBootstrapInitialized || name == null || name == '')
    {
        galaxyBootstrapLastError = 'Bootstrap no inicializado o nombre inválido.';
        return false;
    }

    var loaded:Dynamic =
        callOnHScript('galaxyCore_isLoaded', [name]);

    return loaded == true;
}

function galaxy_Bootstrap_isMechanicEnabled(name:String):Bool
{
    if (!galaxyBootstrapInitialized || name == null || name == '')
    {
        galaxyBootstrapLastError = 'Bootstrap no inicializado o nombre inválido.';
        return false;
    }

    var enabled:Dynamic =
        callOnHScript('galaxyCore_isEnabled', [name]);

    return enabled == true;
}

function galaxy_Bootstrap_enableMechanic(name:String):Bool
{
    if (!galaxyBootstrapInitialized || name == null || name == '')
    {
        galaxyBootstrapLastError = 'Bootstrap no inicializado o nombre inválido.';
        return false;
    }

    if (!galaxy_Bootstrap_isMechanicLoaded(name))
    {
        galaxyBootstrapLastError =
            'No se puede activar una mecánica que no está cargada: ' + name;
        return false;
    }

    var result:Dynamic =
        callOnHScript('galaxyCore_enable', [name]);

    if (result != true)
    {
        galaxyBootstrapLastError =
            'GalaxyCore no pudo activar la mecánica: ' + name;
        return false;
    }

    galaxyBootstrapLastMechanic = name;
    galaxyBootstrapLastError = '';
    return true;
}

function galaxy_Bootstrap_disableMechanic(name:String):Bool
{
    if (!galaxyBootstrapInitialized || name == null || name == '')
    {
        galaxyBootstrapLastError = 'Bootstrap no inicializado o nombre inválido.';
        return false;
    }

    if (!galaxy_Bootstrap_isMechanicLoaded(name))
    {
        galaxyBootstrapLastError = 'No se puede desactivar una mecánica que no está cargada: ' + name;
        return false;
    }

    var result:Dynamic = callOnHScript('galaxyCore_disable', [name]);

    if (result != true)
    {
        galaxyBootstrapLastError = 'GalaxyCore no pudo desactivar la mecánica: ' + name;
        return false;
    }

    galaxyBootstrapLastMechanic = name;
    galaxyBootstrapLastError = '';
    return true;
}

function galaxy_Bootstrap_getStatus():String
{
    var coreReady:Dynamic = false;
    var loadedCount:Int = 0;

    if (galaxyBootstrapInitialized)
    {
        coreReady = callOnHScript('galaxyCore_init', []);

        var loadedMechanics:Dynamic =
            callOnHScript('galaxyCore_getLoaded', []);

        if (loadedMechanics != null)
        {
            loadedCount = loadedMechanics.length;
        }
    }

    return 'initialized=' + galaxyBootstrapInitialized
        + '; coreReady=' + (coreReady == true)
        + '; loadedMechanics=' + loadedCount
        + '; lastMechanic=' + galaxyBootstrapLastMechanic
        + '; lastError=' + galaxyBootstrapLastError;
}

function galaxy_Bootstrap_getLastError():String
{
    return galaxyBootstrapLastError;
}

function galaxy_Bootstrap_ping():String
{
    return 'BOOTSTRAP_OK';
}
