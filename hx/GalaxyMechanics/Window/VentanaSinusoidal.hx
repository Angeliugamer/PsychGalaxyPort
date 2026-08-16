/*
 * ============================================================
 * VentanaSinusoidal.hx
 * ============================================================
 *
 * FNF In The Galaxy -> Psych Engine 1.0.4
 *
 * Sistema de animación sinusoidal para la ventana.
 *
 * ============================================================
 *
 * RESPONSABILIDAD:
 *
 *     - Movimiento sinusoidal de la ventana
 *     - Redimensionamiento sinusoidal
 *     - Movimiento + redimensionamiento
 *     - Ondas independientes X/Y
 *     - Fases independientes
 *     - Velocidades independientes
 *     - Animaciones basadas en posición/tamaño original
 *
 * ============================================================
 *
 * NO SE ENCARGA DE:
 *
 *     - Acceso directo a OpenFL Window
 *     - Movimiento básico
 *     - Redimensionamiento básico
 *     - Shake aleatorio
 *     - Centrado
 *     - Notas
 *     - Strums
 *     - Cámara
 *     - Render
 *     - 3D
 *
 * ============================================================
 *
 * IMPORTANTE:
 *
 * Este módulo utiliza:
 *
 *     MoverVentana.hx
 *     RedimensionarVentana.hx
 *
 * como sistemas base.
 *
 * ============================================================
 */


/**
 * VentanaSinusoidal
 *
 * Sistema especializado para movimientos periódicos de ventana.
 */
class VentanaSinusoidal
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
     * SENO
     * ============================================================
     *
     * Función auxiliar.
     *
     * ============================================================
     */

    public static function sine(
        time:Float,
        speed:Float,
        phase:Float
    ):Float
    {
        return Math.sin(
            time * speed +
            phase
        );
    }


    /*
     * ============================================================
     * COSENO
     * ============================================================
     */

    public static function cosine(
        time:Float,
        speed:Float,
        phase:Float
    ):Float
    {
        return Math.cos(
            time * speed +
            phase
        );
    }


    /*
     * ============================================================
     * VALUE
     * ============================================================
     *
     * Genera:
     *
     *     center + sin(...) * amplitude
     *
     * ============================================================
     */

    public static function value(
        center:Float,
        amplitude:Float,
        speed:Float,
        phase:Float,
        time:Float
    ):Float
    {
        return
            center +
            sine(
                time,
                speed,
                phase
            ) *
            amplitude;
    }


    /*
     * ============================================================
     * VALUE COSINE
     * ============================================================
     */

    public static function valueCosine(
        center:Float,
        amplitude:Float,
        speed:Float,
        phase:Float,
        time:Float
    ):Float
    {
        return
            center +
            cosine(
                time,
                speed,
                phase
            ) *
            amplitude;
    }


    /*
     * ============================================================
     * MOVE
     * ============================================================
     *
     * Movimiento sinusoidal absoluto.
     *
     * ============================================================
     */

    public static function move(
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
            value(
                centerX,
                amplitudeX,
                speedX,
                phaseX,
                time
            );

        var y:Float =
            value(
                centerY,
                amplitudeY,
                speedY,
                phaseY,
                time
            );


        MoverVentana.setPosition(
            x,
            y
        );
    }


    /*
     * ============================================================
     * MOVE COSINE
     * ============================================================
     */

    public static function moveCosine(
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
            valueCosine(
                centerX,
                amplitudeX,
                speedX,
                phaseX,
                time
            );

        var y:Float =
            valueCosine(
                centerY,
                amplitudeY,
                speedY,
                phaseY,
                time
            );


        MoverVentana.setPosition(
            x,
            y
        );
    }


    /*
     * ============================================================
     * MOVE FROM ORIGINAL
     * ============================================================
     *
     * Centro = posición original.
     *
     * ============================================================
     */

    public static function moveFromOriginal(
        amplitudeX:Float,
        amplitudeY:Float,
        speedX:Float,
        speedY:Float,
        phaseX:Float,
        phaseY:Float,
        time:Float
    ):Void
    {
        if (MoverVentana.getOriginalX() == 0 &&
            MoverVentana.getOriginalY() == 0)
        {
            MoverVentana.saveOriginal();
        }


        var x:Float =
            value(
                MoverVentana.getOriginalX(),
                amplitudeX,
                speedX,
                phaseX,
                time
            );

        var y:Float =
            value(
                MoverVentana.getOriginalY(),
                amplitudeY,
                speedY,
                phaseY,
                time
            );


        MoverVentana.setPosition(
            x,
            y
        );
    }


    /*
     * ============================================================
     * MOVE FROM ORIGINAL COSINE
     * ============================================================
 */

    public static function moveFromOriginalCosine(
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
            valueCosine(
                MoverVentana.getOriginalX(),
                amplitudeX,
                speedX,
                phaseX,
                time
            );

        var y:Float =
            valueCosine(
                MoverVentana.getOriginalY(),
                amplitudeY,
                speedY,
                phaseY,
                time
            );


        MoverVentana.setPosition(
            x,
            y
        );
    }


    /*
     * ============================================================
     * RESIZE
     * ============================================================
     *
     * Redimensionamiento sinusoidal absoluto.
     *
     * ============================================================
 */

    public static function resize(
        centerWidth:Float,
        centerHeight:Float,
        amplitudeWidth:Float,
        amplitudeHeight:Float,
        speedWidth:Float,
        speedHeight:Float,
        phaseWidth:Float,
        phaseHeight:Float,
        time:Float
    ):Void
    {
        var width:Float =
            value(
                centerWidth,
                amplitudeWidth,
                speedWidth,
                phaseWidth,
                time
            );

        var height:Float =
            value(
                centerHeight,
                amplitudeHeight,
                speedHeight,
                phaseHeight,
                time
            );


        RedimensionarVentana.setSize(
            width,
            height
        );
    }


    /*
     * ============================================================
     * RESIZE COSINE
     * ============================================================
 */

    public static function resizeCosine(
        centerWidth:Float,
        centerHeight:Float,
        amplitudeWidth:Float,
        amplitudeHeight:Float,
        speedWidth:Float,
        speedHeight:Float,
        phaseWidth:Float,
        phaseHeight:Float,
        time:Float
    ):Void
    {
        var width:Float =
            valueCosine(
                centerWidth,
                amplitudeWidth,
                speedWidth,
                phaseWidth,
                time
            );

        var height:Float =
            valueCosine(
                centerHeight,
                amplitudeHeight,
                speedHeight,
                phaseHeight,
                time
            );


        RedimensionarVentana.setSize(
            width,
            height
        );
    }


    /*
     * ============================================================
     * RESIZE FROM ORIGINAL
     * ============================================================
 */

    public static function resizeFromOriginal(
        amplitudeWidth:Float,
        amplitudeHeight:Float,
        speedWidth:Float,
        speedHeight:Float,
        phaseWidth:Float,
        phaseHeight:Float,
        time:Float
    ):Void
    {
        var width:Float =
            value(
                RedimensionarVentana.getOriginalWidth(),
                amplitudeWidth,
                speedWidth,
                phaseWidth,
                time
            );

        var height:Float =
            value(
                RedimensionarVentana.getOriginalHeight(),
                amplitudeHeight,
                speedHeight,
                phaseHeight,
                time
            );


        RedimensionarVentana.setSize(
            width,
            height
        );
    }


    /*
     * ============================================================
     * RESIZE FROM ORIGINAL COSINE
     * ============================================================
 */

    public static function resizeFromOriginalCosine(
        amplitudeWidth:Float,
        amplitudeHeight:Float,
        speedWidth:Float,
        speedHeight:Float,
        phaseWidth:Float,
        phaseHeight:Float,
        time:Float
    ):Void
    {
        var width:Float =
            valueCosine(
                RedimensionarVentana.getOriginalWidth(),
                amplitudeWidth,
                speedWidth,
                phaseWidth,
                time
            );

        var height:Float =
            valueCosine(
                RedimensionarVentana.getOriginalHeight(),
                amplitudeHeight,
                speedHeight,
                phaseHeight,
                time
            );


        RedimensionarVentana.setSize(
            width,
            height
        );
    }


    /*
     * ============================================================
     * MOVE + RESIZE
     * ============================================================
     *
     * Controla posición y tamaño simultáneamente.
     *
     * ============================================================
 */

    public static function moveAndResize(
        centerX:Float,
        centerY:Float,
        amplitudeX:Float,
        amplitudeY:Float,
        speedX:Float,
        speedY:Float,
        phaseX:Float,
        phaseY:Float,

        centerWidth:Float,
        centerHeight:Float,
        amplitudeWidth:Float,
        amplitudeHeight:Float,
        speedWidth:Float,
        speedHeight:Float,
        phaseWidth:Float,
        phaseHeight:Float,

        time:Float
    ):Void
    {
        var x:Float =
            value(
                centerX,
                amplitudeX,
                speedX,
                phaseX,
                time
            );

        var y:Float =
            value(
                centerY,
                amplitudeY,
                speedY,
                phaseY,
                time
            );


        var width:Float =
            value(
                centerWidth,
                amplitudeWidth,
                speedWidth,
                phaseWidth,
                time
            );

        var height:Float =
            value(
                centerHeight,
                amplitudeHeight,
                speedHeight,
                phaseHeight,
                time
            );


        MoverVentana.setPosition(
            x,
            y
        );


        RedimensionarVentana.setSize(
            width,
            height
        );
    }


    /*
     * ============================================================
     * MOVE + RESIZE FROM ORIGINAL
     * ============================================================
     *
     * Posición y tamaño parten de sus valores originales.
     *
     * ============================================================
 */

    public static function moveAndResizeFromOriginal(
        amplitudeX:Float,
        amplitudeY:Float,
        speedX:Float,
        speedY:Float,
        phaseX:Float,
        phaseY:Float,

        amplitudeWidth:Float,
        amplitudeHeight:Float,
        speedWidth:Float,
        speedHeight:Float,
        phaseWidth:Float,
        phaseHeight:Float,

        time:Float
    ):Void
    {
        var x:Float =
            value(
                MoverVentana.getOriginalX(),
                amplitudeX,
                speedX,
                phaseX,
                time
            );

        var y:Float =
            value(
                MoverVentana.getOriginalY(),
                amplitudeY,
                speedY,
                phaseY,
                time
            );


        var width:Float =
            value(
                RedimensionarVentana.getOriginalWidth(),
                amplitudeWidth,
                speedWidth,
                phaseWidth,
                time
            );

        var height:Float =
            value(
                RedimensionarVentana.getOriginalHeight(),
                amplitudeHeight,
                speedHeight,
                phaseHeight,
                time
            );


        MoverVentana.setPosition(
            x,
            y
        );


        RedimensionarVentana.setSize(
            width,
            height
        );
    }


    /*
     * ============================================================
     * ORBIT
     * ============================================================
     *
     * Movimiento circular basado en seno/coseno.
     *
     * ============================================================
 */

    public static function orbit(
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


        MoverVentana.setPosition(
            x,
            y
        );
    }


    /*
     * ============================================================
     * ORBIT FROM ORIGINAL
     * ============================================================
 */

    public static function orbitFromOriginal(
        radiusX:Float,
        radiusY:Float,
        speed:Float,
        phase:Float,
        time:Float
    ):Void
    {
        orbit(
            MoverVentana.getOriginalX(),
            MoverVentana.getOriginalY(),
            radiusX,
            radiusY,
            speed,
            phase,
            time
        );
    }


    /*
     * ============================================================
     * PULSE SIZE
     * ============================================================
     *
     * Pulsación uniforme del tamaño.
     *
     * ============================================================
 */

    public static function pulseSize(
        amplitude:Float,
        speed:Float,
        phase:Float,
        time:Float
    ):Void
    {
        var factor:Float =
            1 +
            Math.sin(
                time * speed +
                phase
            ) *
            amplitude;


        RedimensionarVentana.scale(
            factor
        );
    }


    /*
     * ============================================================
     * PULSE SIZE FROM ORIGINAL
     * ============================================================
 */

    public static function pulseSizeFromOriginal(
        amplitude:Float,
        speed:Float,
        phase:Float,
        time:Float
    ):Void
    {
        var factor:Float =
            1 +
            Math.sin(
                time * speed +
                phase
            ) *
            amplitude;


        RedimensionarVentana.scale(
            factor
        );
    }


    /*
     * ============================================================
     * PULSE ASYMMETRIC
     * ============================================================
     *
     * Permite pulsar X/Y de forma independiente.
     *
     * ============================================================
 */

    public static function pulseAsymmetric(
        amplitudeX:Float,
        amplitudeY:Float,
        speedX:Float,
        speedY:Float,
        phaseX:Float,
        phaseY:Float,
        time:Float
    ):Void
    {
        var factorX:Float =
            1 +
            Math.sin(
                time * speedX +
                phaseX
            ) *
            amplitudeX;


        var factorY:Float =
            1 +
            Math.sin(
                time * speedY +
                phaseY
            ) *
            amplitudeY;


        RedimensionarVentana.scaleFromOriginal(
            factorX,
            factorY
        );
    }


    /*
     * ============================================================
     * WAVE
     * ============================================================
     *
     * Genera un movimiento usando seno con desfase.
     *
     * ============================================================
 */

    public static function wave(
        baseX:Float,
        baseY:Float,
        amplitude:Float,
        speed:Float,
        phase:Float,
        time:Float
    ):Void
    {
        var offset:Float =
            Math.sin(
                time * speed +
                phase
            ) *
            amplitude;


        MoverVentana.setPosition(
            baseX + offset,
            baseY
        );
    }


    /*
     * ============================================================
     * WAVE VERTICAL
     * ============================================================
 */

    public static function waveVertical(
        baseX:Float,
        baseY:Float,
        amplitude:Float,
        speed:Float,
        phase:Float,
        time:Float
    ):Void
    {
        var offset:Float =
            Math.sin(
                time * speed +
                phase
            ) *
            amplitude;


        MoverVentana.setPosition(
            baseX,
            baseY + offset
        );
    }


    /*
     * ============================================================
     * WAVE BOTH
     * ============================================================
     *
     * Onda diagonal.
     *
     * ============================================================
 */

    public static function waveBoth(
        baseX:Float,
        baseY:Float,
        amplitudeX:Float,
        amplitudeY:Float,
        speed:Float,
        phase:Float,
        time:Float
    ):Void
    {
        var offset:Float =
            Math.sin(
                time * speed +
                phase
            );


        MoverVentana.setPosition(
            baseX +
            offset * amplitudeX,

            baseY +
            offset * amplitudeY
        );
    }


    /*
     * ============================================================
     * STOP POSITION
     * ============================================================
 *
 * Detiene el efecto sinusoidal restaurando la posición.
 *
 * ============================================================
 */

    public static function stopPosition():Void
    {
        MoverVentana.restore();
    }


    /*
     * ============================================================
     * STOP SIZE
     * ============================================================
 */

    public static function stopSize():Void
    {
        RedimensionarVentana.restore();
    }


    /*
     * ============================================================
     * STOP ALL
     * ============================================================
 */

    public static function stopAll():Void
    {
        MoverVentana.restore();

        RedimensionarVentana.restore();
    }
}