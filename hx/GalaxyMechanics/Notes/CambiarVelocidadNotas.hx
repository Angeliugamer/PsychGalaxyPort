/*
 * ============================================================
 * CambiarVelocidadNotas.hx
 * ============================================================
 *
 * FNF In The Galaxy -> Psych Engine 1.0.4
 *
 * Sistema individual para modificar la velocidad de las notas.
 *
 * ============================================================
 *
 * RESPONSABILIDAD:
 *
 *     - Establecer velocidad de una nota
 *     - Aumentar/disminuir velocidad
 *     - Multiplicar velocidad
 *     - Restaurar velocidad original
 *     - Guardar velocidades originales
 *     - Modificar múltiples notas
 *
 * ============================================================
 *
 * NO SE ENCARGA DE:
 *
 *     - Posición
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
 * En Psych Engine la velocidad final de una nota puede estar
 * relacionada con la velocidad del chart y con el sistema de
 * scroll. Por eso este archivo modifica exclusivamente la
 * propiedad speed de la Note.
 *
 * ============================================================
 */

import flixel.FlxSprite;


/**
 * CambiarVelocidadNotas
 *
 * Controlador independiente de velocidad de notas.
 */
class CambiarVelocidadNotas
{
    /*
     * ============================================================
     * VELOCIDADES ORIGINALES
     * ============================================================
     *
     * Se guardan por índice.
     *
     * ============================================================
     */

    private static var originalSpeed:Map<Int, Float> =
        new Map<Int, Float>();


    /*
     * ============================================================
     * VELOCIDADES MODIFICADAS
     * ============================================================
     *
     * Permite saber si una nota ha sido modificada por este
     * sistema.
     *
     * ============================================================
     */

    private static var modifiedSpeed:Map<Int, Float> =
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
     * GET SPEED
     * ============================================================
     */

    private static function getSpeed(
        note:Dynamic
    ):Float
    {
        if (note == null)
            return 0;


        try
        {
            return note.speed;
        }
        catch (e:Dynamic)
        {
            return 0;
        }
    }


    /*
     * ============================================================
     * SET SPEED
     * ============================================================
 */

    private static function setSpeed(
        note:Dynamic,
        value:Float
    ):Void
    {
        if (note == null)
            return;


        try
        {
            note.speed =
                value;
        }
        catch (e:Dynamic)
        {
        }
    }


    /*
     * ============================================================
     * SAVE ORIGINAL SPEED
     * ============================================================
     *
     * Guarda la velocidad actual de una nota.
     *
     * Solo se guarda la primera vez para evitar que una
     * velocidad modificada pase a convertirse en la nueva
     * velocidad original.
     *
     * ============================================================
 */

    public static function saveOriginalSpeed(
        index:Int,
        note:Dynamic
    ):Void
    {
        if (note == null)
            return;


        if (!originalSpeed.exists(index))
        {
            originalSpeed.set(
                index,
                getSpeed(note)
            );
        }
    }


    /*
     * ============================================================
     * SAVE ALL ORIGINAL SPEEDS
     * ============================================================
 */

    public static function saveAllOriginalSpeeds(
        notes:Array<Dynamic>
    ):Void
    {
        if (notes == null)
            return;


        for (i in 0...notes.length)
        {
            saveOriginalSpeed(
                i,
                notes[i]
            );
        }
    }


    /*
     * ============================================================
     * SET SPEED
     * ============================================================
     *
     * Establece una velocidad absoluta.
     *
     * Ejemplo:
     *
     *     setSpeed(note, 2.0);
     *
     * ============================================================
 */

    public static function setNoteSpeed(
        index:Int,
        note:Dynamic,
        speed:Float
    ):Void
    {
        if (note == null)
            return;


        saveOriginalSpeed(
            index,
            note
        );


        setSpeed(
            note,
            speed
        );


        modifiedSpeed.set(
            index,
            speed
        );
    }


    /*
     * ============================================================
     * SET SPEED WITHOUT INDEX
     * ============================================================
     *
     * Versión útil cuando solo necesitamos modificar la nota
     * directamente.
     *
     * ============================================================
 */

    public static function setSpeedDirect(
        note:Dynamic,
        speed:Float
    ):Void
    {
        if (note == null)
            return;


        setSpeed(
            note,
            speed
        );
    }


    /*
     * ============================================================
     * ADD SPEED
     * ============================================================
     *
     * Aumenta/disminuye la velocidad actual.
     *
     * ============================================================
 */

    public static function addSpeed(
        index:Int,
        note:Dynamic,
        amount:Float
    ):Void
    {
        if (note == null)
            return;


        saveOriginalSpeed(
            index,
            note
        );


        var speed:Float =
            getSpeed(note);


        speed +=
            amount;


        setSpeed(
            note,
            speed
        );


        modifiedSpeed.set(
            index,
            speed
        );
    }


    /*
     * ============================================================
     * MULTIPLY SPEED
     * ============================================================
     *
     * Multiplica la velocidad actual.
     *
     * Ejemplo:
     *
     *     1.0 * 2.0 = 2.0
     *     2.0 * 0.5 = 1.0
     *
     * ============================================================
 */

    public static function multiplySpeed(
        index:Int,
        note:Dynamic,
        multiplier:Float
    ):Void
    {
        if (note == null)
            return;


        saveOriginalSpeed(
            index,
            note
        );


        var speed:Float =
            getSpeed(note);


        speed *=
            multiplier;


        setSpeed(
            note,
            speed
        );


        modifiedSpeed.set(
            index,
            speed
        );
    }


    /*
     * ============================================================
     * SET SPEED FROM ORIGINAL
     * ============================================================
     *
     * Establece:
     *
     *     velocidadOriginal * multiplicador
     *
     * Esto evita acumulación.
     *
     * ============================================================
 */

    public static function setFromOriginal(
        index:Int,
        note:Dynamic,
        multiplier:Float
    ):Void
    {
        if (note == null)
            return;


        saveOriginalSpeed(
            index,
            note
        );


        var speed:Float =
            originalSpeed.get(index);


        speed *=
            multiplier;


        setSpeed(
            note,
            speed
        );


        modifiedSpeed.set(
            index,
            speed
        );
    }


    /*
     * ============================================================
     * ADD FROM ORIGINAL
     * ============================================================
     *
     * velocidad = original + amount
     *
     * ============================================================
 */

    public static function addFromOriginal(
        index:Int,
        note:Dynamic,
        amount:Float
    ):Void
    {
        if (note == null)
            return;


        saveOriginalSpeed(
            index,
            note
        );


        var speed:Float =
            originalSpeed.get(index);


        speed +=
            amount;


        setSpeed(
            note,
            speed
        );


        modifiedSpeed.set(
            index,
            speed
        );
    }


    /*
     * ============================================================
     * SET ALL SPEED
     * ============================================================
 */

    public static function setAllSpeed(
        notes:Array<Dynamic>,
        speed:Float
    ):Void
    {
        if (notes == null)
            return;


        saveAllOriginalSpeeds(
            notes
        );


        for (i in 0...notes.length)
        {
            setNoteSpeed(
                i,
                notes[i],
                speed
            );
        }
    }


    /*
     * ============================================================
     * MULTIPLY ALL SPEED
     * ============================================================
 */

    public static function multiplyAllSpeed(
        notes:Array<Dynamic>,
        multiplier:Float
    ):Void
    {
        if (notes == null)
            return;


        saveAllOriginalSpeeds(
            notes
        );


        for (i in 0...notes.length)
        {
            setFromOriginal(
                i,
                notes[i],
                multiplier
            );
        }
    }


    /*
     * ============================================================
     * ADD ALL SPEED
     * ============================================================
 */

    public static function addAllSpeed(
        notes:Array<Dynamic>,
        amount:Float
    ):Void
    {
        if (notes == null)
            return;


        saveAllOriginalSpeeds(
            notes
        );


        for (i in 0...notes.length)
        {
            addFromOriginal(
                i,
                notes[i],
                amount
            );
        }
    }


    /*
     * ============================================================
     * RESTORE SPEED
     * ============================================================
 */

    public static function restore(
        index:Int,
        note:Dynamic
    ):Void
    {
        if (note == null)
            return;


        if (!originalSpeed.exists(index))
            return;


        setSpeed(
            note,
            originalSpeed.get(index)
        );


        modifiedSpeed.remove(
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
     * GET CURRENT SPEED
     * ============================================================
 */

    public static function getCurrentSpeed(
        note:Dynamic
    ):Float
    {
        return getSpeed(
            note
        );
    }


    /*
     * ============================================================
     * GET ORIGINAL SPEED
     * ============================================================
 */

    public static function getOriginalSpeed(
        index:Int
    ):Float
    {
        if (!originalSpeed.exists(index))
            return 0;


        return originalSpeed.get(
            index
        );
    }


    /*
     * ============================================================
     * GET MODIFIED SPEED
     * ============================================================
 */

    public static function getModifiedSpeed(
        index:Int
    ):Float
    {
        if (!modifiedSpeed.exists(index))
            return getOriginalSpeed(index);


        return modifiedSpeed.get(
            index
        );
    }


    /*
     * ============================================================
     * HAS ORIGINAL SPEED
     * ============================================================
 */

    public static function hasOriginalSpeed(
        index:Int
    ):Bool
    {
        return originalSpeed.exists(
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
        return modifiedSpeed.exists(
            index
        );
    }


    /*
     * ============================================================
     * CLEAR ORIGINAL SPEEDS
     * ============================================================
 */

    public static function clearOriginalSpeeds():Void
    {
        originalSpeed =
            new Map<Int, Float>();


        modifiedSpeed =
            new Map<Int, Float>();
    }


    /*
     * ============================================================
     * CLEAR MODIFICATIONS
     * ============================================================
 *
 * Elimina el registro interno de modificaciones sin cambiar
 * la velocidad actual de las notas.
 *
 * ============================================================
 */

    public static function clearModifications():Void
    {
        modifiedSpeed =
            new Map<Int, Float>();
    }


    /*
     * ============================================================
     * GET SPEED INFO
     * ============================================================
 */

    public static function getSpeedInfo(
        index:Int,
        note:Dynamic
    ):Dynamic
    {
        if (note == null)
            return null;


        return {
            current:
                getCurrentSpeed(note),

            original:
                getOriginalSpeed(index),

            modified:
                isModified(index)
        };
    }
}