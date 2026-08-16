/*
 * ============================================================
 * GalaxyBlend.hx
 * ============================================================
 *
 * FNF In The Galaxy -> Psych Engine 1.0.4
 *
 * Administrador de Blend Modes para Galaxy.
 *
 * ============================================================
 *
 * RESPONSABILIDAD:
 *
 *     - Convertir nombres de Blend Modes
 *     - Aplicar Blend Modes a objetos
 *     - Aplicar Blend Modes a sprites
 *     - Consultar Blend Modes
 *     - Restablecer Blend Modes
 *
 * ============================================================
 *
 * NO SE ENCARGA DE:
 *
 *     - Shaders
 *     - Renderizado 3D
 *     - Transformaciones 3D
 *     - Cámaras
 *     - Window effects
 *
 * ============================================================
 *
 * Los shaders son administrados por:
 *
 *     GalaxyShader.hx
 *
 * Los efectos de overlay:
 *
 *     OverlayShader.hx
 *
 * El renderizado 3D:
 *
 *     RenderPath.hx
 *
 * ============================================================
 */

import openfl.display.BlendMode;
import flixel.FlxSprite;
import flixel.FlxCamera;


/**
 * GalaxyBlend
 *
 * Sistema central de Blend Modes para Galaxy.
 */
class GalaxyBlend
{
    /*
     * ============================================================
     * DEFAULT
     * ============================================================
     */

    public static var defaultMode:BlendMode =
        BlendMode.NORMAL;


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
     * FROM STRING
     * ============================================================
     *
     * Convierte un nombre utilizado desde Lua/HScript en
     * un BlendMode real de OpenFL.
     *
     * Ejemplos:
     *
     *     "normal"
     *     "add"
     *     "alpha"
     *     "multiply"
     *     "screen"
     *     "darken"
     *     "lighten"
     *     "overlay"
     *
     * ============================================================
     */

    public static function fromString(
        mode:String
    ):BlendMode
    {
        if (mode == null)
            return BlendMode.NORMAL;


        var value:String =
            mode.toLowerCase();


        value =
            StringTools.trim(
                value
            );


        switch (value)
        {
            case "normal":
                return BlendMode.NORMAL;


            case "alpha":
                return BlendMode.ALPHA;


            case "add":
                return BlendMode.ADD;


            case "subtract":
                return BlendMode.SUBTRACT;


            case "multiply":
                return BlendMode.MULTIPLY;


            case "screen":
                return BlendMode.SCREEN;


            case "darken":
                return BlendMode.DARKEN;


            case "lighten":
                return BlendMode.LIGHTEN;


            case "overlay":
                return BlendMode.OVERLAY;


            case "hardlight":
                return BlendMode.HARDLIGHT;


            case "hard_light":
                return BlendMode.HARDLIGHT;


            case "difference":
                return BlendMode.DIFFERENCE;


            case "erase":
                return BlendMode.ERASE;


            case "invert":
                return BlendMode.INVERT;


            case "layer":
                return BlendMode.LAYER;


            case "shader":
                return BlendMode.SHADER;


            default:
                return BlendMode.NORMAL;
        }
    }


    /*
     * ============================================================
     * TO STRING
     * ============================================================
     *
     * Convierte BlendMode -> nombre legible.
     *
     * ============================================================
     */

    public static function toString(
        mode:BlendMode
    ):String
    {
        if (mode == null)
            return "normal";


        if (mode == BlendMode.NORMAL)
            return "normal";


        if (mode == BlendMode.ALPHA)
            return "alpha";


        if (mode == BlendMode.ADD)
            return "add";


        if (mode == BlendMode.SUBTRACT)
            return "subtract";


        if (mode == BlendMode.MULTIPLY)
            return "multiply";


        if (mode == BlendMode.SCREEN)
            return "screen";


        if (mode == BlendMode.DARKEN)
            return "darken";


        if (mode == BlendMode.LIGHTEN)
            return "lighten";


        if (mode == BlendMode.OVERLAY)
            return "overlay";


        if (mode == BlendMode.HARDLIGHT)
            return "hardlight";


        if (mode == BlendMode.DIFFERENCE)
            return "difference";


        if (mode == BlendMode.ERASE)
            return "erase";


        if (mode == BlendMode.INVERT)
            return "invert";


        if (mode == BlendMode.LAYER)
            return "layer";


        if (mode == BlendMode.SHADER)
            return "shader";


        return "normal";
    }


    /*
     * ============================================================
     * SET
     * ============================================================
     *
     * Aplica un Blend Mode a cualquier objeto que tenga una
     * propiedad "blendMode".
     *
     * ============================================================
     */

    public static function set(
        object:Dynamic,
        mode:String
    ):Bool
    {
        if (object == null)
            return false;


        var blend:BlendMode =
            fromString(
                mode
            );


        try
        {
            Reflect.setField(
                object,
                "blendMode",
                blend
            );
        }
        catch (e:Dynamic)
        {
            return false;
        }


        return true;
    }


    /*
     * ============================================================
     * SET MODE
     * ============================================================
     *
     * Igual que set(), pero recibe directamente BlendMode.
     *
     * ============================================================
     */

    public static function setMode(
        object:Dynamic,
        mode:BlendMode
    ):Bool
    {
        if (object == null)
            return false;


        if (mode == null)
            return false;


        try
        {
            Reflect.setField(
                object,
                "blendMode",
                mode
            );
        }
        catch (e:Dynamic)
        {
            return false;
        }


        return true;
    }


    /*
     * ============================================================
     * GET
     * ============================================================
     */

    public static function get(
        object:Dynamic
    ):BlendMode
    {
        if (object == null)
            return BlendMode.NORMAL;


        try
        {
            var value:Dynamic =
                Reflect.field(
                    object,
                    "blendMode"
                );


            if (value != null)
            {
                return cast value;
            }
        }
        catch (e:Dynamic)
        {
        }


        return BlendMode.NORMAL;
    }


    /*
     * ============================================================
     * GET NAME
     * ============================================================
     */

    public static function getName(
        object:Dynamic
    ):String
    {
        return toString(
            get(
                object
            )
        );
    }


    /*
     * ============================================================
     * APPLY TO SPRITE
     * ============================================================
     */

    public static function applyToSprite(
        sprite:FlxSprite,
        mode:String
    ):Bool
    {
        if (sprite == null)
            return false;


        return set(
            sprite,
            mode
        );
    }


    /*
     * ============================================================
     * APPLY TO CAMERA
     * ============================================================
     *
     * Se mantiene como función separada porque las cámaras de
     * Flixel/OpenFL no necesariamente exponen exactamente el
     * mismo comportamiento de blend que un FlxSprite.
     *
     * Por eso primero comprobamos dinámicamente la propiedad.
     *
     * ============================================================
     */

    public static function applyToCamera(
        camera:FlxCamera,
        mode:String
    ):Bool
    {
        if (camera == null)
            return false;


        return set(
            camera,
            mode
        );
    }


    /*
     * ============================================================
     * APPLY TO OBJECT
     * ============================================================
     *
     * Útil para:
     *
     *     - FlxSprite
     *     - FlxObject con blendMode
     *     - objetos OpenFL
     *     - objetos creados por Galaxy
     *
     * ============================================================
     */

    public static function applyToObject(
        object:Dynamic,
        mode:String
    ):Bool
    {
        return set(
            object,
            mode
        );
    }


    /*
     * ============================================================
     * REMOVE / RESET
     * ============================================================
     *
     * Devuelve el objeto al modo NORMAL.
     *
     * ============================================================
     */

    public static function reset(
        object:Dynamic
    ):Bool
    {
        return setMode(
            object,
            BlendMode.NORMAL
        );
    }


    /*
     * ============================================================
     * RESET SPRITE
     * ============================================================
     */

    public static function resetSprite(
        sprite:FlxSprite
    ):Bool
    {
        if (sprite == null)
            return false;


        sprite.blend =
            BlendMode.NORMAL;


        return true;
    }


    /*
     * ============================================================
     * RESET CAMERA
     * ============================================================
     */

    public static function resetCamera(
        camera:FlxCamera
    ):Bool
    {
        if (camera == null)
            return false;


        try
        {
            camera.blend =
                BlendMode.NORMAL;
        }
        catch (e:Dynamic)
        {
            return false;
        }


        return true;
    }


    /*
     * ============================================================
     * NORMAL
     * ============================================================
     */

    public static function normal(
        object:Dynamic
    ):Bool
    {
        return setMode(
            object,
            BlendMode.NORMAL
        );
    }


    /*
     * ============================================================
     * ADD
     * ============================================================
     */

    public static function add(
        object:Dynamic
    ):Bool
    {
        return setMode(
            object,
            BlendMode.ADD
        );
    }


    /*
     * ============================================================
     * ALPHA
     * ============================================================
     */

    public static function alpha(
        object:Dynamic
    ):Bool
    {
        return setMode(
            object,
            BlendMode.ALPHA
        );
    }


    /*
     * ============================================================
     * MULTIPLY
     * ============================================================
 */

    public static function multiply(
        object:Dynamic
    ):Bool
    {
        return setMode(
            object,
            BlendMode.MULTIPLY
        );
    }


    /*
     * ============================================================
     * SCREEN
     * ============================================================
 */

    public static function screen(
        object:Dynamic
    ):Bool
    {
        return setMode(
            object,
            BlendMode.SCREEN
        );
    }


    /*
     * ============================================================
     * SUBTRACT
     * ============================================================
 */

    public static function subtract(
        object:Dynamic
    ):Bool
    {
        return setMode(
            object,
            BlendMode.SUBTRACT
        );
    }


    /*
     * ============================================================
     * DARKEN
     * ============================================================
 */

    public static function darken(
        object:Dynamic
    ):Bool
    {
        return setMode(
            object,
            BlendMode.DARKEN
        );
    }


    /*
     * ============================================================
     * LIGHTEN
     * ============================================================
 */

    public static function lighten(
        object:Dynamic
    ):Bool
    {
        return setMode(
            object,
            BlendMode.LIGHTEN
        );
    }


    /*
     * ============================================================
     * OVERLAY
     * ============================================================
     *
     * IMPORTANTE:
     *
     * OpenFL/Psych puede no producir el mismo resultado para
     * OVERLAY dependiendo del backend.
     *
     * ============================================================
 */

    public static function overlay(
        object:Dynamic
    ):Bool
    {
        return setMode(
            object,
            BlendMode.OVERLAY
        );
    }


    /*
     * ============================================================
     * HARDLIGHT
     * ============================================================
 */

    public static function hardLight(
        object:Dynamic
    ):Bool
    {
        return setMode(
            object,
            BlendMode.HARDLIGHT
        );
    }


    /*
     * ============================================================
     * DIFFERENCE
     * ============================================================
 */

    public static function difference(
        object:Dynamic
    ):Bool
    {
        return setMode(
            object,
            BlendMode.DIFFERENCE
        );
    }


    /*
     * ============================================================
     * ERASE
     * ============================================================
 */

    public static function erase(
        object:Dynamic
    ):Bool
    {
        return setMode(
            object,
            BlendMode.ERASE
        );
    }


    /*
     * ============================================================
     * INVERT
     * ============================================================
 */

    public static function invert(
        object:Dynamic
    ):Bool
    {
        return setMode(
            object,
            BlendMode.INVERT
        );
    }


    /*
     * ============================================================
     * LAYER
     * ============================================================
 */

    public static function layer(
        object:Dynamic
    ):Bool
    {
        return setMode(
            object,
            BlendMode.LAYER
        );
    }


    /*
     * ============================================================
     * SHADER
     * ============================================================
 *
 * Este BlendMode es especial:
 *
 *     BlendMode.SHADER
 *
 * no sustituye a GalaxyShader.hx.
 *
 * Es simplemente el modo de composición proporcionado por
 * OpenFL para objetos que utilizan un shader como fuente.
 *
     */

    public static function shader(
        object:Dynamic
    ):Bool
    {
        return setMode(
            object,
            BlendMode.SHADER
        );
    }


    /*
     * ============================================================
     * IS VALID MODE
     * ============================================================
     */

    public static function isValid(
        mode:String
    ):Bool
    {
        if (mode == null)
            return false;


        var value:String =
            mode.toLowerCase();


        value =
            StringTools.trim(
                value
            );


        switch (value)
        {
            case "normal",
                 "alpha",
                 "add",
                 "subtract",
                 "multiply",
                 "screen",
                 "darken",
                 "lighten",
                 "overlay",
                 "hardlight",
                 "hard_light",
                 "difference",
                 "erase",
                 "invert",
                 "layer",
                 "shader":

                return true;


            default:
                return false;
        }
    }


    /*
     * ============================================================
     * COPY
     * ============================================================
     *
     * Copia el Blend Mode de un objeto a otro.
     *
     * ============================================================
 */

    public static function copy(
        source:Dynamic,
        target:Dynamic
    ):Bool
    {
        if (
            source == null ||
            target == null
        )
        {
            return false;
        }


        var mode:BlendMode =
            get(
                source
            );


        return setMode(
            target,
            mode
        );
    }


    /*
     * ============================================================
     * RESET
     * ============================================================
     *
     * Restablece la configuración global del sistema.
     *
     * No modifica automáticamente objetos que ya hayan recibido
     * un Blend Mode.
     *
     * ============================================================
 */

    public static function resetSystem():Void
    {
        defaultMode =
            BlendMode.NORMAL;
    }
}