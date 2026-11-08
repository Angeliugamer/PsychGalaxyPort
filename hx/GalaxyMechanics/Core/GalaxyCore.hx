/*
 * GalaxyCore.hx
 * Núcleo de coordinación de PsychGalaxyPort para Psych Engine 1.0.4.
 * Ruta: hx/GalaxyMechanics/Core/GalaxyCore.hx
 *
 * CONTRATO DE COMUNICACIÓN
 * 1) Lua carga este archivo con addHScript(...).
 * 2) Lua llama a la API del núcleo con callOnHScript('galaxyCore_load', [...]).
 * 3) Cada módulo expone funciones con nombres únicos:
 *      galaxy_<NombreMecanica>_<funcion>
 *    Ejemplos: galaxy_MoverNotas_init, galaxy_MoverNotas_onUpdate.
 * 4) Las llamadas entre scripts usan callOnHScript(), igual que en UNRESPONSIVE.
 * 5) Las rutas son relativas a la carpeta del mod y NO incluyen "mods/".
 *
 * IMPORTANTE
 * callOnHScript busca por nombre entre los HScript activos; no selecciona un
 * archivo concreto. Por eso los nombres públicos de los módulos deben ser únicos.
 * La carga se marca como correcta cuando game.initHScript(path) no lanza error;
 * Psych no proporciona aquí una confirmación independiente de que todas las
 * funciones del módulo existan.
 */

import haxe.ds.StringMap;

var galaxyCoreInitialized:Bool = false;
var galaxyMechanicBasePath:String = 'hx/GalaxyMechanics/';

// name -> true si el archivo fue solicitado/cargado sin lanzar excepción.
var galaxyLoadedMechanics = new StringMap();
// name -> true si la mecánica participa en dispatch.
var galaxyEnabledMechanics = new StringMap();
// name -> ruta del archivo HScript.
var galaxyMechanicPaths = new StringMap();
// Almacén de datos compartidos entre módulos.
var galaxySharedData = new StringMap();

var galaxyCoreLastLoadError:String = '';
var galaxyCoreLastLoadPath:String = '';
var galaxyCoreDispatchErrors:Int = 0;
var galaxyCoreLastDispatchError:String = '';

function galaxyCore_init():Bool
{
    if (galaxyCoreInitialized)
        return true;

    galaxyCoreInitialized = true;
    galaxyCore_registerDefaultPaths();
    return true;
}

function galaxyCore_registerPath(name:String, path:String):Bool
{
    if (name == null || name == '' || path == null || path == '')
        return false;

    galaxyMechanicPaths.set(name, path);
        return true;
}

function galaxyCore_registerDefaultPaths():Void
{
    // NOTES
    galaxyCore_registerPath('MoverNotas', galaxyMechanicBasePath + 'Notes/MoverNotas.hx');
    galaxyCore_registerPath('CambiarVelocidadNotas', galaxyMechanicBasePath + 'Notes/CambiarVelocidadNotas.hx');
    galaxyCore_registerPath('InvertirNotas', galaxyMechanicBasePath + 'Notes/InvertirNotas.hx');
    galaxyCore_registerPath('RotarNotas', galaxyMechanicBasePath + 'Notes/RotarNotas.hx');
    galaxyCore_registerPath('OcultarNotas', galaxyMechanicBasePath + 'Notes/OcultarNotas.hx');
    galaxyCore_registerPath('EliminarNotas', galaxyMechanicBasePath + 'Notes/EliminarNotas.hx');
    galaxyCore_registerPath('MoverSustains', galaxyMechanicBasePath + 'Notes/MoverSustains.hx');
    galaxyCore_registerPath('CambiarAlphaNotas', galaxyMechanicBasePath + 'Notes/CambiarAlphaNotas.hx');

    // STRUMS
    galaxyCore_registerPath('MoverStrums', galaxyMechanicBasePath + 'Strums/MoverStrums.hx');
    galaxyCore_registerPath('MoverStrumsVertical', galaxyMechanicBasePath + 'Strums/MoverStrumsVertical.hx');
    galaxyCore_registerPath('MoverStrumsCircular', galaxyMechanicBasePath + 'Strums/MoverStrumsCircular.hx');
    galaxyCore_registerPath('RotarStrums', galaxyMechanicBasePath + 'Strums/RotarStrums.hx');
    galaxyCore_registerPath('StrumPerspective', galaxyMechanicBasePath + 'Strums/StrumPerspective.hx');

    // WINDOW
    galaxyCore_registerPath('MoverVentana', galaxyMechanicBasePath + 'Window/MoverVentana.hx');
    galaxyCore_registerPath('RedimensionarVentana', galaxyMechanicBasePath + 'Window/RedimensionarVentana.hx');
    galaxyCore_registerPath('VentanaSinusoidal', galaxyMechanicBasePath + 'Window/VentanaSinusoidal.hx');
    galaxyCore_registerPath('VentanaShake', galaxyMechanicBasePath + 'Window/VentanaShake.hx');
    galaxyCore_registerPath('VentanaCenter', galaxyMechanicBasePath + 'Window/VentanaCenter.hx');

    // 3D
    galaxyCore_registerPath('Note3D', galaxyMechanicBasePath + '3D/Note3D.hx');
    galaxyCore_registerPath('Perspective', galaxyMechanicBasePath + '3D/Perspective.hx');
    galaxyCore_registerPath('ToWorld', galaxyMechanicBasePath + '3D/ToWorld.hx');
    galaxyCore_registerPath('ToScreen', galaxyMechanicBasePath + '3D/ToScreen.hx');
    galaxyCore_registerPath('RenderPath', galaxyMechanicBasePath + '3D/RenderPath.hx');

    // RENDER
    galaxyCore_registerPath('GalaxyShader', galaxyMechanicBasePath + 'Render/GalaxyShader.hx');
    galaxyCore_registerPath('GalaxyBlend', galaxyMechanicBasePath + 'Render/GalaxyBlend.hx');
    galaxyCore_registerPath('Galaxy3D', galaxyMechanicBasePath + 'Render/Galaxy3D.hx');

    // OBJECTS
    galaxyCore_registerPath('CloneNotes', galaxyMechanicBasePath + 'Objects/CloneNotes.hx');
    galaxyCore_registerPath('GenerateStrums', galaxyMechanicBasePath + 'Objects/GenerateStrums.hx');
    galaxyCore_registerPath('GenerateObjects', galaxyMechanicBasePath + 'Objects/GenerateObjects.hx');

    // EFFECTS
    galaxyCore_registerPath('BeatCharacterAnimation', galaxyMechanicBasePath + 'Effects/BeatCharacterAnimation.hx');
    galaxyCore_registerPath('DamageOnHit', galaxyMechanicBasePath + 'Effects/DamageOnHit.hx');
    galaxyCore_registerPath('ChangeCameraZoom', galaxyMechanicBasePath + 'Effects/ChangeCameraZoom.hx');
}

function galaxyCore_getPath(name:String):String
{
    galaxyCore_init();
    
    if (name == null || name == '' || !galaxyMechanicPaths.exists(name))
        return '';

    return galaxyMechanicPaths.get(name);
}

function galaxyCore_isLoaded(name:String):Bool
{
    return name != null && galaxyLoadedMechanics.exists(name) && galaxyLoadedMechanics.get(name) == true;
}

function galaxyCore_isEnabled(name:String):Bool
{
    return galaxyCore_isLoaded(name) && galaxyEnabledMechanics.exists(name) && galaxyEnabledMechanics.get(name) == true;
}

function galaxyCore_load(name:String):String
{
    galaxyCore_init();

    galaxyCoreLastLoadError = '';
    galaxyCoreLastLoadPath = '';

    if (name == null || name == '')
    {
        galaxyCoreLastLoadError = 'Nombre de mecanica vacio.';
        return false;
    }

    if (galaxyCore_isLoaded(name))
    {
        galaxyCoreLastLoadError = 'La mecanica ya esta registrada.';
        galaxyCoreLastLoadPath = galaxyCore_getPath(name);
        return galaxyCoreLastLoadPath;
    }

    var path = galaxyCore_getPath(name);

    if (path == null || path == '')
    {
        galaxyCoreLastLoadError = 'No existe una ruta registrada para: ' + name;
        return null;
    }

    galaxyCoreLastLoadPath = path;
    galaxyCoreLastLoadError = 'Ruta preparada para addHScript().';

    return path;
}

function galaxyCore_loadMany(names:Array):Array
{
    galaxyCore_init();

    if (names == null)
        return [];

    var result:Array = [];

    for (name in names)
    {
        var path = galaxyCore_load(Std.string(name));

        if (path != null)
            result.push(path);
    }

    return result;
}

function galaxyCore_getLastLoadError():String
{
    return galaxyCoreLastLoadError;
}

function galaxyCore_getLastLoadPath():String
{
    return galaxyCoreLastLoadPath;
}

function galaxyCore_markLoaded(name:String):Bool
{
    galaxyCore_init();

    if (name == null || name == '')
        return false;

    if (!galaxyMechanicPaths.exists(name))
        return false;

    galaxyLoadedMechanics.set(name, true);
    galaxyEnabledMechanics.set(name, true);

    return true;
}

function galaxyCore_enable(name:String):Bool
{
    if (!galaxyCore_isLoaded(name))
        return false;

    galaxyEnabledMechanics.set(name, true);
    return true;
}

function galaxyCore_disable(name:String):Bool
{
    if (!galaxyCore_isLoaded(name))
        return false;

    galaxyEnabledMechanics.set(name, false);
    return true;
}

function galaxyCore_getEnabled():Array
{
    var result:Array = [];

    for (name in galaxyLoadedMechanics.keys())
    {
        if (galaxyCore_isEnabled(name))
            result.push(name);
    }

    return result;
}

function galaxyCore_unregister(name:String):Bool
{
    if (!galaxyCore_isLoaded(name))
        return false;

    galaxyEnabledMechanics.remove(name);
    galaxyLoadedMechanics.remove(name);

    return true;
}

function galaxyCore_getLoaded():Array
{
    var result:Array = [];
    for (name in galaxyLoadedMechanics.keys())
        result.push(name);
    return result;
}

function galaxyCore_setData(name:String, value:Dynamic):Void
{
    if (name == null || name == '')
        return;
    galaxySharedData.set(name, value);
}

function galaxyCore_getData(name:String):Dynamic
{
    if (name == null || name == '' || !galaxySharedData.exists(name))
        return null;
    return galaxySharedData.get(name);
}

function galaxyCore_hasData(name:String):Bool
{
    return name != null && galaxySharedData.exists(name);
}

function galaxyCore_removeData(name:String):Bool
{
    if (name == null || !galaxySharedData.exists(name))
        return false;
    return galaxySharedData.remove(name);
}

// Construye el nombre público y único que debe exponer cada módulo.
function galaxyCore_functionName(mechanic:String, func:String):String
{
    if (mechanic == null || mechanic == '' || func == null || func == '')
        return null;
    return 'galaxy_' + mechanic + '_' + func;
}

// Llama una función exportada por un módulo mediante el mecanismo probado:
// callOnHScript('nombreUnico', argumentos).
function galaxyCore_call(mechanic:String, func:String, args:Array):Dynamic
{
    if (!galaxyCore_isLoaded(mechanic))
        return null;

    var functionName = galaxyCore_functionName(mechanic, func);
    if (functionName == null)
        return null;

    if (args == null)
        args = [];

    return callOnHScript(functionName, args);
}

// Distribuye callbacks únicamente a módulos cargados y habilitados.
// Cada módulo debe exponer, por ejemplo, galaxy_MoverNotas_onUpdate(elapsed).
function galaxyCore_dispatch(callback:String, args:Array):Void
{
    if (callback == null || callback == '')
        return;

    if (args == null)
        args = [];

    var names = galaxyCore_getEnabled();

    for (name in names)
    {
        var functionName =
            galaxyCore_functionName(name, callback);

        if (functionName == null)
            continue;

        try
        {
            callOnHScript(functionName, args);
        }
        catch (e:Dynamic)
        {
            galaxyCoreDispatchErrors = galaxyCoreDispatchErrors + 1;
            galaxyCoreLastDispatchError = name + ' / ' + callback + ': ' + Std.string(e);
        }
    }
}

function galaxyCore_getDispatchErrors():Int
{
    return galaxyCoreDispatchErrors;
}

function galaxyCore_getLastDispatchError():String
{
    return galaxyCoreLastDispatchError;
}

// Callbacks del motor. No se declara curBeat/curStep como parámetros del
// callback del motor: se leen desde PlayState y se pasan a los módulos.
function onCreate():Void
{
    galaxyCore_init();
    galaxyCore_dispatch('onCreate', []);
}

function onCreatePost():Void
{
    galaxyCore_dispatch('onCreatePost', []);
}

function onUpdate(elapsed:Float):Void
{
    galaxyCore_dispatch('onUpdate', [elapsed]);
}

function onUpdatePost(elapsed:Float):Void
{
    galaxyCore_dispatch('onUpdatePost', [elapsed]);
}

function onBeatHit():Void
{
    galaxyCore_dispatch('onBeatHit', [game.curBeat]);
}

function onStepHit():Void
{
    galaxyCore_dispatch('onStepHit', [game.curStep]);
}

function onSongStart():Void
{
    galaxyCore_dispatch('onSongStart', []);
}

// Nota: el retorno de onEndSong no se intercepta aquí todavía. Cuando alguna
// mecánica necesite detener el final de canción, definiremos ese contrato aparte.
function onEndSong():Void
{
    galaxyCore_dispatch('onEndSong', []);
}

function galaxyCore_reset():Void
{
    galaxyLoadedMechanics = new StringMap();
    galaxyEnabledMechanics = new StringMap();
    galaxyMechanicPaths = new StringMap();
    galaxySharedData = new StringMap();
    galaxyCoreInitialized = false;
    galaxyCore_init();
}
