/*
 * ============================================================
 * RedimensionarVentana.hx
 * ============================================================
 *
 * FNF In The Galaxy -> Psych Engine 1.0.4
 *
 * Control independiente del tamaño de la ventana.
 *
 * ============================================================
 *
 * RESPONSABILIDAD:
 *
 *     - Obtener width / height
 *     - Establecer width / height
 *     - Redimensionar absolutamente
 *     - Redimensionar relativamente
 *     - Escalar desde el tamaño original
 *     - Interpolar tamaños
 *     - Redimensionamiento sinusoidal
 *     - Guardar/restaurar tamaño original
 *
 * ============================================================
 *
 * NO SE ENCARGA DE:
 *
 *     - Posición X/Y
 *     - Movimiento de ventana
 *     - Shake
 *     - Centrado
 *     - Notas
 *     - Strums
 *     - Cámara
 *     - Render
 *     - 3D
 *
 * ============================================================
 *
 * Este archivo está diseñado específicamente para
 * Psych Engine 1.0.4 / OpenFL.
 *
 * ============================================================
 */

import openfl.Lib;


/**
 * RedimensionarVentana
 *
 * Sistema independiente para controlar el tamaño de la ventana.
 */
class RedimensionarVentana
{
    /*
     * ============================================================
     * TAMAÑO ORIGINAL
     * ============================================================
     */

    private static var originalWidth:Float = 0;
    private static var originalHeight:Float = 0;

    private static var hasOriginalSize:Bool = false;


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
     * GET WIDTH
     * ============================================================
     */

    public static function getWidth():Float
    {
        var window:Dynamic =
            getWindow();

        if (window == null)
            return 0;

        try
        {
            return window.width;
        }
        catch (e:Dynamic)
        {
            return 0;
        }
    }


    /*
     * ============================================================
     * GET HEIGHT
     * ============================================================
 */

    public static function getHeight():Float
    {
        var window:Dynamic =
            getWindow();

        if (window == null)
            return 0;

        try
        {
            return window.height;
        }
        catch (e:Dynamic)
        {
            return 0;
        }
    }


    /*
     * ============================================================
     * SAVE ORIGINAL
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
            originalWidth =
                window.width;

            originalHeight =
                window.height;

            hasOriginalSize =
                true;
        }
        catch (e:Dynamic)
        {
        }
    }


    /*
     * ============================================================
     * SET WIDTH
     * ============================================================
 */

    public static function setWidth(
        width:Float
    ):Void
    {
        var window:Dynamic =
            getWindow();

        if (window == null)
            return;

        try
        {
            window.width =
                Std.int(width);
        }
        catch (e:Dynamic)
        {
        }
    }


    /*
     * ============================================================
     * SET HEIGHT
     * ============================================================
 */

    public static function setHeight(
        height:Float
    ):Void
    {
        var window:Dynamic =
            getWindow();

        if (window == null)
            return;

        try
        {
            window.height =
                Std.int(height);
        }
        catch (e:Dynamic)
        {
        }
    }


    /*
     * ============================================================
     * SET SIZE
     * ============================================================
 */

    public static function setSize(
        width:Float,
        height:Float
    ):Void
    {
        var window:Dynamic =
            getWindow();

        if (window == null)
            return;

        try
        {
            window.width =
                Std.int(width);

            window.height =
                Std.int(height);
        }
        catch (e:Dynamic)
        {
        }
    }


    /*
     * ============================================================
     * RESIZE
     * ============================================================
 *
 * Alias cómodo para Lua.
 *
 * ============================================================
 */

    public static function resize(
        width:Float,
        height:Float
    ):Void
    {
        setSize(
            width,
            height
        );
    }


    /*
     * ============================================================
     * RESIZE RELATIVE
     * ============================================================
 *
 * Aumenta o reduce el tamaño actual.
 *
 * ============================================================
 */

    public static function resizeRelative(
        amountWidth:Float,
        amountHeight:Float
    ):Void
    {
        setSize(
            getWidth() + amountWidth,
            getHeight() + amountHeight
        );
    }


    /*
     * ============================================================
     * RESIZE FROM ORIGINAL
     * ============================================================
 *
 * Tamaño:
 *
 *     original + offset
 *
 * ============================================================
 */

    public static function resizeFromOriginal(
        offsetWidth:Float,
        offsetHeight:Float
    ):Void
    {
        if (!hasOriginalSize)
            saveOriginal();

        setSize(
            originalWidth + offsetWidth,
            originalHeight + offsetHeight
        );
    }


    /*
     * ============================================================
     * SCALE FROM ORIGINAL
     * ============================================================
 *
 * Multiplica el tamaño original.
 *
 * Ejemplo:
 *
 *     scale = 0.5
 *     -> mitad del tamaño
 *
 *     scale = 2
 *     -> doble del tamaño
 *
 * ============================================================
 */

    public static function scaleFromOriginal(
        scaleX:Float,
        scaleY:Float
    ):Void
    {
        if (!hasOriginalSize)
            saveOriginal();

        setSize(
            originalWidth * scaleX,
            originalHeight * scaleY
        );
    }


    /*
     * ============================================================
     * UNIFORM SCALE
     * ============================================================
 *
 * Escala proporcionalmente.
 *
 * ============================================================
 */

    public static function scale(
        factor:Float
    ):Void
    {
        scaleFromOriginal(
            factor,
            factor
        );
    }


    /*
     * ============================================================
     * LERP
     * ============================================================
 */

    public static function lerp(
        from:Float,
        to:Float,
        amount:Float
    ):Float
    {
        return
            from +
            (to - from) *
            amount;
    }


    /*
     * ============================================================
     * RESIZE LERP
     * ============================================================
 *
 * Interpola entre dos tamaños.
 *
 * amount:
 *
 *     0 = tamaño inicial
 *     1 = tamaño final
 *
 * ============================================================
 */

    public static function resizeLerp(
        startWidth:Float,
        startHeight:Float,
        endWidth:Float,
        endHeight:Float,
        amount:Float
    ):Void
    {
        if (amount < 0)
            amount = 0;

        if (amount > 1)
            amount = 1;

        var width:Float =
            lerp(
                startWidth,
                endWidth,
                amount
            );

        var height:Float =
            lerp(
                startHeight,
                endHeight,
                amount
            );

        setSize(
            width,
            height
        );
    }


    /*
     * ============================================================
     * RESIZE TOWARDS
     * ============================================================
 *
 * Acerca el tamaño actual hacia un objetivo.
 *
 * ============================================================
 */

    public static function resizeTowards(
        targetWidth:Float,
        targetHeight:Float,
        amount:Float
    ):Void
    {
        var width:Float =
            getWidth();

        var height:Float =
            getHeight();

        setSize(
            width +
            (targetWidth - width) *
            amount,

            height +
            (targetHeight - height) *
            amount
        );
    }


    /*
     * ============================================================
     * RESIZE TOWARDS ORIGINAL
     * ============================================================
 */

    public static function resizeTowardsOriginal(
        amount:Float
    ):Void
    {
        if (!hasOriginalSize)
            saveOriginal();

        resizeTowards(
            originalWidth,
            originalHeight,
            amount
        );
    }


    /*
     * ============================================================
     * RESIZE SINUSOIDAL
     * ============================================================
 *
 * Cambia el tamaño siguiendo una onda sinusoidal.
 *
 * ============================================================
 *
 * width:
 *
 *     centerWidth +
 *     sin(time * speedX + phaseX) * amplitudeWidth
 *
 * height:
 *
 *     centerHeight +
 *     sin(time * speedY + phaseY) * amplitudeHeight
 *
 * ============================================================
 */

    public static function resizeSinusoidal(
        centerWidth:Float,
        centerHeight:Float,
        amplitudeWidth:Float,
        amplitudeHeight:Float,
        speedX:Float,
        speedY:Float,
        phaseX:Float,
        phaseY:Float,
        time:Float
    ):Void
    {
        var width:Float =
            centerWidth +
            Math.sin(
                time * speedX +
                phaseX
            ) *
            amplitudeWidth;

        var height:Float =
            centerHeight +
            Math.sin(
                time * speedY +
                phaseY
            ) *
            amplitudeHeight;

        setSize(
            width,
            height
        );
    }


    /*
     * ============================================================
     * RESIZE SINUSOIDAL FROM ORIGINAL
     * ============================================================
 */

    public static function resizeSinusoidalFromOriginal(
        amplitudeWidth:Float,
        amplitudeHeight:Float,
        speedX:Float,
        speedY:Float,
        phaseX:Float,
        phaseY:Float,
        time:Float
    ):Void
    {
        if (!hasOriginalSize)
            saveOriginal();

        resizeSinusoidal(
            originalWidth,
            originalHeight,
            amplitudeWidth,
            amplitudeHeight,
            speedX,
            speedY,
            phaseX,
            phaseY,
            time
        );
    }


    /*
     * ============================================================
     * RESIZE PULSING
     * ============================================================
 *
 * Escalado uniforme pulsante.
 *
 * ============================================================
 */

    public static function pulse(
        amplitude:Float,
        speed:Float,
        time:Float
    ):Void
    {
        if (!hasOriginalSize)
            saveOriginal();

        var factor:Float =
            1 +
            Math.sin(
                time * speed
            ) *
            amplitude;

        scale(
            factor
        );
    }


    /*
     * ============================================================
     * PULSE WITH PHASE
     * ============================================================
 */

    public static function pulseWithPhase(
        amplitude:Float,
        speed:Float,
        phase:Float,
        time:Float
    ):Void
    {
        if (!hasOriginalSize)
            saveOriginal();

        var factor:Float =
            1 +
            Math.sin(
                time * speed +
                phase
            ) *
            amplitude;

        scale(
            factor
        );
    }


    /*
     * ============================================================
     * ASPECT RATIO
     * ============================================================
 *
 * Cambia el ancho manteniendo una relación de aspecto.
 *
 * ============================================================
 */

    public static function setWidthKeepAspect(
        width:Float
    ):Void
    {
        if (!hasOriginalSize)
            saveOriginal();

        if (originalWidth == 0)
            return;

        var ratio:Float =
            originalHeight /
            originalWidth;

        setSize(
            width,
            width * ratio
        );
    }


    /*
     * ============================================================
     * SET HEIGHT KEEP ASPECT
     * ============================================================
 */

    public static function setHeightKeepAspect(
        height:Float
    ):Void
    {
        if (!hasOriginalSize)
            saveOriginal();

        if (originalHeight == 0)
            return;

        var ratio:Float =
            originalWidth /
            originalHeight;

        setSize(
            height * ratio,
            height
        );
    }


    /*
     * ============================================================
     * GET ORIGINAL WIDTH
     * ============================================================
 */

    public static function getOriginalWidth():Float
    {
        if (!hasOriginalSize)
            saveOriginal();

        return originalWidth;
    }


    /*
     * ============================================================
     * GET ORIGINAL HEIGHT
     * ============================================================
 */

    public static function getOriginalHeight():Float
    {
        if (!hasOriginalSize)
            saveOriginal();

        return originalHeight;
    }


    /*
     * ============================================================
     * GET SCALE X FROM ORIGINAL
     * ============================================================
 */

    public static function getScaleX():Float
    {
        if (!hasOriginalSize)
            saveOriginal();

        if (originalWidth == 0)
            return 1;

        return
            getWidth() /
            originalWidth;
    }


    /*
     * ============================================================
     * GET SCALE Y FROM ORIGINAL
     * ============================================================
 */

    public static function getScaleY():Float
    {
        if (!hasOriginalSize)
            saveOriginal();

        if (originalHeight == 0)
            return 1;

        return
            getHeight() /
            originalHeight;
    }


    /*
     * ============================================================
     * GET SIZE
     * ============================================================
 */

    public static function getSize():Dynamic
    {
        return {
            width: getWidth(),
            height: getHeight()
        };
    }


    /*
     * ============================================================
     * RESTORE
     * ============================================================
 */

    public static function restore():Void
    {
        if (!hasOriginalSize)
            return;

        setSize(
            originalWidth,
            originalHeight
        );
    }


    /*
     * ============================================================
     * RESET ORIGINAL
     * ============================================================
 *
 * Convierte el tamaño actual en el nuevo tamaño original.
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
        originalWidth =
            0;

        originalHeight =
            0;

        hasOriginalSize =
            false;
    }
}