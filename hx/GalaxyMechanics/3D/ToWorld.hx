/*
 * ============================================================
 * ToWorld.hx
 * ============================================================
 *
 * FNF In The Galaxy -> Psych Engine 1.0.4
 *
 * Conversión de coordenadas 2D del juego -> mundo 3D.
 *
 * ============================================================
 *
 * RESPONSABILIDAD:
 *
 *     - Convertir X/Y 2D a X/Y/Z del mundo
 *     - Aplicar offsets del mundo
 *     - Aplicar escala del mundo
 *     - Convertir Note3D desde coordenadas de juego
 *     - Convertir puntos individuales
 *     - Convertir listas de puntos
 *
 * ============================================================
 *
 * NO SE ENCARGA DE:
 *
 *     - Perspectiva
 *     - Proyección a pantalla
 *     - Renderizado
 *     - Shaders
 *     - drawTriangles
 *
 * Para eso:
 *
 *     Perspective.hx
 *     ToScreen.hx
 *     RenderPath.hx
 *
 * ============================================================
 *
 * FLUJO:
 *
 *     Note / Strum / Object
 *             |
 *             v
 *          ToWorld
 *             |
 *             v
 *         X / Y / Z
 *             |
 *             v
 *        Perspective
 *             |
 *             v
 *         ToScreen
 *
 * ============================================================
 */

class ToWorld
{
    /*
     * ============================================================
     * CONFIGURACIÓN DEL MUNDO
     * ============================================================
     */

    /**
     * Offset X global del mundo.
     */
    public static var offsetX:Float = 0;


    /**
     * Offset Y global del mundo.
     */
    public static var offsetY:Float = 0;


    /**
     * Offset Z global del mundo.
     */
    public static var offsetZ:Float = 0;


    /**
     * Escala global X.
     */
    public static var scaleX:Float = 1;


    /**
     * Escala global Y.
     */
    public static var scaleY:Float = 1;


    /**
     * Escala global Z.
     */
    public static var scaleZ:Float = 1;


    /*
     * ============================================================
     * PROFUNDIDAD POR DEFECTO
     * ============================================================
     *
     * Si un objeto 2D no proporciona Z, utilizará este valor.
     */

    public static var defaultZ:Float = 0;


    /*
     * ============================================================
     * CONVERSIÓN DE PANTALLA A MUNDO
     * ============================================================
     *
     * Por defecto:
     *
     *     X mundo = X juego
     *     Y mundo = Y juego
     *     Z mundo = 0
     *
     * Esto permite utilizar el sistema 3D de manera gradual.
     *
     * ============================================================
     */

    public static function point(
        x:Float,
        y:Float,
        z:Float = 0
    ):Dynamic
    {
        return {
            x:
                x * scaleX +
                offsetX,

            y:
                y * scaleY +
                offsetY,

            z:
                z * scaleZ +
                offsetZ
        };
    }


    /*
     * ============================================================
     * POINT FROM DEFAULT Z
     * ============================================================
     */

    public static function point2D(
        x:Float,
        y:Float
    ):Dynamic
    {
        return point(
            x,
            y,
            defaultZ
        );
    }


    /*
     * ============================================================
     * POINT OBJECT
     * ============================================================
     *
     * Recibe:
     *
     *     { x, y }
     *
     * o:
     *
     *     { x, y, z }
     *
     * ============================================================
     */

    public static function fromPoint(
        value:Dynamic
    ):Dynamic
    {
        if (value == null)
            return null;


        var z:Float =
            defaultZ;


        if (Reflect.hasField(value, "z"))
            z = value.z;


        return point(
            value.x,
            value.y,
            z
        );
    }


    /*
     * ============================================================
     * NOTE -> WORLD
     * ============================================================
     *
     * Convierte una Note3D existente.
     *
     * No modifica la nota original.
     *
     * ============================================================
     */

    public static function fromNote(
        note:Note3D
    ):Dynamic
    {
        if (note == null)
            return null;


        return point(
            note.x,
            note.y,
            note.z
        );
    }


    /*
     * ============================================================
     * NOTE BASE -> WORLD
     * ============================================================
     *
     * Convierte la posición base de una Note3D.
     *
     * ============================================================
     */

    public static function fromNoteBase(
        note:Note3D
    ):Dynamic
    {
        if (note == null)
            return null;


        return point(
            note.baseX,
            note.baseY,
            note.baseZ
        );
    }


    /*
     * ============================================================
     * CREATE NOTE
     * ============================================================
     *
     * Crea una Note3D a partir de coordenadas 2D.
     *
     * ============================================================
     */

    public static function createNote(
        x:Float,
        y:Float,
        z:Float = 0,
        noteData:Int = -1,
        mustPress:Bool = false,
        isSustain:Bool = false
    ):Note3D
    {
        var world:Dynamic =
            point(
                x,
                y,
                z
            );


        var note:Note3D =
            new Note3D(
                noteData,
                mustPress,
                isSustain
            );


        note.setPosition(
            world.x,
            world.y,
            world.z
        );


        note.setBasePosition(
            world.x,
            world.y,
            world.z
        );


        return note;
    }


    /*
     * ============================================================
     * APPLY TO NOTE
     * ============================================================
     *
     * Convierte y modifica directamente una Note3D.
     *
     * ============================================================
     */

    public static function applyToNote(
        note:Note3D
    ):Void
    {
        if (note == null)
            return;


        var world:Dynamic =
            point(
                note.x,
                note.y,
                note.z
            );


        note.x =
            world.x;

        note.y =
            world.y;

        note.z =
            world.z;
    }


    /*
     * ============================================================
     * APPLY BASE TO NOTE
     * ============================================================
     *
     * Convierte la posición base y actualiza ambas.
     *
     * ============================================================
     */

    public static function applyBaseToNote(
        note:Note3D
    ):Void
    {
        if (note == null)
            return;


        var world:Dynamic =
            point(
                note.baseX,
                note.baseY,
                note.baseZ
            );


        note.baseX =
            world.x;

        note.baseY =
            world.y;

        note.baseZ =
            world.z;


        note.x =
            world.x;

        note.y =
            world.y;

        note.z =
            world.z;
    }


    /*
     * ============================================================
     * ARRAY
     * ============================================================
     *
     * Convierte una lista de puntos.
     *
     * ============================================================
     */

    public static function points(
        input:Array<Dynamic>
    ):Array<Dynamic>
    {
        var result:Array<Dynamic> =
            [];


        if (input == null)
            return result;


        for (value in input)
        {
            var converted:Dynamic =
                fromPoint(value);


            if (converted != null)
                result.push(
                    converted
                );
        }


        return result;
    }


    /*
     * ============================================================
     * NOTE CORNERS
     * ============================================================
     *
     * Obtiene las esquinas transformadas de una Note3D y las
     * convierte al espacio del mundo.
     *
     * ============================================================
     */

    public static function noteCorners(
        note:Note3D
    ):Array<Dynamic>
    {
        var result:Array<Dynamic> =
            [];


        if (note == null)
            return result;


        var corners:Array<Dynamic> =
            note.getTransformedCorners();


        for (corner in corners)
        {
            result.push(
                point(
                    corner.x,
                    corner.y,
                    corner.z
                )
            );
        }


        return result;
    }


    /*
     * ============================================================
     * SET OFFSET
     * ============================================================
     */

    public static function setOffset(
        x:Float,
        y:Float,
        z:Float = 0
    ):Void
    {
        offsetX = x;
        offsetY = y;
        offsetZ = z;
    }


    /*
     * ============================================================
     * OFFSET X
     * ============================================================
     */

    public static function setOffsetX(
        value:Float
    ):Void
    {
        offsetX = value;
    }


    /*
     * ============================================================
     * OFFSET Y
     * ============================================================
 */

    public static function setOffsetY(
        value:Float
    ):Void
    {
        offsetY = value;
    }


    /*
     * ============================================================
     * OFFSET Z
     * ============================================================
     */

    public static function setOffsetZ(
        value:Float
    ):Void
    {
        offsetZ = value;
    }


    /*
     * ============================================================
     * SET SCALE
     * ============================================================
     */

    public static function setScale(
        x:Float,
        y:Float,
        z:Float = 1
    ):Void
    {
        scaleX = x;
        scaleY = y;
        scaleZ = z;
    }


    /*
     * ============================================================
     * SET UNIFORM SCALE
     * ============================================================
     */

    public static function setUniformScale(
        value:Float
    ):Void
    {
        scaleX = value;
        scaleY = value;
        scaleZ = value;
    }


    /*
     * ============================================================
     * SET DEFAULT Z
     * ============================================================
     */

    public static function setDefaultZ(
        value:Float
    ):Void
    {
        defaultZ = value;
    }


    /*
     * ============================================================
     * ADD WORLD OFFSET
     * ============================================================
     *
     * Añade un desplazamiento al offset global actual.
     *
     * ============================================================
     */

    public static function addOffset(
        x:Float,
        y:Float,
        z:Float = 0
    ):Void
    {
        offsetX += x;
        offsetY += y;
        offsetZ += z;
    }


    /*
     * ============================================================
     * RESET TRANSFORM
     * ============================================================
     */

    public static function resetTransform():Void
    {
        offsetX = 0;
        offsetY = 0;
        offsetZ = 0;

        scaleX = 1;
        scaleY = 1;
        scaleZ = 1;

        defaultZ = 0;
    }


    /*
     * ============================================================
     * GET WORLD CENTER
     * ============================================================
     *
     * Obtiene el centro del mundo.
     *
     * Normalmente coincide con el centro de la cámara,
     * pero se mantiene independiente.
     *
     * ============================================================
     */

    public static function getWorldCenter(
        width:Float,
        height:Float
    ):Dynamic
    {
        return point(
            width / 2,
            height / 2,
            0
        );
    }


    /*
     * ============================================================
     * LERP
     * ============================================================
     *
     * Interpolación lineal de dos puntos del mundo.
     *
     * ============================================================
     */

    public static function lerp(
        a:Dynamic,
        b:Dynamic,
        amount:Float
    ):Dynamic
    {
        if (a == null)
            return null;

        if (b == null)
            return null;


        if (amount < 0)
            amount = 0;

        if (amount > 1)
            amount = 1;


        return {
            x:
                a.x +
                (b.x - a.x) *
                amount,

            y:
                a.y +
                (b.y - a.y) *
                amount,

            z:
                a.z +
                (b.z - a.z) *
                amount
        };
    }


    /*
     * ============================================================
     * DISTANCE
     * ============================================================
     */

    public static function distance(
        a:Dynamic,
        b:Dynamic
    ):Float
    {
        if (a == null || b == null)
            return 0;


        var dx:Float =
            b.x - a.x;

        var dy:Float =
            b.y - a.y;

        var dz:Float =
            b.z - a.z;


        return Math.sqrt(
            dx * dx +
            dy * dy +
            dz * dz
        );
    }


    /*
     * ============================================================
     * RESET
     * ============================================================
     */

    public static function reset():Void
    {
        resetTransform();
    }
}