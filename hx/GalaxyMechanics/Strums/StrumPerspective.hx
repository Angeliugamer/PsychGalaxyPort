/*
 * ============================================================
 * StrumPerspective.hx
 * ============================================================
 *
 * FNF In The Galaxy -> Psych Engine 1.0.4
 *
 * Sistema de perspectiva 2D para Strums.
 *
 * ============================================================
 *
 * RESPONSABILIDAD:
 *
 *     - Simular profundidad mediante perspectiva 2D
 *     - Escalar strums según profundidad
 *     - Proyectar posiciones hacia un punto de fuga
 *     - Aplicar perspectiva horizontal/vertical
 *     - Crear formaciones con profundidad
 *     - Calcular offsets de perspectiva
 *     - Restaurar transformaciones originales
 *
 * ============================================================
 *
 * NO SE ENCARGA DE:
 *
 *     - Movimiento circular
 *     - Rotación normal
 *     - Render 3D real
 *     - Shaders
 *     - Blend modes
 *     - Window
 *     - Notas
 *
 * ============================================================
 *
 * NOTA:
 *
 * Este archivo NO intenta convertir los Strums en objetos 3D
 * reales.
 *
 * Es una capa de perspectiva 2D que puede utilizarse antes de
 * pasar a Galaxy3D.hx.
 *
 * ============================================================
 */

import flixel.FlxSprite;


/**
 * StrumPerspective
 *
 * Sistema de perspectiva 2D para receptors.
 */
class StrumPerspective
{
    /*
     * ============================================================
     * ESTADO ORIGINAL
     * ============================================================
     */

    private static var originalX:Map<Int, Float> =
        new Map<Int, Float>();


    private static var originalY:Map<Int, Float> =
        new Map<Int, Float>();


    private static var originalScaleX:Map<Int, Float> =
        new Map<Int, Float>();


    private static var originalScaleY:Map<Int, Float> =
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
     * GET SCALE X
     * ============================================================
 */

    private static function getScaleX(
        strum:Dynamic
    ):Float
    {
        if (strum == null)
            return 1;


        try
        {
            return strum.scale.x;
        }
        catch (e:Dynamic)
        {
            return 1;
        }
    }


    /*
     * ============================================================
     * GET SCALE Y
     * ============================================================
 */

    private static function getScaleY(
        strum:Dynamic
    ):Float
    {
        if (strum == null)
            return 1;


        try
        {
            return strum.scale.y;
        }
        catch (e:Dynamic)
        {
            return 1;
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
     * SET SCALE
     * ============================================================
 */

    private static function setScale(
        strum:Dynamic,
        scaleX:Float,
        scaleY:Float
    ):Void
    {
        if (strum == null)
            return;


        try
        {
            strum.scale.x =
                scaleX;

            strum.scale.y =
                scaleY;
        }
        catch (e:Dynamic)
        {
        }
    }


    /*
     * ============================================================
     * SAVE ORIGINAL
     * ============================================================
 */

    public static function saveOriginal(
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


        if (!originalScaleX.exists(index))
        {
            originalScaleX.set(
                index,
                getScaleX(strum)
            );
        }


        if (!originalScaleY.exists(index))
        {
            originalScaleY.set(
                index,
                getScaleY(strum)
            );
        }
    }


    /*
     * ============================================================
     * SAVE ALL
     * ============================================================
 */

    public static function saveAll(
        strums:Array<Dynamic>
    ):Void
    {
        if (strums == null)
            return;


        for (i in 0...strums.length)
        {
            saveOriginal(
                i,
                strums[i]
            );
        }
    }


    /*
     * ============================================================
     * PERSPECTIVE FACTOR
     * ============================================================
 *
 * Calcula:
 *
 *     factor = perspective / (perspective + depth)
 *
 * ============================================================
 */

    public static function perspectiveFactor(
        depth:Float,
        perspective:Float
    ):Float
    {
        if (perspective + depth == 0)
            return 1;


        return
            perspective /
            (perspective + depth);
    }


    /*
     * ============================================================
     * SAFE PERSPECTIVE FACTOR
     * ============================================================
 */

    public static function safePerspectiveFactor(
        depth:Float,
        perspective:Float,
        minimum:Float,
        maximum:Float
    ):Float
    {
        var factor:Float =
            perspectiveFactor(
                depth,
                perspective
            );


        if (factor < minimum)
            factor = minimum;


        if (factor > maximum)
            factor = maximum;


        return factor;
    }


    /*
     * ============================================================
     * PROJECT
     * ============================================================
 *
 * Proyecta un punto 2D utilizando profundidad.
 *
 * ============================================================
 */

    public static function project(
        x:Float,
        y:Float,
        centerX:Float,
        centerY:Float,
        depth:Float,
        perspective:Float
    ):Dynamic
    {
        var factor:Float =
            perspectiveFactor(
                depth,
                perspective
            );


        return {
            x:
                centerX +
                (x - centerX) *
                factor,

            y:
                centerY +
                (y - centerY) *
                factor,

            scale:
                factor
        };
    }


    /*
     * ============================================================
     * PROJECT WITH SCALE
     * ============================================================
 */

    public static function projectWithScale(
        x:Float,
        y:Float,
        centerX:Float,
        centerY:Float,
        depth:Float,
        perspective:Float,
        baseScaleX:Float,
        baseScaleY:Float
    ):Dynamic
    {
        var factor:Float =
            perspectiveFactor(
                depth,
                perspective
            );


        return {
            x:
                centerX +
                (x - centerX) *
                factor,

            y:
                centerY +
                (y - centerY) *
                factor,

            scaleX:
                baseScaleX *
                factor,

            scaleY:
                baseScaleY *
                factor,

            factor:
                factor
        };
    }


    /*
     * ============================================================
     * APPLY DEPTH
     * ============================================================
 *
 * Aplica perspectiva a un strum usando su posición original.
 *
 * ============================================================
 */

    public static function applyDepth(
        index:Int,
        strum:Dynamic,
        centerX:Float,
        centerY:Float,
        depth:Float,
        perspective:Float
    ):Void
    {
        if (strum == null)
            return;


        saveOriginal(
            index,
            strum
        );


        var result:Dynamic =
            projectWithScale(
                originalX.get(index),
                originalY.get(index),
                centerX,
                centerY,
                depth,
                perspective,
                originalScaleX.get(index),
                originalScaleY.get(index)
            );


        setX(
            strum,
            result.x
        );


        setY(
            strum,
            result.y
        );


        setScale(
            strum,
            result.scaleX,
            result.scaleY
        );
    }


    /*
     * ============================================================
     * APPLY DEPTH OFFSET
     * ============================================================
 *
 * Aplica perspectiva partiendo de la posición original y
 * permitiendo un desplazamiento adicional.
 *
 * ============================================================
 */

    public static function applyDepthOffset(
        index:Int,
        strum:Dynamic,
        centerX:Float,
        centerY:Float,
        depth:Float,
        perspective:Float,
        offsetX:Float,
        offsetY:Float
    ):Void
    {
        if (strum == null)
            return;


        saveOriginal(
            index,
            strum
        );


        var baseX:Float =
            originalX.get(index) +
            offsetX;


        var baseY:Float =
            originalY.get(index) +
            offsetY;


        var result:Dynamic =
            projectWithScale(
                baseX,
                baseY,
                centerX,
                centerY,
                depth,
                perspective,
                originalScaleX.get(index),
                originalScaleY.get(index)
            );


        setX(
            strum,
            result.x
        );


        setY(
            strum,
            result.y
        );


        setScale(
            strum,
            result.scaleX,
            result.scaleY
        );
    }


    /*
     * ============================================================
     * APPLY ALL DEPTH
     * ============================================================
 */

    public static function applyAllDepth(
        strums:Array<Dynamic>,
        centerX:Float,
        centerY:Float,
        depth:Float,
        perspective:Float
    ):Void
    {
        if (strums == null)
            return;


        saveAll(
            strums
        );


        for (i in 0...strums.length)
        {
            applyDepth(
                i,
                strums[i],
                centerX,
                centerY,
                depth,
                perspective
            );
        }
    }


    /*
     * ============================================================
     * APPLY DEPTH ARRAY
     * ============================================================
 *
 * Cada strum puede tener una profundidad diferente.
 *
 * ============================================================
 */

    public static function applyDepthArray(
        strums:Array<Dynamic>,
        centerX:Float,
        centerY:Float,
        depths:Array<Float>,
        perspective:Float
    ):Void
    {
        if (strums == null)
            return;


        if (depths == null)
            return;


        saveAll(
            strums
        );


        var length:Int =
            strums.length;


        if (depths.length < length)
            length =
                depths.length;


        for (i in 0...length)
        {
            applyDepth(
                i,
                strums[i],
                centerX,
                centerY,
                depths[i],
                perspective
            );
        }
    }


    /*
     * ============================================================
     * LINEAR DEPTH
     * ============================================================
 *
 * Distribuye profundidad progresivamente entre los strums.
 *
 * ============================================================
 */

    public static function linearDepth(
        strums:Array<Dynamic>,
        centerX:Float,
        centerY:Float,
        startDepth:Float,
        endDepth:Float,
        perspective:Float
    ):Void
    {
        if (strums == null)
            return;


        var count:Int =
            strums.length;


        if (count <= 0)
            return;


        saveAll(
            strums
        );


        if (count == 1)
        {
            applyDepth(
                0,
                strums[0],
                centerX,
                centerY,
                startDepth,
                perspective
            );


            return;
        }


        var step:Float =
            (endDepth - startDepth) /
            (count - 1);


        for (i in 0...count)
        {
            var depth:Float =
                startDepth +
                i * step;


            applyDepth(
                i,
                strums[i],
                centerX,
                centerY,
                depth,
                perspective
            );
        }
    }


    /*
     * ============================================================
     * DEPTH WAVE
     * ============================================================
 *
 * Profundidad basada en una onda sinusoidal.
 *
 * ============================================================
 */

    public static function depthWave(
        strums:Array<Dynamic>,
        centerX:Float,
        centerY:Float,
        baseDepth:Float,
        amplitude:Float,
        frequency:Float,
        phase:Float,
        perspective:Float
    ):Void
    {
        if (strums == null)
            return;


        saveAll(
            strums
        );


        for (i in 0...strums.length)
        {
            var depth:Float =
                baseDepth +
                Math.sin(
                    i * frequency +
                    phase
                ) *
                amplitude;


            applyDepth(
                i,
                strums[i],
                centerX,
                centerY,
                depth,
                perspective
            );
        }
    }


    /*
     * ============================================================
     * DEPTH WAVE TIME
     * ============================================================
 */

    public static function depthWaveTime(
        strums:Array<Dynamic>,
        centerX:Float,
        centerY:Float,
        baseDepth:Float,
        amplitude:Float,
        frequency:Float,
        speed:Float,
        time:Float,
        perspective:Float
    ):Void
    {
        var phase:Float =
            time * speed;


        depthWave(
            strums,
            centerX,
            centerY,
            baseDepth,
            amplitude,
            frequency,
            phase,
            perspective
        );
    }


    /*
     * ============================================================
     * SET SCALE FROM DEPTH
     * ============================================================
 *
 * Aplica únicamente escala basada en profundidad.
 *
 * ============================================================
 */

    public static function setScaleFromDepth(
        index:Int,
        strum:Dynamic,
        depth:Float,
        perspective:Float
    ):Void
    {
        if (strum == null)
            return;


        saveOriginal(
            index,
            strum
        );


        var factor:Float =
            perspectiveFactor(
                depth,
                perspective
            );


        setScale(
            strum,
            originalScaleX.get(index) *
            factor,

            originalScaleY.get(index) *
            factor
        );
    }


    /*
     * ============================================================
     * SET ALL SCALE FROM DEPTH
     * ============================================================
 */

    public static function setAllScaleFromDepth(
        strums:Array<Dynamic>,
        depth:Float,
        perspective:Float
    ):Void
    {
        if (strums == null)
            return;


        saveAll(
            strums
        );


        for (i in 0...strums.length)
        {
            setScaleFromDepth(
                i,
                strums[i],
                depth,
                perspective
            );
        }
    }


    /*
     * ============================================================
     * SET DEPTH WITH CUSTOM SCALE
     * ============================================================
 */

    public static function setDepthCustomScale(
        index:Int,
        strum:Dynamic,
        centerX:Float,
        centerY:Float,
        depth:Float,
        perspective:Float,
        scaleMultiplierX:Float,
        scaleMultiplierY:Float
    ):Void
    {
        if (strum == null)
            return;


        saveOriginal(
            index,
            strum
        );


        var factor:Float =
            perspectiveFactor(
                depth,
                perspective
            );


        var x:Float =
            centerX +
            (
                originalX.get(index) -
                centerX
            ) *
            factor;


        var y:Float =
            centerY +
            (
                originalY.get(index) -
                centerY
            ) *
            factor;


        setX(
            strum,
            x
        );


        setY(
            strum,
            y
        );


        setScale(
            strum,
            originalScaleX.get(index) *
            factor *
            scaleMultiplierX,

            originalScaleY.get(index) *
            factor *
            scaleMultiplierY
        );
    }


    /*
     * ============================================================
     * GET PERSPECTIVE FACTOR
     * ============================================================
 */

    public static function getStrumPerspectiveFactor(
        index:Int,
        strum:Dynamic,
        centerX:Float,
        centerY:Float,
        depth:Float,
        perspective:Float
    ):Float
    {
        if (strum == null)
            return 1;


        saveOriginal(
            index,
            strum
        );


        return perspectiveFactor(
            depth,
            perspective
        );
    }


    /*
     * ============================================================
     * GET CURRENT SCALE X
     * ============================================================
 */

    public static function getCurrentScaleX(
        strum:Dynamic
    ):Float
    {
        return getScaleX(
            strum
        );
    }


    /*
     * ============================================================
     * GET CURRENT SCALE Y
     * ============================================================
 */

    public static function getCurrentScaleY(
        strum:Dynamic
    ):Float
    {
        return getScaleY(
            strum
        );
    }


    /*
     * ============================================================
     * GET ORIGINAL SCALE X
     * ============================================================
 */

    public static function getOriginalScaleX(
        index:Int
    ):Float
    {
        if (!originalScaleX.exists(index))
            return 1;


        return originalScaleX.get(index);
    }


    /*
     * ============================================================
     * GET ORIGINAL SCALE Y
     * ============================================================
 */

    public static function getOriginalScaleY(
        index:Int
    ):Float
    {
        if (!originalScaleY.exists(index))
            return 1;


        return originalScaleY.get(index);
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


        if (!originalScaleX.exists(index))
            return;


        if (!originalScaleY.exists(index))
            return;


        setX(
            strum,
            originalX.get(index)
        );


        setY(
            strum,
            originalY.get(index)
        );


        setScale(
            strum,
            originalScaleX.get(index),
            originalScaleY.get(index)
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
     * CLEAR ORIGINAL DATA
     * ============================================================
 */

    public static function clearOriginalData():Void
    {
        originalX =
            new Map<Int, Float>();


        originalY =
            new Map<Int, Float>();


        originalScaleX =
            new Map<Int, Float>();


        originalScaleY =
            new Map<Int, Float>();
    }


    /*
     * ============================================================
     * CLEAR
     * ============================================================
 */

    public static function clear():Void
    {
        clearOriginalData();
    }
}