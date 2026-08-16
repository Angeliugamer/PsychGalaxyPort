/*
 * ============================================================
 * MoverStrumsVertical.hx
 * ============================================================
 *
 * FNF In The Galaxy -> Psych Engine 1.0.4
 *
 * Sistema especializado para movimiento vertical de Strums.
 *
 * ============================================================
 *
 * RESPONSABILIDAD:
 *
 *     - Mover strums verticalmente
 *     - Establecer posición Y
 *     - Aplicar offset vertical desde posición original
 *     - Mover todos los strums verticalmente
 *     - Mover rangos de strums verticalmente
 *     - Crear ondas verticales
 *     - Restaurar posición Y original
 *
 * ============================================================
 *
 * NO SE ENCARGA DE:
 *
 *     - Movimiento X general
 *     - Rotación
 *     - Movimiento circular
 *     - Perspectiva
 *     - 3D
 *     - Alpha
 *     - Notas
 *     - Window
 *
 * ============================================================
 *
 * IMPORTANTE:
 *
 * Este archivo está pensado para mecánicas de modchart donde
 * solamente se necesita manipular el eje Y.
 *
 * La posición original se almacena para poder hacer:
 *
 *     Y = Y_original + offset
 *
 * en cada frame sin acumulación.
 *
 * ============================================================
 */

import flixel.FlxSprite;


/**
 * MoverStrumsVertical
 *
 * Controlador especializado del eje Y de los strums.
 */
class MoverStrumsVertical
{
    /*
     * ============================================================
     * POSICIONES Y ORIGINALES
     * ============================================================
     */

    private static var originalY:Map<Int, Float> =
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
     * GET Y
     * ============================================================
     */

    private static function getY(
        strum:Dynamic
    ):Float
    {
        if (strum == null)
            return 0;


        try
        {
            return strum.y;
        }
        catch (e:Dynamic)
        {
            return 0;
        }
    }


    /*
     * ============================================================
     * SET Y
     * ============================================================
 */

    private static function setY(
        strum:Dynamic,
        value:Float
    ):Void
    {
        if (strum == null)
            return;


        try
        {
            strum.y =
                value;
        }
        catch (e:Dynamic)
        {
        }
    }


    /*
     * ============================================================
     * SAVE ORIGINAL Y
     * ============================================================
 */

    public static function saveOriginalY(
        index:Int,
        strum:Dynamic
    ):Void
    {
        if (strum == null)
            return;


        if (!originalY.exists(index))
        {
            originalY.set(
                index,
                getY(strum)
            );
        }
    }


    /*
     * ============================================================
     * SAVE ALL ORIGINAL Y
     * ============================================================
 */

    public static function saveAllOriginalY(
        strums:Array<Dynamic>
    ):Void
    {
        if (strums == null)
            return;


        for (i in 0...strums.length)
        {
            saveOriginalY(
                i,
                strums[i]
            );
        }
    }


    /*
     * ============================================================
     * SET Y
     * ============================================================
 *
 * Establece una posición Y absoluta.
 *
 * ============================================================
 */

    public static function setYPosition(
        index:Int,
        strum:Dynamic,
        y:Float
    ):Void
    {
        if (strum == null)
            return;


        saveOriginalY(
            index,
            strum
        );


        setY(
            strum,
            y
        );
    }


    /*
     * ============================================================
     * MOVE
     * ============================================================
 *
 * Movimiento relativo.
 *
 * ============================================================
 */

    public static function move(
        index:Int,
        strum:Dynamic,
        amount:Float
    ):Void
    {
        if (strum == null)
            return;


        saveOriginalY(
            index,
            strum
        );


        setY(
            strum,
            getY(strum) + amount
        );
    }


    /*
     * ============================================================
     * SET FROM ORIGINAL
     * ============================================================
 *
 * Y = Y_original + offset
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


        saveOriginalY(
            index,
            strum
        );


        var y:Float =
            originalY.get(index);


        setY(
            strum,
            y + offset
        );
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


        saveAllOriginalY(
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
     * MOVE ALL
     * ============================================================
 */

    public static function moveAll(
        strums:Array<Dynamic>,
        amount:Float
    ):Void
    {
        if (strums == null)
            return;


        saveAllOriginalY(
            strums
        );


        for (i in 0...strums.length)
        {
            move(
                i,
                strums[i],
                amount
            );
        }
    }


    /*
     * ============================================================
     * MOVE RANGE
     * ============================================================
 */

    public static function moveRange(
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
            move(
                i,
                strums[i],
                amount
            );
        }
    }


    /*
     * ============================================================
     * SET RANGE FROM ORIGINAL
     * ============================================================
 */

    public static function setRangeFromOriginal(
        strums:Array<Dynamic>,
        start:Int,
        end:Int,
        offset:Float
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
            setFromOriginal(
                i,
                strums[i],
                offset
            );
        }
    }


    /*
     * ============================================================
     * SET DIFFERENT OFFSETS
     * ============================================================
 *
 * Aplica un offset individual a cada strum.
 *
 * Ejemplo:
 *
 *     offsets = [0, 20, 40, 60]
 *
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


        saveAllOriginalY(
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
     * ADD OFFSETS
     * ============================================================
 *
 * Añade un offset individual a la posición actual.
 *
 * ============================================================
 */

    public static function addOffsets(
        strums:Array<Dynamic>,
        offsets:Array<Float>
    ):Void
    {
        if (strums == null)
            return;


        if (offsets == null)
            return;


        var length:Int =
            strums.length;


        if (offsets.length < length)
            length =
                offsets.length;


        for (i in 0...length)
        {
            move(
                i,
                strums[i],
                offsets[i]
            );
        }
    }


    /*
     * ============================================================
     * WAVE
     * ============================================================
 *
 * Crea una onda vertical basada en el índice del strum.
 *
 * Formula:
 *
 *     sin(index * frequency + phase) * amplitude
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


        saveAllOriginalY(
            strums
        );


        for (i in 0...strums.length)
        {
            var offset:Float =
                Math.sin(
                    i * frequency +
                    phase
                ) * amplitude;


            setFromOriginal(
                i,
                strums[i],
                offset
            );
        }
    }


    /*
     * ============================================================
     * WAVE WITH TIME
     * ============================================================
 *
 * Versión pensada para llamarse desde onUpdate.
 *
 * time controla la fase.
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


        saveAllOriginalY(
            strums
        );


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
     * ALTERNATE
     * ============================================================
 *
 * Alterna dos offsets:
 *
 *     índice par  -> offsetA
 *     índice impar -> offsetB
 *
 * ============================================================
 */

    public static function alternate(
        strums:Array<Dynamic>,
        offsetA:Float,
        offsetB:Float
    ):Void
    {
        if (strums == null)
            return;


        saveAllOriginalY(
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
     * RAMP
     * ============================================================
 *
 * Distribuye progresivamente un offset vertical.
 *
 * Ejemplo:
 *
 *     start = 0
 *     end   = 100
 *
 * Cuatro strums:
 *
 *     0
 *     33.33
 *     66.66
 *     100
 *
 * ============================================================
 */

    public static function ramp(
        strums:Array<Dynamic>,
        startOffset:Float,
        endOffset:Float
    ):Void
    {
        if (strums == null)
            return;


        saveAllOriginalY(
            strums
        );


        var length:Int =
            strums.length;


        if (length <= 0)
            return;


        if (length == 1)
        {
            setFromOriginal(
                0,
                strums[0],
                startOffset
            );


            return;
        }


        for (i in 0...length)
        {
            var progress:Float =
                i / (length - 1);


            var offset:Float =
                startOffset +
                (
                    endOffset -
                    startOffset
                ) * progress;


            setFromOriginal(
                i,
                strums[i],
                offset
            );
        }
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


        if (!originalY.exists(index))
            return;


        setY(
            strum,
            originalY.get(index)
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
     * GET CURRENT Y
     * ============================================================
 */

    public static function getCurrentY(
        strum:Dynamic
    ):Float
    {
        return getY(
            strum
        );
    }


    /*
     * ============================================================
     * GET ORIGINAL Y
     * ============================================================
 */

    public static function getOriginalY(
        index:Int
    ):Float
    {
        if (!originalY.exists(index))
            return 0;


        return originalY.get(
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


        if (!originalY.exists(index))
            return 0;


        return
            getY(strum) -
            originalY.get(index);
    }


    /*
     * ============================================================
     * HAS ORIGINAL Y
     * ============================================================
 */

    public static function hasOriginalY(
        index:Int
    ):Bool
    {
        return originalY.exists(
            index
        );
    }


    /*
     * ============================================================
     * CLEAR ORIGINAL Y
     * ============================================================
 */

    public static function clearOriginalY():Void
    {
        originalY =
            new Map<Int, Float>();
    }


    /*
     * ============================================================
     * CLEAR
     * ============================================================
 */

    public static function clear():Void
    {
        clearOriginalY();
    }
}