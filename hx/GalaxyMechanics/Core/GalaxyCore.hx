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
 * Ejemplo desde Lua:
 *
 *     addHScript('mods/MiMod/scripts/Galaxy/GalaxyCore.hx')
 *
 *     runHaxeFunction('Galaxy.load', {'MoverVentana'})
 *
 * Posteriormente podremos crear una interfaz Lua más cómoda.
 */

import haxe.ds.StringMap;


class GalaxyCore
{
    /*
     * ============================================================
     * ESTADO
     * ============================================================
     */

    // Mecánicas actualmente cargadas.
    public static var loadedMechanics:StringMap<Bool> = new StringMap<Bool>();

    // Instancias HScript asociadas a las mecánicas.
    public static var mechanicInstances:StringMap<Dynamic> = new StringMap<Dynamic>();

    // Datos compartidos entre las diferentes mecánicas.
    public static var data:StringMap<Dynamic> = new StringMap<Dynamic>();

    // Indica si el Core ya fue inicializado.
    public static var initialized:Bool = false;


    /*
     * ============================================================
     * INICIALIZACIÓN
     * ============================================================
     */

    public static function init():Void
    {
        if (initialized)
            return;

        initialized = true;

        trace('[GalaxyCore] Initialized.');
    }


    /*
     * ============================================================
     * MECÁNICAS
     * ============================================================
     */

    /**
     * Registra una mecánica como cargada.
     *
     * El archivo HScript debe haber sido cargado previamente
     * mediante addHScript().
     */
    public static function register(name:String):Bool
    {
        init();

        if (name == null || name == '')
        {
            trace('[GalaxyCore] Cannot register mechanic: empty name.');
            return false;
        }

        loadedMechanics.set(name, true);
        trace('[GalaxyCore] Registered mechanic: ' + name);

        return true;
    }

    public static function registerInstance(
        name:String,
        instance:Dynamic
    ):Bool
    {
        if (name == null || name == '')
            return false;

        if (instance == null)
            return false;

        mechanicInstances.set(name, instance);

        return true;
    }


    /**
     * Comprueba si una mecánica está registrada.
     */
    public static function isLoaded(name:String):Bool
    {
        if (name == null)
            return false;

        return loadedMechanics.exists(name)
            && loadedMechanics.get(name) == true;
    }


    /**
     * Desregistra una mecánica.
     *
     * Esto solamente elimina la mecánica del sistema Galaxy.
     * No descarga automáticamente el HScript de Psych.
     */
    public static function unregister(name:String):Bool
    {
        if (!isLoaded(name))
            return false;

        loadedMechanics.remove(name);
        trace('[GalaxyCore] Unregistered mechanic: ' + name);

        return true;
    }


    /**
     * Devuelve todas las mecánicas registradas.
     */
    public static function getLoaded():Array<String>
    {
        var result:Array<String> = [];

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

    /**
     * Guarda un dato global del sistema Galaxy.
     *
     * Ejemplo:
     *
     * GalaxyCore.setData('windowX', 500);
     */
    public static function setData(name:String, value:Dynamic):Void
    {
        if (name == null || name == '')
            return;

        data.set(name, value);
    }


    /**
     * Obtiene un dato global del sistema Galaxy.
     */
    public static function getData(name:String):Dynamic
    {
        if (name == null || name == '')
            return null;

        if (!data.exists(name))
            return null;

        return data.get(name);
    }


    /**
     * Comprueba si existe un dato.
     */
    public static function hasData(name:String):Bool
    {
        return name != null && data.exists(name);
    }


    /**
     * Elimina un dato.
     */
    public static function removeData(name:String):Bool
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

    /**
     * Llama una función de una mecánica.
     *
     * Esta función está pensada como punto central para que
     * posteriormente Lua pueda hacer:
     *
     * Galaxy.call('MoverVentana', 'move', {...});
     */
    public static function call(
        mechanic:String,
        func:String,
        args:Array<Dynamic> = null
    ):Dynamic
    {
        if (!isLoaded(mechanic))
        {
            trace(
                '[GalaxyCore] Cannot call "' +
                func +
                '" because mechanic "' +
                mechanic +
                '" is not loaded.'
            );
            return null;
        }

        if (!mechanicInstances.exists(mechanic))
        {
            trace(
                '[GalaxyCore] Cannot call "' +
                func +
                '" because mechanic "' +
                mechanic +
                '" has no registered instance.'
            );
            return null;
        }

        var instance:Dynamic = mechanicInstances.get(mechanic);

        if (instance == null)
            return null;

        if (!Reflect.hasField(instance, func))
        {
            trace(
                '[GalaxyCore] Function "' +
                func +
                '" was not found in mechanic "' +
                mechanic +
                '".'
            );
            return null;
        }

        var fn:Dynamic = Reflect.field(instance, func);

        if (fn == null)
            return null;

        if (args == null)
            args = [];

        return Reflect.callMethod(
            instance,
            fn,
            args
        );
    }


    /*
     * ============================================================
     * CALLBACKS
     * ============================================================
     *
     * Estos serán utilizados posteriormente por las mecánicas
     * para recibir los eventos de Psych.
     */

    public static function onCreate():Void
    {
        dispatch('onCreate');
    }


    public static function onCreatePost():Void
    {
        dispatch('onCreatePost');
    }


    public static function onUpdate(elapsed:Float):Void
    {
        dispatch('onUpdate', [elapsed]);
    }


    public static function onUpdatePost(elapsed:Float):Void
    {
        dispatch('onUpdatePost', [elapsed]);
    }


    public static function onBeatHit(curBeat:Int):Void
    {
        dispatch('onBeatHit', [curBeat]);
    }


    public static function onStepHit(curStep:Int):Void
    {
        dispatch('onStepHit', [curStep]);
    }


    public static function onSongStart():Void
    {
        dispatch('onSongStart');
    }


    public static function onEndSong():Void
    {
        dispatch('onEndSong');
    }


    /*
     * ============================================================
     * DISPATCHER
     * ============================================================
     */

    /**
     * Envía un callback a las mecánicas registradas.
     *
     * Por ahora solamente sirve como base del sistema.
     *
     * Más adelante podremos hacer que:
     *
     * onUpdate()
     *      ↓
     * MoverNotas.onUpdate()
     * MoverStrums.onUpdate()
     * MoverVentana.onUpdate()
     *
     * etc.
     */
    public static function dispatch(
        callback:String,
        args:Array<Dynamic> = null
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

    /**
     * Desactiva todas las mecánicas.
     *
     * No elimina sus archivos HScript de Psych.
     */
    public static function reset():Void
    {
        loadedMechanics = new StringMap<Bool>();
        mechanicInstances = new StringMap<Dynamic>();
        data = new StringMap<Dynamic>();

        trace('[GalaxyCore] Reset.');
    }
}