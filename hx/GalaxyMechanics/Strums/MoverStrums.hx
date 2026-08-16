/*
 * ============================================================
 * MoverStrums.hx
 * ============================================================
 *
 * FNF In The Galaxy -> Psych Engine 1.0.4
 *
 * Sistema independiente para mover Strum Notes / receptors.
 *
 * ============================================================
 *
 * RESPONSABILIDAD:
 *
 *     - Establecer posición X/Y de un strum
 *     - Mover un strum
 *     - Mover solamente X
 *     - Mover solamente Y
 *     - Mover desde la posición original
 *     - Mover grupos de strums
 *     - Mover rangos de strums
 *     - Restaurar posiciones originales
 *
 * ============================================================
 *
 * NO SE ENCARGA DE:
 *
 *     - Rotación
 *     - Movimiento circular
 *     - Perspectiva 3D
 *     - Alpha
 *     - Notas
 *     - Sustains
 *     - Window
 *
 * ============================================================
 *
 * IMPORTANTE:
 *
 * Este sistema trabaja con los objetos receptor de Psych.
 *
 * Normalmente se utilizará:
 *
 *     game.strumLineNotes.members
 *
 * o un Array específico de strums.
 *
 * ============================================================
 */

import flixel.FlxSprite;


/**
 * MoverStrums
 *
 * Controlador independiente de posición 2D para strums.
 */
class MoverStrums
{
    /*
     * ============================================================
     * POSICIONES ORIGINALES
     * ============================================================
     */

    private static var originalX:Map<Int, Float> =
        new Map<Int, Float>();


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
     * GET X
     * ============================================================
     */

    private static function getX(
        strum:Dynamic
    ):Float
    {
        if (strum == null)
            return 0;


        try
        {
            return strum.x;
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
     * SET X
     * ============================================================
 */

    private static function setX(
        strum:Dynamic,
        value:Float
    ):Void
    {
        if (strum == null)
            return;


        try
        {
            strum.x =
                value;
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
     * SAVE ORIGINAL POSITION
     * ============================================================
 */

    public static function saveOriginalPosition(
        index:Int,
        strum:Dynamic
    ):Void
    {
        if (strum == null)
            return;


        if (!originalX.exists(index))
        {
            originalX.set(
                index,
                getX(strum)
            );
        }


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
     * SAVE ALL ORIGINAL POSITIONS
     * ============================================================
 */

    public static function saveAllOriginalPositions(
        strums:Array<Dynamic>
    ):Void
    {
        if (strums == null)
            return;


        for (i in 0...strums.length)
        {
            saveOriginalPosition(
                i,
                strums[i]
            );
        }
    }


    /*
     * ============================================================
     * SET POSITION
     * ============================================================
 *
 * Establece una posición absoluta.
 *
 * ============================================================
 */

    public static function setPosition(
        index:Int,
        strum:Dynamic,
        x:Float,
        y:Float
    ):Void
    {
        if (strum == null)
            return;


        saveOriginalPosition(
            index,
            strum
        );


        setX(
            strum,
            x
        );


        setY(
            strum,
            y
        );
    }


    /*
     * ============================================================
     * SET X
     * ============================================================
 */

    public static function setStrumX(
        index:Int,
        strum:Dynamic,
        x:Float
    ):Void
    {
        if (strum == null)
            return;


        saveOriginalPosition(
            index,
            strum
        );


        setX(
            strum,
            x
        );
    }


    /*
     * ============================================================
     * SET Y
     * ============================================================
 */

    public static function setStrumY(
        index:Int,
        strum:Dynamic,
        y:Float
    ):Void
    {
        if (strum == null)
            return;


        saveOriginalPosition(
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
 * Movimiento relativo a la posición actual.
 *
 * ============================================================
 */

    public static function move(
        index:Int,
        strum:Dynamic,
        offsetX:Float,
        offsetY:Float
    ):Void
    {
        if (strum == null)
            return;


        saveOriginalPosition(
            index,
            strum
        );


        setX(
            strum,
            getX(strum) + offsetX
        );


        setY(
            strum,
            getY(strum) + offsetY
        );
    }


    /*
     * ============================================================
     * MOVE X
     * ============================================================
 */

    public static function moveX(
        index:Int,
        strum:Dynamic,
        amount:Float
    ):Void
    {
        if (strum == null)
            return;


        saveOriginalPosition(
            index,
            strum
        );


        setX(
            strum,
            getX(strum) + amount
        );
    }


    /*
     * ============================================================
     * MOVE Y
     * ============================================================
 */

    public static function moveY(
        index:Int,
        strum:Dynamic,
        amount:Float
    ):Void
    {
        if (strum == null)
            return;


        saveOriginalPosition(
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
 * Establece:
 *
 *     X = originalX + offsetX
 *     Y = originalY + offsetY
 *
 * Esto evita acumulación en onUpdate.
 *
 * ============================================================
 */

    public static function setFromOriginal(
        index:Int,
        strum:Dynamic,
        offsetX:Float,
        offsetY:Float
    ):Void
    {
        if (strum == null)
            return;


        saveOriginalPosition(
            index,
            strum
        );


        var x:Float =
            originalX.get(index);


        var y:Float =
            originalY.get(index);


        setX(
            strum,
            x + offsetX
        );


        setY(
            strum,
            y + offsetY
        );
    }


    /*
     * ============================================================
     * SET FROM ORIGINAL X
     * ============================================================
 */

    public static function setFromOriginalX(
        index:Int,
        strum:Dynamic,
        offset:Float
    ):Void
    {
        setFromOriginal(
            index,
            strum,
            offset,
            0
        );
    }


    /*
     * ============================================================
     * SET FROM ORIGINAL Y
     * ============================================================
 */

    public static function setFromOriginalY(
        index:Int,
        strum:Dynamic,
        offset:Float
    ):Void
    {
        setFromOriginal(
            index,
            strum,
            0,
            offset
        );
    }


    /*
     * ============================================================
     * MOVE ALL
     * ============================================================
 */

    public static function moveAll(
        strums:Array<Dynamic>,
        offsetX:Float,
        offsetY:Float
    ):Void
    {
        if (strums == null)
            return;


        saveAllOriginalPositions(
            strums
        );


        for (i in 0...strums.length)
        {
            move(
                i,
                strums[i],
                offsetX,
                offsetY
            );
        }
    }


    /*
     * ============================================================
     * MOVE ALL X
     * ============================================================
 */

    public static function moveAllX(
        strums:Array<Dynamic>,
        amount:Float
    ):Void
    {
        if (strums == null)
            return;


        saveAllOriginalPositions(
            strums
        );


        for (i in 0...strums.length)
        {
            moveX(
                i,
                strums[i],
                amount
            );
        }
    }


    /*
     * ============================================================
     * MOVE ALL Y
     * ============================================================
 */

    public static function moveAllY(
        strums:Array<Dynamic>,
        amount:Float
    ):Void
    {
        if (strums == null)
            return;


        saveAllOriginalPositions(
            strums
        );


        for (i in 0...strums.length)
        {
            moveY(
                i,
                strums[i],
                amount
            );
        }
    }


    /*
     * ============================================================
     * SET ALL POSITION
     * ============================================================
 *
 * Coloca todos los strums en la misma posición.
 *
 * ============================================================
 */

    public static function setAllPosition(
        strums:Array<Dynamic>,
        x:Float,
        y:Float
    ):Void
    {
        if (strums == null)
            return;


        saveAllOriginalPositions(
            strums
        );


        for (i in 0...strums.length)
        {
            setPosition(
                i,
                strums[i],
                x,
                y
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
        offsetX:Float,
        offsetY:Float
    ):Void
    {
        if (strums == null)
            return;


        saveAllOriginalPositions(
            strums
        );


        for (i in 0...strums.length)
        {
            setFromOriginal(
                i,
                strums[i],
                offsetX,
                offsetY
            );
        }
    }


    /*
     * ============================================================
     * SET ALL FROM ORIGINAL X
     * ============================================================
 */

    public static function setAllFromOriginalX(
        strums:Array<Dynamic>,
        offset:Float
    ):Void
    {
        setAllFromOriginal(
            strums,
            offset,
            0
        );
    }


    /*
     * ============================================================
     * SET ALL FROM ORIGINAL Y
     * ============================================================
 */

    public static function setAllFromOriginalY(
        strums:Array<Dynamic>,
        offset:Float
    ):Void
    {
        setAllFromOriginal(
            strums,
            0,
            offset
        );
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
        offsetX:Float,
        offsetY:Float
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
                offsetX,
                offsetY
            );
        }
    }


    /*
     * ============================================================
     * MOVE RANGE X
     * ============================================================
 */

    public static function moveRangeX(
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
            moveX(
                i,
                strums[i],
                amount
            );
        }
    }


    /*
     * ============================================================
     * MOVE RANGE Y
     * ============================================================
 */

    public static function moveRangeY(
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
            moveY(
                i,
                strums[i],
                amount
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


        if (!originalX.exists(index))
            return;


        if (!originalY.exists(index))
            return;


        setX(
            strum,
            originalX.get(index)
        );


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
     * GET CURRENT X
     * ============================================================
 */

    public static function getCurrentX(
        strum:Dynamic
    ):Float
    {
        return getX(
            strum
        );
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
     * GET ORIGINAL X
     * ============================================================
 */

    public static function getOriginalX(
        index:Int
    ):Float
    {
        if (!originalX.exists(index))
            return 0;


        return originalX.get(
            index
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
    ):Dynamic
    {
        if (strum == null)
            return null;


        if (
            !originalX.exists(index) ||
            !originalY.exists(index)
        )
        {
            return {
                x: 0,
                y: 0
            };
        }


        return {
            x:
                getX(strum) -
                originalX.get(index),

            y:
                getY(strum) -
                originalY.get(index)
        };
    }


    /*
     * ============================================================
     * HAS ORIGINAL POSITION
     * ============================================================
 */

    public static function hasOriginalPosition(
        index:Int
    ):Bool
    {
        return
            originalX.exists(index) &&
            originalY.exists(index);
    }


    /*
     * ============================================================
     * CLEAR ORIGINAL POSITIONS
     * ============================================================
 */

    public static function clearOriginalPositions():Void
    {
        originalX =
            new Map<Int, Float>();


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
        clearOriginalPositions();
    }
}