/*
 * ============================================================
 * GenerateStrums.hx
 * ============================================================
 *
 * FNF In The Galaxy -> Psych Engine 1.0.4
 *
 * Sistema para generar STRUMS VISUALES adicionales.
 *
 * ============================================================
 *
 * RESPONSABILIDAD:
 *
 *     - Crear strums visuales adicionales
 *     - Crear múltiples strums
 *     - Copiar apariencia de strums existentes
 *     - Posicionar strums
 *     - Rotar strums
 *     - Cambiar alpha
 *     - Cambiar escala
 *     - Ocultar / mostrar
 *     - Eliminar strums generados
 *     - Seguir strums originales
 *
 * ============================================================
 *
 * IMPORTANTE:
 *
 * Los strums generados por este sistema son VISUALES.
 *
 * NO forman parte de:
 *
 *     - input
 *     - receptors reales de Psych
 *     - hit detection
 *     - key presses
 *     - accuracy
 *     - score
 *
 * ============================================================
 *
 * Esto permite utilizar:
 *
 *     - strums fantasma
 *     - strums duplicados
 *     - strums decorativos
 *     - efectos de GalaxyMod
 *     - múltiples líneas visuales
 *
 * sin alterar el gameplay original.
 *
 * ============================================================
 */

import flixel.FlxSprite;
import flixel.FlxBasic;


/**
 * GenerateStrums
 *
 * Administrador de strums visuales generados.
 */
class GenerateStrums
{
    /*
     * ============================================================
     * STORAGE
     * ============================================================
     *
     * Cada strum posee un ID independiente.
     *
     * ============================================================
     */

    private static var strums:Map<String, FlxSprite> =
        new Map<String, FlxSprite>();


    /*
     * ============================================================
     * COUNTER
     * ============================================================
     */

    private static var strumCounter:Int = 0;


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
     * GET ORIGINAL STRUM
     * ============================================================
 *
 * Obtiene un strum del grupo real de Psych.
 *
 * ============================================================
 */

    private static function getOriginalStrum(
        strumIndex:Int
    ):Dynamic
    {
        if (PlayState.instance == null)
            return null;


        if (PlayState.instance.strumLineNotes == null)
            return null;


        if (strumIndex < 0)
            return null;


        if (strumIndex >=
            PlayState.instance.strumLineNotes.length)
        {
            return null;
        }


        return
            PlayState.instance
                .strumLineNotes
                .members[strumIndex];
    }


    /*
     * ============================================================
     * GENERATE ID
     * ============================================================
 */

    private static function generateID():String
    {
        strumCounter++;

        return
            "galaxyStrum_" +
            Std.string(strumCounter);
    }


    /*
     * ============================================================
     * ADD
     * ============================================================
 */

    private static function addStrum(
        sprite:FlxSprite
    ):Void
    {
        if (PlayState.instance == null)
            return;


        PlayState.instance.add(
            sprite
        );
    }


    /*
     * ============================================================
     * CREATE
     * ============================================================
 *
 * Crea un strum visual copiando uno existente.
 *
 * originalIndex:
 *
 *     Índice del strum original.
 *
 * id:
 *
 *     Identificador opcional.
 *
 * ============================================================
 */

    public static function create(
        originalIndex:Int,
        ?id:String
    ):String
    {
        var original:Dynamic =
            getOriginalStrum(
                originalIndex
            );


        if (original == null)
            return "";


        var strumID:String =
            id != null
            ? id
            : generateID();


        /*
         * Si ya existe ese ID,
         * reemplazarlo.
         */

        if (strums.exists(strumID))
        {
            remove(
                strumID
            );
        }


        var sprite:FlxSprite =
            new FlxSprite();


        /*
         * Copiar gráfico.
         */

        try
        {
            sprite.loadGraphicFromSprite(
                original
            );
        }
        catch (e:Dynamic)
        {
            return "";
        }


        /*
         * Copiar frame.
         */

        try
        {
            sprite.frame =
                original.frame;
        }
        catch (e:Dynamic)
        {
        }


        /*
         * Posición.
         */

        sprite.x =
            original.x;

        sprite.y =
            original.y;


        /*
         * Transformaciones.
         */

        sprite.angle =
            original.angle;

        sprite.alpha =
            original.alpha;


        sprite.scale.x =
            original.scale.x;

        sprite.scale.y =
            original.scale.y;


        /*
         * Flip.
         */

        sprite.flipX =
            original.flipX;

        sprite.flipY =
            original.flipY;


        /*
         * Origin.
         */

        sprite.origin.x =
            original.origin.x;

        sprite.origin.y =
            original.origin.y;


        /*
         * Offset.
         */

        sprite.offset.x =
            original.offset.x;

        sprite.offset.y =
            original.offset.y;


        /*
         * Cámara.
         */

        try
        {
            sprite.cameras =
                original.cameras;
        }
        catch (e:Dynamic)
        {
        }


        /*
         * Añadir al estado.
         */

        addStrum(
            sprite
        );


        /*
         * Guardar.
         */

        strums.set(
            strumID,
            sprite
        );


        return strumID;
    }


    /*
     * ============================================================
     * CREATE AT POSITION
     * ============================================================
 */

    public static function createAt(
        originalIndex:Int,
        x:Float,
        y:Float,
        ?id:String
    ):String
    {
        var strumID:String =
            create(
                originalIndex,
                id
            );


        if (strumID == "")
            return "";


        setPosition(
            strumID,
            x,
            y
        );


        return strumID;
    }


    /*
     * ============================================================
     * CREATE OFFSET
     * ============================================================
 *
 * Crea un clon desplazado respecto al strum original.
 *
 * ============================================================
 */

    public static function createOffset(
        originalIndex:Int,
        offsetX:Float,
        offsetY:Float,
        ?id:String
    ):String
    {
        var strumID:String =
            create(
                originalIndex,
                id
            );


        if (strumID == "")
            return "";


        move(
            strumID,
            offsetX,
            offsetY
        );


        return strumID;
    }


    /*
     * ============================================================
     * CREATE MULTIPLE
     * ============================================================
 *
 * Crea varios strums a partir de una lista de índices.
 *
 * ============================================================
 */

    public static function createMultiple(
        indices:Array<Int>,
        prefix:String = "galaxyStrum"
    ):Array<String>
    {
        var result:Array<String> =
            [];


        for (i in 0...indices.length)
        {
            var id:String =
                prefix +
                "_" +
                Std.string(i);


            var created:String =
                create(
                    indices[i],
                    id
                );


            if (created != "")
            {
                result.push(
                    created
                );
            }
        }


        return result;
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
        if (!strums.exists(id))
            return null;


        return
            strums.get(id);
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
            strums.exists(id);
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
     * MOVE
     * ============================================================
 *
 * Movimiento relativo.
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
        value:Float
    ):Void
    {
        setScale(
            id,
            value,
            value
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
     * SET BLEND
     * ============================================================
 *
 * Compatible con GalaxyBlend.hx.
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
     * FOLLOW
     * ============================================================
 *
 * Hace que un strum generado siga a un strum original.
 *
 * Debe ejecutarse desde onUpdate.
 *
 * ============================================================
 */

    public static function follow(
        id:String,
        originalIndex:Int,
        offsetX:Float = 0,
        offsetY:Float = 0
    ):Void
    {
        var sprite:FlxSprite =
            get(id);

        var original:Dynamic =
            getOriginalStrum(
                originalIndex
            );


        if (sprite == null ||
            original == null)
        {
            return;
        }


        sprite.x =
            original.x +
            offsetX;

        sprite.y =
            original.y +
            offsetY;
    }


    /*
     * ============================================================
     * FOLLOW FULL
     * ============================================================
 *
 * Copia posición + transformaciones del strum original.
 *
 * ============================================================
 */

    public static function followFull(
        id:String,
        originalIndex:Int,
        offsetX:Float = 0,
        offsetY:Float = 0
    ):Void
    {
        var sprite:FlxSprite =
            get(id);

        var original:Dynamic =
            getOriginalStrum(
                originalIndex
            );


        if (sprite == null ||
            original == null)
        {
            return;
        }


        sprite.x =
            original.x +
            offsetX;

        sprite.y =
            original.y +
            offsetY;


        sprite.angle =
            original.angle;

        sprite.alpha =
            original.alpha;


        sprite.scale.x =
            original.scale.x;

        sprite.scale.y =
            original.scale.y;


        sprite.flipX =
            original.flipX;

        sprite.flipY =
            original.flipY;


        try
        {
            sprite.frame =
                original.frame;
        }
        catch (e:Dynamic)
        {
        }
    }


    /*
     * ============================================================
     * COPY APPEARANCE
     * ============================================================
 */

    public static function copyAppearance(
        id:String,
        originalIndex:Int
    ):Void
    {
        var sprite:FlxSprite =
            get(id);

        var original:Dynamic =
            getOriginalStrum(
                originalIndex
            );


        if (sprite == null ||
            original == null)
        {
            return;
        }


        try
        {
            sprite.frame =
                original.frame;
        }
        catch (e:Dynamic)
        {
        }


        sprite.angle =
            original.angle;

        sprite.alpha =
            original.alpha;


        sprite.scale.x =
            original.scale.x;

        sprite.scale.y =
            original.scale.y;


        sprite.flipX =
            original.flipX;

        sprite.flipY =
            original.flipY;
    }


    /*
     * ============================================================
     * RESET TO ORIGINAL
     * ============================================================
 *
 * Vuelve a colocar un strum generado sobre el strum original.
 *
 * ============================================================
 */

    public static function resetToOriginal(
        id:String,
        originalIndex:Int
    ):Void
    {
        var original:Dynamic =
            getOriginalStrum(
                originalIndex
            );


        var sprite:FlxSprite =
            get(id);


        if (original == null ||
            sprite == null)
        {
            return;
        }


        sprite.x =
            original.x;

        sprite.y =
            original.y;

        sprite.angle =
            original.angle;

        sprite.alpha =
            original.alpha;

        sprite.scale.x =
            original.scale.x;

        sprite.scale.y =
            original.scale.y;
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


        strums.remove(
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


        for (id in strums.keys())
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


        for (id in strums.keys())
        {
            result++;
        }


        return result;
    }


    /*
     * ============================================================
     * GET IDS
     * ============================================================
 */

    public static function getIDs():Array<String>
    {
        var result:Array<String> =
            [];


        for (id in strums.keys())
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

        strumCounter =
            0;
    }
}