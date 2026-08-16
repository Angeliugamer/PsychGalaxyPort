/*
 * ============================================================
 * MoverVentana.hx
 * ============================================================
 *
 * FNF In The Galaxy -> Psych Engine 1.0.4
 *
 * Control independiente de la posición de la ventana.
 *
 * ============================================================
 *
 * RESPONSABILIDAD:
 *
 *     - Obtener posición de la ventana
 *     - Establecer X/Y
 *     - Mover la ventana
 *     - Moverla de forma relativa
 *     - Interpolar entre posiciones
 *     - Movimiento sinusoidal
 *     - Movimiento circular
 *     - Guardar/restaurar posición original
 *
 * ============================================================
 *
 * NO SE ENCARGA DE:
 *
 *     - Redimensionar ventana
 *     - Shake
 *     - Centrar ventana
 *     - Notas
 *     - Strums
 *     - Cámara
 *     - Render
 *     - 3D
 *
 * ============================================================
 *
 * Este archivo utiliza directamente la ventana de OpenFL.
 *
 * Está pensado exclusivamente para Psych Engine 1.0.4.
 *
 * ============================================================
 */

import openfl.Lib;
import openfl.display.Window;


/**
 * MoverVentana
 *
 * Sistema de movimiento de la ventana de Psych Engine.
 */
class MoverVentana
{
    /*
     * ============================================================
     * POSICIÓN ORIGINAL
     * ============================================================
     */

    private static var originalX:Float = 0;
    private static var originalY:Float = 0;

    private static var hasOriginalPosition:Bool = false;


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
     * GET X
     * ============================================================
     */

    public static function getX():Float
    {
        var window:Dynamic =
            getWindow();

        if (window == null)
            return 0;

        try
        {
            return window.x;
        }
        catch (e:Dynamic)
        {
            return 0;
        }
    }


    /*
     * ============================================================
     * GET Y
     * ============================================================
 */

    public static function getY():Float
    {
        var window:Dynamic =
            getWindow();

        if (window == null)
            return 0;

        try
        {
            return window.y;
        }
        catch (e:Dynamic)
        {
            return 0;
        }
    }


    /*
     * ============================================================
     * SAVE ORIGINAL POSITION
     * ============================================================
 */

    public static function saveOriginal():Void
    {
        var window:Dynamic =
            getWindow();

        if (window == null)
            return;

        try
        {
            originalX =
                window.x;

            originalY =
                window.y;

            hasOriginalPosition =
                true;
        }
        catch (e:Dynamic)
        {
        }
    }


    /*
     * ============================================================
     * SET X
     * ============================================================
 */

    public static function setX(
        x:Float
    ):Void
    {
        var window:Dynamic =
            getWindow();

        if (window == null)
            return;

        try
        {
            window.x =
                Std.int(x);
        }
        catch (e:Dynamic)
        {
        }
    }


    /*
     * ============================================================
     * SET Y
     * ============================================================
 */

    public static function setY(
        y:Float
    ):Void
    {
        var window:Dynamic =
            getWindow();

        if (window == null)
            return;

        try
        {
            window.y =
                Std.int(y);
        }
        catch (e:Dynamic)
        {
        }
    }


    /*
     * ============================================================
     * SET POSITION
     * ============================================================
 */

    public static function setPosition(
        x:Float,
        y:Float
    ):Void
    {
        var window:Dynamic =
            getWindow();

        if (window == null)
            return;

        try
        {
            window.x =
                Std.int(x);

            window.y =
                Std.int(y);
        }
        catch (e:Dynamic)
        {
        }
    }


    /*
     * ============================================================
     * MOVE
     * ============================================================
 *
 * Movimiento absoluto.
 *
 * ============================================================
 */

    public static function move(
        x:Float,
        y:Float
    ):Void
    {
        setPosition(
            x,
            y
        );
    }


    /*
     * ============================================================
     * MOVE RELATIVE
     * ============================================================
 *
 * Mueve la ventana respecto a su posición actual.
 *
 * ============================================================
 */

    public static function moveRelative(
        offsetX:Float,
        offsetY:Float
    ):Void
    {
        setPosition(
            getX() + offsetX,
            getY() + offsetY
        );
    }


    /*
     * ============================================================
     * MOVE FROM ORIGINAL
     * ============================================================
 *
 * Posición:
 *
 *     original + offset
 *
 * Esto es especialmente útil en onUpdate porque evita
 * acumular desplazamiento cada frame.
 *
 * ============================================================
 */

    public static function moveFromOriginal(
        offsetX:Float,
        offsetY:Float
    ):Void
    {
        if (!hasOriginalPosition)
            saveOriginal();

        setPosition(
            originalX + offsetX,
            originalY + offsetY
        );
    }


    /*
     * ============================================================
     * GET ORIGINAL X
     * ============================================================
 */

    public static function getOriginalX():Float
    {
        if (!hasOriginalPosition)
            saveOriginal();

        return originalX;
    }


    /*
     * ============================================================
     * GET ORIGINAL Y
     * ============================================================
 */

    public static function getOriginalY():Float
    {
        if (!hasOriginalPosition)
            saveOriginal();

        return originalY;
    }


    /*
     * ============================================================
     * LERP
     * ============================================================
 *
 * Interpolación lineal.
 *
 * ============================================================
 */

    public static function lerp(
        from:Float,
        to:Float,
        amount:Float
    ):Float
    {
        return from +
            (to - from) *
            amount;
    }


    /*
     * ============================================================
     * MOVE LERP
     * ============================================================
 *
 * Interpola la ventana entre dos posiciones.
 *
 * amount:
 *
 *     0 = inicio
 *     1 = destino
 *
 * ============================================================
 */

    public static function moveLerp(
        startX:Float,
        startY:Float,
        endX:Float,
        endY:Float,
        amount:Float
    ):Void
    {
        if (amount < 0)
            amount = 0;

        if (amount > 1)
            amount = 1;

        setPosition(
            lerp(
                startX,
                endX,
                amount
            ),

            lerp(
                startY,
                endY,
                amount
            )
        );
    }


    /*
     * ============================================================
     * MOVE TO ORIGINAL
     * ============================================================
 */

    public static function moveToOriginal():Void
    {
        if (!hasOriginalPosition)
            return;

        setPosition(
            originalX,
            originalY
        );
    }


    /*
     * ============================================================
     * MOVE TO ORIGINAL LERP
     * ============================================================
 */

    public static function moveToOriginalLerp(
        amount:Float
    ):Void
    {
        if (!hasOriginalPosition)
            saveOriginal();

        moveLerp(
            getX(),
            getY(),
            originalX,
            originalY,
            amount
        );
    }


    /*
     * ============================================================
     * MOVE SINUSOIDAL
     * ============================================================
 *
 * Movimiento sinusoidal independiente en X/Y.
 *
 * Fórmula:
 *
 *     x = centerX + sin(time * speedX + phaseX) * amplitudeX
 *     y = centerY + sin(time * speedY + phaseY) * amplitudeY
 *
 * ============================================================
 */

    public static function moveSinusoidal(
        centerX:Float,
        centerY:Float,
        amplitudeX:Float,
        amplitudeY:Float,
        speedX:Float,
        speedY:Float,
        phaseX:Float,
        phaseY:Float,
        time:Float
    ):Void
    {
        var x:Float =
            centerX +
            Math.sin(
                time * speedX +
                phaseX
            ) *
            amplitudeX;

        var y:Float =
            centerY +
            Math.sin(
                time * speedY +
                phaseY
            ) *
            amplitudeY;

        setPosition(
            x,
            y
        );
    }


    /*
     * ============================================================
     * MOVE SINUSOIDAL FROM ORIGINAL
     * ============================================================
 *
 * Variante especialmente útil para modcharts.
 *
 * ============================================================
 */

    public static function moveSinusoidalFromOriginal(
        amplitudeX:Float,
        amplitudeY:Float,
        speedX:Float,
        speedY:Float,
        phaseX:Float,
        phaseY:Float,
        time:Float
    ):Void
    {
        if (!hasOriginalPosition)
            saveOriginal();

        moveSinusoidal(
            originalX,
            originalY,
            amplitudeX,
            amplitudeY,
            speedX,
            speedY,
            phaseX,
            phaseY,
            time
        );
    }


    /*
     * ============================================================
     * MOVE CIRCULAR
     * ============================================================
 *
 * Movimiento alrededor de un punto.
 *
 * ============================================================
 */

    public static function moveCircular(
        centerX:Float,
        centerY:Float,
        radiusX:Float,
        radiusY:Float,
        speed:Float,
        phase:Float,
        time:Float
    ):Void
    {
        var angle:Float =
            time * speed +
            phase;

        var x:Float =
            centerX +
            Math.cos(angle) *
            radiusX;

        var y:Float =
            centerY +
            Math.sin(angle) *
            radiusY;

        setPosition(
            x,
            y
        );
    }


    /*
     * ============================================================
     * MOVE CIRCULAR FROM ORIGINAL
     * ============================================================
 */

    public static function moveCircularFromOriginal(
        radiusX:Float,
        radiusY:Float,
        speed:Float,
        phase:Float,
        time:Float
    ):Void
    {
        if (!hasOriginalPosition)
            saveOriginal();

        moveCircular(
            originalX,
            originalY,
            radiusX,
            radiusY,
            speed,
            phase,
            time
        );
    }


    /*
     * ============================================================
     * MOVE TOWARDS
     * ============================================================
 *
 * Acerca la ventana a un destino una cantidad determinada.
 *
 * ============================================================
 */

    public static function moveTowards(
        targetX:Float,
        targetY:Float,
        amount:Float
    ):Void
    {
        var currentX:Float =
            getX();

        var currentY:Float =
            getY();

        setPosition(
            currentX +
            (targetX - currentX) *
            amount,

            currentY +
            (targetY - currentY) *
            amount
        );
    }


    /*
     * ============================================================
     * MOVE FROM ORIGINAL TOWARDS
     * ============================================================
 */

    public static function moveOriginalTowards(
        targetOffsetX:Float,
        targetOffsetY:Float,
        amount:Float
    ):Void
    {
        if (!hasOriginalPosition)
            saveOriginal();

        var targetX:Float =
            originalX +
            targetOffsetX;

        var targetY:Float =
            originalY +
            targetOffsetY;

        moveTowards(
            targetX,
            targetY,
            amount
        );
    }


    /*
     * ============================================================
     * SET OFFSET FROM ORIGINAL
     * ============================================================
 *
 * Alias cómodo para Lua.
 *
 * ============================================================
 */

    public static function setOffset(
        offsetX:Float,
        offsetY:Float
    ):Void
    {
        moveFromOriginal(
            offsetX,
            offsetY
        );
    }


    /*
     * ============================================================
     * GET OFFSET X
     * ============================================================
 */

    public static function getOffsetX():Float
    {
        if (!hasOriginalPosition)
            saveOriginal();

        return
            getX() -
            originalX;
    }


    /*
     * ============================================================
     * GET OFFSET Y
     * ============================================================
 */

    public static function getOffsetY():Float
    {
        if (!hasOriginalPosition)
            saveOriginal();

        return
            getY() -
            originalY;
    }


    /*
     * ============================================================
     * RESTORE
     * ============================================================
 */

    public static function restore():Void
    {
        if (!hasOriginalPosition)
            return;

        setPosition(
            originalX,
            originalY
        );
    }


    /*
     * ============================================================
     * RESET ORIGINAL
     * ============================================================
 *
 * Hace que la posición actual pase a ser la nueva posición
 * original.
 *
 * ============================================================
 */

    public static function resetOriginal():Void
    {
        saveOriginal();
    }


    /*
     * ============================================================
     * CLEAR ORIGINAL
     * ============================================================
 */

    public static function clearOriginal():Void
    {
        originalX =
            0;

        originalY =
            0;

        hasOriginalPosition =
            false;
    }


    /*
     * ============================================================
     * GET POSITION
     * ============================================================
 */

    public static function getPosition():Dynamic
    {
        return {
            x: getX(),
            y: getY()
        };
    }


    /*
     * ============================================================
     * SET POSITION INTEGER
     * ============================================================
 *
 * Versión explícita para movimientos de ventana que requieren
 * valores enteros.
 *
 * ============================================================
 */

    public static function setPositionInt(
        x:Int,
        y:Int
    ):Void
    {
        var window:Dynamic =
            getWindow();

        if (window == null)
            return;

        try
        {
            window.x =
                x;

            window.y =
                y;
        }
        catch (e:Dynamic)
        {
        }
    }
}