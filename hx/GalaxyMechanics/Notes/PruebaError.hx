var galaxyPruebaErrorInitialized:Bool = false;

function galaxy_PruebaError_init():Bool
{
    galaxyPruebaErrorInitialized = true;
    return true;
}

function galaxy_PruebaError_onUpdate(elapsed:Float):String
{
    try
    {
        throw 'Error intencional de prueba en PruebaError';
    }
    catch (e:Dynamic)
    {
        return '[GALAXY_ERROR] ' + Std.string(e);
    }

    return '';
}

function galaxy_PruebaError_getStatus():String
{
    return 'initialized=' + galaxyPruebaErrorInitialized;
}

function galaxy_PruebaError_testThrow():Void
{
    throw 'Error externo de prueba';
}

function galaxy_PruebaError_testSafe():String
{
    try
    {
        galaxy_PruebaError_testThrow();
        return 'SIN EXCEPCION';
    }
    catch (e:Dynamic)
    {
        return 'CAPTURADO: ' + Std.string(e);
    }
}