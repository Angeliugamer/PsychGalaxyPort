/*
 * ============================================================
 * Perspective.hx
 * ============================================================
 *
 * FNF In The Galaxy -> Psych Engine 1.0.4
 *
 * Sistema de perspectiva 3D -> 2D.
 *
 * ============================================================
 *
 * RESPONSABILIDAD:
 *
 *     - Definir la cámara/perspectiva
 *     - Convertir Z en un factor de escala
 *     - Proyectar puntos 3D a pantalla
 *     - Determinar profundidad
 *     - Calcular escala aparente
 *     - Calcular posición aparente
 *
 * ============================================================
 *
 * NO SE ENCARGA DE:
 *
 *     - Dibujar
 *     - Shaders
 *     - OpenFL drawTriangles
 *     - Manipular FlxSprite
 *     - Manipular Notes directamente
 *
 * ============================================================
 *
 * FLUJO:
 *
 *     Note3D
 *        |
 *        v
 *     Perspective
 *        |
 *        v
 *     ToScreen
 *        |
 *        v
 *     RenderPath
 *
 * ============================================================
 *
 * SISTEMA:
 *
 *     camera
 *          |
 *          v
 *
 *       X/Y
 *        |
 *        |       Z
 *        |      /
 *        |     /
 *        |    /
 *        v   v
 *       pantalla
 *
 * ============================================================
 */

class Perspective
{
    /*
     * ============================================================
     * CONFIGURACIÓN DE LA CÁMARA
     * ============================================================
     */

    /**
     * Distancia focal.
     *
     * Cuanto mayor sea:
     *
     *     - menor efecto de perspectiva
     *     - la cámara parece estar más lejos
     *
     * Cuanto menor sea:
     *
     *     - mayor efecto de perspectiva
     *
     * Un valor inicial razonable:
     *
     *     500
     */
    public static var focalLength:Float = 500;


    /**
     * Profundidad mínima antes de considerar que un punto
     * está demasiado cerca de la cámara.
     */
    public static var nearClip:Float = 1;


    /**
     * Profundidad máxima.
     *
     * Actualmente se utiliza como referencia para clipping
     * lógico y no como clipping de renderer.
     */
    public static var farClip:Float = 10000;


    /*
     * ============================================================
     * CENTRO DE PROYECCIÓN
     * ============================================================
     *
     * Normalmente será:
     *
     *     screenWidth / 2
     *     screenHeight / 2
     *
     * ============================================================
     */

    public static var centerX:Float = 0;
    public static var centerY:Float = 0;


    /*
     * ============================================================
     * POSICIÓN DE LA CÁMARA
     * ============================================================
     */

    public static var cameraX:Float = 0;
    public static var cameraY:Float = 0;
    public static var cameraZ:Float = 0;


    /*
     * ============================================================
     * ESCALA GLOBAL
     * ============================================================
     *
     * Permite hacer que todo el sistema 3D sea más grande o
     * pequeño sin modificar focalLength.
     *
     * ============================================================
     */

    public static var globalScale:Float = 1;


    /*
     * ============================================================
     * INVERSIÓN DE PROFUNDIDAD
     * ============================================================
     *
     * false:
     *
     *     Z positivo = más lejos
     *
     * true:
     *
     *     Z positivo = más cerca
     *
     * Esto nos permite adaptar posteriormente diferentes
     * convenciones utilizadas por distintos modcharts.
     *
     * ============================================================
     */

    public static var invertDepth:Bool = false;


    /*
     * ============================================================
     * CONSTRUCTOR
     * ============================================================
     *
     * Esta clase utiliza principalmente funciones estáticas,
     * pero dejamos constructor para poder crear configuraciones
     * independientes si posteriormente fueran necesarias.
     *
     * ============================================================
     */

    public function new()
    {
    }


    /*
     * ============================================================
     * SETUP
     * ============================================================
     *
     * Configuración rápida del sistema.
     *
     * ============================================================
     */

    public static function setup(
        width:Float,
        height:Float,
        focalLength:Float = 500
    ):Void
    {
        Perspective.centerX =
            width / 2;

        Perspective.centerY =
            height / 2;

        Perspective.focalLength =
            focalLength;
    }


    /*
     * ============================================================
     * SET CENTER
     * ============================================================
     */

    public static function setCenter(
        x:Float,
        y:Float
    ):Void
    {
        centerX = x;
        centerY = y;
    }


    /*
     * ============================================================
     * SET CAMERA
     * ============================================================
     */

    public static function setCamera(
        x:Float,
        y:Float,
        z:Float
    ):Void
    {
        cameraX = x;
        cameraY = y;
        cameraZ = z;
    }


    /*
     * ============================================================
     * SET FOCAL LENGTH
     * ============================================================
     */

    public static function setFocalLength(
        value:Float
    ):Void
    {
        if (value < 0.001)
            value = 0.001;

        focalLength = value;
    }


    /*
     * ============================================================
     * GET DEPTH
     * ============================================================
     *
     * Convierte la coordenada Z de un punto en profundidad
     * relativa a la cámara.
     *
     * ============================================================
     */

    public static function getDepth(
        z:Float
    ):Float
    {
        var depth:Float =
            z - cameraZ;


        if (invertDepth)
            depth = -depth;


        return depth;
    }


    /*
     * ============================================================
     * GET PERSPECTIVE SCALE
     * ============================================================
     *
     * Fórmula:
     *
     *              focalLength
     * scale = -----------------------
     *         focalLength + depth
     *
     * ============================================================
     *
     * Cuando depth = 0:
     *
     *     scale = 1
     *
     * Cuando depth aumenta:
     *
     *     scale disminuye
     *
     * ============================================================
     */

    public static function getScale(
        z:Float
    ):Float
    {
        var depth:Float =
            getDepth(z);


        var denominator:Float =
            focalLength +
            depth;


        if (denominator <= nearClip)
            denominator =
                nearClip;


        return (
            focalLength /
            denominator
        ) * globalScale;
    }


    /*
     * ============================================================
     * GET SCALE FROM DEPTH
     * ============================================================
     */

    public static function getScaleFromDepth(
        depth:Float
    ):Float
    {
        var denominator:Float =
            focalLength +
            depth;


        if (denominator <= nearClip)
            denominator =
                nearClip;


        return (
            focalLength /
            denominator
        ) * globalScale;
    }


    /*
     * ============================================================
     * PROJECT POINT
     * ============================================================
     *
     * Proyecta un punto 3D a pantalla.
     *
     * Entrada:
     *
     *     x
     *     y
     *     z
     *
     * Salida:
     *
     *     x
     *     y
     *     scale
     *     depth
     *
     * ============================================================
     */

    public static function projectPoint(
        x:Float,
        y:Float,
        z:Float
    ):Dynamic
    {
        var depth:Float =
            getDepth(z);


        var scale:Float =
            getScaleFromDepth(
                depth
            );


        var relativeX:Float =
            x - cameraX;

        var relativeY:Float =
            y - cameraY;


        var screenX:Float =
            centerX +
            relativeX *
            scale;


        var screenY:Float =
            centerY +
            relativeY *
            scale;


        return {
            x: screenX,
            y: screenY,
            z: z,
            depth: depth,
            scale: scale,
            visible:
                isDepthVisible(z)
        };
    }


    /*
     * ============================================================
     * PROJECT POINT OBJECT
     * ============================================================
     *
     * Versión que recibe:
     *
     *     { x, y, z }
     *
     * ============================================================
     */

    public static function project(
        point:Dynamic
    ):Dynamic
    {
        if (point == null)
            return null;


        return projectPoint(
            point.x,
            point.y,
            point.z
        );
    }


    /*
     * ============================================================
     * PROJECT NOTE
     * ============================================================
     *
     * Proyecta una Note3D sin modificarla.
     *
     * ============================================================
     */

    public static function projectNote(
        note:Note3D
    ):Dynamic
    {
        if (note == null)
            return null;


        var result:Dynamic =
            projectPoint(
                note.x,
                note.y,
                note.z
            );


        /*
         * Guardamos la información calculada en la nota.
         *
         * Esto no modifica su posición 3D original.
         */

        note.perspective =
            result.scale;

        note.depth =
            result.depth;

        note.behindCamera =
            !result.visible;


        return result;
    }


    /*
     * ============================================================
     * PROJECT CORNERS
     * ============================================================
     *
     * Proyecta las cuatro esquinas de una Note3D.
     *
     * Esto será utilizado posteriormente por RenderPath.
     *
     * ============================================================
     */

    public static function projectCorners(
        corners:Array<Dynamic>
    ):Array<Dynamic>
    {
        var result:Array<Dynamic> =
            [];


        if (corners == null)
            return result;


        for (corner in corners)
        {
            result.push(
                project(
                    corner
                )
            );
        }


        return result;
    }


    /*
     * ============================================================
     * PROJECT NOTE CORNERS
     * ============================================================
     */

    public static function projectNoteCorners(
        note:Note3D
    ):Array<Dynamic>
    {
        if (note == null)
            return [];


        var corners:Array<Dynamic> =
            note.getTransformedCorners();


        return projectCorners(
            corners
        );
    }


    /*
     * ============================================================
     * DEPTH VISIBILITY
     * ============================================================
     *
     * Determina si un punto está dentro del rango útil de
     * profundidad.
     *
     * ============================================================
     */

    public static function isDepthVisible(
        z:Float
    ):Bool
    {
        var depth:Float =
            getDepth(z);


        if (
            depth < -focalLength +
            nearClip
        )
        {
            return false;
        }


        if (depth > farClip)
            return false;


        return true;
    }


    /*
     * ============================================================
     * IS BEHIND CAMERA
     * ============================================================
     */

    public static function isBehindCamera(
        z:Float
    ):Bool
    {
        var depth:Float =
            getDepth(z);


        return (
            depth <
            -focalLength +
            nearClip
        );
    }


    /*
     * ============================================================
     * APPARENT WIDTH
     * ============================================================
     */

    public static function getApparentWidth(
        width:Float,
        z:Float
    ):Float
    {
        return width *
            getScale(z);
    }


    /*
     * ============================================================
     * APPARENT HEIGHT
     * ============================================================
     */

    public static function getApparentHeight(
        height:Float,
        z:Float
    ):Float
    {
        return height *
            getScale(z);
    }


    /*
     * ============================================================
     * APPARENT SIZE
     * ============================================================
     */

    public static function getApparentSize(
        width:Float,
        height:Float,
        z:Float
    ):Dynamic
    {
        var scale:Float =
            getScale(z);


        return {
            width:
                width * scale,

            height:
                height * scale,

            scale:
                scale
        };
    }


    /*
     * ============================================================
     * DEPTH SORT VALUE
     * ============================================================
     *
     * Devuelve un valor que puede utilizarse posteriormente
     * para ordenar objetos antes del render.
     *
     * ============================================================
     */

    public static function getSortValue(
        z:Float
    ):Float
    {
        return getDepth(z);
    }


    /*
     * ============================================================
     * INTERPOLATE DEPTH
     * ============================================================
     *
     * Convierte un rango de profundidad a 0..1.
     *
     * Ejemplo:
     *
     *     depth = near
     *         -> 0
     *
     *     depth = far
     *         -> 1
     *
     * ============================================================
     */

    public static function normalizeDepth(
        z:Float
    ):Float
    {
        var depth:Float =
            getDepth(z);


        var range:Float =
            farClip -
            0;


        if (range <= 0)
            return 0;


        var value:Float =
            depth /
            range;


        if (value < 0)
            value = 0;

        if (value > 1)
            value = 1;


        return value;
    }


    /*
     * ============================================================
     * DEPTH TO Z
     * ============================================================
     *
     * Convierte una profundidad relativa nuevamente a Z.
     *
     * ============================================================
     */

    public static function depthToZ(
        depth:Float
    ):Float
    {
        if (invertDepth)
            return cameraZ - depth;


        return cameraZ + depth;
    }


    /*
     * ============================================================
     * RESET
     * ============================================================
     */

    public static function reset():Void
    {
        focalLength = 500;

        nearClip = 1;

        farClip = 10000;

        centerX = 0;
        centerY = 0;

        cameraX = 0;
        cameraY = 0;
        cameraZ = 0;

        globalScale = 1;

        invertDepth = false;
    }
}