var galaxyPruebaIndependenciaBInitialized:Bool = false;
var galaxyPruebaIndependenciaBUpdateCount:Int = 0;

function galaxy_PruebaIndependenciaB_init():Bool
{
    galaxyPruebaIndependenciaBInitialized = true;
    galaxyPruebaIndependenciaBUpdateCount = 0;
    return true;
}

function galaxy_PruebaIndependenciaB_onUpdate(elapsed:Float):Void
{
    galaxyPruebaIndependenciaBUpdateCount =
        galaxyPruebaIndependenciaBUpdateCount + 1;
}

function galaxy_PruebaIndependenciaB_getUpdateCount():Int
{
    return galaxyPruebaIndependenciaBUpdateCount;
}

function galaxy_PruebaIndependenciaB_getStatus():String
{
    return 'initialized=' + galaxyPruebaIndependenciaBInitialized
        + '; updates=' + galaxyPruebaIndependenciaBUpdateCount;
}