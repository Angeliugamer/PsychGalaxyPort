/*
 * ============================================================
 * InvertirNotas.hx
 * ============================================================
 *
 * FNF In The Galaxy -> Psych Engine 1.0.4
 *
 * Sistema individual para invertir la posición de las notas.
 *
 * ============================================================
 *
 * RESPONSABILIDAD:
 *
 *     - Invertir notas horizontalmente
 *     - Invertir notas verticalmente
 *     - Invertir X/Y
 *     - Invertir respecto a un centro
 *     - Invertir respecto a la posición original
 *     - Invertir grupos de notas
 *     - Restaurar posiciones originales
 *
 * ============================================================
 *
 * NO SE ENCARGA DE:
 *
 *     - Velocidad
 *     - Alpha
 *     - Rotación
 *     - Sustains
 *     - Strums
 *     - 3D
 *     - Window
 *
 * ============================================================
 *
 * IMPORTANTE:
 *
 * "Invertir" aquí significa invertir la POSICIÓN de la nota.
 *
 * No se modifica:
 *
 *     note.angle
 *     note.scale
 *     note.speed
 *
 * ============================================================
 */

import flixel.FlxSprite;


/**
 * InvertirNotas
 *
 * Controlador independiente para invertir posiciones.
 */
class InvertirNotas
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
     * ESTADO DE INVERSIÓN
     * ============================================================
     */

    private static var invertedX:Map<Int, Bool> =
        new Map<Int, Bool>();


    private static var invertedY:Map<Int, Bool> =
        new Map<Int, Bool>();


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
     */

    public static function saveOriginalPosition(
        index:Int,
        note:Dynamic
    ):Void
    {
        if (note == null)
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
     * INVERT X
     * ============================================================
     *
     * Invierte la nota respecto a un eje X.
     *
     * Fórmula:
     *
     *     nuevaX = centroX - (x - centroX)
     *
     * ============================================================
 */

    public static function invertX(
        note:Dynamic,
        centerX:Float
    ):Void
    {
        if (note == null)
            return;


        var distance:Float =
            getX(note) -
            centerX;


        setX(
            note,
            centerX -
            distance
        );
    }


    /*
     * ============================================================
     * INVERT Y
     * ============================================================
 */

    public static function invertY(
        note:Dynamic,
        centerY:Float
    ):Void
    {
        if (note == null)
            return;


        var distance:Float =
            getY(note) -
            centerY;


        setY(
            note,
            centerY -
            distance
        );
    }


    /*
     * ============================================================
     * INVERT X/Y
     * ============================================================
 */

    public static function invert(
        note:Dynamic,
        centerX:Float,
        centerY:Float
    ):Void
    {
        if (note == null)
            return;


        invertX(
            note,
            centerX
        );


        invertY(
            note,
            centerY
        );
    }


    /*
     * ============================================================
     * INVERT X FROM ORIGINAL
     * ============================================================
     *
     * Invierte la posición original respecto a centerX.
     *
     * Esto evita acumulación.
     *
     * ============================================================
 */

    public static function invertXFromOriginal(
        index:Int,
        note:Dynamic,
        centerX:Float
    ):Void
    {
        if (note == null)
            return;


        saveOriginalPosition(
            index,
            note
        );


        var original:Float =
            originalX.get(index);


        var distance:Float =
            original -
            centerX;


        setX(
            note,
            centerX -
            distance
        );


        invertedX.set(
            index,
            true
        );
    }


    /*
     * ============================================================
     * INVERT Y FROM ORIGINAL
     * ============================================================
 */

    public static function invertYFromOriginal(
        index:Int,
        note:Dynamic,
        centerY:Float
    ):Void
    {
        if (note == null)
            return;


        saveOriginalPosition(
            index,
            note
        );


        var original:Float =
            originalY.get(index);


        var distance:Float =
            original -
            centerY;


        setY(
            note,
            centerY -
            distance
        );


        invertedY.set(
            index,
            true
        );
    }


    /*
     * ============================================================
     * INVERT FROM ORIGINAL
     * ============================================================
 */

    public static function invertFromOriginal(
        index:Int,
        note:Dynamic,
        centerX:Float,
        centerY:Float
    ):Void
    {
        if (note == null)
            return;


        invertXFromOriginal(
            index,
            note,
            centerX
        );


        invertYFromOriginal(
            index,
            note,
            centerY
        );
    }


    /*
     * ============================================================
     * TOGGLE X
     * ============================================================
     *
     * Alterna entre posición normal e invertida.
     *
     * ============================================================
 */

    public static function toggleX(
        index:Int,
        note:Dynamic,
        centerX:Float
    ):Void
    {
        if (note == null)
            return;


        saveOriginalPosition(
            index,
            note
        );


        var state:Bool =
            invertedX.exists(index)
            ? invertedX.get(index)
            : false;


        if (state)
        {
            setX(
                note,
                originalX.get(index)
            );


            invertedX.set(
                index,
                false
            );
        }
        else
        {
            invertXFromOriginal(
                index,
                note,
                centerX
            );
        }
    }


    /*
     * ============================================================
     * TOGGLE Y
     * ============================================================
 */

    public static function toggleY(
        index:Int,
        note:Dynamic,
        centerY:Float
    ):Void
    {
        if (note == null)
            return;


        saveOriginalPosition(
            index,
            note
        );


        var state:Bool =
            invertedY.exists(index)
            ? invertedY.get(index)
            : false;


        if (state)
        {
            setY(
                note,
                originalY.get(index)
            );


            invertedY.set(
                index,
                false
            );
        }
        else
        {
            invertYFromOriginal(
                index,
                note,
                centerY
            );
        }
    }


    /*
     * ============================================================
     * TOGGLE
     * ============================================================
 */

    public static function toggle(
        index:Int,
        note:Dynamic,
        centerX:Float,
        centerY:Float
    ):Void
    {
        if (note == null)
            return;


        toggleX(
            index,
            note,
            centerX
        );


        toggleY(
            index,
            note,
            centerY
        );
    }


    /*
     * ============================================================
     * INVERT ALL X
     * ============================================================
 */

    public static function invertAllX(
        notes:Array<Dynamic>,
        centerX:Float
    ):Void
    {
        if (notes == null)
            return;


        saveAllOriginalPositions(
            notes
        );


        for (i in 0...notes.length)
        {
            invertXFromOriginal(
                i,
                notes[i],
                centerX
            );
        }
    }


    /*
     * ============================================================
     * INVERT ALL Y
     * ============================================================
 */

    public static function invertAllY(
        notes:Array<Dynamic>,
        centerY:Float
    ):Void
    {
        if (notes == null)
            return;


        saveAllOriginalPositions(
            notes
        );


        for (i in 0...notes.length)
        {
            invertYFromOriginal(
                i,
                notes[i],
                centerY
            );
        }
    }


    /*
     * ============================================================
     * INVERT ALL
     * ============================================================
 */

    public static function invertAll(
        notes:Array<Dynamic>,
        centerX:Float,
        centerY:Float
    ):Void
    {
        if (notes == null)
            return;


        saveAllOriginalPositions(
            notes
        );


        for (i in 0...notes.length)
        {
            invertFromOriginal(
                i,
                notes[i],
                centerX,
                centerY
            );
        }
    }


    /*
     * ============================================================
     * RESTORE X
     * ============================================================
 */

    public static function restoreX(
        index:Int,
        note:Dynamic
    ):Void
    {
        if (note == null)
            return;


        if (!originalX.exists(index))
            return;


        setX(
            note,
            originalX.get(index)
        );


        invertedX.set(
            index,
            false
        );
    }


    /*
     * ============================================================
     * RESTORE Y
     * ============================================================
 */

    public static function restoreY(
        index:Int,
        note:Dynamic
    ):Void
    {
        if (note == null)
            return;


        if (!originalY.exists(index))
            return;


        setY(
            note,
            originalY.get(index)
        );


        invertedY.set(
            index,
            false
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


        restoreX(
            index,
            note
        );


        restoreY(
            index,
            note
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
     * IS X INVERTED
     * ============================================================
 */

    public static function isXInverted(
        index:Int
    ):Bool
    {
        if (!invertedX.exists(index))
            return false;


        return invertedX.get(
            index
        );
    }


    /*
     * ============================================================
     * IS Y INVERTED
     * ============================================================
 */

    public static function isYInverted(
        index:Int
    ):Bool
    {
        if (!invertedY.exists(index))
            return false;


        return invertedY.get(
            index
        );
    }


    /*
     * ============================================================
     * CLEAR
     * ============================================================
 */

    public static function clear():Void
    {
        originalX =
            new Map<Int, Float>();


        originalY =
            new Map<Int, Float>();


        invertedX =
            new Map<Int, Bool>();


        invertedY =
            new Map<Int, Bool>();
    }
}