/*
 * ============================================================
 * PlayWindow.hx
 * ============================================================
 *
 * FNF In The Galaxy -> Psych Engine 1.0.4
 *
 * API base para controlar la ventana del juego.
 *
 * ============================================================
 *
 * RESPONSABILIDAD:
 *
 *     - Obtener la ventana
 *     - Obtener su tamaño
 *     - Cambiar su tamaño
 *     - Guardar/restaurar tamaño original
 *     - Obtener/cambiar escala
 *     - Minimizar/restaurar
 *     - Mostrar/ocultar la ventana
 *
 * ============================================================
 *
 * NO IMPLEMENTA:
 *
 *     - Movimiento de ventana
 *     - Shake
 *     - Movimiento sinusoidal
 *     - Animaciones
 *
 * Para eso:
 *
 *     PlayMoving.hx
 *     MoverVentana.hx
 *     VentanaShake.hx
 *     VentanaSinusoidal.hx
 *
 * ============================================================
 */

import openfl.Lib;
import openfl.display.Window;


class PlayWindow
{
    /*
     * ============================================================
     * ESTADO BASE
     * ============================================================
     */

    /**
     * Ancho original de la ventana.
     */
    public static var baseWidth:Int = 0;


    /**
     * Alto original de la ventana.
     */
    public static var baseHeight:Int = 0;


    /**
     * Indica si ya se guardó el tamaño original.
     */
    public static var initialized:Bool = false;


    /*
     * ============================================================
     * GET WINDOW
     * ============================================================
     */

    public static function getWindow():Window
    {
        if (Lib.application == null)
            return null;

        return Lib.application.window;
    }


    /*
     * ============================================================
     * INIT
     * ============================================================
     *
     * Guarda el tamaño actual como tamaño base.
     *
     * ============================================================
     */

    public static function init():Void
    {
        var window:Window =
            getWindow();

        if (window == null)
            return;


        baseWidth =
            window.width;

        baseHeight =
            window.height;

        initialized = true;
    }


    /*
     * ============================================================
     * GET WIDTH
     * ============================================================
     */

    public static function getWidth():Int
    {
        var window:Window =
            getWindow();

        if (window == null)
            return 0;

        return window.width;
    }


    /*
     * ============================================================
     * GET HEIGHT
     * ============================================================
     */

    public static function getHeight():Int
    {
        var window:Window =
            getWindow();

        if (window == null)
            return 0;

        return window.height;
    }


    /*
     * ============================================================
     * SET WIDTH
     * ============================================================
     */

    public static function setWidth(
        width:Int
    ):Void
    {
        var window:Window =
            getWindow();

        if (window == null)
            return;


        if (width < 1)
            width = 1;


        window.width =
            width;
    }


    /*
     * ============================================================
     * SET HEIGHT
     * ============================================================
     */

    public static function setHeight(
        height:Int
    ):Void
    {
        var window:Window =
            getWindow();

        if (window == null)
            return;


        if (height < 1)
            height = 1;


        window.height =
            height;
    }


    /*
     * ============================================================
     * SET SIZE
     * ============================================================
     */

    public static function setSize(
        width:Int,
        height:Int
    ):Void
    {
        var window:Window =
            getWindow();

        if (window == null)
            return;


        if (width < 1)
            width = 1;

        if (height < 1)
            height = 1;


        window.width =
            width;

        window.height =
            height;
    }


    /*
     * ============================================================
     * OFFSET SIZE
     * ============================================================
     *
     * Cambia el tamaño actual de manera relativa.
     *
     * Ejemplo:
     *
     *     ventana = 1280x720
     *
     *     offsetSize(100, 50)
     *
     *     resultado = 1380x770
     *
     * ============================================================
     */

    public static function offsetSize(
        width:Int,
        height:Int
    ):Void
    {
        var window:Window =
            getWindow();

        if (window == null)
            return;


        setSize(
            window.width + width,
            window.height + height
        );
    }


    /*
     * ============================================================
     * SCALE
     * ============================================================
     *
     * Cambia el tamaño utilizando un multiplicador.
     *
     * Ejemplo:
     *
     *     1280x720
     *
     *     scale(0.5)
     *
     *     = 640x360
     *
     * ============================================================
     */

    public static function scale(
        multiplier:Float
    ):Void
    {
        var window:Window =
            getWindow();

        if (window == null)
            return;


        if (multiplier < 0)
            multiplier = 0;


        var width:Int =
            Std.int(
                window.width *
                multiplier
            );


        var height:Int =
            Std.int(
                window.height *
                multiplier
            );


        setSize(
            width,
            height
        );
    }


    /*
     * ============================================================
     * SCALE FROM BASE
     * ============================================================
     *
     * Cambia el tamaño tomando como referencia el tamaño
     * original guardado en init().
     *
     * ============================================================
     */

    public static function scaleFromBase(
        multiplier:Float
    ):Void
    {
        if (!initialized)
            init();


        if (multiplier < 0)
            multiplier = 0;


        var width:Int =
            Std.int(
                baseWidth *
                multiplier
            );


        var height:Int =
            Std.int(
                baseHeight *
                multiplier
            );


        setSize(
            width,
            height
        );
    }


    /*
     * ============================================================
     * SAVE SIZE
     * ============================================================
     *
     * Sobrescribe el tamaño base con el tamaño actual.
     *
     * ============================================================
     */

    public static function saveSize():Void
    {
        var window:Window =
            getWindow();

        if (window == null)
            return;


        baseWidth =
            window.width;

        baseHeight =
            window.height;

        initialized = true;
    }


    /*
     * ============================================================
     * SET BASE SIZE
     * ============================================================
     *
     * Cambia el tamaño base sin cambiar el tamaño actual.
     *
     * ============================================================
     */

    public static function setBaseSize(
        width:Int,
        height:Int
    ):Void
    {
        if (width < 1)
            width = 1;

        if (height < 1)
            height = 1;


        baseWidth =
            width;

        baseHeight =
            height;

        initialized = true;
    }


    /*
     * ============================================================
     * GET BASE WIDTH
     * ============================================================
     */

    public static function getBaseWidth():Int
    {
        if (!initialized)
            init();

        return baseWidth;
    }


    /*
     * ============================================================
     * GET BASE HEIGHT
     * ============================================================
     */

    public static function getBaseHeight():Int
    {
        if (!initialized)
            init();

        return baseHeight;
    }


    /*
     * ============================================================
     * RESET SIZE
     * ============================================================
     *
     * Devuelve la ventana a su tamaño original.
     *
     * ============================================================
     */

    public static function resetSize():Void
    {
        if (!initialized)
            init();


        setSize(
            baseWidth,
            baseHeight
        );
    }


    /*
     * ============================================================
     * MINIMIZE
     * ============================================================
     */

    public static function minimize():Void
    {
        var window:Window =
            getWindow();

        if (window == null)
            return;

        window.minimized = true;
    }


    /*
     * ============================================================
     * RESTORE
     * ============================================================
     */

    public static function restore():Void
    {
        var window:Window =
            getWindow();

        if (window == null)
            return;

        window.minimized = false;
    }


    /*
     * ============================================================
     * IS MINIMIZED
     * ============================================================
     */

    public static function isMinimized():Bool
    {
        var window:Window =
            getWindow();

        if (window == null)
            return false;

        return window.minimized;
    }


    /*
     * ============================================================
     * SHOW
     * ============================================================
     */

    public static function show():Void
    {
        var window:Window =
            getWindow();

        if (window == null)
            return;

        window.visible = true;
    }


    /*
     * ============================================================
     * HIDE
     * ============================================================
 */

    public static function hide():Void
    {
        var window:Window =
            getWindow();

        if (window == null)
            return;

        window.visible = false;
    }


    /*
     * ============================================================
     * IS VISIBLE
     * ============================================================
     */

    public static function isVisible():Bool
    {
        var window:Window =
            getWindow();

        if (window == null)
            return false;

        return window.visible;
    }


    /*
     * ============================================================
     * GET DISPLAY SCALE
     * ============================================================
     *
     * Devuelve la escala de densidad de la pantalla donde está
     * la ventana.
     *
     * Puede resultar útil posteriormente para cálculos que
     * involucren diferentes escalas DPI.
     *
     * ============================================================
     */

    public static function getDisplayScale():Float
    {
        var window:Window =
            getWindow();

        if (window == null)
            return 1;


        return window.scale;
    }


    /*
     * ============================================================
     * GET FRAME RATE
     * ============================================================
     *
     * Devuelve el frameRate configurado en la ventana.
     *
     * No cambia el FPS del juego.
     * ============================================================
     */

    public static function getFrameRate():Float
    {
        var window:Window =
            getWindow();

        if (window == null)
            return 0;


        return window.frameRate;
    }


    /*
     * ============================================================
     * SET FRAME RATE
     * ============================================================
     *
     * Se incluye como utilidad de ventana, aunque las mecánicas
     * de Galaxy no deberían depender de esto.
     * ============================================================
     */

    public static function setFrameRate(
        fps:Float
    ):Void
    {
        var window:Window =
            getWindow();

        if (window == null)
            return;


        if (fps < 1)
            fps = 1;


        window.frameRate =
            fps;
    }


    /*
     * ============================================================
     * RESET
     * ============================================================
     *
     * Borra la información almacenada.
     *
     * No modifica la ventana.
     *
     * ============================================================
     */

    public static function reset():Void
    {
        baseWidth = 0;
        baseHeight = 0;

        initialized = false;
    }
}