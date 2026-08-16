/*
 * ============================================================
 * VentanaCenter.hx
 * ============================================================
 *
 * FNF In The Galaxy -> Psych Engine 1.0.4
 *
 * Sistema independiente para centrar la ventana.
 *
 * ============================================================
 *
 * RESPONSABILIDAD:
 *
 *     - Centrar la ventana horizontalmente
 *     - Centrar la ventana verticalmente
 *     - Centrar ambos ejes
 *     - Centrar usando el tamaño actual
 *     - Centrar usando un tamaño personalizado
 *     - Obtener el área de trabajo disponible
 *     - Obtener la posición necesaria para centrar
 *
 * ============================================================
 *
 * NO SE ENCARGA DE:
 *
 *     - Redimensionar la ventana
 *     - Shake
 *     - Movimiento sinusoidal
 *     - Movimiento general
 *     - Notas
 *     - Strums
 *     - Cámara
 *     - Render
 *     - 3D
 *
 * ============================================================
 *
 * Utiliza:
 *
 *     MoverVentana.hx
 *     RedimensionarVentana.hx
 *
 * ============================================================
 */

import openfl.Lib;


/**
 * VentanaCenter
 *
 * Sistema de centrado de la ventana.
 */
class VentanaCenter
{
    /*
     * ============================================================
     * CONSTRUCTOR
     * ============================================================
     */

    public function new()
    {
    }


    /*
     * ============================================================
     * GET WINDOW
     * ============================================================
     */

    private static function getWindow():Dynamic
    {
        try
        {
            return Lib.application.window;
        }
        catch (e:Dynamic)
        {
            return null;
        }
    }


    /*
     * ============================================================
     * GET DISPLAY
     * ============================================================
     *
     * Obtiene el display principal.
     *
     * En OpenFL:
     *
     *     window.display
     *
     * proporciona información del monitor asociado.
     *
     * ============================================================
     */

    private static function getDisplay():Dynamic
    {
        var window:Dynamic =
            getWindow();

        if (window == null)
            return null;

        try
        {
            return window.display;
        }
        catch (e:Dynamic)
        {
            return null;
        }
    }


    /*
     * ============================================================
     * DISPLAY WIDTH
     * ============================================================
     */

    public static function getDisplayWidth():Float
    {
        var display:Dynamic =
            getDisplay();

        if (display == null)
            return 0;

        try
        {
            return display.bounds.width;
        }
        catch (e:Dynamic)
        {
            return 0;
        }
    }


    /*
     * ============================================================
     * DISPLAY HEIGHT
     * ============================================================
 */

    public static function getDisplayHeight():Float
    {
        var display:Dynamic =
            getDisplay();

        if (display == null)
            return 0;

        try
        {
            return display.bounds.height;
        }
        catch (e:Dynamic)
        {
            return 0;
        }
    }


    /*
     * ============================================================
     * DISPLAY X
     * ============================================================
 *
 * Posición X del monitor.
 *
 * Esto es importante para sistemas con varios monitores.
 *
 * ============================================================
 */

    public static function getDisplayX():Float
    {
        var display:Dynamic =
            getDisplay();

        if (display == null)
            return 0;

        try
        {
            return display.bounds.x;
        }
        catch (e:Dynamic)
        {
            return 0;
        }
    }


    /*
     * ============================================================
     * DISPLAY Y
     * ============================================================
 */

    public static function getDisplayY():Float
    {
        var display:Dynamic =
            getDisplay();

        if (display == null)
            return 0;

        try
        {
            return display.bounds.y;
        }
        catch (e:Dynamic)
        {
            return 0;
        }
    }


    /*
     * ============================================================
     * CENTER X
     * ============================================================
 *
 * Calcula la posición X necesaria para centrar.
 *
 * ============================================================
 */

    public static function calculateCenterX(
        windowWidth:Float
    ):Float
    {
        return
            getDisplayX() +
            (
                getDisplayWidth() -
                windowWidth
            ) / 2;
    }


    /*
     * ============================================================
     * CENTER Y
     * ============================================================
 */

    public static function calculateCenterY(
        windowHeight:Float
    ):Float
    {
        return
            getDisplayY() +
            (
                getDisplayHeight() -
                windowHeight
            ) / 2;
    }


    /*
     * ============================================================
     * GET CENTER POSITION
     * ============================================================
 */

    public static function getCenterPosition():Dynamic
    {
        var width:Float =
            RedimensionarVentana.getWidth();

        var height:Float =
            RedimensionarVentana.getHeight();

        return {
            x: calculateCenterX(width),
            y: calculateCenterY(height)
        };
    }


    /*
     * ============================================================
     * CENTER X
     * ============================================================
 */

    public static function centerX():Void
    {
        var width:Float =
            RedimensionarVentana.getWidth();

        var x:Float =
            calculateCenterX(width);

        MoverVentana.setX(
            x
        );
    }


    /*
     * ============================================================
     * CENTER Y
     * ============================================================
 */

    public static function centerY():Void
    {
        var height:Float =
            RedimensionarVentana.getHeight();

        var y:Float =
            calculateCenterY(height);

        MoverVentana.setY(
            y
        );
    }


    /*
     * ============================================================
     * CENTER
     * ============================================================
 *
 * Centra usando el tamaño actual de la ventana.
 *
 * ============================================================
 */

    public static function center():Void
    {
        var width:Float =
            RedimensionarVentana.getWidth();

        var height:Float =
            RedimensionarVentana.getHeight();


        var x:Float =
            calculateCenterX(
                width
            );

        var y:Float =
            calculateCenterY(
                height
            );


        MoverVentana.setPosition(
            x,
            y
        );
    }


    /*
     * ============================================================
     * CENTER WITH SIZE
     * ============================================================
 *
 * Calcula el centro utilizando un tamaño específico.
 *
 * Esto NO redimensiona la ventana.
 *
 * ============================================================
 */

    public static function centerWithSize(
        width:Float,
        height:Float
    ):Void
    {
        var x:Float =
            calculateCenterX(
                width
            );

        var y:Float =
            calculateCenterY(
                height
            );


        MoverVentana.setPosition(
            x,
            y
        );
    }


    /*
     * ============================================================
     * CENTER AFTER RESIZE
     * ============================================================
 *
 * Redimensiona y centra.
 *
 * ============================================================
 */

    public static function resizeAndCenter(
        width:Float,
        height:Float
    ):Void
    {
        RedimensionarVentana.setSize(
            width,
            height
        );

        center();
    }


    /*
     * ============================================================
     * CENTER FROM ORIGINAL
     * ============================================================
 *
 * Centra la ventana usando su tamaño original.
 *
 * ============================================================
 */

    public static function centerFromOriginal():Void
    {
        var width:Float =
            RedimensionarVentana.getOriginalWidth();

        var height:Float =
            RedimensionarVentana.getOriginalHeight();


        centerWithSize(
            width,
            height
        );
    }


    /*
     * ============================================================
     * CENTER WITH ORIGINAL SIZE
     * ============================================================
 *
 * Restaura el tamaño original y centra.
 *
 * ============================================================
 */

    public static function restoreAndCenter():Void
    {
        RedimensionarVentana.restore();

        center();
    }


    /*
     * ============================================================
     * CENTER RELATIVE
     * ============================================================
 *
 * Centra y aplica un offset.
 *
 * ============================================================
 */

    public static function centerRelative(
        offsetX:Float,
        offsetY:Float
    ):Void
    {
        var width:Float =
            RedimensionarVentana.getWidth();

        var height:Float =
            RedimensionarVentana.getHeight();


        var x:Float =
            calculateCenterX(
                width
            ) +
            offsetX;

        var y:Float =
            calculateCenterY(
                height
            ) +
            offsetY;


        MoverVentana.setPosition(
            x,
            y
        );
    }


    /*
     * ============================================================
     * CENTER X RELATIVE
     * ============================================================
 */

    public static function centerXRelative(
        offset:Float
    ):Void
    {
        var width:Float =
            RedimensionarVentana.getWidth();

        var x:Float =
            calculateCenterX(
                width
            ) +
            offset;

        MoverVentana.setX(
            x
        );
    }


    /*
     * ============================================================
     * CENTER Y RELATIVE
     * ============================================================
 */

    public static function centerYRelative(
        offset:Float
    ):Void
    {
        var height:Float =
            RedimensionarVentana.getHeight();

        var y:Float =
            calculateCenterY(
                height
            ) +
            offset;

        MoverVentana.setY(
            y
        );
    }


    /*
     * ============================================================
     * GET DISTANCE FROM CENTER
     * ============================================================
 */

    public static function getDistanceFromCenter():Dynamic
    {
        var width:Float =
            RedimensionarVentana.getWidth();

        var height:Float =
            RedimensionarVentana.getHeight();


        var centerX:Float =
            calculateCenterX(
                width
            );

        var centerY:Float =
            calculateCenterY(
                height
            );


        return {
            x:
                MoverVentana.getX() -
                centerX,

            y:
                MoverVentana.getY() -
                centerY
        };
    }


    /*
     * ============================================================
     * IS CENTERED
     * ============================================================
 */

    public static function isCentered(
        tolerance:Float = 1
    ):Bool
    {
        var distance:Dynamic =
            getDistanceFromCenter();

        return
            Math.abs(distance.x) <= tolerance &&
            Math.abs(distance.y) <= tolerance;
    }


    /*
     * ============================================================
     * CENTER SMOOTH
     * ============================================================
 *
 * Acerca progresivamente la ventana al centro.
 *
 * amount:
 *
 *     0 = no movimiento
 *     1 = centro completo
 *
 * ============================================================
 */

    public static function centerSmooth(
        amount:Float
    ):Void
    {
        if (amount < 0)
            amount = 0;

        if (amount > 1)
            amount = 1;


        var width:Float =
            RedimensionarVentana.getWidth();

        var height:Float =
            RedimensionarVentana.getHeight();


        var targetX:Float =
            calculateCenterX(
                width
            );

        var targetY:Float =
            calculateCenterY(
                height
            );


        var currentX:Float =
            MoverVentana.getX();

        var currentY:Float =
            MoverVentana.getY();


        var x:Float =
            currentX +
            (
                targetX -
                currentX
            ) *
            amount;


        var y:Float =
            currentY +
            (
                targetY -
                currentY
            ) *
            amount;


        MoverVentana.setPosition(
            x,
            y
        );
    }


    /*
     * ============================================================
     * CENTER SMOOTH SPEED
     * ============================================================
 *
 * Usa una velocidad en lugar de un porcentaje fijo.
 *
 * ============================================================
 */

    public static function centerSmoothSpeed(
        speed:Float,
        delta:Float
    ):Void
    {
        if (speed < 0)
            speed = 0;

        if (delta < 0)
            delta = 0;


        var amount:Float =
            speed *
            delta;


        if (amount > 1)
            amount = 1;


        centerSmooth(
            amount
        );
    }
}