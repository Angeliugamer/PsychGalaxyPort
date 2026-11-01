/*
 * MoverNotas.hx — módulo de prueba de callbacks para PsychGalaxyPort.
 * Ruta dentro del mod: hx/GalaxyMechanics/Notes/MoverNotas.hx
 *
 * Esta versión todavía NO mueve notas. Registra qué callbacks de GalaxyCore
 * llegaron al módulo para poder verificarlos desde Lua.
 */

var galaxyMoverNotasTestInitialized:Bool = false;
var galaxyMoverNotasCreateCount:Int = 0;
var galaxyMoverNotasCreatePostCount:Int = 0;
var galaxyMoverNotasUpdateCount:Int = 0;
var galaxyMoverNotasUpdatePostCount:Int = 0;
var galaxyMoverNotasBeatCount:Int = 0;
var galaxyMoverNotasStepCount:Int = 0;
var galaxyMoverNotasSongStartCount:Int = 0;
var galaxyMoverNotasLastElapsed:Float = 0;
var galaxyMoverNotasLastBeat:Int = -1;
var galaxyMoverNotasLastStep:Int = -1;

function galaxy_MoverNotas_ping(message:String):String
{
    if (message == null)
        message = '(sin mensaje)';
    return '[MoverNotas] ping recibido: ' + message;
}

function galaxy_MoverNotas_init():Bool
{
    galaxyMoverNotasTestInitialized = true;
    return galaxyMoverNotasTestInitialized;
}

function galaxy_MoverNotas_getStatus():String
{
    return 'initialized=' + galaxyMoverNotasTestInitialized
        + '; onCreate=' + galaxyMoverNotasCreateCount
        + '; onCreatePost=' + galaxyMoverNotasCreatePostCount
        + '; onUpdate=' + galaxyMoverNotasUpdateCount
        + '; onUpdatePost=' + galaxyMoverNotasUpdatePostCount
        + '; onBeatHit=' + galaxyMoverNotasBeatCount
        + '; onStepHit=' + galaxyMoverNotasStepCount
        + '; onSongStart=' + galaxyMoverNotasSongStartCount
        + '; lastElapsed=' + galaxyMoverNotasLastElapsed
        + '; lastBeat=' + galaxyMoverNotasLastBeat
        + '; lastStep=' + galaxyMoverNotasLastStep;
}

function galaxy_MoverNotas_testCoreCall():String
{
    var testValue:String = 'MoverNotas->GalaxyCore OK';
    try
    {
        callOnHScript('galaxyCore_setData', ['MoverNotas_comms_test', testValue]);
        var result:Dynamic = callOnHScript('galaxyCore_getData', ['MoverNotas_comms_test']);
        return '[MoverNotas] llamada a GalaxyCore: ' + Std.string(result);
    }
    catch (e:Dynamic)
    {
        return '[MoverNotas] ERROR llamando a GalaxyCore: ' + Std.string(e);
    }
}

function galaxy_MoverNotas_onCreate():Void
{
    galaxyMoverNotasCreateCount = galaxyMoverNotasCreateCount + 1;
}

function galaxy_MoverNotas_onCreatePost():Void
{
    galaxyMoverNotasCreatePostCount = galaxyMoverNotasCreatePostCount + 1;
}

function galaxy_MoverNotas_onUpdate(elapsed:Float):Void
{
    galaxyMoverNotasUpdateCount = galaxyMoverNotasUpdateCount + 1;
    galaxyMoverNotasLastElapsed = elapsed;
}

function galaxy_MoverNotas_onUpdatePost(elapsed:Float):Void
{
    galaxyMoverNotasUpdatePostCount = galaxyMoverNotasUpdatePostCount + 1;
}

function galaxy_MoverNotas_onBeatHit(curBeat:Int):Void
{
    galaxyMoverNotasBeatCount = galaxyMoverNotasBeatCount + 1;
    galaxyMoverNotasLastBeat = curBeat;
}

function galaxy_MoverNotas_onStepHit(curStep:Int):Void
{
    galaxyMoverNotasStepCount = galaxyMoverNotasStepCount + 1;
    galaxyMoverNotasLastStep = curStep;
}

function galaxy_MoverNotas_onSongStart():Void
{
    galaxyMoverNotasSongStartCount = galaxyMoverNotasSongStartCount + 1;
}

function galaxy_MoverNotas_onEndSong():Void
{
    // Nop
}
