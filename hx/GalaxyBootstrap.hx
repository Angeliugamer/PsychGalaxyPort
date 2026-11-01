/*
 * GalaxyBootstrap.hx
 * Coordinador de carga de módulos para PsychGalaxyPort.
 *
 * La carga física de HScript sigue siendo responsabilidad de Lua.
 * Bootstrap prepara las rutas, registra e inicializa los módulos.
 */

function galaxy_Bootstrap_ping():String
{
    return 'BOOTSTRAP_OK';
}