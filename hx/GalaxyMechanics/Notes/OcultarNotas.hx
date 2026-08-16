/*
 * ============================================================
 * OcultarNotas.hx
 * ============================================================
 *
 * FNF In The Galaxy -> Psych Engine 1.0.4
 *
 * Sistema individual para ocultar y mostrar notas.
 *
 * ============================================================
 *
 * RESPONSABILIDAD:
 *
 *     - Ocultar una nota
 *     - Mostrar una nota
 *     - Alternar visibilidad
 *     - Ocultar grupos de notas
 *     - Mostrar grupos de notas
 *     - Guardar el estado original
 *     - Restaurar el estado original
 *
 * ============================================================
 *
 * NO SE ENCARGA DE:
 *
 *     - Alpha
 *     - Posición
 *     - Velocidad
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
 * Este archivo utiliza:
 *
 *     note.visible
 *
 * No utiliza:
 *
 *     note.alpha = 0
 *
 * Para modificar alpha debe utilizarse:
 *
 *     CambiarAlphaNotas.hx
 *
 * De esta manera una nota puede estar:
 *
 *     visible = true
 *     alpha = 0.5
 *
 * o:
 *
 *     visible = false
 *
 * de forma completamente independiente.
 *
 * ============================================================
 */

import flixel.FlxSprite;


/**
 * OcultarNotas
 *
 * Controlador independiente de visibilidad.
 */
class OcultarNotas
{
    /*
     * ============================================================
     * ESTADO ORIGINAL
     * ============================================================
     *
     * Se almacena por índice.
     *
     * ============================================================
     */

    private static var originalVisible:Map<Int, Bool> =
        new Map<Int, Bool>();


    /*
     * ============================================================
     * ESTADO MODIFICADO
     * ============================================================
     */

    private static var modifiedVisible:Map<Int, Bool> =
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
     * GET VISIBLE
     * ============================================================
     */

    private static function getVisible(
        note:Dynamic
    ):Bool
    {
        if (note == null)
            return false;


        try
        {
            return note.visible;
        }
        catch (e:Dynamic)
        {
            return false;
        }
    }


    /*
     * ============================================================
     * SET VISIBLE
     * ============================================================
     */

    private static function setVisible(
        note:Dynamic,
        value:Bool
    ):Void
    {
        if (note == null)
            return;


        try
        {
            note.visible =
                value;
        }
        catch (e:Dynamic)
        {
        }
    }


    /*
     * ============================================================
     * SAVE ORIGINAL VISIBILITY
     * ============================================================
     */

    public static function saveOriginalVisibility(
        index:Int,
        note:Dynamic
    ):Void
    {
        if (note == null)
            return;


        if (!originalVisible.exists(index))
        {
            originalVisible.set(
                index,
                getVisible(note)
            );
        }
    }


    /*
     * ============================================================
     * SAVE ALL ORIGINAL VISIBILITY
     * ============================================================
 */

    public static function saveAllOriginalVisibility(
        notes:Array<Dynamic>
    ):Void
    {
        if (notes == null)
            return;


        for (i in 0...notes.length)
        {
            saveOriginalVisibility(
                i,
                notes[i]
            );
        }
    }


    /*
     * ============================================================
     * HIDE
     * ============================================================
 *
 * Oculta una nota.
 *
 * ============================================================
 */

    public static function hide(
        index:Int,
        note:Dynamic
    ):Void
    {
        if (note == null)
            return;


        saveOriginalVisibility(
            index,
            note
        );


        setVisible(
            note,
            false
        );


        modifiedVisible.set(
            index,
            false
        );
    }


    /*
     * ============================================================
     * SHOW
     * ============================================================
 *
 * Muestra una nota.
 *
 * ============================================================
 */

    public static function show(
        index:Int,
        note:Dynamic
    ):Void
    {
        if (note == null)
            return;


        saveOriginalVisibility(
            index,
            note
        );


        setVisible(
            note,
            true
        );


        modifiedVisible.set(
            index,
            true
        );
    }


    /*
     * ============================================================
     * SET VISIBILITY
     * ============================================================
 */

    public static function setVisibility(
        index:Int,
        note:Dynamic,
        visible:Bool
    ):Void
    {
        if (visible)
        {
            show(
                index,
                note
            );
        }
        else
        {
            hide(
                index,
                note
            );
        }
    }


    /*
     * ============================================================
     * TOGGLE
     * ============================================================
 *
 * Cambia:
 *
 *     visible -> invisible
 *     invisible -> visible
 *
 * ============================================================
 */

    public static function toggle(
        index:Int,
        note:Dynamic
    ):Void
    {
        if (note == null)
            return;


        saveOriginalVisibility(
            index,
            note
        );


        var current:Bool =
            getVisible(note);


        setVisible(
            note,
            !current
        );


        modifiedVisible.set(
            index,
            !current
        );
    }


    /*
     * ============================================================
     * HIDE ALL
     * ============================================================
 */

    public static function hideAll(
        notes:Array<Dynamic>
    ):Void
    {
        if (notes == null)
            return;


        saveAllOriginalVisibility(
            notes
        );


        for (i in 0...notes.length)
        {
            hide(
                i,
                notes[i]
            );
        }
    }


    /*
     * ============================================================
     * SHOW ALL
     * ============================================================
 */

    public static function showAll(
        notes:Array<Dynamic>
    ):Void
    {
        if (notes == null)
            return;


        saveAllOriginalVisibility(
            notes
        );


        for (i in 0...notes.length)
        {
            show(
                i,
                notes[i]
            );
        }
    }


    /*
     * ============================================================
     * SET ALL VISIBILITY
     * ============================================================
 */

    public static function setAllVisibility(
        notes:Array<Dynamic>,
        visible:Bool
    ):Void
    {
        if (notes == null)
            return;


        saveAllOriginalVisibility(
            notes
        );


        for (i in 0...notes.length)
        {
            setVisibility(
                i,
                notes[i],
                visible
            );
        }
    }


    /*
     * ============================================================
     * HIDE RANGE
     * ============================================================
 *
 * Oculta un rango de notas.
 *
 * Ejemplo:
 *
 *     hideRange(notes, 0, 3)
 *
 * oculta las notas 0, 1, 2 y 3.
 *
 * ============================================================
 */

    public static function hideRange(
        notes:Array<Dynamic>,
        start:Int,
        end:Int
    ):Void
    {
        if (notes == null)
            return;


        if (start < 0)
            start = 0;


        if (end >= notes.length)
            end = notes.length - 1;


        if (start > end)
            return;


        for (i in start...end + 1)
        {
            hide(
                i,
                notes[i]
            );
        }
    }


    /*
     * ============================================================
     * SHOW RANGE
     * ============================================================
 */

    public static function showRange(
        notes:Array<Dynamic>,
        start:Int,
        end:Int
    ):Void
    {
        if (notes == null)
            return;


        if (start < 0)
            start = 0;


        if (end >= notes.length)
            end = notes.length - 1;


        if (start > end)
            return;


        for (i in start...end + 1)
        {
            show(
                i,
                notes[i]
            );
        }
    }


    /*
     * ============================================================
     * TOGGLE RANGE
     * ============================================================
 */

    public static function toggleRange(
        notes:Array<Dynamic>,
        start:Int,
        end:Int
    ):Void
    {
        if (notes == null)
            return;


        if (start < 0)
            start = 0;


        if (end >= notes.length)
            end = notes.length - 1;


        if (start > end)
            return;


        for (i in start...end + 1)
        {
            toggle(
                i,
                notes[i]
            );
        }
    }


    /*
     * ============================================================
     * RESTORE
     * ============================================================
 *
 * Restaura el estado visible/invisible que tenía originalmente.
 *
 * ============================================================
 */

    public static function restore(
        index:Int,
        note:Dynamic
    ):Void
    {
        if (note == null)
            return;


        if (!originalVisible.exists(index))
            return;


        setVisible(
            note,
            originalVisible.get(index)
        );


        modifiedVisible.remove(
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
     * GET CURRENT VISIBILITY
     * ============================================================
 */

    public static function isVisible(
        note:Dynamic
    ):Bool
    {
        return getVisible(
            note
        );
    }


    /*
     * ============================================================
     * IS HIDDEN
     * ============================================================
 */

    public static function isHidden(
        note:Dynamic
    ):Bool
    {
        return !getVisible(
            note
        );
    }


    /*
     * ============================================================
     * GET ORIGINAL VISIBILITY
     * ============================================================
 */

    public static function getOriginalVisibility(
        index:Int
    ):Bool
    {
        if (!originalVisible.exists(index))
            return true;


        return originalVisible.get(
            index
        );
    }


    /*
     * ============================================================
     * GET MODIFIED VISIBILITY
     * ============================================================
 */

    public static function getModifiedVisibility(
        index:Int
    ):Bool
    {
        if (!modifiedVisible.exists(index))
            return getOriginalVisibility(index);


        return modifiedVisible.get(
            index
        );
    }


    /*
     * ============================================================
     * HAS ORIGINAL VISIBILITY
     * ============================================================
 */

    public static function hasOriginalVisibility(
        index:Int
    ):Bool
    {
        return originalVisible.exists(
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
        return modifiedVisible.exists(
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
        originalVisible =
            new Map<Int, Bool>();


        modifiedVisible =
            new Map<Int, Bool>();
    }
}