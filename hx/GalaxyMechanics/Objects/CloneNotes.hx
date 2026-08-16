/*
 * ============================================================
 * CloneNotes.hx
 * ============================================================
 *
 * FNF In The Galaxy -> Psych Engine 1.0.4
 *
 * Sistema para crear clones VISUALES de notas.
 *
 * ============================================================
 *
 * RESPONSABILIDAD:
 *
 *     - Crear clones visuales de Notes
 *     - Copiar apariencia de una Note
 *     - Copiar posición
 *     - Copiar escala
 *     - Copiar ángulo
 *     - Copiar alpha
 *     - Copiar flip
 *     - Copiar cámara
 *     - Mover clones independientemente
 *     - Eliminar clones
 *     - Limpiar todos los clones
 *
 * ============================================================
 *
 * IMPORTANTE:
 *
 * Los clones NO son Notes jugables.
 *
 * No participan en:
 *
 *     - Hit detection
 *     - Misses
 *     - Score
 *     - Combo
 *     - Sustain logic
 *     - Input
 *
 * Son únicamente sprites visuales.
 *
 * ============================================================
 */

import flixel.FlxSprite;
import flixel.FlxBasic;

import states.PlayState;


/**
 * CloneNotes
 *
 * Administrador de clones visuales de notas.
 */
class CloneNotes
{
    /*
     * ============================================================
     * CLONES
     * ============================================================
     *
     * Los clones se almacenan por ID.
     *
     * Ejemplo:
     *
     *     CloneNotes.clone(5, "ghost");
     *
     * ============================================================
     */

    private static var clones:Map<String, FlxSprite> =
        new Map<String, FlxSprite>();


    /*
     * ============================================================
     * COUNTER
     * ============================================================
     */

    private static var cloneCounter:Int = 0;


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
     * GET NOTE
     * ============================================================
     *
     * Obtiene una Note desde PlayState.notes.
     *
     * ============================================================
     */

    private static function getNote(
        noteIndex:Int
    ):Dynamic
    {
        if (PlayState.instance == null)
            return null;

        if (PlayState.instance.notes == null)
            return null;

        if (noteIndex < 0)
            return null;

        if (noteIndex >=
            PlayState.instance.notes.length)
        {
            return null;
        }

        return
            PlayState.instance.notes.members[noteIndex];
    }


    /*
     * ============================================================
     * GENERATE ID
     * ============================================================
 */

    private static function generateID():String
    {
        cloneCounter++;

        return
            "galaxyClone_" +
            Std.string(cloneCounter);
    }


    /*
     * ============================================================
     * ADD CLONE
     * ============================================================
 */

    private static function addClone(
        clone:FlxSprite
    ):Void
    {
        if (PlayState.instance == null)
            return;

        PlayState.instance.add(
            clone
        );
    }


    /*
     * ============================================================
     * CLONE
     * ============================================================
     *
     * Crea un clon visual de una Note.
     *
     * ============================================================
 *
     * Retorna:
     *
     *     ID del clon
     *
     * ============================================================
 */

    public static function clone(
        noteIndex:Int,
        ?id:String
    ):String
    {
        var note:Dynamic =
            getNote(
                noteIndex
            );

        if (note == null)
            return "";


        var cloneID:String =
            id != null
            ? id
            : generateID();


        /*
         * Si ya existe un clon con este ID,
         * lo eliminamos antes de reemplazarlo.
         */

        if (clones.exists(cloneID))
        {
            remove(
                cloneID
            );
        }


        var sprite:FlxSprite =
            new FlxSprite();


        /*
         * Copiar el gráfico actual.
         *
         * loadGraphicFromSprite permite conservar
         * el gráfico del Note original.
         */

        try
        {
            sprite.loadGraphicFromSprite(
                note
            );
        }
        catch (e:Dynamic)
        {
            return "";
        }


        /*
         * Copiar frame actual.
         */

        try
        {
            sprite.frame =
                note.frame;
        }
        catch (e:Dynamic)
        {
        }


        /*
         * Copiar posición.
         */

        sprite.x =
            note.x;

        sprite.y =
            note.y;


        /*
         * Copiar transformaciones.
         */

        sprite.angle =
            note.angle;

        sprite.alpha =
            note.alpha;

        sprite.scale.x =
            note.scale.x;

        sprite.scale.y =
            note.scale.y;


        /*
         * Copiar flip.
         */

        sprite.flipX =
            note.flipX;

        sprite.flipY =
            note.flipY;


        /*
         * Copiar origen.
         */

        sprite.origin.x =
            note.origin.x;

        sprite.origin.y =
            note.origin.y;


        /*
         * Copiar offset.
         */

        sprite.offset.x =
            note.offset.x;

        sprite.offset.y =
            note.offset.y;


        /*
         * Copiar cámara.
         */

        try
        {
            sprite.cameras =
                note.cameras;
        }
        catch (e:Dynamic)
        {
        }


        /*
         * Añadir al PlayState.
         */

        addClone(
            sprite
        );


        /*
         * Guardar.
         */

        clones.set(
            cloneID,
            sprite
        );


        return cloneID;
    }


    /*
     * ============================================================
     * CLONE WITH OFFSET
     * ============================================================
 *
 * Crea un clon desplazado respecto a la Note.
 *
 * ============================================================
 */

    public static function cloneWithOffset(
        noteIndex:Int,
        offsetX:Float,
        offsetY:Float,
        ?id:String
    ):String
    {
        var cloneID:String =
            clone(
                noteIndex,
                id
            );

        if (cloneID == "")
            return "";


        move(
            cloneID,
            offsetX,
            offsetY
        );


        return cloneID;
    }


    /*
     * ============================================================
     * GET
     * ============================================================
 */

    public static function get(
        id:String
    ):FlxSprite
    {
        if (!clones.exists(id))
            return null;

        return
            clones.get(id);
    }


    /*
     * ============================================================
     * EXISTS
     * ============================================================
 */

    public static function exists(
        id:String
    ):Bool
    {
        return
            clones.exists(id);
    }


    /*
     * ============================================================
     * MOVE
     * ============================================================
 *
 * Desplaza el clon respecto a su posición actual.
 *
 * ============================================================
 */

    public static function move(
        id:String,
        x:Float,
        y:Float
    ):Void
    {
        var sprite:FlxSprite =
            get(id);

        if (sprite == null)
            return;


        sprite.x +=
            x;

        sprite.y +=
            y;
    }


    /*
     * ============================================================
     * SET POSITION
     * ============================================================
 */

    public static function setPosition(
        id:String,
        x:Float,
        y:Float
    ):Void
    {
        var sprite:FlxSprite =
            get(id);

        if (sprite == null)
            return;


        sprite.x =
            x;

        sprite.y =
            y;
    }


    /*
     * ============================================================
     * SET X
     * ============================================================
 */

    public static function setX(
        id:String,
        x:Float
    ):Void
    {
        var sprite:FlxSprite =
            get(id);

        if (sprite == null)
            return;

        sprite.x =
            x;
    }


    /*
     * ============================================================
     * SET Y
     * ============================================================
 */

    public static function setY(
        id:String,
        y:Float
    ):Void
    {
        var sprite:FlxSprite =
            get(id);

        if (sprite == null)
            return;

        sprite.y =
            y;
    }


    /*
     * ============================================================
     * SET ALPHA
     * ============================================================
 */

    public static function setAlpha(
        id:String,
        alpha:Float
    ):Void
    {
        var sprite:FlxSprite =
            get(id);

        if (sprite == null)
            return;

        sprite.alpha =
            alpha;
    }


    /*
     * ============================================================
     * SET ANGLE
     * ============================================================
 */

    public static function setAngle(
        id:String,
        angle:Float
    ):Void
    {
        var sprite:FlxSprite =
            get(id);

        if (sprite == null)
            return;

        sprite.angle =
            angle;
    }


    /*
     * ============================================================
     * ROTATE
     * ============================================================
 */

    public static function rotate(
        id:String,
        amount:Float
    ):Void
    {
        var sprite:FlxSprite =
            get(id);

        if (sprite == null)
            return;

        sprite.angle +=
            amount;
    }


    /*
     * ============================================================
     * SET SCALE
     * ============================================================
 */

    public static function setScale(
        id:String,
        scaleX:Float,
        scaleY:Float
    ):Void
    {
        var sprite:FlxSprite =
            get(id);

        if (sprite == null)
            return;


        sprite.scale.x =
            scaleX;

        sprite.scale.y =
            scaleY;


        sprite.updateHitbox();
    }


    /*
     * ============================================================
     * SET UNIFORM SCALE
     * ============================================================
 */

    public static function scale(
        id:String,
        scale:Float
    ):Void
    {
        setScale(
            id,
            scale,
            scale
        );
    }


    /*
     * ============================================================
     * SET VISIBLE
     * ============================================================
 */

    public static function setVisible(
        id:String,
        value:Bool
    ):Void
    {
        var sprite:FlxSprite =
            get(id);

        if (sprite == null)
            return;

        sprite.visible =
            value;
    }


    /*
     * ============================================================
     * SET FLIP X
     * ============================================================
 */

    public static function setFlipX(
        id:String,
        value:Bool
    ):Void
    {
        var sprite:FlxSprite =
            get(id);

        if (sprite == null)
            return;

        sprite.flipX =
            value;
    }


    /*
     * ============================================================
     * SET FLIP Y
     * ============================================================
 */

    public static function setFlipY(
        id:String,
        value:Bool
    ):Void
    {
        var sprite:FlxSprite =
            get(id);

        if (sprite == null)
            return;

        sprite.flipY =
            value;
    }


    /*
     * ============================================================
     * SET CAMERA
     * ============================================================
 */

    public static function setCamera(
        id:String,
        camera:Dynamic
    ):Void
    {
        var sprite:FlxSprite =
            get(id);

        if (sprite == null)
            return;


        try
        {
            sprite.cameras =
                [camera];
        }
        catch (e:Dynamic)
        {
        }
    }


    /*
     * ============================================================
     * SET Z ORDER
     * ============================================================
 *
 * Cambia la posición del objeto dentro del grupo.
 *
 * ============================================================
 */

    public static function setZ(
        id:String,
        position:Int
    ):Void
    {
        var sprite:FlxSprite =
            get(id);

        if (sprite == null)
            return;

        if (PlayState.instance == null)
            return;


        try
        {
            PlayState.instance.remove(
                sprite,
                true
            );

            PlayState.instance.insert(
                position,
                sprite
            );
        }
        catch (e:Dynamic)
        {
        }
    }


    /*
     * ============================================================
     * FOLLOW NOTE
     * ============================================================
 *
 * Hace que un clon copie la posición de una Note.
 *
 * Esto debe llamarse desde onUpdate.
 *
 * ============================================================
 */

    public static function follow(
        id:String,
        noteIndex:Int,
        offsetX:Float = 0,
        offsetY:Float = 0
    ):Void
    {
        var sprite:FlxSprite =
            get(id);

        var note:Dynamic =
            getNote(noteIndex);


        if (sprite == null ||
            note == null)
        {
            return;
        }


        sprite.x =
            note.x +
            offsetX;

        sprite.y =
            note.y +
            offsetY;
    }


    /*
     * ============================================================
     * FOLLOW FULL
     * ============================================================
 *
 * Copia posición y transformaciones.
 *
 * ============================================================
 */

    public static function followFull(
        id:String,
        noteIndex:Int,
        offsetX:Float = 0,
        offsetY:Float = 0
    ):Void
    {
        var sprite:FlxSprite =
            get(id);

        var note:Dynamic =
            getNote(noteIndex);


        if (sprite == null ||
            note == null)
        {
            return;
        }


        sprite.x =
            note.x +
            offsetX;

        sprite.y =
            note.y +
            offsetY;


        sprite.angle =
            note.angle;

        sprite.alpha =
            note.alpha;

        sprite.scale.x =
            note.scale.x;

        sprite.scale.y =
            note.scale.y;

        sprite.flipX =
            note.flipX;

        sprite.flipY =
            note.flipY;


        try
        {
            sprite.frame =
                note.frame;
        }
        catch (e:Dynamic)
        {
        }
    }


    /*
     * ============================================================
     * COPY FROM NOTE
     * ============================================================
 *
 * Actualiza la apariencia del clon.
 *
 * ============================================================
 */

    public static function copyFromNote(
        id:String,
        noteIndex:Int
    ):Void
    {
        var sprite:FlxSprite =
            get(id);

        var note:Dynamic =
            getNote(noteIndex);


        if (sprite == null ||
            note == null)
        {
            return;
        }


        try
        {
            sprite.frame =
                note.frame;
        }
        catch (e:Dynamic)
        {
        }


        sprite.angle =
            note.angle;

        sprite.alpha =
            note.alpha;

        sprite.scale.x =
            note.scale.x;

        sprite.scale.y =
            note.scale.y;

        sprite.flipX =
            note.flipX;

        sprite.flipY =
            note.flipY;
    }


    /*
     * ============================================================
     * SET BLEND
     * ============================================================
 *
 * Preparado para combinarlo posteriormente con
 * GalaxyBlend.hx.
 *
 * ============================================================
 */

    public static function setBlendMode(
        id:String,
        mode:Dynamic
    ):Void
    {
        var sprite:FlxSprite =
            get(id);

        if (sprite == null)
            return;


        try
        {
            sprite.blend =
                mode;
        }
        catch (e:Dynamic)
        {
        }
    }


    /*
     * ============================================================
     * REMOVE
     * ============================================================
 */

    public static function remove(
        id:String
    ):Void
    {
        var sprite:FlxSprite =
            get(id);

        if (sprite == null)
            return;


        try
        {
            if (PlayState.instance != null)
            {
                PlayState.instance.remove(
                    sprite,
                    true
                );
            }
        }
        catch (e:Dynamic)
        {
        }


        clones.remove(
            id
        );
    }


    /*
     * ============================================================
     * REMOVE ALL
     * ============================================================
 */

    public static function removeAll():Void
    {
        var ids:Array<String> =
            [];

        for (id in clones.keys())
        {
            ids.push(
                id
            );
        }


        for (id in ids)
        {
            remove(
                id
            );
        }
    }


    /*
     * ============================================================
     * COUNT
     * ============================================================
 */

    public static function count():Int
    {
        var result:Int =
            0;

        for (id in clones.keys())
        {
            result++;
        }

        return result;
    }


    /*
     * ============================================================
     * GET ALL IDS
     * ============================================================
 */

    public static function getIDs():Array<String>
    {
        var result:Array<String> =
            [];

        for (id in clones.keys())
        {
            result.push(
                id
            );
        }

        return result;
    }


    /*
     * ============================================================
     * CLEAR
     * ============================================================
 */

    public static function clear():Void
    {
        removeAll();

        cloneCounter =
            0;
    }
}