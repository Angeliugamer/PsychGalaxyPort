/*
 * ============================================================
 * RotarStrums.hx
 * ============================================================
 *
 * FNF In The Galaxy -> Psych Engine 1.0.4
 *
 * Sistema independiente para rotación de Strums.
 *
 * ============================================================
 *
 * RESPONSABILIDAD:
 *
 *     - Establecer angle de un strum
 *     - Rotar un strum
 *     - Rotación relativa
 *     - Rotación desde el ángulo original
 *     - Rotación continua
 *     - Rotación por tiempo
 *     - Distribución angular
 *     - Rotación por índice
 *     - Restaurar ángulos originales
 *
 * ============================================================
 *
 * NO SE ENCARGA DE:
 *
 *     - Posición X
 *     - Posición Y
 *     - Movimiento circular
 *     - Perspectiva
 *     - 3D
 *     - Alpha
 *     - Notas
 *     - Sustains
 *     - Window
 *
 * ============================================================
 *
 * IMPORTANTE:
 *
 * Este archivo modifica solamente:
 *
 *     strum.angle
 *
 * ============================================================
 */

import flixel.FlxSprite;


/**
 * RotarStrums
 *
 * Controlador independiente del ángulo de los strums.
 */
class RotarStrums
{
    /*
     * ============================================================
     * ÁNGULOS ORIGINALES
     * ============================================================
     */

    private static var originalAngle:Map<Int, Float> =
        new Map<Int, Float>();


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
     * GET ANGLE
     * ============================================================
     */

    private static function getAngle(
        strum:Dynamic
    ):Float
    {
        if (strum == null)
            return 0;


        try
        {
            return strum.angle;
        }
        catch (e:Dynamic)
        {
            return 0;
        }
    }


    /*
     * ============================================================
     * SET ANGLE
     * ============================================================
     */

    private static function setAngle(
        strum:Dynamic,
        value:Float
    ):Void
    {
        if (strum == null)
            return;


        try
        {
            strum.angle =
                value;
        }
        catch (e:Dynamic)
        {
        }
    }


    /*
     * ============================================================
     * SAVE ORIGINAL ANGLE
     * ============================================================
 */

    public static function saveOriginalAngle(
        index:Int,
        strum:Dynamic
    ):Void
    {
        if (strum == null)
            return;


        if (!originalAngle.exists(index))
        {
            originalAngle.set(
                index,
                getAngle(strum)
            );
        }
    }


    /*
     * ============================================================
     * SAVE ALL ORIGINAL ANGLES
     * ============================================================
 */

    public static function saveAllOriginalAngles(
        strums:Array<Dynamic>
    ):Void
    {
        if (strums == null)
            return;


        for (i in 0...strums.length)
        {
            saveOriginalAngle(
                i,
                strums[i]
            );
        }
    }


    /*
     * ============================================================
     * SET ANGLE
     * ============================================================
 *
 * Establece un ángulo absoluto.
 *
 * ============================================================
 */

    public static function setAnglePosition(
        index:Int,
        strum:Dynamic,
        angle:Float
    ):Void
    {
        if (strum == null)
            return;


        saveOriginalAngle(
            index,
            strum
        );


        setAngle(
            strum,
            angle
        );
    }


    /*
     * ============================================================
     * ROTATE
     * ============================================================
 *
 * Rotación relativa al ángulo actual.
 *
 * ============================================================
 */

    public static function rotate(
        index:Int,
        strum:Dynamic,
        amount:Float
    ):Void
    {
        if (strum == null)
            return;


        saveOriginalAngle(
            index,
            strum
        );


        setAngle(
            strum,
            getAngle(strum) + amount
        );
    }


    /*
     * ============================================================
     * SET FROM ORIGINAL
     * ============================================================
 *
 * angle = originalAngle + offset
 *
 * Evita acumulación cuando se utiliza desde onUpdate.
 *
 * ============================================================
 */

    public static function setFromOriginal(
        index:Int,
        strum:Dynamic,
        offset:Float
    ):Void
    {
        if (strum == null)
            return;


        saveOriginalAngle(
            index,
            strum
        );


        setAngle(
            strum,
            originalAngle.get(index) + offset
        );
    }


    /*
     * ============================================================
     * SET ALL ANGLES
     * ============================================================
 */

    public static function setAll(
        strums:Array<Dynamic>,
        angle:Float
    ):Void
    {
        if (strums == null)
            return;


        saveAllOriginalAngles(
            strums
        );


        for (i in 0...strums.length)
        {
            setAnglePosition(
                i,
                strums[i],
                angle
            );
        }
    }


    /*
     * ============================================================
     * ROTATE ALL
     * ============================================================
 */

    public static function rotateAll(
        strums:Array<Dynamic>,
        amount:Float
    ):Void
    {
        if (strums == null)
            return;


        saveAllOriginalAngles(
            strums
        );


        for (i in 0...strums.length)
        {
            rotate(
                i,
                strums[i],
                amount
            );
        }
    }


    /*
     * ============================================================
     * SET ALL FROM ORIGINAL
     * ============================================================
 */

    public static function setAllFromOriginal(
        strums:Array<Dynamic>,
        offset:Float
    ):Void
    {
        if (strums == null)
            return;


        saveAllOriginalAngles(
            strums
        );


        for (i in 0...strums.length)
        {
            setFromOriginal(
                i,
                strums[i],
                offset
            );
        }
    }


    /*
     * ============================================================
     * SET RANGE
     * ============================================================
 */

    public static function setRange(
        strums:Array<Dynamic>,
        start:Int,
        end:Int,
        angle:Float
    ):Void
    {
        if (strums == null)
            return;


        if (start < 0)
            start = 0;


        if (end >= strums.length)
            end =
                strums.length - 1;


        if (start > end)
            return;


        for (i in start...end + 1)
        {
            setAnglePosition(
                i,
                strums[i],
                angle
            );
        }
    }


    /*
     * ============================================================
     * ROTATE RANGE
     * ============================================================
 */

    public static function rotateRange(
        strums:Array<Dynamic>,
        start:Int,
        end:Int,
        amount:Float
    ):Void
    {
        if (strums == null)
            return;


        if (start < 0)
            start = 0;


        if (end >= strums.length)
            end =
                strums.length - 1;


        if (start > end)
            return;


        for (i in start...end + 1)
        {
            rotate(
                i,
                strums[i],
                amount
            );
        }
    }


    /*
     * ============================================================
     * DISTRIBUTE
     * ============================================================
 *
 * Distribuye los strums uniformemente entre ángulos.
 *
 * ============================================================
 */

    public static function distribute(
        strums:Array<Dynamic>,
        startAngle:Float,
        endAngle:Float
    ):Void
    {
        if (strums == null)
            return;


        var count:Int =
            strums.length;


        if (count <= 0)
            return;


        saveAllOriginalAngles(
            strums
        );


        if (count == 1)
        {
            setAnglePosition(
                0,
                strums[0],
                startAngle
            );


            return;
        }


        var step:Float =
            (endAngle - startAngle) /
            (count - 1);


        for (i in 0...count)
        {
            var angle:Float =
                startAngle +
                i * step;


            setAnglePosition(
                i,
                strums[i],
                angle
            );
        }
    }


    /*
     * ============================================================
     * DISTRIBUTE OFFSET
     * ============================================================
 *
 * Distribuye ángulos alrededor del ángulo original.
 *
 * ============================================================
 */

    public static function distributeFromOriginal(
        strums:Array<Dynamic>,
        startOffset:Float,
        endOffset:Float
    ):Void
    {
        if (strums == null)
            return;


        var count:Int =
            strums.length;


        if (count <= 0)
            return;


        saveAllOriginalAngles(
            strums
        );


        if (count == 1)
        {
            setFromOriginal(
                0,
                strums[0],
                startOffset
            );


            return;
        }


        var step:Float =
            (endOffset - startOffset) /
            (count - 1);


        for (i in 0...count)
        {
            var offset:Float =
                startOffset +
                i * step;


            setFromOriginal(
                i,
                strums[i],
                offset
            );
        }
    }


    /*
     * ============================================================
     * ALTERNATE
     * ============================================================
 *
 * Ángulo diferente para strums pares/impares.
 *
 * ============================================================
 */

    public static function alternate(
        strums:Array<Dynamic>,
        angleA:Float,
        angleB:Float
    ):Void
    {
        if (strums == null)
            return;


        saveAllOriginalAngles(
            strums
        );


        for (i in 0...strums.length)
        {
            var angle:Float;


            if (i % 2 == 0)
            {
                angle =
                    angleA;
            }
            else
            {
                angle =
                    angleB;
            }


            setAnglePosition(
                i,
                strums[i],
                angle
            );
        }
    }


    /*
     * ============================================================
     * ALTERNATE FROM ORIGINAL
     * ============================================================
 */

    public static function alternateFromOriginal(
        strums:Array<Dynamic>,
        offsetA:Float,
        offsetB:Float
    ):Void
    {
        if (strums == null)
            return;


        saveAllOriginalAngles(
            strums
        );


        for (i in 0...strums.length)
        {
            var offset:Float;


            if (i % 2 == 0)
            {
                offset =
                    offsetA;
            }
            else
            {
                offset =
                    offsetB;
            }


            setFromOriginal(
                i,
                strums[i],
                offset
            );
        }
    }


    /*
     * ============================================================
     * WAVE
     * ============================================================
 *
 * Aplica una onda angular basada en el índice.
 *
 * ============================================================
 */

    public static function wave(
        strums:Array<Dynamic>,
        amplitude:Float,
        frequency:Float,
        phase:Float
    ):Void
    {
        if (strums == null)
            return;


        saveAllOriginalAngles(
            strums
        );


        for (i in 0...strums.length)
        {
            var offset:Float =
                Math.sin(
                    i * frequency +
                    phase
                ) *
                amplitude;


            setFromOriginal(
                i,
                strums[i],
                offset
            );
        }
    }


    /*
     * ============================================================
     * WAVE TIME
     * ============================================================
 *
 * Onda angular animada.
 *
 * ============================================================
 */

    public static function waveTime(
        strums:Array<Dynamic>,
        amplitude:Float,
        frequency:Float,
        speed:Float,
        time:Float
    ):Void
    {
        if (strums == null)
            return;


        var phase:Float =
            time * speed;


        wave(
            strums,
            amplitude,
            frequency,
            phase
        );
    }


    /*
     * ============================================================
     * ROTATE TIME
     * ============================================================
 *
 * Rotación absoluta basada en tiempo.
 *
 * angle =
 *
 *     originalAngle + startOffset + time * speed
 *
 * ============================================================
 */

    public static function rotateTime(
        index:Int,
        strum:Dynamic,
        startOffset:Float,
        speed:Float,
        time:Float
    ):Void
    {
        if (strum == null)
            return;


        saveOriginalAngle(
            index,
            strum
        );


        var angle:Float =
            originalAngle.get(index) +
            startOffset +
            time * speed;


        setAngle(
            strum,
            angle
        );
    }


    /*
     * ============================================================
     * ROTATE ALL TIME
     * ============================================================
 */

    public static function rotateAllTime(
        strums:Array<Dynamic>,
        startOffset:Float,
        speed:Float,
        time:Float
    ):Void
    {
        if (strums == null)
            return;


        saveAllOriginalAngles(
            strums
        );


        for (i in 0...strums.length)
        {
            rotateTime(
                i,
                strums[i],
                startOffset,
                speed,
                time
            );
        }
    }


    /*
     * ============================================================
     * ROTATE RANGE TIME
     * ============================================================
 */

    public static function rotateRangeTime(
        strums:Array<Dynamic>,
        start:Int,
        end:Int,
        startOffset:Float,
        speed:Float,
        time:Float
    ):Void
    {
        if (strums == null)
            return;


        if (start < 0)
            start = 0;


        if (end >= strums.length)
            end =
                strums.length - 1;


        if (start > end)
            return;


        for (i in start...end + 1)
        {
            rotateTime(
                i,
                strums[i],
                startOffset,
                speed,
                time
            );
        }
    }


    /*
     * ============================================================
     * SET INDIVIDUAL ANGLES
     * ============================================================
 */

    public static function setAngles(
        strums:Array<Dynamic>,
        angles:Array<Float>
    ):Void
    {
        if (strums == null)
            return;


        if (angles == null)
            return;


        saveAllOriginalAngles(
            strums
        );


        var length:Int =
            strums.length;


        if (angles.length < length)
            length =
                angles.length;


        for (i in 0...length)
        {
            setAnglePosition(
                i,
                strums[i],
                angles[i]
            );
        }
    }


    /*
     * ============================================================
     * SET INDIVIDUAL OFFSETS
     * ============================================================
 */

    public static function setOffsets(
        strums:Array<Dynamic>,
        offsets:Array<Float>
    ):Void
    {
        if (strums == null)
            return;


        if (offsets == null)
            return;


        saveAllOriginalAngles(
            strums
        );


        var length:Int =
            strums.length;


        if (offsets.length < length)
            length =
                offsets.length;


        for (i in 0...length)
        {
            setFromOriginal(
                i,
                strums[i],
                offsets[i]
            );
        }
    }


    /*
     * ============================================================
     * GET CURRENT ANGLE
     * ============================================================
 */

    public static function getCurrentAngle(
        strum:Dynamic
    ):Float
    {
        return getAngle(
            strum
        );
    }


    /*
     * ============================================================
     * GET ORIGINAL ANGLE
     * ============================================================
 */

    public static function getOriginalAngle(
        index:Int
    ):Float
    {
        if (!originalAngle.exists(index))
            return 0;


        return originalAngle.get(
            index
        );
    }


    /*
     * ============================================================
     * GET OFFSET FROM ORIGINAL
     * ============================================================
 */

    public static function getOffsetFromOriginal(
        index:Int,
        strum:Dynamic
    ):Float
    {
        if (strum == null)
            return 0;


        if (!originalAngle.exists(index))
            return 0;


        return
            getAngle(strum) -
            originalAngle.get(index);
    }


    /*
     * ============================================================
     * HAS ORIGINAL ANGLE
     * ============================================================
 */

    public static function hasOriginalAngle(
        index:Int
    ):Bool
    {
        return originalAngle.exists(
            index
        );
    }


    /*
     * ============================================================
     * RESTORE
     * ============================================================
 */

    public static function restore(
        index:Int,
        strum:Dynamic
    ):Void
    {
        if (strum == null)
            return;


        if (!originalAngle.exists(index))
            return;


        setAngle(
            strum,
            originalAngle.get(index)
        );
    }


    /*
     * ============================================================
     * RESTORE ALL
     * ============================================================
 */

    public static function restoreAll(
        strums:Array<Dynamic>
    ):Void
    {
        if (strums == null)
            return;


        for (i in 0...strums.length)
        {
            restore(
                i,
                strums[i]
            );
        }
    }


    /*
     * ============================================================
     * RESTORE RANGE
     * ============================================================
 */

    public static function restoreRange(
        strums:Array<Dynamic>,
        start:Int,
        end:Int
    ):Void
    {
        if (strums == null)
            return;


        if (start < 0)
            start = 0;


        if (end >= strums.length)
            end =
                strums.length - 1;


        if (start > end)
            return;


        for (i in start...end + 1)
        {
            restore(
                i,
                strums[i]
            );
        }
    }


    /*
     * ============================================================
     * CLEAR ORIGINAL ANGLES
     * ============================================================
 */

    public static function clearOriginalAngles():Void
    {
        originalAngle =
            new Map<Int, Float>();
    }


    /*
     * ============================================================
     * CLEAR
     * ============================================================
 */

    public static function clear():Void
    {
        clearOriginalAngles();
    }
}