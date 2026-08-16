/*
 * ============================================================
 * CambiarAlphaNotas.hx
 * ============================================================
 *
 * FNF In The Galaxy -> Psych Engine 1.0.4
 *
 * Sistema independiente para modificar el alpha de las notas.
 *
 * ============================================================
 *
 * RESPONSABILIDAD:
 *
 *     - Establecer alpha
 *     - Añadir alpha
 *     - Multiplicar alpha
 *     - Establecer alpha desde el valor original
 *     - Modificar alpha de todas las notas
 *     - Modificar alpha por rango
 *     - Restaurar alpha original
 *
 * ============================================================
 *
 * NO SE ENCARGA DE:
 *
 *     - visible
 *     - posición
 *     - velocidad
 *     - rotación
 *     - sustains
 *     - strums
 *     - 3D
 *     - shaders
 *     - Window
 *
 * ============================================================
 *
 * IMPORTANTE:
 *
 * Alpha y visible son dos sistemas independientes.
 *
 * Por ejemplo:
 *
 *     visible = true
 *     alpha   = 0
 *
 * hace que la nota exista y siga siendo procesada por Flixel,
 * pero sea completamente transparente.
 *
 * En cambio:
 *
 *     visible = false
 *
 * es responsabilidad de OcultarNotas.hx.
 *
 * ============================================================
 */

import flixel.FlxSprite;


/**
 * CambiarAlphaNotas
 *
 * Controlador independiente del alpha de las notas.
 */
class CambiarAlphaNotas
{
    /*
     * ============================================================
     * ALPHA ORIGINAL
     * ============================================================
     */

    private static var originalAlpha:Map<Int, Float> =
        new Map<Int, Float>();


    /*
     * ============================================================
     * ALPHA MODIFICADO
     * ============================================================
     */

    private static var modifiedAlpha:Map<Int, Float> =
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
     * GET ALPHA
     * ============================================================
 */

    private static function getAlpha(
        note:Dynamic
    ):Float
    {
        if (note == null)
            return 0;


        try
        {
            return note.alpha;
        }
        catch (e:Dynamic)
        {
            return 0;
        }
    }


    /*
     * ============================================================
     * SET ALPHA
     * ============================================================
 */

    private static function setAlpha(
        note:Dynamic,
        value:Float
    ):Void
    {
        if (note == null)
            return;


        try
        {
            note.alpha =
                value;
        }
        catch (e:Dynamic)
        {
        }
    }


    /*
     * ============================================================
     * CLAMP
     * ============================================================
 *
 * Mantiene el alpha entre:
 *
 *     0.0
 *     1.0
 *
 * ============================================================
 */

    private static function clampAlpha(
        value:Float
    ):Float
    {
        if (value < 0)
            return 0;


        if (value > 1)
            return 1;


        return value;
    }


    /*
     * ============================================================
     * SAVE ORIGINAL ALPHA
     * ============================================================
 */

    public static function saveOriginalAlpha(
        index:Int,
        note:Dynamic
    ):Void
    {
        if (note == null)
            return;


        if (!originalAlpha.exists(index))
        {
            originalAlpha.set(
                index,
                getAlpha(note)
            );
        }
    }


    /*
     * ============================================================
     * SAVE ALL ORIGINAL ALPHA
     * ============================================================
 */

    public static function saveAllOriginalAlpha(
        notes:Array<Dynamic>
    ):Void
    {
        if (notes == null)
            return;


        for (i in 0...notes.length)
        {
            saveOriginalAlpha(
                i,
                notes[i]
            );
        }
    }


    /*
     * ============================================================
     * SET ALPHA
     * ============================================================
 *
 * Establece un alpha absoluto.
 *
 * ============================================================
 */

    public static function setAlphaValue(
        index:Int,
        note:Dynamic,
        alpha:Float
    ):Void
    {
        if (note == null)
            return;


        saveOriginalAlpha(
            index,
            note
        );


        alpha =
            clampAlpha(alpha);


        setAlpha(
            note,
            alpha
        );


        modifiedAlpha.set(
            index,
            alpha
        );
    }


    /*
     * ============================================================
     * SET ALPHA DIRECT
     * ============================================================
 *
 * Versión que no requiere índice.
 *
 * ============================================================
 */

    public static function setAlphaDirect(
        note:Dynamic,
        alpha:Float
    ):Void
    {
        if (note == null)
            return;


        alpha =
            clampAlpha(alpha);


        setAlpha(
            note,
            alpha
        );
    }


    /*
     * ============================================================
     * ADD ALPHA
     * ============================================================
 *
 * Añade una cantidad al alpha actual.
 *
 * ============================================================
 */

    public static function addAlpha(
        index:Int,
        note:Dynamic,
        amount:Float
    ):Void
    {
        if (note == null)
            return;


        saveOriginalAlpha(
            index,
            note
        );


        var alpha:Float =
            getAlpha(note);


        alpha +=
            amount;


        alpha =
            clampAlpha(alpha);


        setAlpha(
            note,
            alpha
        );


        modifiedAlpha.set(
            index,
            alpha
        );
    }


    /*
     * ============================================================
     * MULTIPLY ALPHA
     * ============================================================
 *
 * Multiplica el alpha actual.
 *
 * Ejemplo:
 *
 *     alpha = 1
 *     multiplier = 0.5
 *
 * Resultado:
 *
 *     alpha = 0.5
 *
 * ============================================================
 */

    public static function multiplyAlpha(
        index:Int,
        note:Dynamic,
        multiplier:Float
    ):Void
    {
        if (note == null)
            return;


        saveOriginalAlpha(
            index,
            note
        );


        var alpha:Float =
            getAlpha(note);


        alpha *=
            multiplier;


        alpha =
            clampAlpha(alpha);


        setAlpha(
            note,
            alpha
        );


        modifiedAlpha.set(
            index,
            alpha
        );
    }


    /*
     * ============================================================
     * SET FROM ORIGINAL
     * ============================================================
 *
 * Establece:
 *
 *     alpha = original + offset
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


        saveOriginalAlpha(
            index,
            note
        );


        var alpha:Float =
            originalAlpha.get(index);


        alpha +=
            offset;


        alpha =
            clampAlpha(alpha);


        setAlpha(
            note,
            alpha
        );


        modifiedAlpha.set(
            index,
            alpha
        );
    }


    /*
     * ============================================================
     * SET FROM ORIGINAL MULTIPLIED
     * ============================================================
 *
 * Establece:
 *
 *     alpha = original * multiplier
 *
 * ============================================================
 */

    public static function setFromOriginalMultiplier(
        index:Int,
        note:Dynamic,
        multiplier:Float
    ):Void
    {
        if (note == null)
            return;


        saveOriginalAlpha(
            index,
            note
        );


        var alpha:Float =
            originalAlpha.get(index);


        alpha *=
            multiplier;


        alpha =
            clampAlpha(alpha);


        setAlpha(
            note,
            alpha
        );


        modifiedAlpha.set(
            index,
            alpha
        );
    }


    /*
     * ============================================================
     * SET ALL ALPHA
     * ============================================================
 */

    public static function setAllAlpha(
        notes:Array<Dynamic>,
        alpha:Float
    ):Void
    {
        if (notes == null)
            return;


        saveAllOriginalAlpha(
            notes
        );


        alpha =
            clampAlpha(alpha);


        for (i in 0...notes.length)
        {
            setAlphaValue(
                i,
                notes[i],
                alpha
            );
        }
    }


    /*
     * ============================================================
     * ADD ALL ALPHA
     * ============================================================
 */

    public static function addAllAlpha(
        notes:Array<Dynamic>,
        amount:Float
    ):Void
    {
        if (notes == null)
            return;


        saveAllOriginalAlpha(
            notes
        );


        for (i in 0...notes.length)
        {
            addAlpha(
                i,
                notes[i],
                amount
            );
        }
    }


    /*
     * ============================================================
     * MULTIPLY ALL ALPHA
     * ============================================================
 */

    public static function multiplyAllAlpha(
        notes:Array<Dynamic>,
        multiplier:Float
    ):Void
    {
        if (notes == null)
            return;


        saveAllOriginalAlpha(
            notes
        );


        for (i in 0...notes.length)
        {
            multiplyAlpha(
                i,
                notes[i],
                multiplier
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


        saveAllOriginalAlpha(
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
     * SET ALL FROM ORIGINAL MULTIPLIER
     * ============================================================
 */

    public static function setAllFromOriginalMultiplier(
        notes:Array<Dynamic>,
        multiplier:Float
    ):Void
    {
        if (notes == null)
            return;


        saveAllOriginalAlpha(
            notes
        );


        for (i in 0...notes.length)
        {
            setFromOriginalMultiplier(
                i,
                notes[i],
                multiplier
            );
        }
    }


    /*
     * ============================================================
     * SET INVISIBLE
     * ============================================================
 *
 * Hace:
 *
 *     alpha = 0
 *
 * IMPORTANTE:
 *
 * Esto NO modifica visible.
 *
 * ============================================================
 */

    public static function setInvisible(
        index:Int,
        note:Dynamic
    ):Void
    {
        setAlphaValue(
            index,
            note,
            0
        );
    }


    /*
     * ============================================================
     * SET FULL ALPHA
     * ============================================================
 *
 * Hace:
 *
 *     alpha = 1
 *
 * ============================================================
 */

    public static function setFullAlpha(
        index:Int,
        note:Dynamic
    ):Void
    {
        setAlphaValue(
            index,
            note,
            1
        );
    }


    /*
     * ============================================================
     * FADE TO
     * ============================================================
 *
 * Esta función NO realiza una transición por sí sola.
 *
 * Simplemente establece el valor final.
 *
 * Las transiciones temporales pueden ser realizadas desde Lua
 * utilizando elapsed, tween o una interpolación.
 *
 * ============================================================
 */

    public static function fadeTo(
        index:Int,
        note:Dynamic,
        alpha:Float
    ):Void
    {
        setAlphaValue(
            index,
            note,
            alpha
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


        if (!originalAlpha.exists(index))
            return;


        setAlpha(
            note,
            originalAlpha.get(index)
        );


        modifiedAlpha.remove(
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
     * GET CURRENT ALPHA
     * ============================================================
 */

    public static function getCurrentAlpha(
        note:Dynamic
    ):Float
    {
        return getAlpha(
            note
        );
    }


    /*
     * ============================================================
     * GET ORIGINAL ALPHA
     * ============================================================
 */

    public static function getOriginalAlpha(
        index:Int
    ):Float
    {
        if (!originalAlpha.exists(index))
            return 1;


        return originalAlpha.get(
            index
        );
    }


    /*
     * ============================================================
     * GET MODIFIED ALPHA
     * ============================================================
 */

    public static function getModifiedAlpha(
        index:Int
    ):Float
    {
        if (!modifiedAlpha.exists(index))
        {
            return getOriginalAlpha(
                index
            );
        }


        return modifiedAlpha.get(
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
        note:Dynamic
    ):Float
    {
        if (note == null)
            return 0;


        return
            getAlpha(note) -
            getOriginalAlpha(index);
    }


    /*
     * ============================================================
     * HAS ORIGINAL ALPHA
     * ============================================================
 */

    public static function hasOriginalAlpha(
        index:Int
    ):Bool
    {
        return originalAlpha.exists(
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
        return modifiedAlpha.exists(
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
        originalAlpha =
            new Map<Int, Float>();


        modifiedAlpha =
            new Map<Int, Float>();
    }
}