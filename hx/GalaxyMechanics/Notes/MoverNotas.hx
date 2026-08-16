/*
 * ============================================================
 * MoverNotas.hx
 * ============================================================
 *
 * FNF In The Galaxy -> Psych Engine 1.0.4
 *
 * Sistema individual para mover notas.
 *
 * ============================================================
 *
 * RESPONSABILIDAD:
 *
 *     - Mover notas individualmente
 *     - Mover notas por X
 *     - Mover notas por Y
 *     - Mover notas por X/Y
 *     - Mover notas relativamente
 *     - Guardar posiciones originales
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
 * La idea es poder utilizar solamente este archivo cuando
 * una canción necesite una mecánica de movimiento.
 *
 * ============================================================
 */

import flixel.FlxSprite;


/**
 * MoverNotas
 *
 * Controlador independiente para posiciones de notas.
 */
class MoverNotas
{
    /*
     * ============================================================
     * POSICIONES ORIGINALES
     * ============================================================
     *
     * Se almacenan por índice de nota.
     *
     * Ejemplo:
     *
     *     originalesX[0]
     *     originalesY[0]
     *
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
     * Guarda la posición actual de una nota.
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
 *
 * Recibe un Array de notas.
 *
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
 * Establece directamente X/Y.
 *
 * ============================================================
 */

    public static function setPosition(
        note:Dynamic,
        x:Float,
        y:Float
    ):Void
    {
        if (note == null)
            return;


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

    public static function setNoteX(
        note:Dynamic,
        x:Float
    ):Void
    {
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

    public static function setNoteY(
        note:Dynamic,
        y:Float
    ):Void
    {
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
 * Mueve una nota una cantidad determinada.
 *
 * Ejemplo:
 *
 *     move(note, 100, 0)
 *
 * mueve la nota 100 píxeles a la derecha.
 *
 * ============================================================
 */

    public static function move(
        note:Dynamic,
        offsetX:Float,
        offsetY:Float
    ):Void
    {
        if (note == null)
            return;


        setPosition(
            note,
            getX(note) + offsetX,
            getY(note) + offsetY
        );
    }


    /*
     * ============================================================
     * MOVE X
     * ============================================================
 */

    public static function moveX(
        note:Dynamic,
        amount:Float
    ):Void
    {
        if (note == null)
            return;


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
        note:Dynamic,
        amount:Float
    ):Void
    {
        if (note == null)
            return;


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
 * Coloca una nota en una posición relativa a su posición
 * original.
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


        saveOriginalPosition(
            index,
            note
        );


        var x:Float =
            originalX.get(index);


        var y:Float =
            originalY.get(index);


        setPosition(
            note,
            x + offsetX,
            y + offsetY
        );
    }


    /*
     * ============================================================
     * MOVE FROM ORIGINAL
     * ============================================================
 *
 * Similar a setFromOriginal(), pero permite utilizar la
 * posición original como referencia sin acumular movimiento.
 *
 * Esto es importante para efectos como:
 *
 *     X = originalX + sin(...)
 *
 * porque evita que el movimiento se acumule cada frame.
 *
 * ============================================================
 */

    public static function moveFromOriginal(
        index:Int,
        note:Dynamic,
        offsetX:Float,
        offsetY:Float
    ):Void
    {
        setFromOriginal(
            index,
            note,
            offsetX,
            offsetY
        );
    }


    /*
     * ============================================================
     * MOVE ALL
     * ============================================================
 *
 * Mueve todas las notas del Array.
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


        for (note in notes)
        {
            move(
                note,
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


        for (note in notes)
        {
            moveX(
                note,
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


        for (note in notes)
        {
            moveY(
                note,
                amount
            );
        }
    }


    /*
     * ============================================================
     * SET ALL POSITION
     * ============================================================
 *
 * Coloca todas las notas en la misma posición.
 *
 * Normalmente no será lo que queramos utilizar para un
 * modchart, pero puede resultar útil para efectos.
 *
 * ============================================================
 */

    public static function setAllPosition(
        notes:Array<Dynamic>,
        x:Float,
        y:Float
    ):Void
    {
        if (notes == null)
            return;


        for (note in notes)
        {
            setPosition(
                note,
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
     * RESTORE NOTE
     * ============================================================
 */

    public static function restore(
        index:Int,
        note:Dynamic
    ):Void
    {
        if (note == null)
            return;


        if (!originalX.exists(index))
            return;


        if (!originalY.exists(index))
            return;


        setPosition(
            note,
            originalX.get(index),
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
     * GET CURRENT POSITION
     * ============================================================
 */

    public static function getPosition(
        note:Dynamic
    ):Dynamic
    {
        if (note == null)
            return null;


        return {
            x: getX(note),
            y: getY(note)
        };
    }


    /*
     * ============================================================
     * GET ORIGINAL POSITION
     * ============================================================
 */

    public static function getOriginalPosition(
        index:Int
    ):Dynamic
    {
        return {
            x: getOriginalX(index),
            y: getOriginalY(index)
        };
    }


    /*
     * ============================================================
     * OFFSET FROM ORIGINAL
     * ============================================================
 *
 * Devuelve cuánto se ha alejado una nota de su posición
 * original.
 *
 * ============================================================
 */

    public static function getOffsetFromOriginal(
        index:Int,
        note:Dynamic
    ):Dynamic
    {
        if (note == null)
            return null;


        if (!hasOriginalPosition(index))
            return {
                x: 0,
                y: 0
            };


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
     * MOVE RELATIVE TO ORIGINAL X
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
     * MOVE RELATIVE TO ORIGINAL Y
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
     * CENTER OFFSET
     * ============================================================
 *
 * Mueve una nota alrededor de un punto central.
 *
 * ============================================================
 */

    public static function setCentered(
        note:Dynamic,
        centerX:Float,
        centerY:Float,
        offsetX:Float,
        offsetY:Float
    ):Void
    {
        if (note == null)
            return;


        setPosition(
            note,
            centerX + offsetX,
            centerY + offsetY
        );
    }


    /*
     * ============================================================
     * MIRROR X
     * ============================================================
 *
 * Invierte la posición X respecto a un eje.
 *
 * ============================================================
 */

    public static function mirrorX(
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
     * MIRROR Y
     * ============================================================
 */

    public static function mirrorY(
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
     * SWAP POSITION
     * ============================================================
 *
 * Intercambia la posición de dos notas.
 *
 * ============================================================
 */

    public static function swap(
        noteA:Dynamic,
        noteB:Dynamic
    ):Void
    {
        if (
            noteA == null ||
            noteB == null
        )
        {
            return;
        }


        var ax:Float =
            getX(noteA);

        var ay:Float =
            getY(noteA);


        var bx:Float =
            getX(noteB);

        var by:Float =
            getY(noteB);


        setPosition(
            noteA,
            bx,
            by
        );


        setPosition(
            noteB,
            ax,
            ay
        );
    }
}