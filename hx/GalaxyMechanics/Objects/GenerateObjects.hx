/*
 * ============================================================
 * GenerateObjects.hx
 * ============================================================
 *
 * FNF In The Galaxy -> Psych Engine 1.0.4
 *
 * Generador de objetos visuales genéricos.
 *
 * ============================================================
 *
 * RESPONSABILIDAD:
 *
 *     - Crear sprites desde imágenes
 *     - Crear sprites vacíos
 *     - Crear rectángulos
 *     - Clonar FlxSprites
 *     - Posicionar objetos
 *     - Mover objetos
 *     - Rotar objetos
 *     - Escalar objetos
 *     - Cambiar alpha
 *     - Cambiar visibilidad
 *     - Cambiar cámara
 *     - Cambiar blend
 *     - Eliminar objetos
 *     - Administrar objetos mediante IDs
 *
 * ============================================================
 *
 * NO SE ENCARGA DE:
 *
 *     - Notas
 *     - Strums
 *     - Gameplay
 *     - Ventana
 *     - Cámara global
 *     - 3D
 *     - Shaders
 *
 * Estos sistemas pueden utilizar posteriormente los objetos
 * generados por este archivo.
 *
 * ============================================================
 */

import flixel.FlxSprite;
import flixel.util.FlxColor;

import states.PlayState;


/**
 * GenerateObjects
 *
 * Administrador de objetos visuales genéricos.
 */
class GenerateObjects
{
    /*
     * ============================================================
     * STORAGE
     * ============================================================
     */

    private static var objects:Map<String, FlxSprite> =
        new Map<String, FlxSprite>();


    /*
     * ============================================================
     * COUNTER
     * ============================================================
     */

    private static var objectCounter:Int = 0;


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
     * GENERATE ID
     * ============================================================
     */

    private static function generateID():String
    {
        objectCounter++;

        return
            "galaxyObject_" +
            Std.string(objectCounter);
    }


    /*
     * ============================================================
     * ADD OBJECT
     * ============================================================
     */

    private static function addObject(
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
     * Crea un sprite vacío.
     *
     * ============================================================
     */

    public static function create(
        ?id:String
    ):String
    {
        var objectID:String =
            id != null
            ? id
            : generateID();


        if (objects.exists(objectID))
        {
            remove(
                objectID
            );
        }


        var sprite:FlxSprite =
            new FlxSprite();


        addObject(
            sprite
        );


        objects.set(
            objectID,
            sprite
        );


        return objectID;
    }


    /*
     * ============================================================
     * CREATE SPRITE
     * ============================================================
     *
     * Carga una imagen desde assets.
     *
     * assetPath:
     *
     *     Ruta relativa dentro de images.
     *
     * Ejemplo:
     *
     *     "galaxy/background"
     *
     * ============================================================
     */

    public static function createSprite(
        assetPath:String,
        ?id:String,
        x:Float = 0,
        y:Float = 0
    ):String
    {
        var objectID:String =
            create(
                id
            );


        if (objectID == "")
            return "";


        var sprite:FlxSprite =
            get(objectID);


        if (sprite == null)
            return "";


        sprite.loadGraphic(
            Paths.image(
                assetPath
            )
        );


        sprite.x =
            x;

        sprite.y =
            y;


        return objectID;
    }


    /*
     * ============================================================
     * CREATE RECTANGLE
     * ============================================================
     *
     * Crea un objeto rectangular.
     *
     * Muy útil para:
     *
     *     - overlays
     *     - barras
     *     - máscaras
     *     - fondos
     *     - efectos visuales
     *
     * ============================================================
     */

    public static function createRectangle(
        width:Int,
        height:Int,
        color:Int = FlxColor.WHITE,
        ?id:String,
        x:Float = 0,
        y:Float = 0
    ):String
    {
        var objectID:String =
            create(
                id
            );


        if (objectID == "")
            return "";


        var sprite:FlxSprite =
            get(objectID);


        if (sprite == null)
            return "";


        sprite.makeGraphic(
            width,
            height,
            color
        );


        sprite.x =
            x;

        sprite.y =
            y;


        return objectID;
    }


    /*
     * ============================================================
     * CREATE CLONE
     * ============================================================
     *
     * Clona cualquier FlxSprite.
     *
     * ============================================================
 */

    public static function clone(
        source:FlxSprite,
        ?id:String
    ):String
    {
        if (source == null)
            return "";


        var objectID:String =
            id != null
            ? id
            : generateID();


        if (objects.exists(objectID))
        {
            remove(
                objectID
            );
        }


        var sprite:FlxSprite =
            new FlxSprite();


        try
        {
            sprite.loadGraphicFromSprite(
                source
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
                source.frame;
        }
        catch (e:Dynamic)
        {
        }


        /*
         * Transformaciones.
         */

        sprite.x =
            source.x;

        sprite.y =
            source.y;

        sprite.angle =
            source.angle;

        sprite.alpha =
            source.alpha;

        sprite.scale.x =
            source.scale.x;

        sprite.scale.y =
            source.scale.y;

        sprite.flipX =
            source.flipX;

        sprite.flipY =
            source.flipY;


        /*
         * Origin.
         */

        sprite.origin.x =
            source.origin.x;

        sprite.origin.y =
            source.origin.y;


        /*
         * Offset.
         */

        sprite.offset.x =
            source.offset.x;

        sprite.offset.y =
            source.offset.y;


        /*
         * Cámara.
         */

        try
        {
            sprite.cameras =
                source.cameras;
        }
        catch (e:Dynamic)
        {
        }


        addObject(
            sprite
        );


        objects.set(
            objectID,
            sprite
        );


        return objectID;
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
        if (!objects.exists(id))
            return null;


        return
            objects.get(id);
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
            objects.exists(id);
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
     * GET X
     * ============================================================
 */

    public static function getX(
        id:String
    ):Float
    {
        var sprite:FlxSprite =
            get(id);


        if (sprite == null)
            return 0;


        return sprite.x;
    }


    /*
     * ============================================================
     * GET Y
     * ============================================================
 */

    public static function getY(
        id:String
    ):Float
    {
        var sprite:FlxSprite =
            get(id);


        if (sprite == null)
            return 0;


        return sprite.y;
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


        if (alpha < 0)
            alpha = 0;

        if (alpha > 1)
            alpha = 1;


        sprite.alpha =
            alpha;
    }


    /*
     * ============================================================
     * GET ALPHA
     * ============================================================
 */

    public static function getAlpha(
        id:String
    ):Float
    {
        var sprite:FlxSprite =
            get(id);


        if (sprite == null)
            return 0;


        return sprite.alpha;
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
     * SET BLEND MODE
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
     * SET COLOR
     * ============================================================
 */

    public static function setColor(
        id:String,
        color:Int
    ):Void
    {
        var sprite:FlxSprite =
            get(id);


        if (sprite == null)
            return;


        sprite.color =
            color;
    }


    /*
     * ============================================================
     * SET ANTIALIASING
     * ============================================================
 */

    public static function setAntialiasing(
        id:String,
        value:Bool
    ):Void
    {
        var sprite:FlxSprite =
            get(id);


        if (sprite == null)
            return;


        sprite.antialiasing =
            value;
    }


    /*
     * ============================================================
     * SET SCROLL FACTOR
     * ============================================================
 *
 * Útil para objetos que deban moverse a distinta velocidad
 * respecto a la cámara.
 *
 * ============================================================
 */

    public static function setScrollFactor(
        id:String,
        x:Float,
        y:Float
    ):Void
    {
        var sprite:FlxSprite =
            get(id);


        if (sprite == null)
            return;


        sprite.scrollFactor.set(
            x,
            y
        );
    }


    /*
     * ============================================================
     * CENTER ORIGIN
     * ============================================================
 */

    public static function centerOrigin(
        id:String
    ):Void
    {
        var sprite:FlxSprite =
            get(id);


        if (sprite == null)
            return;


        sprite.centerOrigin();
    }


    /*
     * ============================================================
     * UPDATE HITBOX
     * ============================================================
 */

    public static function updateHitbox(
        id:String
    ):Void
    {
        var sprite:FlxSprite =
            get(id);


        if (sprite == null)
            return;


        sprite.updateHitbox();
    }


    /*
     * ============================================================
     * FOLLOW OBJECT
     * ============================================================
 *
 * Hace que un objeto siga a otro objeto generado.
 *
 * ============================================================
 */

    public static function follow(
        id:String,
        targetID:String,
        offsetX:Float = 0,
        offsetY:Float = 0
    ):Void
    {
        var sprite:FlxSprite =
            get(id);

        var target:FlxSprite =
            get(targetID);


        if (sprite == null ||
            target == null)
        {
            return;
        }


        sprite.x =
            target.x +
            offsetX;

        sprite.y =
            target.y +
            offsetY;
    }


    /*
     * ============================================================
     * FOLLOW FULL
     * ============================================================
 *
 * Sigue posición + transformaciones.
 *
 * ============================================================
 */

    public static function followFull(
        id:String,
        targetID:String,
        offsetX:Float = 0,
        offsetY:Float = 0
    ):Void
    {
        var sprite:FlxSprite =
            get(id);

        var target:FlxSprite =
            get(targetID);


        if (sprite == null ||
            target == null)
        {
            return;
        }


        sprite.x =
            target.x +
            offsetX;

        sprite.y =
            target.y +
            offsetY;


        sprite.angle =
            target.angle;

        sprite.alpha =
            target.alpha;


        sprite.scale.x =
            target.scale.x;

        sprite.scale.y =
            target.scale.y;


        sprite.flipX =
            target.flipX;

        sprite.flipY =
            target.flipY;
    }


    /*
     * ============================================================
     * SET SIZE
     * ============================================================
 *
 * Modifica el tamaño del objeto mediante scale.
 *
 * ============================================================
 */

    public static function setSize(
        id:String,
        width:Float,
        height:Float
    ):Void
    {
        var sprite:FlxSprite =
            get(id);


        if (sprite == null)
            return;


        if (sprite.frameWidth <= 0 ||
            sprite.frameHeight <= 0)
        {
            return;
        }


        sprite.scale.x =
            width /
            sprite.frameWidth;

        sprite.scale.y =
            height /
            sprite.frameHeight;


        sprite.updateHitbox();
    }


    /*
     * ============================================================
     * GET WIDTH
     * ============================================================
 */

    public static function getWidth(
        id:String
    ):Float
    {
        var sprite:FlxSprite =
            get(id);


        if (sprite == null)
            return 0;


        return sprite.width;
    }


    /*
     * ============================================================
     * GET HEIGHT
     * ============================================================
 */

    public static function getHeight(
        id:String
    ):Float
    {
        var sprite:FlxSprite =
            get(id);


        if (sprite == null)
            return 0;


        return sprite.height;
    }


    /*
     * ============================================================
     * SET ACTIVE
     * ============================================================
 */

    public static function setActive(
        id:String,
        value:Bool
    ):Void
    {
        var sprite:FlxSprite =
            get(id);


        if (sprite == null)
            return;


        sprite.active =
            value;
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


        objects.remove(
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


        for (id in objects.keys())
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


        for (id in objects.keys())
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


        for (id in objects.keys())
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

        objectCounter =
            0;
    }
}