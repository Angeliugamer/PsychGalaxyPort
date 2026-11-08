var galaxyPruebaIndependenciaInitialized:Bool = false;
var galaxyPruebaIndependenciaUpdateCount:Int = 0;

function galaxy_PruebaIndependencia_init():Bool
{
    galaxyPruebaIndependenciaInitialized = true;
    galaxyPruebaIndependenciaUpdateCount = 0;
    return true;
}

function galaxy_PruebaIndependencia_onUpdate(elapsed:Float):Void
{
    galaxyPruebaIndependenciaUpdateCount =
        galaxyPruebaIndependenciaUpdateCount + 1;
}

function galaxy_PruebaIndependencia_getUpdateCount():Int
{
    return galaxyPruebaIndependenciaUpdateCount;
}

function galaxy_PruebaIndependencia_getStatus():String
{
    return 'initialized=' + galaxyPruebaIndependenciaInitialized
        + '; updates=' + galaxyPruebaIndependenciaUpdateCount;
}
