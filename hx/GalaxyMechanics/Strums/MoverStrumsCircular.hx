 /*
  * ============================================================
  * MoverStrumsCircular.hx
  * ============================================================
  *
  * FNF In The Galaxy -> Psych Engine 1.0.4
  *
  * Sistema independiente para movimiento circular/orbital
  * de Strums.
  *
  * ============================================================
  *
  * RESPONSABILIDAD:
  *
  *     - Movimiento circular
  *     - Movimiento orbital
  *     - Control de radio X/Y
  *     - Control de ángulo inicial
  *     - Control de velocidad angular
  *     - Movimiento circular basado en índice
  *     - Movimiento circular basado en tiempo
  *     - Movimiento circular alrededor de un centro
  *     - Restauración de posición original
  *
  * ============================================================
  *
  * NO SE ENCARGA DE:
  *
  *     - Cambiar angle del strum
  *     - Rotación visual
  *     - Perspectiva
  *     - 3D
  *     - Alpha
  *     - Notas
  *     - Sustains
  *     - Window
  *
  * ============================================================
  *
  * IMPORTANTE:
  *
  * Este sistema modifica solamente:
  *
  *     strum.x
  *     strum.y
  *
  * La rotación del receptor sigue siendo responsabilidad de:
  *
  *     RotarStrums.hx
  *
  * ============================================================
  */

import flixel.FlxSprite;


/**
 * MoverStrumsCircular
 *
 * Controlador de movimiento circular/orbital.
 */
class MoverStrumsCircular
{
    /*
     * ============================================================
     * POSICIONES ORIGINALES
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
        strum:Dynamic
    ):Float
    {
        if (strum == null)
            return 0;


        try
        {
            return strum.x;
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
        strum:Dynamic
    ):Float
    {
        if (strum == null)
            return 0;


        try
        {
            return strum.y;
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
        strum:Dynamic,
        value:Float
    ):Void
    {
        if (strum == null)
            return;


        try
        {
            strum.x =
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
        strum:Dynamic,
        value:Float
    ):Void
    {
        if (strum == null)
            return;


        try
        {
            strum.y =
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
     */

    public static function saveOriginalPosition(
        index:Int,
        strum:Dynamic
    ):Void
    {
        if (strum == null)
            return;


        if (!originalX.exists(index))
        {
            originalX.set(
                index,
                getX(strum)
            );
        }


        if (!originalY.exists(index))
        {
            originalY.set(
                index,
                getY(strum)
            );
        }
    }


    /*
     * ============================================================
     * SAVE ALL ORIGINAL POSITIONS
     * ============================================================
     */

    public static function saveAllOriginalPositions(
        strums:Array<Dynamic>
    ):Void
    {
        if (strums == null)
            return;


        for (i in 0...strums.length)
        {
            saveOriginalPosition(
                i,
                strums[i]
            );
        }
    }


    /*
     * ============================================================
     * SET CIRCULAR POSITION
     * ============================================================
     *
     * Coloca un strum en una posición circular.
     *
     * centerX:
     *     Centro X de la órbita.
     *
     * centerY:
     *     Centro Y de la órbita.
     *
     * radiusX:
     *     Radio horizontal.
     *
     * radiusY:
     *     Radio vertical.
     *
     * angle:
     *     Ángulo en grados.
     *
     * ============================================================
     */

    public static function setCircular(
        index:Int,
        strum:Dynamic,
        centerX:Float,
        centerY:Float,
        radiusX:Float,
        radiusY:Float,
        angle:Float
    ):Void
    {
        if (strum == null)
            return;


        saveOriginalPosition(
            index,
            strum
        );


        var radians:Float =
            angle * Math.PI / 180;


        var x:Float =
            centerX +
            Math.cos(radians) *
            radiusX;


        var y:Float =
            centerY +
            Math.sin(radians) *
            radiusY;


        setX(
            strum,
            x
        );


        setY(
            strum,
            y
        );
    }


    /*
     * ============================================================
     * SET CIRCULAR FROM ORIGINAL
     * ============================================================
     *
     * Utiliza la posición original del strum como centro.
     *
     * Esto es útil cuando queremos que cada receptor orbite
     * alrededor de su posición normal.
     *
     * ============================================================
     */

    public static function setCircularFromOriginal(
        index:Int,
        strum:Dynamic,
        radiusX:Float,
        radiusY:Float,
        angle:Float
    ):Void
    {
        if (strum == null)
            return;


        saveOriginalPosition(
            index,
            strum
        );


        var radians:Float =
            angle * Math.PI / 180;


        var x:Float =
            originalX.get(index) +
            Math.cos(radians) *
            radiusX;


        var y:Float =
            originalY.get(index) +
            Math.sin(radians) *
            radiusY;


        setX(
            strum,
            x
        );


        setY(
            strum,
            y
        );
    }


    /*
     * ============================================================
     * MOVE CIRCULAR
     * ============================================================
     *
     * Añade una posición circular a la posición original.
     *
     * Fórmula:
     *
     *     X = originalX + cos(angle) * radiusX
     *     Y = originalY + sin(angle) * radiusY
     *
     * ============================================================
     */

    public static function moveCircular(
        index:Int,
        strum:Dynamic,
        radiusX:Float,
        radiusY:Float,
        angle:Float
    ):Void
    {
        setCircularFromOriginal(
            index,
            strum,
            radiusX,
            radiusY,
            angle
        );
    }


    /*
     * ============================================================
     * SET ALL CIRCULAR
     * ============================================================
     *
     * Cada strum recibe el mismo ángulo.
     *
     * ============================================================
     */

    public static function setAllCircular(
        strums:Array<Dynamic>,
        centerX:Float,
        centerY:Float,
        radiusX:Float,
        radiusY:Float,
        angle:Float
    ):Void
    {
        if (strums == null)
            return;


        saveAllOriginalPositions(
            strums
        );


        for (i in 0...strums.length)
        {
            setCircular(
                i,
                strums[i],
                centerX,
                centerY,
                radiusX,
                radiusY,
                angle
            );
        }
    }


    /*
     * ============================================================
     * SET ALL CIRCULAR DISTRIBUTED
     * ============================================================
     *
     * Distribuye los strums alrededor de un círculo.
     *
     * Ejemplo con 4 strums:
     *
     *     0°
     *     90°
     *     180°
     *     270°
     *
     * ============================================================
     */

    public static function setAllCircularDistributed(
        strums:Array<Dynamic>,
        centerX:Float,
        centerY:Float,
        radiusX:Float,
        radiusY:Float,
        startAngle:Float
    ):Void
    {
        if (strums == null)
            return;


        var count:Int =
            strums.length;


        if (count <= 0)
            return;


        saveAllOriginalPositions(
            strums
        );


        var step:Float =
            360 / count;


        for (i in 0...count)
        {
            var angle:Float =
                startAngle +
                i * step;


            setCircular(
                i,
                strums[i],
                centerX,
                centerY,
                radiusX,
                radiusY,
                angle
            );
        }
    }


    /*
     * ============================================================
     * DISTRIBUTED FROM ORIGINAL
     * ============================================================
     *
     * Distribuye los strums alrededor de sus posiciones
     * originales utilizando un offset circular.
     *
     * ============================================================
     */

    public static function setAllCircularFromOriginal(
        strums:Array<Dynamic>,
        radiusX:Float,
        radiusY:Float,
        startAngle:Float
    ):Void
    {
        if (strums == null)
            return;


        var count:Int =
            strums.length;


        if (count <= 0)
            return;


        saveAllOriginalPositions(
            strums
        );


        var step:Float =
            360 / count;


        for (i in 0...count)
        {
            var angle:Float =
                startAngle +
                i * step;


            setCircularFromOriginal(
                i,
                strums[i],
                radiusX,
                radiusY,
                angle
            );
        }
    }


    /*
     * ============================================================
     * CIRCULAR WAVE
     * ============================================================
     *
     * Cada strum recibe un ángulo diferente.
     *
     * angle =
     *
     *     baseAngle +
     *     index * angleSpacing
     *
     * ============================================================
     */

    public static function circularWave(
        strums:Array<Dynamic>,
        radiusX:Float,
        radiusY:Float,
        baseAngle:Float,
        angleSpacing:Float
    ):Void
    {
        if (strums == null)
            return;


        saveAllOriginalPositions(
            strums
        );


        for (i in 0...strums.length)
        {
            var angle:Float =
                baseAngle +
                i * angleSpacing;


            setCircularFromOriginal(
                i,
                strums[i],
                radiusX,
                radiusY,
                angle
            );
        }
    }


    /*
     * ============================================================
     * CIRCULAR WAVE TIME
     * ============================================================
     *
     * Igual que circularWave pero añade movimiento temporal.
     *
     * angle =
     *
     *     baseAngle
     *     + index * angleSpacing
     *     + time * speed
     *
     * ============================================================
     */

    public static function circularWaveTime(
        strums:Array<Dynamic>,
        radiusX:Float,
        radiusY:Float,
        baseAngle:Float,
        angleSpacing:Float,
        speed:Float,
        time:Float
    ):Void
    {
        if (strums == null)
            return;


        var currentAngle:Float =
            baseAngle +
            time * speed;


        circularWave(
            strums,
            radiusX,
            radiusY,
            currentAngle,
            angleSpacing
        );
    }


    /*
     * ============================================================
     * ORBIT
     * ============================================================
     *
     * Hace que todos los strums giren alrededor de un centro
     * común.
     *
     * ============================================================
     */

    public static function orbit(
        strums:Array<Dynamic>,
        centerX:Float,
        centerY:Float,
        radiusX:Float,
        radiusY:Float,
        startAngle:Float,
        speed:Float,
        time:Float
    ):Void
    {
        if (strums == null)
            return;


        var angle:Float =
            startAngle +
            speed * time;


        setAllCircularDistributed(
            strums,
            centerX,
            centerY,
            radiusX,
            radiusY,
            angle
        );
    }


    /*
     * ============================================================
     * ORBIT FROM ORIGINAL
     * ============================================================
     *
     * Cada strum orbita alrededor de su posición original.
     *
     * ============================================================
     */

    public static function orbitFromOriginal(
        strums:Array<Dynamic>,
        radiusX:Float,
        radiusY:Float,
        startAngle:Float,
        speed:Float,
        time:Float
    ):Void
    {
        if (strums == null)
            return;


        var angle:Float =
            startAngle +
            speed * time;


        setAllCircularFromOriginal(
            strums,
            radiusX,
            radiusY,
            angle
        );
    }


    /*
     * ============================================================
     * SET INDIVIDUAL ANGLES
     * ============================================================
     *
     * Cada strum puede tener su propio ángulo.
     *
     * ============================================================
     */

    public static function setAngles(
        strums:Array<Dynamic>,
        centerX:Float,
        centerY:Float,
        radiusX:Float,
        radiusY:Float,
        angles:Array<Float>
    ):Void
    {
        if (strums == null)
            return;


        if (angles == null)
            return;


        saveAllOriginalPositions(
            strums
        );


        var length:Int =
            strums.length;


        if (angles.length < length)
            length =
                angles.length;


        for (i in 0...length)
        {
            setCircular(
                i,
                strums[i],
                centerX,
                centerY,
                radiusX,
                radiusY,
                angles[i]
            );
        }
    }


    /*
     * ============================================================
     * SET RADII
     * ============================================================
     *
     * Permite utilizar radios diferentes para cada strum.
     *
     * ============================================================
     */

    public static function setRadii(
        strums:Array<Dynamic>,
        centerX:Float,
        centerY:Float,
        radiusX:Array<Float>,
        radiusY:Array<Float>,
        startAngle:Float,
        angleSpacing:Float
    ):Void
    {
        if (strums == null)
            return;


        if (radiusX == null)
            return;


        if (radiusY == null)
            return;


        saveAllOriginalPositions(
            strums
        );


        var length:Int =
            strums.length;


        if (radiusX.length < length)
            length =
                radiusX.length;


        if (radiusY.length < length)
            length =
                radiusY.length;


        for (i in 0...length)
        {
            var angle:Float =
                startAngle +
                i * angleSpacing;


            setCircular(
                i,
                strums[i],
                centerX,
                centerY,
                radiusX[i],
                radiusY[i],
                angle
            );
        }
    }


    /*
     * ============================================================
     * RESTORE
     * ============================================================
     */

    public static function restore(
        index:Int,
        strum:Dynamic
    ):Void
    {
        if (strum == null)
            return;


        if (!originalX.exists(index))
            return;


        if (!originalY.exists(index))
            return;


        setX(
            strum,
            originalX.get(index)
        );


        setY(
            strum,
            originalY.get(index)
        );
    }


    /*
     * ============================================================
     * RESTORE ALL
     * ============================================================
     */

    public static function restoreAll(
        strums:Array<Dynamic>
    ):Void
    {
        if (strums == null)
            return;


        for (i in 0...strums.length)
        {
            restore(
                i,
                strums[i]
            );
        }
    }


    /*
     * ============================================================
     * GET CURRENT X
     * ============================================================
     */

    public static function getCurrentX(
        strum:Dynamic
    ):Float
    {
        return getX(
            strum
        );
    }


    /*
     * ============================================================
     * GET CURRENT Y
     * ============================================================
     */

    public static function getCurrentY(
        strum:Dynamic
    ):Float
    {
        return getY(
            strum
        );
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
     * GET OFFSET FROM ORIGINAL
     * ============================================================
 */

    public static function getOffsetFromOriginal(
        index:Int,
        strum:Dynamic
    ):Dynamic
    {
        if (strum == null)
            return null;


        if (
            !originalX.exists(index) ||
            !originalY.exists(index)
        )
        {
            return {
                x: 0,
                y: 0
            };
        }


        return {
            x:
                getX(strum) -
                originalX.get(index),

            y:
                getY(strum) -
                originalY.get(index)
        };
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
     * CLEAR
     * ============================================================
 */

    public static function clear():Void
    {
        clearOriginalPositions();
    }
}