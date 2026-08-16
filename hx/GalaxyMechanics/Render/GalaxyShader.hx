/*
 * ============================================================
 * GalaxyShader.hx
 * ============================================================
 *
 * FNF In The Galaxy -> Psych Engine 1.0.4
 *
 * Sistema central para administrar shaders de Galaxy.
 *
 * ============================================================
 *
 * RESPONSABILIDAD:
 *
 *     - Crear/obtener shaders runtime
 *     - Administrar shaders activos
 *     - Modificar uniforms
 *     - Aplicar shaders a objetos
 *     - Aplicar shaders a cámaras
 *     - Quitar shaders
 *     - Activar/desactivar efectos
 *
 * ============================================================
 *
 * EL GLSL NO SE GUARDA AQUÍ.
 *
 * Ejemplo:
 *
 *     shaders/
 *
 *         galaxyWave.frag
 *         galaxyChromatic.frag
 *         galaxyDistortion.frag
 *
 * Este archivo solamente administra esos shaders.
 *
 * ============================================================
 *
 * IMPORTANTE:
 *
 * Este sistema está pensado para Psych Engine 1.0.4.
 *
 * ============================================================
 */

import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.system.FlxAssets.FlxShader;


/**
 * Información de un shader registrado.
 */
typedef GalaxyShaderData =
{
    var name:String;
    var shader:FlxShader;
    var active:Bool;
}


/**
 * GalaxyShader
 *
 * Administrador de shaders para el port de Galaxy.
 */
class GalaxyShader
{
    /*
     * ============================================================
     * SHADERS REGISTRADOS
     * ============================================================
     *
     * Todos los shaders creados por Galaxy pueden mantenerse
     * aquí para poder reutilizarlos.
     */

    public static var shaders:Map<String, FlxShader> =
        new Map<String, FlxShader>();


    /*
     * ============================================================
     * SHADERS ACTIVOS
     * ============================================================
     */

    public static var activeShaders:Map<String, Bool> =
        new Map<String, Bool>();


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
     * REGISTER
     * ============================================================
     *
     * Registra manualmente un shader.
     *
     * Esto es útil cuando Lua ya creó el shader mediante
     * initLuaShader() y queremos asociarlo con GalaxyShader.
     *
     * ============================================================
     */

    public static function register(
        name:String,
        shader:FlxShader
    ):Void
    {
        if (name == null || name == "")
            return;

        if (shader == null)
            return;


        shaders.set(
            name,
            shader
        );

        activeShaders.set(
            name,
            false
        );
    }


    /*
     * ============================================================
     * GET
     * ============================================================
     */

    public static function get(
        name:String
    ):FlxShader
    {
        if (name == null)
            return null;


        if (!shaders.exists(name))
            return null;


        return shaders.get(name);
    }


    /*
     * ============================================================
     * EXISTS
     * ============================================================
     */

    public static function exists(
        name:String
    ):Bool
    {
        if (name == null)
            return false;


        return shaders.exists(name);
    }


    /*
     * ============================================================
     * IS ACTIVE
     * ============================================================
 */

    public static function isActive(
        name:String
    ):Bool
    {
        if (name == null)
            return false;


        if (!activeShaders.exists(name))
            return false;


        return activeShaders.get(name);
    }


    /*
     * ============================================================
     * ACTIVATE
     * ============================================================
     */

    public static function activate(
        name:String
    ):Void
    {
        if (!shaders.exists(name))
            return;


        activeShaders.set(
            name,
            true
        );
    }


    /*
     * ============================================================
     * DEACTIVATE
     * ============================================================
 */

    public static function deactivate(
        name:String
    ):Void
    {
        if (!activeShaders.exists(name))
            return;


        activeShaders.set(
            name,
            false
        );
    }


    /*
     * ============================================================
     * TOGGLE
     * ============================================================
 */

    public static function toggle(
        name:String
    ):Bool
    {
        var value:Bool =
            isActive(name);


        value =
            !value;


        activeShaders.set(
            name,
            value
        );


        return value;
    }


    /*
     * ============================================================
     * SET FLOAT
     * ============================================================
     *
     * Modifica un uniform float.
     *
     * Ejemplo GLSL:
     *
     *     uniform float intensity;
     *
     * Lua/Haxe:
     *
     *     GalaxyShader.setFloat(
     *         "wave",
     *         "intensity",
     *         0.5
     *     );
     *
     * ============================================================
     */

    public static function setFloat(
        shaderName:String,
        uniformName:String,
        value:Float
    ):Void
    {
        var shader:FlxShader =
            get(shaderName);


        if (shader == null)
            return;


        if (shader.data == null)
            return;


        if (
            !Reflect.hasField(
                shader.data,
                uniformName
            )
        )
        {
            return;
        }


        var uniform:Dynamic =
            Reflect.field(
                shader.data,
                uniformName
            );


        if (uniform == null)
            return;


        uniform.value = [
            value
        ];
    }


    /*
     * ============================================================
     * SET INT
     * ============================================================
 */

    public static function setInt(
        shaderName:String,
        uniformName:String,
        value:Int
    ):Void
    {
        setFloat(
            shaderName,
            uniformName,
            value
        );
    }


    /*
     * ============================================================
     * SET BOOL
     * ============================================================
 */

    public static function setBool(
        shaderName:String,
        uniformName:String,
        value:Bool
    ):Void
    {
        setFloat(
            shaderName,
            uniformName,
            value ? 1 : 0
        );
    }


    /*
     * ============================================================
     * SET VECTOR2
     * ============================================================
 */

    public static function setVector2(
        shaderName:String,
        uniformName:String,
        x:Float,
        y:Float
    ):Void
    {
        var shader:FlxShader =
            get(shaderName);


        if (shader == null)
            return;


        if (shader.data == null)
            return;


        if (
            !Reflect.hasField(
                shader.data,
                uniformName
            )
        )
        {
            return;
        }


        var uniform:Dynamic =
            Reflect.field(
                shader.data,
                uniformName
            );


        if (uniform == null)
            return;


        uniform.value = [
            x,
            y
        ];
    }


    /*
     * ============================================================
     * SET VECTOR3
     * ============================================================
 */

    public static function setVector3(
        shaderName:String,
        uniformName:String,
        x:Float,
        y:Float,
        z:Float
    ):Void
    {
        var shader:FlxShader =
            get(shaderName);


        if (shader == null)
            return;


        if (shader.data == null)
            return;


        if (
            !Reflect.hasField(
                shader.data,
                uniformName
            )
        )
        {
            return;
        }


        var uniform:Dynamic =
            Reflect.field(
                shader.data,
                uniformName
            );


        if (uniform == null)
            return;


        uniform.value = [
            x,
            y,
            z
        ];
    }


    /*
     * ============================================================
     * SET VECTOR4
     * ============================================================
 */

    public static function setVector4(
        shaderName:String,
        uniformName:String,
        x:Float,
        y:Float,
        z:Float,
        w:Float
    ):Void
    {
        var shader:FlxShader =
            get(shaderName);


        if (shader == null)
            return;


        if (shader.data == null)
            return;


        if (
            !Reflect.hasField(
                shader.data,
                uniformName
            )
        )
        {
            return;
        }


        var uniform:Dynamic =
            Reflect.field(
                shader.data,
                uniformName
            );


        if (uniform == null)
            return;


        uniform.value = [
            x,
            y,
            z,
            w
        ];
    }


    /*
     * ============================================================
     * SET ARRAY
     * ============================================================
     *
     * Permite establecer uniforms que necesiten varios valores.
     *
     * ============================================================
 */

    public static function setArray(
        shaderName:String,
        uniformName:String,
        values:Array<Float>
    ):Void
    {
        var shader:FlxShader =
            get(shaderName);


        if (shader == null)
            return;


        if (shader.data == null)
            return;


        if (
            !Reflect.hasField(
                shader.data,
                uniformName
            )
        )
        {
            return;
        }


        var uniform:Dynamic =
            Reflect.field(
                shader.data,
                uniformName
            );


        if (uniform == null)
            return;


        uniform.value =
            values;
    }


    /*
     * ============================================================
     * GET UNIFORM
     * ============================================================
 */

    public static function getUniform(
        shaderName:String,
        uniformName:String
    ):Dynamic
    {
        var shader:FlxShader =
            get(shaderName);


        if (shader == null)
            return null;


        if (shader.data == null)
            return null;


        if (
            !Reflect.hasField(
                shader.data,
                uniformName
            )
        )
        {
            return null;
        }


        return Reflect.field(
            shader.data,
            uniformName
        );
    }


    /*
     * ============================================================
     * APPLY TO SPRITE
     * ============================================================
     *
     * Aplica directamente un shader a un FlxSprite.
     *
     * ============================================================
 */

    public static function applyToSprite(
        sprite:FlxSprite,
        shaderName:String
    ):Bool
    {
        if (sprite == null)
            return false;


        var shader:FlxShader =
            get(shaderName);


        if (shader == null)
            return false;


        sprite.shader =
            shader;


        activate(
            shaderName
        );


        return true;
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


        sprite.shader =
            null;
    }


    /*
     * ============================================================
     * APPLY TO CAMERA
     * ============================================================
     *
     * Utiliza la propiedad shader de FlxCamera.
     *
     * ============================================================
 */

    public static function applyToCamera(
        camera:FlxCamera,
        shaderName:String
    ):Bool
    {
        if (camera == null)
            return false;


        var shader:FlxShader =
            get(shaderName);


        if (shader == null)
            return false;


        camera.shader =
            shader;


        activate(
            shaderName
        );


        return true;
    }


    /*
     * ============================================================
     * REMOVE FROM CAMERA
     * ============================================================
 */

    public static function removeFromCamera(
        camera:FlxCamera
    ):Void
    {
        if (camera == null)
            return;


        camera.shader =
            null;
    }


    /*
     * ============================================================
     * APPLY TO ANY OBJECT
     * ============================================================
     *
     * Permite trabajar con objetos que expongan una propiedad
     * shader.
     *
     * Esto será útil para algunos objetos de Psych sin obligar
     * a GalaxyShader a conocer todas sus clases.
     *
     * ============================================================
 */

    public static function applyToObject(
        object:Dynamic,
        shaderName:String
    ):Bool
    {
        if (object == null)
            return false;


        var shader:FlxShader =
            get(shaderName);


        if (shader == null)
            return false;


        try
        {
            Reflect.setField(
                object,
                "shader",
                shader
            );
        }
        catch (e:Dynamic)
        {
            return false;
        }


        activate(
            shaderName
        );


        return true;
    }


    /*
     * ============================================================
     * REMOVE FROM OBJECT
     * ============================================================
 */

    public static function removeFromObject(
        object:Dynamic
    ):Void
    {
        if (object == null)
            return;


        try
        {
            Reflect.setField(
                object,
                "shader",
                null
            );
        }
        catch (e:Dynamic)
        {
        }
    }


    /*
     * ============================================================
     * CLEAR SPRITE
     * ============================================================
 *
     * Quita el shader solamente si coincide con el shader
     * indicado.
     */

    public static function clearSprite(
        sprite:FlxSprite,
        shaderName:String
    ):Void
    {
        if (sprite == null)
            return;


        var shader:FlxShader =
            get(shaderName);


        if (shader == null)
            return;


        if (sprite.shader == shader)
        {
            sprite.shader =
                null;
        }
    }


    /*
     * ============================================================
     * CLEAR CAMERA
     * ============================================================
 */

    public static function clearCamera(
        camera:FlxCamera,
        shaderName:String
    ):Void
    {
        if (camera == null)
            return;


        var shader:FlxShader =
            get(shaderName);


        if (shader == null)
            return;


        if (camera.shader == shader)
        {
            camera.shader =
                null;
        }
    }


    /*
     * ============================================================
     * REMOVE SHADER
     * ============================================================
     *
     * Elimina un shader del registro.
     *
     * IMPORTANTE:
     *
     * Esto NO intenta localizar automáticamente todos los
     * sprites/cámaras donde haya sido aplicado.
     *
     * ============================================================
 */

    public static function remove(
        name:String
    ):Void
    {
        if (name == null)
            return;


        shaders.remove(
            name
        );

        activeShaders.remove(
            name
        );
    }


    /*
     * ============================================================
     * CLEAR
     * ============================================================
     *
     * Limpia todos los shaders registrados.
     *
     * ============================================================
 */

    public static function clear():Void
    {
        shaders =
            new Map<String, FlxShader>();


        activeShaders =
            new Map<String, Bool>();
    }


    /*
     * ============================================================
     * GET ACTIVE SHADERS
     * ============================================================
 */

    public static function getActiveShaders():Array<String>
    {
        var result:Array<String> =
            [];


        for (name in activeShaders.keys())
        {
            if (
                activeShaders.get(
                    name
                )
            )
            {
                result.push(
                    name
                );
            }
        }


        return result;
    }


    /*
     * ============================================================
     * UPDATE FLOAT
     * ============================================================
     *
     * Alias pensado para ser cómodo desde eventos.
     *
     * ============================================================
 */

    public static function updateFloat(
        shaderName:String,
        uniformName:String,
        value:Float
    ):Void
    {
        setFloat(
            shaderName,
            uniformName,
            value
        );
    }


    /*
     * ============================================================
     * UPDATE VECTOR2
     * ============================================================
 */

    public static function updateVector2(
        shaderName:String,
        uniformName:String,
        x:Float,
        y:Float
    ):Void
    {
        setVector2(
            shaderName,
            uniformName,
            x,
            y
        );
    }


    /*
     * ============================================================
     * UPDATE VECTOR3
     * ============================================================
 */

    public static function updateVector3(
        shaderName:String,
        uniformName:String,
        x:Float,
        y:Float,
        z:Float
    ):Void
    {
        setVector3(
            shaderName,
            uniformName,
            x,
            y,
            z
        );
    }


    /*
     * ============================================================
     * UPDATE VECTOR4
     * ============================================================
 */

    public static function updateVector4(
        shaderName:String,
        uniformName:String,
        x:Float,
        y:Float,
        z:Float,
        w:Float
    ):Void
    {
        setVector4(
            shaderName,
            uniformName,
            x,
            y,
            z,
            w
        );
    }


    /*
     * ============================================================
     * RESET
     * ============================================================
 */

    public static function reset():Void
    {
        clear();
    }
}