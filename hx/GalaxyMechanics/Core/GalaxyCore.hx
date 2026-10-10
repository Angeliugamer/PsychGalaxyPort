/*
 * GalaxyCore.hx
 *
 * Núcleo del sistema de mecánicas Galaxy para Psych Engine 1.0.4
 *
 * Función:
 *  - Registrar mecánicas HScript.
 *  - Activarlas/desactivarlas.
 *  - Llamar funciones de mecánicas individuales.
 *  - Compartir datos entre Lua y HScript.
 *  - Mantener una lista de mecánicas cargadas.
 *
 * IMPORTANTE:
 * Este archivo NO contiene mecánicas concretas.
 *
 * No utiliza:
 *     class GalaxyCore
 *     static
 *     StringMap<Bool>
 *     StringMap<Dynamic>
 *     Array<Dynamic>
 *
 * HScript de Psych no está interpretando esas construcciones
 * de la misma manera que un archivo Haxe compilado.
 *
 * Ruta:
 *
 *     hx/GalaxyMechanics/Core/GalaxyCore.hx
 *
 * ============================================================
 */


import haxe.ds.StringMap;


/*
 * ============================================================
 * ESTADO
 * ============================================================
 */


/*
 * Mecánicas actualmente cargadas.
 *
 * Se utiliza StringMap sin especificar tipo genérico porque
 * HScript de Psych no acepta la sintaxis <Tipo> que utilizamos
 * anteriormente.
 */
var loadedMechanics = new StringMap();


/*
 * Funciones expuestas por cada mecánica.
 */
var mechanicFunctions = new StringMap();


/*
 * Datos compartidos del sistema Galaxy.
 */
var data = new StringMap();


/*
 * Rutas registradas para cada mecánica.
 */
var mechanicPaths = new StringMap();


/*
 * Ruta base de las mecánicas.
 *
 * Esta ruta es relativa al mod.
 *
 * Estructura:
 *
 * FNGalaxy Port/
 * └── hx/
 *     └── GalaxyMechanics/
 *
 */
var mechanicBasePath:String =
    'hx/GalaxyMechanics/';


/*
 * Indica si GalaxyCore ya fue inicializado.
 */
var initialized:Bool = false;


/*
 * ============================================================
 * INICIALIZACIÓN
 * ============================================================
 */


function init():Bool
{
    if (initialized)
        return true;

    initialized = true;

    registerDefaultPaths();

    return true;
}


/*
 * ============================================================
 * REGISTRO DE MECÁNICAS
 * ============================================================
 */


/*
 * Registra una mecánica como cargada.
 */
function register(name:String):Bool
{
    init();

    if (name == null || name == '')
    {
        return false;
    }

    loadedMechanics.set(
        name,
        true
    );

    return true;
}


/*
 * Registra las funciones de una mecánica.
 */
function registerFunctions(
    name:String,
    functions:Dynamic
):Bool
{
    if (name == null || name == '')
        return false;

    if (functions == null)
        return false;

    mechanicFunctions.set(
        name, functions
    );

    loadedMechanics.set(
        name, true
    );

    return true;
}


/*
 * Registra la ruta de una mecánica.
 */
function registerPath(
    name:String,
    path:String
):Bool
{
    if (name == null || name == '')
        return false;

    if (path == null || path == '')
        return false;

    mechanicPaths.set(
        name, path
    );

    return true;
}


/*
 * ============================================================
 * RUTAS PREDETERMINADAS
 * ============================================================
 */


function registerDefaultPaths():Void
{
    /*
     * --------------------------------------------------------
     * NOTES
     * --------------------------------------------------------
     */

    registerPath('MoverNotas',
        mechanicBasePath + 'Notes/MoverNotas.hx'
    );

    registerPath('CambiarVelocidadNotas',
        mechanicBasePath + 'Notes/CambiarVelocidadNotas.hx'
    );

    registerPath('InvertirNotas',
        mechanicBasePath + 'Notes/InvertirNotas.hx'
    );

    registerPath('RotarNotas',
        mechanicBasePath + 'Notes/RotarNotas.hx'
    );

    registerPath('OcultarNotas',
        mechanicBasePath + 'Notes/OcultarNotas.hx'
    );

    registerPath('EliminarNotas',
        mechanicBasePath + 'Notes/EliminarNotas.hx'
    );

    registerPath('MoverSustains',
        mechanicBasePath + 'Notes/MoverSustains.hx'
    );

    registerPath('CambiarAlphaNotas',
        mechanicBasePath + 'Notes/CambiarAlphaNotas.hx'
    );


    /*
     * --------------------------------------------------------
     * STRUMS
     * --------------------------------------------------------
     */

    registerPath('MoverStrums',
        mechanicBasePath + 'Strums/MoverStrums.hx'
    );

    registerPath('MoverStrumsVertical',
        mechanicBasePath + 'Strums/MoverStrumsVertical.hx'
    );

    registerPath('MoverStrumsCircular',
        mechanicBasePath + 'Strums/MoverStrumsCircular.hx'
    );

    registerPath('RotarStrums',
        mechanicBasePath + 'Strums/RotarStrums.hx'
    );

    registerPath('StrumPerspective',
        mechanicBasePath + 'Strums/StrumPerspective.hx'
    );


    /*
     * --------------------------------------------------------
     * WINDOW
     * --------------------------------------------------------
     */

    registerPath('MoverVentana',
        mechanicBasePath + 'Window/MoverVentana.hx'
    );

    registerPath('RedimensionarVentana',
        mechanicBasePath + 'Window/RedimensionarVentana.hx'
    );

    registerPath('VentanaSinusoidal',
        mechanicBasePath + 'Window/VentanaSinusoidal.hx'
    );

    registerPath('VentanaShake',
        mechanicBasePath + 'Window/VentanaShake.hx'
    );

    registerPath('VentanaCenter',
        mechanicBasePath + 'Window/VentanaCenter.hx'
    );


    /*
     * --------------------------------------------------------
     * 3D
     * --------------------------------------------------------
     */

    registerPath('Note3D',
        mechanicBasePath + '3D/Note3D.hx'
    );

    registerPath('Perspective',
        mechanicBasePath + '3D/Perspective.hx'
    );

    registerPath('ToWorld',
        mechanicBasePath + '3D/ToWorld.hx'
    );

    registerPath('ToScreen',
        mechanicBasePath + '3D/ToScreen.hx'
    );

    registerPath('RenderPath',
        mechanicBasePath + '3D/RenderPath.hx'
    );


    /*
     * --------------------------------------------------------
     * RENDER
     * --------------------------------------------------------
     */

    registerPath('GalaxyShader',
        mechanicBasePath + 'Render/GalaxyShader.hx'
    );

    registerPath('GalaxyBlend',
        mechanicBasePath + 'Render/GalaxyBlend.hx'
    );

    registerPath('Galaxy3D',
        mechanicBasePath + 'Render/Galaxy3D.hx'
    );


    /*
     * --------------------------------------------------------
     * OBJECTS
     * --------------------------------------------------------
     */

    registerPath('CloneNotes',
        mechanicBasePath + 'Objects/CloneNotes.hx'
    );

    registerPath('GenerateStrums',
        mechanicBasePath + 'Objects/GenerateStrums.hx'
    );

    registerPath('GenerateObjects',
        mechanicBasePath + 'Objects/GenerateObjects.hx'
    );


    /*
     * --------------------------------------------------------
     * EFFECTS
     * --------------------------------------------------------
     */

    registerPath('BeatCharacterAnimation',
        mechanicBasePath + 'Effects/BeatCharacterAnimation.hx'
    );

    registerPath('DamageOnHit',
        mechanicBasePath + 'Effects/DamageOnHit.hx'
    );

    registerPath('ChangeCameraZoom',
        mechanicBasePath + 'Effects/ChangeCameraZoom.hx'
    );
}


/*
 * ============================================================
 * CARGA
 * ============================================================
 */


/*
 * Devuelve la ruta registrada de una mecánica.
 */
function getMechanicPath(
    name:String
):String
{
    init();

    if (name == null || name == '')
        return null;

    if (!mechanicPaths.exists(name))
        return null;

    return mechanicPaths.get(name);
}


/*
 * Comprueba si una mecánica está cargada.
 */
function isLoaded(
    name:String
):Bool
{
    if (name == null)
        return false;

    return
        mechanicPaths.exists(name)
        &&
        loadedMechanics.exists(name)
        &&
        loadedMechanics.get(name) == true;
}


/*
 * Carga una mecánica.
 *
 * La carga física del archivo HScript se realiza mediante
 * PlayState.initHScript().
 */
function load(
    name:String
):Bool
{
    init();

    if (name == null || name == '')
        return false;

    if (isLoaded(name))
        return true;

    if (!mechanicPaths.exists(name))
        return false;

    var path:String =
        mechanicPaths.get(name);

    if (path == null || path == '')
        return false;

    game.initHScript(path);
    
    loadedMechanics.set(name, true);

    return isLoaded(name);
}


/*
 * ============================================================
 * DESREGISTRO
 * ============================================================
 */


/*
 * Desregistra una mecánica del sistema Galaxy.
 *
 * Esto NO elimina físicamente el HScript de Psych.
 */
function unregister(
    name:String
):Bool
{
    if (!isLoaded(name))
        return false;


    loadedMechanics.remove(name);


    mechanicFunctions.remove(name);


    return true;
}


/*
 * ============================================================
 * MECÁNICAS CARGADAS
 * ============================================================
 */


/*
 * Devuelve los nombres de las mecánicas cargadas.
 */
function getLoaded():Array
{
    var result:Array = [];


    for (name in loadedMechanics.keys())
    {
        result.push(name);
    }


    return result;
}


/*
 * ============================================================
 * DATOS COMPARTIDOS
 * ============================================================
 */


/*
 * Guarda un dato global de Galaxy.
 */
function setData(
    name:String,
    value:Dynamic
):Void
{
    if (name == null || name == '')
        return;


    data.set(
        name,
        value
    );
}


/*
 * Obtiene un dato global.
 */
function getData(
    name:String
):Dynamic
{
    if (name == null || name == '')
        return null;


    if (!data.exists(name))
        return null;


    return data.get(name);
}


/*
 * Comprueba si existe un dato.
 */
function hasData(
    name:String
):Bool
{
    return
        name != null
        &&
        data.exists(name);
}


/*
 * Elimina un dato.
 */
function removeData(
    name:String
):Bool
{
    if (name == null || !data.exists(name))
        return false;


    return data.remove(name);
}


/*
 * ============================================================
 * LLAMADAS A MECÁNICAS
 * ============================================================
 */


/*
 * Llama una función registrada de una mecánica.
 */
function call(
    mechanic:String,
    func:String,
    args:Array
):Dynamic
{
    if (!isLoaded(mechanic))
        return null;


    if (!mechanicFunctions.exists(mechanic))
        return null;


    var functions:Dynamic =
        mechanicFunctions.get(mechanic);


    if (functions == null)
        return null;


    if (!Reflect.hasField(
        functions,
        func
    ))
    {
        return null;
    }


    var fn:Dynamic =
        Reflect.field(
            functions,
            func
        );


    if (fn == null)
        return null;


    if (args == null)
        args = [];


    return Reflect.callMethod(
        functions,
        fn,
        args
    );
}


/*
 * ============================================================
 * CALLBACKS
 * ============================================================
 */


/*
 * Estos callbacks serán utilizados posteriormente
 * para distribuir los eventos de Psych a las mecánicas.
 */


function onCreate():Void
{
    dispatch(
        'onCreate',
        []
    );
}


function onCreatePost():Void
{
    dispatch(
        'onCreatePost',
        []
    );
}


function onUpdate(
    elapsed:Float
):Void
{
    dispatch(
        'onUpdate',
        [elapsed]
    );
}


function onUpdatePost(
    elapsed:Float
):Void
{
    dispatch(
        'onUpdatePost',
        [elapsed]
    );
}


function onBeatHit(
    curBeat:Int
):Void
{
    dispatch(
        'onBeatHit',
        [curBeat]
    );
}


function onStepHit(
    curStep:Int
):Void
{
    dispatch(
        'onStepHit',
        [curStep]
    );
}


function onSongStart():Void
{
    dispatch(
        'onSongStart',
        []
    );
}


function onEndSong():Void
{
    dispatch(
        'onEndSong',
        []
    );
}


/*
 * ============================================================
 * DISPATCHER
 * ============================================================
 */


/*
 * Envía un callback a todas las mecánicas registradas.
 */
function dispatch(
    callback:String,
    args:Array
):Void
{
    for (mechanic in loadedMechanics.keys())
    {
        if (!loadedMechanics.get(mechanic))
            continue;

        call(
            mechanic,
            callback,
            args
        );
    }
}


/*
 * ============================================================
 * LIMPIEZA
 * ============================================================
 */


/*
 * Reinicia el estado interno del Core.
 */
function reset():Void
{
    loadedMechanics =
        new StringMap();


    mechanicFunctions =
        new StringMap();


    mechanicPaths =
        new StringMap();


    data =
        new StringMap();


    initialized = false;


    init();
}