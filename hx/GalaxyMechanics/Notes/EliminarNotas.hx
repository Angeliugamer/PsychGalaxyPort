/*
 * ============================================================
 * EliminarNotas.hx
 * ============================================================
 *
 * FNF In The Galaxy -> Psych Engine 1.0.4
 *
 * Sistema individual para eliminar/desactivar notas.
 *
 * ============================================================
 *
 * RESPONSABILIDAD:
 *
 *     - Eliminar una nota visualmente
 *     - Desactivar una nota
 *     - Eliminar grupos de notas
 *     - Eliminar rangos de notas
 *     - Restaurar notas eliminadas temporalmente
 *     - Consultar estado de eliminación
 *
 * ============================================================
 *
 * NO SE ENCARGA DE:
 *
 *     - Posición
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
 * No se utiliza game.notes.remove() como método principal.
 *
 * Eliminar físicamente un objeto del FlxTypedGroup durante
 * el gameplay puede alterar la estructura del grupo y producir
 * problemas con la indexación o con otros sistemas de Psych.
 *
 * En su lugar se utiliza:
 *
 *     kill()
 *     exists = false
 *     active = false
 *     visible = false
 *
 * De esta forma la nota deja de participar visualmente sin
 * modificar físicamente la estructura de game.notes.
 *
 * ============================================================
 */

import flixel.FlxSprite;


/**
 * EliminarNotas
 *
 * Controlador independiente para eliminar/desactivar notas.
 */
class EliminarNotas
{
    /*
     * ============================================================
     * ESTADO ORIGINAL
     * ============================================================
     *
     * Se guarda para poder restaurar una nota posteriormente.
     *
     * ============================================================
     */

    private static var originalExists:Map<Int, Bool> =
        new Map<Int, Bool>();


    private static var originalActive:Map<Int, Bool> =
        new Map<Int, Bool>();


    private static var originalVisible:Map<Int, Bool> =
        new Map<Int, Bool>();


    /*
     * ============================================================
     * ESTADO DE ELIMINACIÓN
     * ============================================================
     */

    private static var deleted:Map<Int, Bool> =
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
     * GET EXISTS
     * ============================================================
     */

    private static function getExists(
        note:Dynamic
    ):Bool
    {
        if (note == null)
            return false;


        try
        {
            return note.exists;
        }
        catch (e:Dynamic)
        {
            return false;
        }
    }


    /*
     * ============================================================
     * GET ACTIVE
     * ============================================================
     */

    private static function getActive(
        note:Dynamic
    ):Bool
    {
        if (note == null)
            return false;


        try
        {
            return note.active;
        }
        catch (e:Dynamic)
        {
            return false;
        }
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
     * SET EXISTS
     * ============================================================
 */

    private static function setExists(
        note:Dynamic,
        value:Bool
    ):Void
    {
        if (note == null)
            return;


        try
        {
            note.exists =
                value;
        }
        catch (e:Dynamic)
        {
        }
    }


    /*
     * ============================================================
     * SET ACTIVE
     * ============================================================
 */

    private static function setActive(
        note:Dynamic,
        value:Bool
    ):Void
    {
        if (note == null)
            return;


        try
        {
            note.active =
                value;
        }
        catch (e:Dynamic)
        {
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
     * SAVE ORIGINAL STATE
     * ============================================================
 */

    public static function saveOriginalState(
        index:Int,
        note:Dynamic
    ):Void
    {
        if (note == null)
            return;


        if (!originalExists.exists(index))
        {
            originalExists.set(
                index,
                getExists(note)
            );
        }


        if (!originalActive.exists(index))
        {
            originalActive.set(
                index,
                getActive(note)
            );
        }


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
     * SAVE ALL ORIGINAL STATES
     * ============================================================
 */

    public static function saveAllOriginalStates(
        notes:Array<Dynamic>
    ):Void
    {
        if (notes == null)
            return;


        for (i in 0...notes.length)
        {
            saveOriginalState(
                i,
                notes[i]
            );
        }
    }


    /*
     * ============================================================
     * DELETE
     * ============================================================
     *
     * Desactiva completamente una nota.
     *
     * ============================================================
 */

    public static function delete(
        index:Int,
        note:Dynamic
    ):Void
    {
        if (note == null)
            return;


        saveOriginalState(
            index,
            note
        );


        /*
         * kill() establece alive = false y puede realizar
         * limpieza interna de Flixel.
         */

        try
        {
            note.kill();
        }
        catch (e:Dynamic)
        {
        }


        setExists(
            note,
            false
        );


        setActive(
            note,
            false
        );


        setVisible(
            note,
            false
        );


        deleted.set(
            index,
            true
        );
    }


    /*
     * ============================================================
     * DELETE DIRECT
     * ============================================================
     *
     * Versión que no necesita índice.
     *
     * Útil cuando el Lua ya tiene la referencia directa a la
     * Note.
     *
     * ============================================================
 */

    public static function deleteDirect(
        note:Dynamic
    ):Void
    {
        if (note == null)
            return;


        try
        {
            note.kill();
        }
        catch (e:Dynamic)
        {
        }


        setExists(
            note,
            false
        );


        setActive(
            note,
            false
        );


        setVisible(
            note,
            false
        );
    }


    /*
     * ============================================================
     * DELETE ALL
     * ============================================================
 */

    public static function deleteAll(
        notes:Array<Dynamic>
    ):Void
    {
        if (notes == null)
            return;


        saveAllOriginalStates(
            notes
        );


        for (i in 0...notes.length)
        {
            delete(
                i,
                notes[i]
            );
        }
    }


    /*
     * ============================================================
     * DELETE RANGE
     * ============================================================
 *
 * Elimina un rango de notas.
 *
 * Ejemplo:
 *
 *     deleteRange(notes, 0, 3)
 *
 * elimina/desactiva 0, 1, 2 y 3.
 *
 * ============================================================
 */

    public static function deleteRange(
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
            end =
                notes.length - 1;


        if (start > end)
            return;


        for (i in start...end + 1)
        {
            delete(
                i,
                notes[i]
            );
        }
    }


    /*
     * ============================================================
     * DELETE BY ARRAY OF INDICES
     * ============================================================
 *
 * Permite eliminar notas concretas.
 *
 * Ejemplo:
 *
 *     [0, 3, 7, 10]
 *
 * ============================================================
 */

    public static function deleteIndices(
        notes:Array<Dynamic>,
        indices:Array<Int>
    ):Void
    {
        if (
            notes == null ||
            indices == null
        )
        {
            return;
        }


        for (index in indices)
        {
            if (
                index < 0 ||
                index >= notes.length
            )
            {
                continue;
            }


            delete(
                index,
                notes[index]
            );
        }
    }


    /*
     * ============================================================
     * RESTORE
     * ============================================================
     *
     * Restaura el estado que tenía la nota antes de ser
     * eliminada.
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


        if (!originalExists.exists(index))
            return;


        setExists(
            note,
            originalExists.get(index)
        );


        setActive(
            note,
            originalActive.get(index)
        );


        setVisible(
            note,
            originalVisible.get(index)
        );


        /*
         * Flixel puede haber puesto alive = false mediante
         * kill(). Si existe la función revive(), la utilizamos.
         */

        try
        {
            note.revive();
        }
        catch (e:Dynamic)
        {
        }


        deleted.remove(
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
     * RESTORE RANGE
     * ============================================================
 */

    public static function restoreRange(
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
            end =
                notes.length - 1;


        if (start > end)
            return;


        for (i in start...end + 1)
        {
            restore(
                i,
                notes[i]
            );
        }
    }


    /*
     * ============================================================
     * IS DELETED
     * ============================================================
 */

    public static function isDeleted(
        index:Int
    ):Bool
    {
        if (!deleted.exists(index))
            return false;


        return deleted.get(
            index
        );
    }


    /*
     * ============================================================
     * IS ACTIVE
     * ============================================================
 */

    public static function isActive(
        note:Dynamic
    ):Bool
    {
        return getActive(
            note
        );
    }


    /*
     * ============================================================
     * EXISTS
     * ============================================================
 */

    public static function exists(
        note:Dynamic
    ):Bool
    {
        return getExists(
            note
        );
    }


    /*
     * ============================================================
     * IS VISIBLE
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
     * GET ORIGINAL EXISTS
     * ============================================================
 */

    public static function getOriginalExists(
        index:Int
    ):Bool
    {
        if (!originalExists.exists(index))
            return true;


        return originalExists.get(
            index
        );
    }


    /*
     * ============================================================
     * GET ORIGINAL ACTIVE
     * ============================================================
 */

    public static function getOriginalActive(
        index:Int
    ):Bool
    {
        if (!originalActive.exists(index))
            return true;


        return originalActive.get(
            index
        );
    }


    /*
     * ============================================================
     * GET ORIGINAL VISIBLE
     * ============================================================
 */

    public static function getOriginalVisible(
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
     * CLEAR
     * ============================================================
 */

    public static function clear():Void
    {
        originalExists =
            new Map<Int, Bool>();


        originalActive =
            new Map<Int, Bool>();


        originalVisible =
            new Map<Int, Bool>();


        deleted =
            new Map<Int, Bool>();
    }
}