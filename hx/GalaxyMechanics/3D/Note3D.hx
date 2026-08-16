/*
 * ============================================================
 * Note3D.hx
 * ============================================================
 *
 * FNF In The Galaxy -> Psych Engine 1.0.4
 *
 * Representación 3D de una Note/Sustain.
 *
 * ============================================================
 *
 * Este archivo NO dibuja la nota.
 *
 * Su responsabilidad es almacenar y manipular la información
 * 3D necesaria para posteriormente convertirla a pantalla.
 *
 * ============================================================
 *
 * DATOS:
 *
 *     X / Y / Z
 *
 *     Rotación X / Y / Z
 *
 *     Escala X / Y / Z
 *
 *     Anchor X / Y
 *
 *     NoteData
 *     MustPress
 *
 * ============================================================
 *
 * El flujo posterior será:
 *
 *     Note3D
 *        |
 *        v
 *     ToWorld
 *        |
 *        v
 *     Perspective
 *        |
 *        v
 *     ToScreen
 *        |
 *        v
 *     RenderPath
 *        |
 *        v
 *     OpenFL / Flixel
 *
 * ============================================================
 *
 * IMPORTANTE:
 *
 * Z positivo representa profundidad.
 *
 * El valor exacto de profundidad y la perspectiva final
 * serán definidos por Perspective.hx.
 *
 * ============================================================
 */

class Note3D
{
    /*
     * ============================================================
     * IDENTIFICACIÓN
     * ============================================================
     */

    /**
     * Índice de la nota dentro del chart.
     *
     * No necesariamente coincide con noteData.
     */
    public var index:Int = -1;


    /**
     * NoteData:
     *
     *     0 = LEFT
     *     1 = DOWN
     *     2 = UP
     *     3 = RIGHT
     */
    public var noteData:Int = -1;


    /**
     * true  = player note
     * false = opponent note
     */
    public var mustPress:Bool = false;


    /**
     * Indica si la nota es sustain.
     */
    public var isSustain:Bool = false;


    /*
     * ============================================================
     * POSICIÓN 3D
     * ============================================================
     *
     * Coordenadas locales/mundiales dependiendo de la etapa
     * de transformación.
     */

    public var x:Float = 0;
    public var y:Float = 0;
    public var z:Float = 0;


    /*
     * ============================================================
     * POSICIÓN ORIGINAL
     * ============================================================
     *
     * Permite volver a la posición antes de aplicar efectos 3D.
     */

    public var baseX:Float = 0;
    public var baseY:Float = 0;
    public var baseZ:Float = 0;


    /*
     * ============================================================
     * ROTACIÓN 3D
     * ============================================================
     *
     * Valores expresados en grados.
     */

    public var rotationX:Float = 0;
    public var rotationY:Float = 0;
    public var rotationZ:Float = 0;


    /*
     * ============================================================
     * ROTACIÓN BASE
     * ============================================================
     */

    public var baseRotationX:Float = 0;
    public var baseRotationY:Float = 0;
    public var baseRotationZ:Float = 0;


    /*
     * ============================================================
     * ESCALA 3D
     * ============================================================
     */

    public var scaleX:Float = 1;
    public var scaleY:Float = 1;
    public var scaleZ:Float = 1;


    /*
     * ============================================================
     * ESCALA BASE
     * ============================================================
     */

    public var baseScaleX:Float = 1;
    public var baseScaleY:Float = 1;
    public var baseScaleZ:Float = 1;


    /*
     * ============================================================
     * ANCHOR
     * ============================================================
     *
     * Punto alrededor del cual se aplican las rotaciones.
     *
     * Normalmente:
     *
     *     0.5, 0.5
     *
     * representa el centro.
     */

    public var anchorX:Float = 0.5;
    public var anchorY:Float = 0.5;


    /*
     * ============================================================
     * TAMAÑO
     * ============================================================
     *
     * Tamaño lógico de la superficie que representa la nota.
     */

    public var width:Float = 0;
    public var height:Float = 0;


    /*
     * ============================================================
     * VISUAL
     * ============================================================
     */

    public var alpha:Float = 1;

    public var visible:Bool = true;


    /*
     * ============================================================
     * PROFUNDIDAD / RENDER
     * ============================================================
     */

    /**
     * Factor de profundidad adicional.
     *
     * No es necesariamente el Z físico.
     */
    public var depth:Float = 0;


    /**
     * Indica si la nota está delante o detrás del plano
     * de cámara después de la transformación.
     */
    public var behindCamera:Bool = false;


    /**
     * Factor de perspectiva calculado por Perspective.hx.
     */
    public var perspective:Float = 1;


    /*
     * ============================================================
     * CONSTRUCTOR
     * ============================================================
     */

    public function new(
        noteData:Int = -1,
        mustPress:Bool = false,
        isSustain:Bool = false
    )
    {
        this.noteData = noteData;
        this.mustPress = mustPress;
        this.isSustain = isSustain;
    }


    /*
     * ============================================================
     * SET POSITION
     * ============================================================
     */

    public function setPosition(
        x:Float,
        y:Float,
        z:Float = 0
    ):Note3D
    {
        this.x = x;
        this.y = y;
        this.z = z;

        return this;
    }


    /*
     * ============================================================
     * SET BASE POSITION
     * ============================================================
     */

    public function setBasePosition(
        x:Float,
        y:Float,
        z:Float = 0
    ):Note3D
    {
        this.baseX = x;
        this.baseY = y;
        this.baseZ = z;

        return this;
    }


    /*
     * ============================================================
     * MOVE
     * ============================================================
     */

    public function move(
        x:Float,
        y:Float,
        z:Float = 0
    ):Note3D
    {
        this.x += x;
        this.y += y;
        this.z += z;

        return this;
    }


    /*
     * ============================================================
     * MOVE X
     * ============================================================
     */

    public function moveX(
        value:Float
    ):Note3D
    {
        x += value;

        return this;
    }


    /*
     * ============================================================
     * MOVE Y
     * ============================================================
     */

    public function moveY(
        value:Float
    ):Note3D
    {
        y += value;

        return this;
    }


    /*
     * ============================================================
     * MOVE Z
     * ============================================================
     */

    public function moveZ(
        value:Float
    ):Note3D
    {
        z += value;

        return this;
    }


    /*
     * ============================================================
     * SET ROTATION
     * ============================================================
     */

    public function setRotation(
        x:Float,
        y:Float,
        z:Float
    ):Note3D
    {
        rotationX = x;
        rotationY = y;
        rotationZ = z;

        return this;
    }


    /*
     * ============================================================
     * ROTATE
     * ============================================================
     */

    public function rotate(
        x:Float,
        y:Float,
        z:Float
    ):Note3D
    {
        rotationX += x;
        rotationY += y;
        rotationZ += z;

        return this;
    }


    /*
     * ============================================================
     * ROTATE X
     * ============================================================
     */

    public function rotateX(
        value:Float
    ):Note3D
    {
        rotationX += value;

        return this;
    }


    /*
     * ============================================================
     * ROTATE Y
     * ============================================================
 */

    public function rotateY(
        value:Float
    ):Note3D
    {
        rotationY += value;

        return this;
    }


    /*
     * ============================================================
     * ROTATE Z
     * ============================================================
     */

    public function rotateZ(
        value:Float
    ):Note3D
    {
        rotationZ += value;

        return this;
    }


    /*
     * ============================================================
     * SET SCALE
     * ============================================================
     */

    public function setScale(
        x:Float,
        y:Float,
        z:Float = 1
    ):Note3D
    {
        scaleX = x;
        scaleY = y;
        scaleZ = z;

        return this;
    }


    /*
     * ============================================================
     * SCALE
     * ============================================================
     */

    public function multiplyScale(
        x:Float,
        y:Float,
        z:Float = 1
    ):Note3D
    {
        scaleX *= x;
        scaleY *= y;
        scaleZ *= z;

        return this;
    }


    /*
     * ============================================================
     * SET SIZE
     * ============================================================
 */

    public function setSize(
        width:Float,
        height:Float
    ):Note3D
    {
        this.width = width;
        this.height = height;

        return this;
    }


    /*
     * ============================================================
     * SET ANCHOR
     * ============================================================
     */

    public function setAnchor(
        x:Float,
        y:Float
    ):Note3D
    {
        anchorX = x;
        anchorY = y;

        return this;
    }


    /*
     * ============================================================
     * RESET POSITION
     * ============================================================
     */

    public function resetPosition():Note3D
    {
        x = baseX;
        y = baseY;
        z = baseZ;

        return this;
    }


    /*
     * ============================================================
     * RESET ROTATION
     * ============================================================
     */

    public function resetRotation():Note3D
    {
        rotationX = baseRotationX;
        rotationY = baseRotationY;
        rotationZ = baseRotationZ;

        return this;
    }


    /*
     * ============================================================
     * RESET SCALE
     * ============================================================
     */

    public function resetScale():Note3D
    {
        scaleX = baseScaleX;
        scaleY = baseScaleY;
        scaleZ = baseScaleZ;

        return this;
    }


    /*
     * ============================================================
     * RESET
     * ============================================================
     *
     * Restaura todos los parámetros 3D a su estado base.
     */

    public function reset():Note3D
    {
        resetPosition();
        resetRotation();
        resetScale();

        alpha = 1;
        visible = true;

        depth = 0;
        perspective = 1;
        behindCamera = false;

        return this;
    }


    /*
     * ============================================================
     * SAVE AS BASE
     * ============================================================
     *
     * Guarda el estado actual como nuevo estado base.
     */

    public function saveAsBase():Note3D
    {
        baseX = x;
        baseY = y;
        baseZ = z;

        baseRotationX = rotationX;
        baseRotationY = rotationY;
        baseRotationZ = rotationZ;

        baseScaleX = scaleX;
        baseScaleY = scaleY;
        baseScaleZ = scaleZ;

        return this;
    }


    /*
     * ============================================================
     * COPY
     * ============================================================
     *
     * Crea una copia independiente.
     *
     * Esto será útil para efectos que necesiten generar
     * transformaciones temporales sin modificar el objeto
     * original.
     */

    public function clone():Note3D
    {
        var result:Note3D =
            new Note3D(
                noteData,
                mustPress,
                isSustain
            );


        result.index = index;

        result.x = x;
        result.y = y;
        result.z = z;

        result.baseX = baseX;
        result.baseY = baseY;
        result.baseZ = baseZ;

        result.rotationX = rotationX;
        result.rotationY = rotationY;
        result.rotationZ = rotationZ;

        result.baseRotationX =
            baseRotationX;

        result.baseRotationY =
            baseRotationY;

        result.baseRotationZ =
            baseRotationZ;

        result.scaleX = scaleX;
        result.scaleY = scaleY;
        result.scaleZ = scaleZ;

        result.baseScaleX =
            baseScaleX;

        result.baseScaleY =
            baseScaleY;

        result.baseScaleZ =
            baseScaleZ;

        result.anchorX = anchorX;
        result.anchorY = anchorY;

        result.width = width;
        result.height = height;

        result.alpha = alpha;
        result.visible = visible;

        result.depth = depth;
        result.behindCamera =
            behindCamera;

        result.perspective =
            perspective;

        return result;
    }


    /*
     * ============================================================
     * DISTANCE
     * ============================================================
     *
     * Distancia 3D entre esta nota y un punto.
     */

    public function distanceTo(
        x:Float,
        y:Float,
        z:Float
    ):Float
    {
        var dx:Float =
            this.x - x;

        var dy:Float =
            this.y - y;

        var dz:Float =
            this.z - z;


        return Math.sqrt(
            dx * dx +
            dy * dy +
            dz * dz
        );
    }


    /*
     * ============================================================
     * DISTANCE TO NOTE
     * ============================================================
     */

    public function distanceToNote(
        other:Note3D
    ):Float
    {
        if (other == null)
            return 0;

        return distanceTo(
            other.x,
            other.y,
            other.z
        );
    }


    /*
     * ============================================================
     * GET CENTER
     * ============================================================
     *
     * Devuelve el centro lógico de la nota.
     *
     * Esto NO tiene en cuenta perspectiva.
     */

    public function getCenter():Dynamic
    {
        return {
            x:
                x +
                width *
                (0.5 - anchorX),

            y:
                y +
                height *
                (0.5 - anchorY),

            z: z
        };
    }


    /*
     * ============================================================
     * GET CORNERS
     * ============================================================
     *
     * Genera las cuatro esquinas locales de la nota.
     *
     * El resultado está en formato:
     *
     *     [
     *         {x, y, z},
     *         {x, y, z},
     *         {x, y, z},
     *         {x, y, z}
     *     ]
     *
     * El orden es:
     *
     *     0 = top-left
     *     1 = top-right
     *     2 = bottom-left
     *     3 = bottom-right
     *
     * ============================================================
     */

    public function getCorners():Array<Dynamic>
    {
        var left:Float =
            -width * anchorX;

        var right:Float =
            width *
            (1 - anchorX);

        var top:Float =
            -height * anchorY;

        var bottom:Float =
            height *
            (1 - anchorY);


        return [
            {
                x: left,
                y: top,
                z: 0
            },

            {
                x: right,
                y: top,
                z: 0
            },

            {
                x: left,
                y: bottom,
                z: 0
            },

            {
                x: right,
                y: bottom,
                z: 0
            }
        ];
    }


    /*
     * ============================================================
     * ROTATE VECTOR X
     * ============================================================
     *
     * Rotación matemática sobre X.
     *
     * No modifica la nota.
     *
     * ============================================================
     */

    public static function rotateVectorX(
        point:Dynamic,
        angle:Float
    ):Dynamic
    {
        var rad:Float =
            angle *
            Math.PI /
            180;


        var cos:Float =
            Math.cos(rad);

        var sin:Float =
            Math.sin(rad);


        var y:Float =
            point.y * cos -
            point.z * sin;

        var z:Float =
            point.y * sin +
            point.z * cos;


        return {
            x: point.x,
            y: y,
            z: z
        };
    }


    /*
     * ============================================================
     * ROTATE VECTOR Y
     * ============================================================
     */

    public static function rotateVectorY(
        point:Dynamic,
        angle:Float
    ):Dynamic
    {
        var rad:Float =
            angle *
            Math.PI /
            180;


        var cos:Float =
            Math.cos(rad);

        var sin:Float =
            Math.sin(rad);


        var x:Float =
            point.x * cos +
            point.z * sin;

        var z:Float =
            -point.x * sin +
            point.z * cos;


        return {
            x: x,
            y: point.y,
            z: z
        };
    }


    /*
     * ============================================================
     * ROTATE VECTOR Z
     * ============================================================
     */

    public static function rotateVectorZ(
        point:Dynamic,
        angle:Float
    ):Dynamic
    {
        var rad:Float =
            angle *
            Math.PI /
            180;


        var cos:Float =
            Math.cos(rad);

        var sin:Float =
            Math.sin(rad);


        var x:Float =
            point.x * cos -
            point.y * sin;

        var y:Float =
            point.x * sin +
            point.y * cos;


        return {
            x: x,
            y: y,
            z: point.z
        };
    }


    /*
     * ============================================================
     * ROTATE VECTOR
     * ============================================================
     *
     * Aplica:
     *
     *     X
     *     Y
     *     Z
     *
     * en ese orden.
     *
     * ============================================================
     */

    public function transformPoint(
        point:Dynamic
    ):Dynamic
    {
        var result:Dynamic = {
            x:
                point.x *
                scaleX,

            y:
                point.y *
                scaleY,

            z:
                point.z *
                scaleZ
        };


        /*
         * Rotación X
         */
        result =
            rotateVectorX(
                result,
                rotationX
            );


        /*
         * Rotación Y
         */
        result =
            rotateVectorY(
                result,
                rotationY
            );


        /*
         * Rotación Z
         */
        result =
            rotateVectorZ(
                result,
                rotationZ
            );


        /*
         * Traslación
         */
        result.x += x;
        result.y += y;
        result.z += z;


        return result;
    }


    /*
     * ============================================================
     * GET TRANSFORMED CORNERS
     * ============================================================
     */

    public function getTransformedCorners():Array<Dynamic>
    {
        var corners:Array<Dynamic> =
            getCorners();

        var result:Array<Dynamic> =
            [];


        for (corner in corners)
        {
            result.push(
                transformPoint(
                    corner
                )
            );
        }


        return result;
    }


    /*
     * ============================================================
     * IS BEHIND CAMERA
     * ============================================================
     *
     * Esta función NO calcula perspectiva.
     *
     * Perspective.hx será quien establezca behindCamera.
     *
     * ============================================================
     */

    public function isBehindCamera():Bool
    {
        return behindCamera;
    }


    /*
     * ============================================================
     * SET PERSPECTIVE
     * ============================================================
     */

    public function setPerspective(
        value:Float
    ):Note3D
    {
        perspective =
            value;

        return this;
    }


    /*
     * ============================================================
     * SET DEPTH
     * ============================================================
     */

    public function setDepth(
        value:Float
    ):Note3D
    {
        depth =
            value;

        z =
            value;

        return this;
    }


    /*
     * ============================================================
     * TO STRING
     * ============================================================
     */

    public function toString():String
    {
        return
            "Note3D(" +
            "data=" + noteData +
            ", x=" + x +
            ", y=" + y +
            ", z=" + z +
            ", rotX=" + rotationX +
            ", rotY=" + rotationY +
            ", rotZ=" + rotationZ +
            ")";
    }
}