// Identificación del módulo.
var galaxyModuloInitialized:Bool = false;
var galaxyModuloEnabled:Bool = true;

// Inicialización.
function galaxy_Modulo_init():Bool
{
    if (galaxyModuloInitialized)
        return true;

    // Inicialización de variables y recursos.

    galaxyModuloInitialized = true;
    return true;
}

// Estado.
function galaxy_Modulo_getStatus():String
{
    return 'initialized=' + galaxyModuloInitialized
        + '; enabled=' + galaxyModuloEnabled;
}

// Comunicación.
function galaxy_Modulo_ping(message:String):String
{
    if (message == null)
        message = '(sin mensaje)';

    return '[Modulo] ping recibido: ' + message;
}

// Callbacks.
function galaxy_Modulo_onCreate():Void {}
function galaxy_Modulo_onCreatePost():Void {}
function galaxy_Modulo_onUpdate(elapsed:Float):Void {}
function galaxy_Modulo_onUpdatePost(elapsed:Float):Void {}
function galaxy_Modulo_onBeatHit(curBeat:Int):Void {}
function galaxy_Modulo_onStepHit(curStep:Int):Void {}
function galaxy_Modulo_onSongStart():Void {}
function galaxy_Modulo_onEndSong():Void {}