/*
 * ============================================================
 * VentanaShake.hx
 * ============================================================
 *
 * FNF In The Galaxy -> Psych Engine 1.0.4
 *
 * Sistema independiente de Shake para la ventana.
 *
 * ============================================================
 *
 * RESPONSABILIDAD:
 *
 *     - Sacudir la posición de la ventana
 *     - Shake aleatorio
 *     - Shake determinista
 *     - Shake con decaimiento
 *     - Shake sinusoidal
 *     - Shake en X/Y
 *     - Shake uniforme
 *     - Controlar duración e intensidad
 *
 * ============================================================
 *
 * NO SE ENCARGA DE:
 *
 *     - Redimensionar la ventana
 *     - Centrar la ventana
 *     - Movimiento normal
 *     - Movimiento sinusoidal permanente
 *     - Notas
 *     - Strums
 *     - Cámara
 *     - Render
 *     - 3D
 *
 * ============================================================
 *
 * Este sistema utiliza:
 *
 *     MoverVentana.hx
 *
 * para modificar la posición real de la ventana.
 *
 * ============================================================
 */

class VentanaShake
{
    /*
     * ============================================================
     * ESTADO DEL SHAKE
     * ============================================================
     */

    private static var active:Bool = false;

    private static var elapsed:Float = 0;
    private static var duration:Float = 0;

    private static var intensityX:Float = 0;
    private static var intensityY:Float = 0;

    private static var decay:Bool = false;

    private static var originalSaved:Bool = false;


    /*
     * ============================================================
     * ESTADO DETERMINISTA
     * ============================================================
     */

    private static var seed:Int = 1337;

    private static var deterministicTime:Float = 0;


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
     * SAVE ORIGINAL
     * ============================================================
     */

    private static function ensureOriginal():Void
    {
        if (!originalSaved)
        {
            MoverVentana.saveOriginal();

            originalSaved =
                true;
        }
    }


    /*
     * ============================================================
     * START
     * ============================================================
     *
     * Inicia un shake.
     *
     * duration:
     *
     *     duración en segundos
     *
     * intensity:
     *
     *     intensidad uniforme
     *
     * ============================================================
     */

    public static function start(
        duration:Float,
        intensity:Float
    ):Void
    {
        startXY(
            duration,
            intensity,
            intensity
        );
    }


    /*
     * ============================================================
     * START XY
     * ============================================================
     */

    public static function startXY(
        durationValue:Float,
        intensityXValue:Float,
        intensityYValue:Float
    ):Void
    {
        ensureOriginal();

        elapsed =
            0;

        duration =
            durationValue;

        intensityX =
            Math.abs(
                intensityXValue
            );

        intensityY =
            Math.abs(
                intensityYValue
            );

        decay =
            false;

        active =
            true;

        deterministicTime =
            0;
    }


    /*
     * ============================================================
     * START DECAY
     * ============================================================
     *
     * Shake cuya intensidad disminuye progresivamente.
     *
     * ============================================================
     */

    public static function startDecay(
        durationValue:Float,
        intensity:Float
    ):Void
    {
        startDecayXY(
            durationValue,
            intensity,
            intensity
        );
    }


    /*
     * ============================================================
     * START DECAY XY
     * ============================================================
 */

    public static function startDecayXY(
        durationValue:Float,
        intensityXValue:Float,
        intensityYValue:Float
    ):Void
    {
        ensureOriginal();

        elapsed =
            0;

        duration =
            durationValue;

        intensityX =
            Math.abs(
                intensityXValue
            );

        intensityY =
            Math.abs(
                intensityYValue
            );

        decay =
            true;

        active =
            true;

        deterministicTime =
            0;
    }


    /*
     * ============================================================
     * STOP
     * ============================================================
 */

    public static function stop():Void
    {
        active =
            false;

        elapsed =
            0;

        duration =
            0;

        intensityX =
            0;

        intensityY =
            0;

        deterministicTime =
            0;

        MoverVentana.restore();
    }


    /*
     * ============================================================
     * IS ACTIVE
     * ============================================================
 */

    public static function isActive():Bool
    {
        return active;
    }


    /*
     * ============================================================
     * GET PROGRESS
     * ============================================================
 *
 * Devuelve:
 *
 *     0 = inicio
 *     1 = final
 *
 * ============================================================
 */

    public static function getProgress():Float
    {
        if (duration <= 0)
            return 1;

        var progress:Float =
            elapsed /
            duration;

        if (progress < 0)
            progress = 0;

        if (progress > 1)
            progress = 1;

        return progress;
    }


    /*
     * ============================================================
     * GET DECAY
     * ============================================================
 *
 * Intensidad restante.
 *
 * ============================================================
 */

    public static function getDecay():Float
    {
        if (!decay)
            return 1;

        return 1 -
            getProgress();
    }


    /*
     * ============================================================
     * RANDOM
     * ============================================================
 */

    private static function randomRange(
        min:Float,
        max:Float
    ):Float
    {
        return min +
            Math.random() *
            (max - min);
    }


    /*
     * ============================================================
     * DETERMINISTIC RANDOM
     * ============================================================
 *
 * Generador simple para movimientos reproducibles.
 *
 * ============================================================
 */

    private static function deterministicRandom():Float
    {
        seed =
            (
                seed *
                1103515245 +
                12345
            ) & 0x7fffffff;

        return
            seed /
            2147483647;
    }


    /*
     * ============================================================
     * SET SEED
     * ============================================================
 */

    public static function setSeed(
        value:Int
    ):Void
    {
        seed =
            value;
    }


    /*
     * ============================================================
     * UPDATE
     * ============================================================
 *
 * Actualiza el shake.
 *
 * delta:
 *
 *     tiempo transcurrido desde el frame anterior.
 *
 * ============================================================
 */

    public static function update(
        delta:Float
    ):Void
    {
        if (!active)
            return;

        if (delta < 0)
            delta = 0;


        elapsed +=
            delta;


        if (duration > 0 &&
            elapsed >= duration)
        {
            stop();

            return;
        }


        var currentIntensityX:Float =
            intensityX;

        var currentIntensityY:Float =
            intensityY;


        if (decay)
        {
            var factor:Float =
                getDecay();

            currentIntensityX *=
                factor;

            currentIntensityY *=
                factor;
        }


        var offsetX:Float =
            randomRange(
                -currentIntensityX,
                currentIntensityX
            );

        var offsetY:Float =
            randomRange(
                -currentIntensityY,
                currentIntensityY
            );


        MoverVentana.moveFromOriginal(
            offsetX,
            offsetY
        );
    }


    /*
     * ============================================================
     * UPDATE DETERMINISTIC
     * ============================================================
 *
 * Variante reproducible.
 *
 * ============================================================
 */

    public static function updateDeterministic(
        delta:Float
    ):Void
    {
        if (!active)
            return;

        if (delta < 0)
            delta = 0;


        elapsed +=
            delta;

        deterministicTime +=
            delta;


        if (duration > 0 &&
            elapsed >= duration)
        {
            stop();

            return;
        }


        var currentIntensityX:Float =
            intensityX;

        var currentIntensityY:Float =
            intensityY;


        if (decay)
        {
            var factor:Float =
                getDecay();

            currentIntensityX *=
                factor;

            currentIntensityY *=
                factor;
        }


        var randomX:Float =
            deterministicRandom() *
            2 -
            1;

        var randomY:Float =
            deterministicRandom() *
            2 -
            1;


        MoverVentana.moveFromOriginal(
            randomX *
            currentIntensityX,

            randomY *
            currentIntensityY
        );
    }


    /*
     * ============================================================
     * SHAKE ONCE
     * ============================================================
 *
 * Aplica un desplazamiento instantáneo.
 *
 * ============================================================
 */

    public static function shakeOnce(
        intensity:Float
    ):Void
    {
        ensureOriginal();

        var offsetX:Float =
            randomRange(
                -intensity,
                intensity
            );

        var offsetY:Float =
            randomRange(
                -intensity,
                intensity
            );


        MoverVentana.moveFromOriginal(
            offsetX,
            offsetY
        );
    }


    /*
     * ============================================================
     * SHAKE ONCE XY
     * ============================================================
 */

    public static function shakeOnceXY(
        intensityXValue:Float,
        intensityYValue:Float
    ):Void
    {
        ensureOriginal();

        var offsetX:Float =
            randomRange(
                -Math.abs(intensityXValue),
                Math.abs(intensityXValue)
            );

        var offsetY:Float =
            randomRange(
                -Math.abs(intensityYValue),
                Math.abs(intensityYValue)
            );


        MoverVentana.moveFromOriginal(
            offsetX,
            offsetY
        );
    }


    /*
     * ============================================================
     * SINE SHAKE
     * ============================================================
 *
 * Shake suave y periódico.
 *
 * ============================================================
 */

    public static function sineShake(
        amplitudeX:Float,
        amplitudeY:Float,
        speedX:Float,
        speedY:Float,
        phaseX:Float,
        phaseY:Float,
        time:Float
    ):Void
    {
        ensureOriginal();

        var offsetX:Float =
            Math.sin(
                time * speedX +
                phaseX
            ) *
            amplitudeX;

        var offsetY:Float =
            Math.sin(
                time * speedY +
                phaseY
            ) *
            amplitudeY;


        MoverVentana.moveFromOriginal(
            offsetX,
            offsetY
        );
    }


    /*
     * ============================================================
     * SINE SHAKE CIRCULAR
     * ============================================================
 *
 * Movimiento circular rápido alrededor del punto original.
 *
 * ============================================================
 */

    public static function sineShakeCircular(
        amplitude:Float,
        speed:Float,
        phase:Float,
        time:Float
    ):Void
    {
        ensureOriginal();

        var angle:Float =
            time *
            speed +
            phase;


        var offsetX:Float =
            Math.cos(angle) *
            amplitude;

        var offsetY:Float =
            Math.sin(angle) *
            amplitude;


        MoverVentana.moveFromOriginal(
            offsetX,
            offsetY
        );
    }


    /*
     * ============================================================
     * SQUARE SHAKE
     * ============================================================
 *
 * Shake basado en cambios bruscos de dirección.
 *
 * ============================================================
 */

    public static function squareShake(
        amplitudeX:Float,
        amplitudeY:Float,
        speed:Float,
        time:Float
    ):Void
    {
        ensureOriginal();

        var valueX:Float =
            Math.sin(
                time * speed
            ) >= 0
            ? amplitudeX
            : -amplitudeX;


        var valueY:Float =
            Math.cos(
                time * speed
            ) >= 0
            ? amplitudeY
            : -amplitudeY;


        MoverVentana.moveFromOriginal(
            valueX,
            valueY
        );
    }


    /*
     * ============================================================
     * IMPULSE
     * ============================================================
 *
 * Shake de impulso con caída cuadrática.
 *
 * progress:
 *
 *     0 -> máximo
 *     1 -> cero
 *
 * ============================================================
 */

    public static function impulse(
        intensityXValue:Float,
        intensityYValue:Float,
        progress:Float
    ):Void
    {
        ensureOriginal();

        if (progress < 0)
            progress = 0;

        if (progress > 1)
            progress = 1;


        var strength:Float =
            1 -
            progress;


        strength =
            strength *
            strength;


        var offsetX:Float =
            randomRange(
                -intensityXValue,
                intensityXValue
            ) *
            strength;


        var offsetY:Float =
            randomRange(
                -intensityYValue,
                intensityYValue
            ) *
            strength;


        MoverVentana.moveFromOriginal(
            offsetX,
            offsetY
        );
    }


    /*
     * ============================================================
     * UPDATE IMPULSE
     * ============================================================
 */

    public static function updateImpulse(
        delta:Float
    ):Void
    {
        if (!active)
            return;


        elapsed +=
            delta;


        if (duration <= 0)
        {
            stop();

            return;
        }


        if (elapsed >= duration)
        {
            stop();

            return;
        }


        var progress:Float =
            elapsed /
            duration;


        impulse(
            intensityX,
            intensityY,
            progress
        );
    }


    /*
     * ============================================================
     * SET INTENSITY
     * ============================================================
 */

    public static function setIntensity(
        intensity:Float
    ):Void
    {
        intensityX =
            Math.abs(intensity);

        intensityY =
            Math.abs(intensity);
    }


    /*
     * ============================================================
     * SET INTENSITY XY
     * ============================================================
 */

    public static function setIntensityXY(
        valueX:Float,
        valueY:Float
    ):Void
    {
        intensityX =
            Math.abs(valueX);

        intensityY =
            Math.abs(valueY);
    }


    /*
     * ============================================================
     * GET INTENSITY X
     * ============================================================
 */

    public static function getIntensityX():Float
    {
        return intensityX;
    }


    /*
     * ============================================================
     * GET INTENSITY Y
     * ============================================================
 */

    public static function getIntensityY():Float
    {
        return intensityY;
    }


    /*
     * ============================================================
     * SET DURATION
     * ============================================================
 */

    public static function setDuration(
        value:Float
    ):Void
    {
        duration =
            value;
    }


    /*
     * ============================================================
     * GET DURATION
     * ============================================================
 */

    public static function getDuration():Float
    {
        return duration;
    }


    /*
     * ============================================================
     * GET ELAPSED
     * ============================================================
 */

    public static function getElapsed():Float
    {
        return elapsed;
    }


    /*
     * ============================================================
     * RESET
     * ============================================================
 */

    public static function reset():Void
    {
        active =
            false;

        elapsed =
            0;

        duration =
            0;

        intensityX =
            0;

        intensityY =
            0;

        deterministicTime =
            0;

        originalSaved =
            false;

        MoverVentana.restore();
    }
}