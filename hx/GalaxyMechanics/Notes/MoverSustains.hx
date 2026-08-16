/*
 * ============================================================
 * MoverSustains.hx
 * ============================================================
 *
 * FNF In The Galaxy -> Psych Engine 1.0.4
 *
 * Sistema individual para mover sustain notes.
 *
 * ============================================================
 *
 * RESPONSABILIDAD:
 *
 *     - Mover sustains en X/Y
 *     - Establecer posición de sustains
 *     - Mover sustains desde su posición original
 *     - Mover todos los sustains
 *     - Restaurar posiciones originales
 *     - Trabajar únicamente con sustain notes
 *
 * ============================================================
 *
 * NO SE ENCARGA DE:
 *
 *     - Notas normales
 *     - Velocidad
 *     - Alpha
 *     - Rotación
 *     - Strums
 *     - 3D
 *     - Window
 *
 * ============================================================
 *
 * IMPORTANTE:
 *
 * Una sustain note de Psych sigue siendo una Note.
 *
 * Por eso este sistema trabaja con Dynamic para poder utilizar
 * las propiedades de Note sin acoplarse innecesariamente a una
 * implementación concreta.
 *
 * La comprobación isSustainNote se realiza cuando corresponde.
 *
 * ============================================================
 */

import flixel.FlxSprite;


/**
 * MoverSustains
 *
 * Controlador independiente para posiciones de sustains.
 */
class MoverSustains
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
     * IS SUSTAIN
     * ============================================================
     *
     * Comprueba si el objeto corresponde a un sustain note.
     *
     * Si la propiedad no existe, devolvemos false en lugar de
     * provocar un crash.
     *
     * ============================================================
     */

    private static function isSustain(
        note:Dynamic
    ):Bool
    {
        if (note == null)
            return false;


        try
        {
            return note.isSustainNote;
        }
        catch (e:Dynamic)
        {
            return false;
        }
    }


    /*
     * ============================================================
     * GET X
     * ============================================================
     */

    private static function getX(
        note:Dynamic
    ):Float
    {
        if (note == null)
            return 0;


        try
        {
            return note.x;
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
        note:Dynamic
    ):Float
    {
        if (note == null)
            return 0;


        try
        {
            return note.y;
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
        note:Dynamic,
        value:Float
    ):Void
    {
        if (note == null)
            return;


        try
        {
            note.x =
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
        note:Dynamic,
        value:Float
    ):Void
    {
        if (note == null)
            return;


        try
        {
            note.y =
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
 *
 * Solo guarda objetos que realmente sean sustains.
 *
 * ============================================================
 */

    public static function saveOriginalPosition(
        index:Int,
        note:Dynamic
    ):Void
    {
        if (note == null)
            return;


        if (!isSustain(note))
            return;


        if (!originalX.exists(index))
        {
            originalX.set(
                index,
                getX(note)
            );
        }


        if (!originalY.exists(index))
        {
            originalY.set(
                index,
                getY(note)
            );
        }
    }


    /*
     * ============================================================
     * SAVE ALL ORIGINAL POSITIONS
     * ============================================================
 */

    public static function saveAllOriginalPositions(
        notes:Array<Dynamic>
    ):Void
    {
        if (notes == null)
            return;


        for (i in 0...notes.length)
        {
            saveOriginalPosition(
                i,
                notes[i]
            );
        }
    }


    /*
     * ============================================================
     * SET POSITION
     * ============================================================
 *
 * Establece X/Y de un sustain.
 *
 * ============================================================
 */

    public static function setPosition(
        index:Int,
        note:Dynamic,
        x:Float,
        y:Float
    ):Void
    {
        if (note == null)
            return;


        if (!isSustain(note))
            return;


        saveOriginalPosition(
            index,
            note
        );


        setX(
            note,
            x
        );


        setY(
            note,
            y
        );
    }


    /*
     * ============================================================
     * SET X
     * ============================================================
 */

    public static function setSustainX(
        index:Int,
        note:Dynamic,
        x:Float
    ):Void
    {
        if (note == null)
            return;


        if (!isSustain(note))
            return;


        saveOriginalPosition(
            index,
            note
        );


        setX(
            note,
            x
        );
    }


    /*
     * ============================================================
     * SET Y
     * ============================================================
 */

    public static function setSustainY(
        index:Int,
        note:Dynamic,
        y:Float
    ):Void
    {
        if (note == null)
            return;


        if (!isSustain(note))
            return;


        saveOriginalPosition(
            index,
            note
        );


        setY(
            note,
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
        note:Dynamic,
        offsetX:Float,
        offsetY:Float
    ):Void
    {
        if (note == null)
            return;


        if (!isSustain(note))
            return;


        saveOriginalPosition(
            index,
            note
        );


        setX(
            note,
            getX(note) + offsetX
        );


        setY(
            note,
            getY(note) + offsetY
        );
    }


    /*
     * ============================================================
     * MOVE X
     * ============================================================
 */

    public static function moveX(
        index:Int,
        note:Dynamic,
        amount:Float
    ):Void
    {
        if (note == null)
            return;


        if (!isSustain(note))
            return;


        saveOriginalPosition(
            index,
            note
        );


        setX(
            note,
            getX(note) + amount
        );
    }


    /*
     * ============================================================
     * MOVE Y
     * ============================================================
 */

    public static function moveY(
        index:Int,
        note:Dynamic,
        amount:Float
    ):Void
    {
        if (note == null)
            return;


        if (!isSustain(note))
            return;


        saveOriginalPosition(
            index,
            note
        );


        setY(
            note,
            getY(note) + amount
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
 * Esto evita acumulación.
 *
 * ============================================================
 */

    public static function setFromOriginal(
        index:Int,
        note:Dynamic,
        offsetX:Float,
        offsetY:Float
    ):Void
    {
        if (note == null)
            return;


        if (!isSustain(note))
            return;


        saveOriginalPosition(
            index,
            note
        );


        var x:Float =
            originalX.get(index);


        var y:Float =
            originalY.get(index);


        setX(
            note,
            x + offsetX
        );


        setY(
            note,
            y + offsetY
        );
    }


    /*
     * ============================================================
     * SET ORIGINAL X
     * ============================================================
 */

    public static function setOriginalX(
        index:Int,
        note:Dynamic,
        offset:Float
    ):Void
    {
        setFromOriginal(
            index,
            note,
            offset,
            0
        );
    }


    /*
     * ============================================================
     * SET ORIGINAL Y
     * ============================================================
 */

    public static function setOriginalY(
        index:Int,
        note:Dynamic,
        offset:Float
    ):Void
    {
        setFromOriginal(
            index,
            note,
            0,
            offset
        );
    }


    /*
     * ============================================================
     * MOVE ALL
     * ============================================================
 *
 * Mueve todos los objetos del Array que sean sustains.
 *
 * ============================================================
 */

    public static function moveAll(
        notes:Array<Dynamic>,
        offsetX:Float,
        offsetY:Float
    ):Void
    {
        if (notes == null)
            return;


        saveAllOriginalPositions(
            notes
        );


        for (i in 0...notes.length)
        {
            move(
                i,
                notes[i],
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
        notes:Array<Dynamic>,
        amount:Float
    ):Void
    {
        if (notes == null)
            return;


        saveAllOriginalPositions(
            notes
        );


        for (i in 0...notes.length)
        {
            moveX(
                i,
                notes[i],
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
        notes:Array<Dynamic>,
        amount:Float
    ):Void
    {
        if (notes == null)
            return;


        saveAllOriginalPositions(
            notes
        );


        for (i in 0...notes.length)
        {
            moveY(
                i,
                notes[i],
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
        notes:Array<Dynamic>,
        offsetX:Float,
        offsetY:Float
    ):Void
    {
        if (notes == null)
            return;


        saveAllOriginalPositions(
            notes
        );


        for (i in 0...notes.length)
        {
            setFromOriginal(
                i,
                notes[i],
                offsetX,
                offsetY
            );
        }
    }


    /*
     * ============================================================
     * SET ALL ORIGINAL X
     * ============================================================
 */

    public static function setAllOriginalX(
        notes:Array<Dynamic>,
        offset:Float
    ):Void
    {
        setAllFromOriginal(
            notes,
            offset,
            0
        );
    }


    /*
     * ============================================================
     * SET ALL ORIGINAL Y
     * ============================================================
 */

    public static function setAllOriginalY(
        notes:Array<Dynamic>,
        offset:Float
    ):Void
    {
        setAllFromOriginal(
            notes,
            0,
            offset
        );
    }


    /*
     * ============================================================
     * RESTORE
     * ============================================================
 */

    public static function restore(
        index:Int,
        note:Dynamic
    ):Void
    {
        if (note == null)
            return;


        if (!isSustain(note))
            return;


        if (!originalX.exists(index))
            return;


        if (!originalY.exists(index))
            return;


        setX(
            note,
            originalX.get(index)
        );


        setY(
            note,
            originalY.get(index)
        );
    }


    /*
     * ============================================================
     * RESTORE ALL
     * ============================================================
 */

    public static function restoreAll(
        notes:Array<Dynamic>
    ):Void
    {
        if (notes == null)
            return;


        for (i in 0...notes.length)
        {
            restore(
                i,
                notes[i]
            );
        }
    }


    /*
     * ============================================================
     * GET CURRENT X
     * ============================================================
 */

    public static function getCurrentX(
        note:Dynamic
    ):Float
    {
        return getX(
            note
        );
    }


    /*
     * ============================================================
     * GET CURRENT Y
     * ============================================================
 */

    public static function getCurrentY(
        note:Dynamic
    ):Float
    {
        return getY(
            note
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
     * GET OFFSET FROM ORIGINAL
     * ============================================================
 */

    public static function getOffsetFromOriginal(
        index:Int,
        note:Dynamic
    ):Dynamic
    {
        if (note == null)
            return null;


        if (!isSustain(note))
            return null;


        if (!hasOriginalPosition(index))
        {
            return {
                x: 0,
                y: 0
            };
        }


        return {
            x:
                getX(note) -
                originalX.get(index),

            y:
                getY(note) -
                originalY.get(index)
        };
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