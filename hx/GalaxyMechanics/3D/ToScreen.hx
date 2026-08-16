/*
 * ============================================================
 * ToScreen.hx
 * ============================================================
 *
 * FNF In The Galaxy -> Psych Engine 1.0.4
 *
 * Conversión de coordenadas del mundo 3D -> pantalla 2D.
 *
 * ============================================================
 *
 * RESPONSABILIDAD:
 *
 *     - Utilizar Perspective.hx para proyectar puntos
 *     - Aplicar offset de pantalla
 *     - Aplicar escala de pantalla
 *     - Convertir puntos 3D a puntos 2D
 *     - Convertir esquinas de objetos 3D
 *     - Preparar información para RenderPath
 *
 * ============================================================
 *
 * NO SE ENCARGA DE:
 *
 *     - Crear sprites
 *     - Dibujar
 *     - Shaders
 *     - Blend modes
 *     - drawTriangles
 *     - Modificar Notes directamente
 *
 * ============================================================
 *
 * FLUJO:
 *
 *     ToWorld
 *         |
 *         v
 *       3D World
 *         |
 *         v
 *     Perspective
 *         |
 *         v
 *      ToScreen
 *         |
 *         v
 *      2D Points
 *         |
 *         v
 *     RenderPath
 *
 * ============================================================
 */

class ToScreen
{
    /*
     * ============================================================
     * CONFIGURACIÓN
     * ============================================================
     */

    /**
     * Offset adicional X de pantalla.
     *
     * Esto permite desplazar todo el sistema proyectado
     * sin modificar la cámara.
     */
    public static var offsetX:Float = 0;


    /**
     * Offset adicional Y de pantalla.
     */
    public static var offsetY:Float = 0;


    /**
     * Escala horizontal final.
     */
    public static var scaleX:Float = 1;


    /**
     * Escala vertical final.
     */
    public static var scaleY:Float = 1;


    /**
     * Si es true, se considera que las coordenadas recibidas
     * ya están proyectadas y no se vuelve a aplicar
     * Perspective.project().
     */
    public static var inputIsProjected:Bool = false;


    /**
     * Si está activo, los puntos se limitan al área visible
     * de la pantalla.
     *
     * Esto NO elimina puntos ni modifica el renderer.
     * Solamente marca el resultado como visible/invisible.
     */
    public static var screenClipping:Bool = false;


    /**
     * Tamaño de pantalla utilizado para clipping.
     */
    public static var screenWidth:Float = 1280;
    public static var screenHeight:Float = 720;


    /**
     * Margen adicional de clipping.
     *
     * Permite que objetos parcialmente fuera de pantalla
     * sigan considerándose visibles.
     */
    public static var clipMargin:Float = 256;


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
     * SET SCREEN SIZE
     * ============================================================
     */

    public static function setScreenSize(
        width:Float,
        height:Float
    ):Void
    {
        screenWidth =
            width;

        screenHeight =
            height;
    }


    /*
     * ============================================================
     * SET OFFSET
     * ============================================================
     */

    public static function setOffset(
        x:Float,
        y:Float
    ):Void
    {
        offsetX =
            x;

        offsetY =
            y;
    }


    /*
     * ============================================================
     * SET SCALE
     * ============================================================
 */

    public static function setScale(
        x:Float,
        y:Float
    ):Void
    {
        scaleX =
            x;

        scaleY =
            y;
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
        scaleX =
            value;

        scaleY =
            value;
    }


    /*
     * ============================================================
     * WORLD -> SCREEN
     * ============================================================
     *
     * Recibe:
     *
     *     X
     *     Y
     *     Z
     *
     * y devuelve:
     *
     *     X
     *     Y
     *     Z
     *     depth
     *     scale
     *     visible
     *
     * ============================================================
     */

    public static function point(
        x:Float,
        y:Float,
        z:Float = 0
    ):Dynamic
    {
        var projected:Dynamic;


        /*
         * Si el usuario ya proporcionó coordenadas proyectadas,
         * no volvemos a ejecutar Perspective.
         */
        if (inputIsProjected)
        {
            projected = {
                x: x,
                y: y,
                z: z,
                depth: 0,
                scale: 1,
                visible: true
            };
        }
        else
        {
            projected =
                Perspective.projectPoint(
                    x,
                    y,
                    z
                );
        }


        if (projected == null)
            return null;


        var finalX:Float =
            projected.x *
            scaleX +
            offsetX;


        var finalY:Float =
            projected.y *
            scaleY +
            offsetY;


        var visible:Bool =
            projected.visible;


        if (
            visible &&
            screenClipping
        )
        {
            visible =
                isOnScreen(
                    finalX,
                    finalY
                );
        }


        return {
            x: finalX,
            y: finalY,
            z: projected.z,
            depth: projected.depth,
            scale: projected.scale,
            visible: visible
        };
    }


    /*
     * ============================================================
     * PROJECTED POINT -> SCREEN
     * ============================================================
     *
     * Utilizado cuando Perspective ya hizo el cálculo.
     *
     * ============================================================
     */

    public static function projectedPoint(
        point:Dynamic
    ):Dynamic
    {
        if (point == null)
            return null;


        var finalX:Float =
            point.x *
            scaleX +
            offsetX;


        var finalY:Float =
            point.y *
            scaleY +
            offsetY;


        var visible:Bool =
            true;


        if (
            Reflect.hasField(
                point,
                "visible"
            )
        )
        {
            visible =
                point.visible;
        }


        if (
            visible &&
            screenClipping
        )
        {
            visible =
                isOnScreen(
                    finalX,
                    finalY
                );
        }


        return {
            x: finalX,
            y: finalY,
            z:
                Reflect.hasField(
                    point,
                    "z"
                )
                    ? point.z
                    : 0,

            depth:
                Reflect.hasField(
                    point,
                    "depth"
                )
                    ? point.depth
                    : 0,

            scale:
                Reflect.hasField(
                    point,
                    "scale"
                )
                    ? point.scale
                    : 1,

            visible: visible
        };
    }


    /*
     * ============================================================
     * OBJECT -> SCREEN
     * ============================================================
     *
     * Recibe:
     *
     *     {x, y, z}
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
            0;


        if (
            Reflect.hasField(
                value,
                "z"
            )
        )
        {
            z =
                value.z;
        }


        return point(
            value.x,
            value.y,
            z
        );
    }


    /*
     * ============================================================
     * ARRAY -> SCREEN
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
                fromPoint(
                    value
                );


            if (converted != null)
            {
                result.push(
                    converted
                );
            }
        }


        return result;
    }


    /*
     * ============================================================
     * NOTE -> SCREEN
     * ============================================================
     *
     * Proyecta el centro lógico de una Note3D.
     *
     * ============================================================
     */

    public static function note(
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
     * NOTE CORNERS -> SCREEN
     * ============================================================
     *
     * Convierte las cuatro esquinas transformadas de una nota.
     *
     * Resultado:
     *
     *     0 = top-left
     *     1 = top-right
     *     2 = bottom-left
     *     3 = bottom-right
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
            var screenPoint:Dynamic =
                point(
                    corner.x,
                    corner.y,
                    corner.z
                );


            if (screenPoint != null)
            {
                result.push(
                    screenPoint
                );
            }
        }


        return result;
    }


    /*
     * ============================================================
     * PROJECT + SCREEN
     * ============================================================
     *
     * Ejecuta explícitamente:
     *
     *     Perspective
     *         +
     *     ToScreen
     *
     * ============================================================
     */

    public static function project(
        point3D:Dynamic
    ):Dynamic
    {
        if (point3D == null)
            return null;


        var projected:Dynamic =
            Perspective.project(
                point3D
            );


        return projectedPoint(
            projected
        );
    }


    /*
     * ============================================================
     * PROJECT ARRAY
     * ============================================================
     */

    public static function projectPoints(
        points3D:Array<Dynamic>
    ):Array<Dynamic>
    {
        var result:Array<Dynamic> =
            [];


        if (points3D == null)
            return result;


        for (point3D in points3D)
        {
            var projected:Dynamic =
                project(
                    point3D
                );


            if (projected != null)
            {
                result.push(
                    projected
                );
            }
        }


        return result;
    }


    /*
     * ============================================================
     * IS ON SCREEN
     * ============================================================
     *
     * Comprueba si un punto está dentro del área visible.
     *
     * El margen evita descartar prematuramente objetos que
     * solamente están parcialmente fuera de pantalla.
     *
     * ============================================================
     */

    public static function isOnScreen(
        x:Float,
        y:Float
    ):Bool
    {
        return (
            x >= -clipMargin &&
            x <= screenWidth + clipMargin &&
            y >= -clipMargin &&
            y <= screenHeight + clipMargin
        );
    }


    /*
     * ============================================================
     * IS RECTANGLE ON SCREEN
     * ============================================================
     *
     * Comprueba un rectángulo.
     *
     * ============================================================
     */

    public static function isRectangleOnScreen(
        x:Float,
        y:Float,
        width:Float,
        height:Float
    ):Bool
    {
        return !(
            x + width < -clipMargin ||
            y + height < -clipMargin ||
            x > screenWidth + clipMargin ||
            y > screenHeight + clipMargin
        );
    }


    /*
     * ============================================================
     * GET BOUNDING BOX
     * ============================================================
     *
     * Recibe una lista de puntos 2D y devuelve:
     *
     *     minX
     *     minY
     *     maxX
     *     maxY
     *     width
     *     height
     *
     * ============================================================
     */

    public static function getBounds(
        points:Array<Dynamic>
    ):Dynamic
    {
        if (
            points == null ||
            points.length == 0
        )
        {
            return {
                minX: 0,
                minY: 0,
                maxX: 0,
                maxY: 0,
                width: 0,
                height: 0
            };
        }


        var minX:Float =
            Math.POSITIVE_INFINITY;

        var minY:Float =
            Math.POSITIVE_INFINITY;

        var maxX:Float =
            Math.NEGATIVE_INFINITY;

        var maxY:Float =
            Math.NEGATIVE_INFINITY;


        for (point in points)
        {
            if (point == null)
                continue;


            if (point.x < minX)
                minX = point.x;

            if (point.y < minY)
                minY = point.y;

            if (point.x > maxX)
                maxX = point.x;

            if (point.y > maxY)
                maxY = point.y;
        }


        return {
            minX: minX,
            minY: minY,
            maxX: maxX,
            maxY: maxY,

            width:
                maxX - minX,

            height:
                maxY - minY
        };
    }


    /*
     * ============================================================
     * NOTE BOUNDS
     * ============================================================
     */

    public static function getNoteBounds(
        note:Note3D
    ):Dynamic
    {
        if (note == null)
            return {
                minX: 0,
                minY: 0,
                maxX: 0,
                maxY: 0,
                width: 0,
                height: 0
            };


        var corners:Array<Dynamic> =
            noteCorners(
                note
            );


        return getBounds(
            corners
        );
    }


    /*
     * ============================================================
     * IS NOTE ON SCREEN
     * ============================================================
     */

    public static function isNoteOnScreen(
        note:Note3D
    ):Bool
    {
        if (note == null)
            return false;


        var corners:Array<Dynamic> =
            noteCorners(
                note
            );


        if (
            corners == null ||
            corners.length == 0
        )
        {
            return false;
        }


        var bounds:Dynamic =
            getBounds(
                corners
            );


        return isRectangleOnScreen(
            bounds.minX,
            bounds.minY,
            bounds.width,
            bounds.height
        );
    }


    /*
     * ============================================================
     * GET APPARENT SIZE
     * ============================================================
     *
     * Calcula el tamaño aparente de un objeto según su Z.
     *
     * ============================================================
     */

    public static function getApparentSize(
        width:Float,
        height:Float,
        z:Float
    ):Dynamic
    {
        var projectedScale:Float =
            Perspective.getScale(
                z
            );


        return {
            width:
                width *
                projectedScale *
                scaleX,

            height:
                height *
                projectedScale *
                scaleY,

            scale:
                projectedScale
        };
    }


    /*
     * ============================================================
     * GET DEPTH
     * ============================================================
     */

    public static function getDepth(
        z:Float
    ):Float
    {
        return Perspective.getDepth(
            z
        );
    }


    /*
     * ============================================================
     * GET PERSPECTIVE SCALE
     * ============================================================
     */

    public static function getPerspectiveScale(
        z:Float
    ):Float
    {
        return Perspective.getScale(
            z
        );
    }


    /*
     * ============================================================
     * SET INPUT MODE
     * ============================================================
     */

    public static function setInputProjected(
        value:Bool
    ):Void
    {
        inputIsProjected =
            value;
    }


    /*
     * ============================================================
     * SET CLIPPING
     * ============================================================
 */

    public static function setClipping(
        value:Bool
    ):Void
    {
        screenClipping =
            value;
    }


    /*
     * ============================================================
     * SET CLIP MARGIN
     * ============================================================
     */

    public static function setClipMargin(
        value:Float
    ):Void
    {
        clipMargin =
            value;
    }


    /*
     * ============================================================
     * RESET
     * ============================================================
     */

    public static function reset():Void
    {
        offsetX = 0;
        offsetY = 0;

        scaleX = 1;
        scaleY = 1;

        inputIsProjected = false;

        screenClipping = false;

        screenWidth = 1280;
        screenHeight = 720;

        clipMargin = 256;
    }
}