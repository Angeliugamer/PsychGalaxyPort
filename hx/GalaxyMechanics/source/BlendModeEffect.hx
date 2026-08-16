/*
 * ============================================================
 * BlendModeEffect.hx
 * ============================================================
 *
 * FNF In The Galaxy -> Psych Engine 1.0.4
 *
 * Wrapper reutilizable para efectos de Blend mediante shaders.
 *
 * El shader .frag NO se encuentra aquí.
 *
 * Los shaders estarán en:
 *
 *     FNGalaxy Port/shaders/
 *
 * Este archivo se encarga de:
 *
 *     - Crear el shader
 *     - Configurar uBlendColor
 *     - Configurar alpha
 *     - Aplicar el shader a un FlxSprite
 *     - Aplicarlo a una cámara
 *     - Quitar el efecto
 *
 * ============================================================
 *
 * IMPORTANTE:
 *
 * BlendModeEffect NO decide qué blend utilizar.
 *
 * El comportamiento real del blend depende del .frag.
 *
 * Por ejemplo:
 *
 *     GalaxyBlendLighten.frag
 *     GalaxyBlendAdd.frag
 *     GalaxyBlendMultiply.frag
 *
 * pueden utilizar exactamente esta misma clase.
 *
 * ============================================================
 */

import flixel.FlxSprite;
import flixel.FlxCamera;
import openfl.filters.ShaderFilter;
import openfl.display.Shader;


class BlendModeEffect
{
    /*
     * ============================================================
     * SHADERS ACTIVOS
     * ============================================================
     *
     * Guardamos los shaders por nombre para poder reutilizarlos
     * desde Lua/HScript sin tener que crearlos nuevamente.
     *
     * Ejemplo:
     *
     *     BlendModeEffect.create("cyber", shader);
     *
     * ============================================================
     */

    private static var shaders:Map<String, Shader> =
        new Map<String, Shader>();


    /*
     * ============================================================
     * COLORES
     * ============================================================
     *
     * Color almacenado en formato:
     *
     *     RGB = 0..255
     *     A   = 0..1
     *
     * El shader recibe:
     *
     *     RGB = 0..1
     *     A   = 0..1
     * ============================================================
     */


    /*
     * ============================================================
     * CREATE
     * ============================================================
     *
     * Registra un Shader ya creado.
     *
     * Esto permite que GalaxyShader.hx sea responsable de cargar
     * el archivo .frag mientras BlendModeEffect se ocupa
     * exclusivamente del blend.
     *
     * ============================================================
     */

    public static function create(
        id:String,
        shader:Shader
    ):Shader
    {
        if (id == null ||
            shader == null)
        {
            return null;
        }

        shaders.set(
            id,
            shader
        );

        return shader;
    }


    /*
     * ============================================================
     * GET
     * ============================================================
     */

    public static function get(
        id:String
    ):Shader
    {
        if (id == null)
            return null;

        return shaders.get(id);
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
        return id != null &&
               shaders.exists(id);
    }


    /*
     * ============================================================
     * SET BLEND COLOR
     * ============================================================
     *
     * El GalaxyMod original utiliza un parámetro:
     *
     *     uBlendColor
     *
     * para enviar el color al shader.
     *
     * Aquí mantenemos ese mismo nombre para facilitar el port.
     *
     * ============================================================
     */

    public static function setBlendColor(
        id:String,
        r:Float,
        g:Float,
        b:Float,
        a:Float = 1
    ):Void
    {
        var shader:Shader =
            get(id);

        if (shader == null)
            return;


        /*
         * Convertir 0..255 -> 0..1
         *
         * Si el usuario ya proporciona valores 0..1,
         * también los aceptamos.
         */
        r = normalizeColor(r);
        g = normalizeColor(g);
        b = normalizeColor(b);

        a = clamp(
            a,
            0,
            1
        );


        setUniform4(
            shader,
            "uBlendColor",
            r,
            g,
            b,
            a
        );
    }


    /*
     * ============================================================
     * SET BLEND COLOR HEX
     * ============================================================
     *
     * Permite utilizar:
     *
     *     0xFF0000
     *
     * en lugar de:
     *
     *     255, 0, 0
     *
     * ============================================================
     */

    public static function setBlendColorHex(
        id:String,
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
            id,
            r,
            g,
            b,
            alpha
        );
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
        var shader:Shader =
            get(id);

        if (shader == null)
            return;


        alpha =
            clamp(
                alpha,
                0,
                1
            );


        /*
         * Intentamos modificar solamente el alpha
         * del blend color existente.
         */
        var parameter:Dynamic =
            Reflect.field(
                shader.data,
                "uBlendColor"
            );


        if (parameter == null)
            return;


        var current:Array<Float> =
            getParameterValue(
                parameter
            );


        if (current == null ||
            current.length < 4)
        {
            setUniform4(
                shader,
                "uBlendColor",
                0,
                0,
                0,
                alpha
            );

            return;
        }


        setUniform4(
            shader,
            "uBlendColor",
            current[0],
            current[1],
            current[2],
            alpha
        );
    }


    /*
     * ============================================================
     * APPLY TO SPRITE
     * ============================================================
     */

    public static function applyToSprite(
        id:String,
        sprite:FlxSprite
    ):Void
    {
        if (sprite == null)
            return;


        var shader:Shader =
            get(id);

        if (shader == null)
            return;


        sprite.shader =
            shader;
    }


    /*
     * ============================================================
     * REMOVE FROM SPRITE
     * ============================================================
     */

    public static function removeFromSprite(
        sprite:FlxSprite
    ):Void
    {
        if (sprite == null)
            return;

        sprite.shader = null;
    }


    /*
     * ============================================================
     * APPLY TO CAMERA
     * ============================================================
     *
     * Psych/OpenFL maneja los shaders de cámara mediante
     * ShaderFilter.
     *
     * ============================================================
     */

    public static function applyToCamera(
        id:String,
        camera:FlxCamera
    ):Void
    {
        if (camera == null)
            return;


        var shader:Shader =
            get(id);

        if (shader == null)
            return;


        var filter:ShaderFilter =
            new ShaderFilter(
                shader
            );


        /*
         * Conservamos filtros existentes.
         *
         * Esto es importante porque una cámara puede tener
         * otros shaders/filtros activos.
         */
        var filters:Array<Dynamic> =
            camera.filters;


        if (filters == null)
            filters = [];


        filters.push(filter);

        camera.filters =
            filters;
    }


    /*
     * ============================================================
     * REMOVE FROM CAMERA
     * ============================================================
     */

    public static function removeFromCamera(
        id:String,
        camera:FlxCamera
    ):Void
    {
        if (camera == null)
            return;


        var shader:Shader =
            get(id);

        if (shader == null)
            return;


        var filters:Array<Dynamic> =
            camera.filters;

        if (filters == null)
            return;


        var result:Array<Dynamic> =
            [];


        for (filter in filters)
        {
            if (filter == null)
                continue;


            /*
             * Solo eliminamos el ShaderFilter que utiliza
             * exactamente nuestro shader.
             */
            if (Std.isOfType(
                filter,
                ShaderFilter
            ))
            {
                var shaderFilter:ShaderFilter =
                    cast filter;


                if (shaderFilter.shader == shader)
                    continue;
            }


            result.push(
                filter
            );
        }


        camera.filters =
            result;
    }


    /*
     * ============================================================
     * CLEAR CAMERA FILTERS
     * ============================================================
     *
     * ATENCIÓN:
     *
     * Esto elimina TODOS los filtros de la cámara.
     *
     * Se deja como función explícita porque puede ser útil
     * durante el desarrollo, pero no debe utilizarse si hay
     * otros shaders activos.
     * ============================================================
     */

    public static function clearCamera(
        camera:FlxCamera
    ):Void
    {
        if (camera == null)
            return;

        camera.filters = [];
    }


    /*
     * ============================================================
     * REMOVE SHADER
     * ============================================================
     *
     * Elimina el shader del registro.
     *
     * No elimina automáticamente el shader de sprites/cámaras
     * donde ya haya sido aplicado.
     * ============================================================
     */

    public static function remove(
        id:String
    ):Void
    {
        if (id == null)
            return;

        shaders.remove(id);
    }


    /*
     * ============================================================
     * CLEAR
     * ============================================================
     */

    public static function clear():Void
    {
        shaders.clear();
    }


    /*
     * ============================================================
     * SET UNIFORM FLOAT
     * ============================================================
     *
     * Utilidad para futuros shaders de blend que necesiten
     * parámetros adicionales.
     * ============================================================
     */

    public static function setFloat(
        id:String,
        uniform:String,
        value:Float
    ):Void
    {
        var shader:Shader =
            get(id);

        if (shader == null)
            return;


        var parameter:Dynamic =
            Reflect.field(
                shader.data,
                uniform
            );

        if (parameter == null)
            return;


        parameter.value =
            [value];
    }


    /*
     * ============================================================
     * SET BOOL
     * ============================================================
     */

    public static function setBool(
        id:String,
        uniform:String,
        value:Bool
    ):Void
    {
        setFloat(
            id,
            uniform,
            value ? 1 : 0
        );
    }


    /*
     * ============================================================
     * SET VECTOR 2
     * ============================================================
     */

    public static function setVector2(
        id:String,
        uniform:String,
        x:Float,
        y:Float
    ):Void
    {
        var shader:Shader =
            get(id);

        if (shader == null)
            return;


        var parameter:Dynamic =
            Reflect.field(
                shader.data,
                uniform
            );

        if (parameter == null)
            return;


        parameter.value =
            [x, y];
    }


    /*
     * ============================================================
     * SET UNIFORM 4
     * ============================================================
     */

    private static function setUniform4(
        shader:Shader,
        uniform:String,
        x:Float,
        y:Float,
        z:Float,
        w:Float
    ):Void
    {
        if (shader == null)
            return;


        var parameter:Dynamic =
            Reflect.field(
                shader.data,
                uniform
            );

        if (parameter == null)
            return;


        parameter.value =
            [
                x,
                y,
                z,
                w
            ];
    }


    /*
     * ============================================================
     * GET PARAMETER VALUE
     * ============================================================
     */

    private static function getParameterValue(
        parameter:Dynamic
    ):Array<Float>
    {
        if (parameter == null)
            return null;


        var value:Dynamic =
            Reflect.field(
                parameter,
                "value"
            );


        if (value == null)
            return null;


        if (Std.isOfType(
            value,
            Array
        ))
        {
            return cast value;
        }


        return null;
    }


    /*
     * ============================================================
     * COLOR NORMALIZATION
     * ============================================================
     *
     * Permite:
     *
     *     255 -> 1
     *     128 -> 0.501...
     *
     * pero también:
     *
     *     1 -> 1
     *     0.5 -> 0.5
     *
     * ============================================================
     */

    private static function normalizeColor(
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

    private static function clamp(
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