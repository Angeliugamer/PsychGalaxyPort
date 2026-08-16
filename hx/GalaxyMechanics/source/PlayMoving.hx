/*
 * ============================================================
 * PlayMoving.hx
 * ============================================================
 *
 * FNF In The Galaxy -> Psych Engine 1.0.4
 *
 * Control básico de MOVIMIENTO de la ventana de Windows.
 *
 * ============================================================
 *
 * RESPONSABILIDAD:
 *
 *     - Obtener la posición de la ventana
 *     - Cambiar X/Y
 *     - Moverla de forma relativa
 *     - Guardar una posición base
 *     - Restaurar la posición base
 *     - Centrar la ventana
 *
 * ============================================================
 *
 * NO se encarga de:
 *
 *     - Redimensionar la ventana
 *     - Hacer shake
 *     - Movimiento sinusoidal
 *     - Mecánicas específicas de una canción
 *
 * Esas funciones pertenecen a:
 *
 *     MoverVentana.hx
 *     RedimensionarVentana.hx
 *     VentanaShake.hx
 *     VentanaSinusoidal.hx
 *
 * ============================================================
 */

import openfl.Lib;
import openfl.display.Window;


class PlayMoving
{
    /*
     * ============================================================
     * ESTADO
     * ============================================================
     */

    /**
     * Posición base X de la ventana.
     */
    public static var baseX:Int = 0;


    /**
     * Posición base Y de la ventana.
     */
    public static var baseY:Int = 0;


    /**
     * Indica si ya se guardó una posición base.
     */
    public static var initialized:Bool = false;


    /*
     * ============================================================
     * GET WINDOW
     * ============================================================
     *
     * Devuelve la ventana principal de OpenFL.
     *
     * Si el engine todavía no tiene una ventana disponible,
     * devuelve null.
     *
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
     * Guarda la posición actual de la ventana como posición base.
     *
     * Normalmente se ejecutará una sola vez:
     *
     *     PlayMoving.init();
     *
     * ============================================================
     */

    public static function init():Void
    {
        var window:Window =
            getWindow();

        if (window == null)
            return;


        baseX =
            window.x;

        baseY =
            window.y;


        initialized = true;
    }


    /*
     * ============================================================
     * GET X
     * ============================================================
     */

    public static function getX():Int
    {
        var window:Window =
            getWindow();

        if (window == null)
            return 0;

        return window.x;
    }


    /*
     * ============================================================
     * GET Y
     * ============================================================
     */

    public static function getY():Int
    {
        var window:Window =
            getWindow();

        if (window == null)
            return 0;

        return window.y;
    }


    /*
     * ============================================================
     * SET X
     * ============================================================
     */

    public static function setX(
        x:Int
    ):Void
    {
        var window:Window =
            getWindow();

        if (window == null)
            return;

        window.x = x;
    }


    /*
     * ============================================================
     * SET Y
     * ============================================================
     */

    public static function setY(
        y:Int
    ):Void
    {
        var window:Window =
            getWindow();

        if (window == null)
            return;

        window.y = y;
    }


    /*
     * ============================================================
     * SET POSITION
     * ============================================================
     */

    public static function setPosition(
        x:Int,
        y:Int
    ):Void
    {
        var window:Window =
            getWindow();

        if (window == null)
            return;


        window.x = x;
        window.y = y;
    }


    /*
     * ============================================================
     * MOVE
     * ============================================================
     *
     * Movimiento ABSOLUTO.
     *
     * Ejemplo:
     *
     *     PlayMoving.move(100, 50);
     *
     * coloca la ventana en:
     *
     *     X = 100
     *     Y = 50
     *
     * ============================================================
     */

    public static function move(
        x:Int,
        y:Int
    ):Void
    {
        setPosition(
            x,
            y
        );
    }


    /*
     * ============================================================
     * OFFSET
     * ============================================================
     *
     * Movimiento RELATIVO.
     *
     * Ejemplo:
     *
     * ventana actual:
     *
     *     500, 300
     *
     * offset:
     *
     *     +50, -20
     *
     * resultado:
     *
     *     550, 280
     *
     * ============================================================
     */

    public static function offset(
        x:Int,
        y:Int
    ):Void
    {
        var window:Window =
            getWindow();

        if (window == null)
            return;


        window.x += x;
        window.y += y;
    }


    /*
     * ============================================================
     * MOVE FROM BASE
     * ============================================================
     *
     * Mueve la ventana tomando como referencia la posición
     * original guardada en init().
     *
     * ============================================================
     */

    public static function moveFromBase(
        offsetX:Int,
        offsetY:Int
    ):Void
    {
        if (!initialized)
            init();


        setPosition(
            baseX + offsetX,
            baseY + offsetY
        );
    }


    /*
     * ============================================================
     * SAVE CURRENT POSITION
     * ============================================================
     *
     * Sobrescribe la posición base con la posición actual.
     *
     * ============================================================
     */

    public static function savePosition():Void
    {
        var window:Window =
            getWindow();

        if (window == null)
            return;


        baseX =
            window.x;

        baseY =
            window.y;


        initialized = true;
    }


    /*
     * ============================================================
     * RESET POSITION
     * ============================================================
     *
     * Devuelve la ventana a la posición guardada.
     *
     * ============================================================
     */

    public static function resetPosition():Void
    {
        if (!initialized)
            init();


        setPosition(
            baseX,
            baseY
        );
    }


    /*
     * ============================================================
     * GET BASE X
     * ============================================================
     */

    public static function getBaseX():Int
    {
        if (!initialized)
            init();

        return baseX;
    }


    /*
     * ============================================================
     * GET BASE Y
     * ============================================================
     */

    public static function getBaseY():Int
    {
        if (!initialized)
            init();

        return baseY;
    }


    /*
     * ============================================================
     * SET BASE POSITION
     * ============================================================
     *
     * Cambia la posición que será considerada como "original".
     *
     * No mueve la ventana.
     *
     * ============================================================
     */

    public static function setBasePosition(
        x:Int,
        y:Int
    ):Void
    {
        baseX =
            x;

        baseY =
            y;

        initialized = true;
    }


    /*
     * ============================================================
     * CENTER
     * ============================================================
     *
     * Centra la ventana en la pantalla principal.
     *
     * Utilizamos screen.bounds para obtener las dimensiones
     * del monitor principal.
     *
     * ============================================================
     */

    public static function center():Void
    {
        var window:Window =
            getWindow();

        if (window == null)
            return;


        var screenBounds =
            window.display.bounds;


        var newX:Int =
            Std.int(
                screenBounds.x +
                (
                    screenBounds.width -
                    window.width
                ) / 2
            );


        var newY:Int =
            Std.int(
                screenBounds.y +
                (
                    screenBounds.height -
                    window.height
                ) / 2
            );


        setPosition(
            newX,
            newY
        );
    }


    /*
     * ============================================================
     * CENTER X
     * ============================================================
     */

    public static function centerX():Void
    {
        var window:Window =
            getWindow();

        if (window == null)
            return;


        var screenBounds =
            window.display.bounds;


        var newX:Int =
            Std.int(
                screenBounds.x +
                (
                    screenBounds.width -
                    window.width
                ) / 2
            );


        setX(
            newX
        );
    }


    /*
     * ============================================================
     * CENTER Y
     * ============================================================
     */

    public static function centerY():Void
    {
        var window:Window =
            getWindow();

        if (window == null)
            return;


        var screenBounds =
            window.display.bounds;


        var newY:Int =
            Std.int(
                screenBounds.y +
                (
                    screenBounds.height -
                    window.height
                ) / 2
            );


        setY(
            newY
        );
    }


    /*
     * ============================================================
     * RESET
     * ============================================================
     *
     * Borra la posición almacenada.
     *
     * No mueve la ventana.
     *
     * ============================================================
     */

    public static function reset():Void
    {
        baseX = 0;
        baseY = 0;

        initialized = false;
    }
}