/*
 * ============================================================
 * RotarNotas.hx
 * ============================================================
 *
 * FNF In The Galaxy -> Psych Engine 1.0.4
 *
 * Sistema individual para rotar notas.
 *
 * ============================================================
 *
 * RESPONSABILIDAD:
 *
 *     - Establecer ángulo de una nota
 *     - Rotar una nota
 *     - Añadir rotación
 *     - Rotar desde el ángulo original
 *     - Rotar grupos de notas
 *     - Restaurar ángulos originales
 *     - Limitar / normalizar ángulos
 *
 * ============================================================
 *
 * NO SE ENCARGA DE:
 *
 *     - Posición
 *     - Velocidad
 *     - Alpha
 *     - Sustains
 *     - Strums
 *     - 3D
 *     - Window
 *
 * ============================================================
 *
 * IMPORTANTE:
 *
 * Esta clase utiliza note.angle, que corresponde a la rotación
 * 2D de Flixel.
 *
 * No intenta modificar:
 *
 *     rotationX
 *     rotationY
 *     rotationZ
 *
 * del sistema 3D.
 *
 * Para eso se utilizará Note3D.hx.
 *
 * ============================================================
 */

import flixel.FlxSprite;


/**
 * RotarNotas
 *
 * Controlador independiente para rotación 2D de notas.
 */
class RotarNotas
{
    /*
     * ============================================================
     * ÁNGULOS ORIGINALES
     * ============================================================
     *
     * Se almacenan por índice de nota.
     *
     * ============================================================
     */

    private static var originalAngle:Map<Int, Float> =
        new Map<Int, Float>();


    /*
     * ============================================================
     * ÁNGULOS MODIFICADOS
     * ============================================================
     */

    private static var modifiedAngle:Map<Int, Float> =
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
        note:Dynamic
    ):Float
    {
        if (note == null)
            return 0;


        try
        {
            return note.angle;
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
        note:Dynamic,
        value:Float
    ):Void
    {
        if (note == null)
            return;


        try
        {
            note.angle =
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
        note:Dynamic
    ):Void
    {
        if (note == null)
            return;


        if (!originalAngle.exists(index))
        {
            originalAngle.set(
                index,
                getAngle(note)
            );
        }
    }


    /*
     * ============================================================
     * SAVE ALL ORIGINAL ANGLES
     * ============================================================
 */

    public static function saveAllOriginalAngles(
        notes:Array<Dynamic>
    ):Void
    {
        if (notes == null)
            return;


        for (i in 0...notes.length)
        {
            saveOriginalAngle(
                i,
                notes[i]
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

    public static function setNoteAngle(
        index:Int,
        note:Dynamic,
        angle:Float
    ):Void
    {
        if (note == null)
            return;


        saveOriginalAngle(
            index,
            note
        );


        setAngle(
            note,
            angle
        );


        modifiedAngle.set(
            index,
            angle
        );
    }


    /*
     * ============================================================
     * SET ANGLE DIRECT
     * ============================================================
 *
 * Versión sin índice.
 *
 * ============================================================
 */

    public static function setAngleDirect(
        note:Dynamic,
        angle:Float
    ):Void
    {
        if (note == null)
            return;


        setAngle(
            note,
            angle
        );
    }


    /*
     * ============================================================
     * ADD ANGLE
     * ============================================================
 *
 * Añade una cantidad al ángulo actual.
 *
 * ============================================================
 */

    public static function addAngle(
        index:Int,
        note:Dynamic,
        amount:Float
    ):Void
    {
        if (note == null)
            return;


        saveOriginalAngle(
            index,
            note
        );


        var angle:Float =
            getAngle(note);


        angle +=
            amount;


        setAngle(
            note,
            angle
        );


        modifiedAngle.set(
            index,
            angle
        );
    }


    /*
     * ============================================================
     * SET FROM ORIGINAL
     * ============================================================
 *
 * Establece:
 *
 *     ángulo = original + offset
 *
 * Esto evita acumulación.
 *
 * ============================================================
 */

    public static function setFromOriginal(
        index:Int,
        note:Dynamic,
        offset:Float
    ):Void
    {
        if (note == null)
            return;


        saveOriginalAngle(
            index,
            note
        );


        var angle:Float =
            originalAngle.get(index);


        angle +=
            offset;


        setAngle(
            note,
            angle
        );


        modifiedAngle.set(
            index,
            angle
        );
    }


    /*
     * ============================================================
     * SET ALL ANGLES
     * ============================================================
 */

    public static function setAllAngle(
        notes:Array<Dynamic>,
        angle:Float
    ):Void
    {
        if (notes == null)
            return;


        saveAllOriginalAngles(
            notes
        );


        for (i in 0...notes.length)
        {
            setNoteAngle(
                i,
                notes[i],
                angle
            );
        }
    }


    /*
     * ============================================================
     * ADD ALL ANGLES
     * ============================================================
 */

    public static function addAllAngle(
        notes:Array<Dynamic>,
        amount:Float
    ):Void
    {
        if (notes == null)
            return;


        saveAllOriginalAngles(
            notes
        );


        for (i in 0...notes.length)
        {
            addAngle(
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
        offset:Float
    ):Void
    {
        if (notes == null)
            return;


        saveAllOriginalAngles(
            notes
        );


        for (i in 0...notes.length)
        {
            setFromOriginal(
                i,
                notes[i],
                offset
            );
        }
    }


    /*
     * ============================================================
     * ROTATE 90
     * ============================================================
 *
 * Gira 90 grados.
 *
 * ============================================================
 */

    public static function rotate90(
        index:Int,
        note:Dynamic,
        clockwise:Bool = true
    ):Void
    {
        if (note == null)
            return;


        var amount:Float =
            clockwise
            ? 90
            : -90;


        addAngle(
            index,
            note,
            amount
        );
    }


    /*
     * ============================================================
     * ROTATE 180
     * ============================================================
 */

    public static function rotate180(
        index:Int,
        note:Dynamic
    ):Void
    {
        if (note == null)
            return;


        addAngle(
            index,
            note,
            180
        );
    }


    /*
     * ============================================================
     * ROTATE 270
     * ============================================================
 */

    public static function rotate270(
        index:Int,
        note:Dynamic,
        clockwise:Bool = true
    ):Void
    {
        if (note == null)
            return;


        var amount:Float =
            clockwise
            ? 270
            : -270;


        addAngle(
            index,
            note,
            amount
        );
    }


    /*
     * ============================================================
     * NORMALIZE ANGLE
     * ============================================================
 *
 * Convierte el ángulo al rango:
 *
 *     0 <= angle < 360
 *
 * ============================================================
 */

    public static function normalize(
        index:Int,
        note:Dynamic
    ):Void
    {
        if (note == null)
            return;


        var angle:Float =
            getAngle(note);


        angle =
            normalizeValue(
                angle
            );


        setAngle(
            note,
            angle
        );


        modifiedAngle.set(
            index,
            angle
        );
    }


    /*
     * ============================================================
     * NORMALIZE VALUE
     * ============================================================
 */

    public static function normalizeValue(
        angle:Float
    ):Float
    {
        while (angle < 0)
        {
            angle +=
                360;
        }


        while (angle >= 360)
        {
            angle -=
                360;
        }


        return angle;
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


        if (!originalAngle.exists(index))
            return;


        setAngle(
            note,
            originalAngle.get(index)
        );


        modifiedAngle.remove(
            index
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
     * GET CURRENT ANGLE
     * ============================================================
 */

    public static function getCurrentAngle(
        note:Dynamic
    ):Float
    {
        return getAngle(
            note
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
     * GET MODIFIED ANGLE
     * ============================================================
 */

    public static function getModifiedAngle(
        index:Int
    ):Float
    {
        if (!modifiedAngle.exists(index))
            return getOriginalAngle(index);


        return modifiedAngle.get(
            index
        );
    }


    /*
     * ============================================================
     * IS MODIFIED
     * ============================================================
 */

    public static function isModified(
        index:Int
    ):Bool
    {
        return modifiedAngle.exists(
            index
        );
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
     * CLEAR
     * ============================================================
 */

    public static function clear():Void
    {
        originalAngle =
            new Map<Int, Float>();


        modifiedAngle =
            new Map<Int, Float>();
    }


    /*
     * ============================================================
     * GET ANGLE INFO
     * ============================================================
 */

    public static function getAngleInfo(
        index:Int,
        note:Dynamic
    ):Dynamic
    {
        if (note == null)
            return null;


        return {
            current:
                getCurrentAngle(note),

            original:
                getOriginalAngle(index),

            modified:
                isModified(index)
        };
    }
}