/*
 * ============================================================
 * OverlayShader.hx
 * ============================================================
 *
 * FNF In The Galaxy -> Psych Engine 1.0.4
 *
 * Port del OverlayShader original de GalaxyMod.
 *
 * El shader original implementa un efecto de "lighten/overlay"
 * utilizando:
 *
 *     uniform vec4 uBlendColor;
 *
 * y la textura actual:
 *
 *     bitmap
 *
 * ============================================================
 *
 * En este port el código GLSL NO se encuentra embebido aquí.
 *
 * El fragment shader se encuentra en:
 *
 *     FNGalaxy Port/shaders/GalaxyOverlay.frag
 *
 * ============================================================
 *
 * Esta clase se encarga únicamente de:
 *
 *     - Crear el shader
 *     - Acceder a uBlendColor
 *     - Cambiar el color del overlay
 *     - Cambiar su alpha
 *
 * La aplicación del shader a sprites/cámaras corresponde a
 * BlendModeEffect.hx / GalaxyShader.hx.
 *
 * ============================================================
 */

import flixel.system.FlxAssets.FlxShader;


class OverlayShader extends FlxShader
{
    /*
     * ============================================================
     * CONSTRUCTOR
     * ============================================================
     */

    public function new()
    {
        super();
    }


    /*
     * ============================================================
     * SET BLEND COLOR
     * ============================================================
     *
     * Valores:
     *
     *     r = 0..255 o 0..1
     *     g = 0..255 o 0..1
     *     b = 0..255 o 0..1
     *     a = 0..1
     *
     * Internamente el shader utiliza:
     *
     *     uBlendColor = vec4(r, g, b, a)
     *
     * ============================================================
     */

    public function setBlendColor(
        r:Float,
        g:Float,
        b:Float,
        a:Float = 1
    ):Void
    {
        r = normalizeColor(r);
        g = normalizeColor(g);
        b = normalizeColor(b);

        a = clamp(
            a,
            0,
            1
        );


        if (data.uBlendColor != null)
        {
            data.uBlendColor.value = [
                r,
                g,
                b,
                a
            ];
        }
    }


    /*
     * ============================================================
     * SET BLEND COLOR HEX
     * ============================================================
     *
     * Ejemplo:
     *
     *     shader.setBlendColorHex(
     *         0xFF0000,
     *         0.5
     *     );
     *
     * ============================================================
     */

    public function setBlendColorHex(
        color:Int,
        alpha:Float = 1
    ):Void
    {
        var r:Int =
            (color >> 16) & 0xFF;

        var g:Int =
            (color >> 8) & 0xFF;

        var b:Int =
            color & 0xFF;


        setBlendColor(
            r,
            g,
            b,
            alpha
        );
    }


    /*
     * ============================================================
     * SET RED
     * ============================================================
     */

    public function setRed(
        value:Float
    ):Void
    {
        var color:Array<Float> =
            getBlendColor();

        setBlendColor(
            value,
            color[1],
            color[2],
            color[3]
        );
    }


    /*
     * ============================================================
     * SET GREEN
     * ============================================================
     */

    public function setGreen(
        value:Float
    ):Void
    {
        var color:Array<Float> =
            getBlendColor();

        setBlendColor(
            color[0],
            value,
            color[2],
            color[3]
        );
    }


    /*
     * ============================================================
     * SET BLUE
     * ============================================================
     */

    public function setBlue(
        value:Float
    ):Void
    {
        var color:Array<Float> =
            getBlendColor();

        setBlendColor(
            color[0],
            color[1],
            value,
            color[3]
        );
    }


    /*
     * ============================================================
     * SET ALPHA
     * ============================================================
     */

    public function setAlpha(
        value:Float
    ):Void
    {
        var color:Array<Float> =
            getBlendColor();

        setBlendColor(
            color[0],
            color[1],
            color[2],
            value
        );
    }


    /*
     * ============================================================
     * GET BLEND COLOR
     * ============================================================
     *
     * Devuelve:
     *
     *     [r, g, b, a]
     *
     * en rango 0..1.
     *
     * ============================================================
     */

    public function getBlendColor():Array<Float>
    {
        if (data.uBlendColor == null)
        {
            return [
                0,
                0,
                0,
                0
            ];
        }


        var value:Dynamic =
            data.uBlendColor.value;


        if (value == null)
        {
            return [
                0,
                0,
                0,
                0
            ];
        }


        return cast value;
    }


    /*
     * ============================================================
     * NORMALIZE COLOR
     * ============================================================
     *
     * Permite utilizar tanto:
     *
     *     255
     *
     * como:
     *
     *     1
     *
     * ============================================================
     */

    private function normalizeColor(
        value:Float
    ):Float
    {
        if (value > 1)
            value /= 255;

        return clamp(
            value,
            0,
            1
        );
    }


    /*
     * ============================================================
     * CLAMP
     * ============================================================
     */

    private function clamp(
        value:Float,
        min:Float,
        max:Float
    ):Float
    {
        if (value < min)
            return min;

        if (value > max)
            return max;

        return value;
    }
}