/*
 * ============================================================
 * Galaxy3D.hx
 * ============================================================
 *
 * FNF In The Galaxy -> Psych Engine 1.0.4
 *
 * Controlador principal del sistema 3D de Galaxy.
 *
 * ============================================================
 *
 * RESPONSABILIDAD:
 *
 *     - Activar/desactivar el sistema 3D
 *     - Administrar la cámara 3D
 *     - Coordinar ToWorld
 *     - Coordinar Perspective
 *     - Coordinar ToScreen
 *     - Coordinar RenderPath
 *     - Registrar objetos 3D
 *     - Actualizar objetos 3D
 *     - Aplicar transformaciones
 *
 * ============================================================
 *
 * NO SE ENCARGA DIRECTAMENTE DE:
 *
 *     - La matemática individual de perspectiva
 *     - La transformación individual de Note3D
 *     - La conversión 2D -> mundo
 *     - La conversión mundo -> pantalla
 *     - La creación del shader
 *     - El BlendMode
 *
 * Esas responsabilidades pertenecen a:
 *
 *     ToWorld.hx
 *     Perspective.hx
 *     ToScreen.hx
 *     Note3D.hx
 *     RenderPath.hx
 *     GalaxyShader.hx
 *     GalaxyBlend.hx
 *
 * ============================================================
 *
 * FLUJO:
 *
 *       Psych / Lua
 *            |
 *            v
 *        Galaxy3D
 *            |
 *      +-----+-----+
 *      |     |     |
 *      v     v     v
 *   ToWorld Note3D Perspective
 *      |     |     |
 *      +-----+-----+
 *            |
 *            v
 *        ToScreen
 *            |
 *            v
 *        RenderPath
 *
 * ============================================================
 */

import flixel.FlxCamera;
import flixel.FlxSprite;


/**
 * Galaxy3D
 *
 * Sistema central de coordinación 3D.
 */
class Galaxy3D
{
    /*
     * ============================================================
     * ESTADO GLOBAL
     * ============================================================
     */

    /**
     * Indica si el sistema 3D está activo.
     */
    public static var enabled:Bool = false;


    /**
     * Indica si el sistema está inicializado.
     */
    public static var initialized:Bool = false;


    /**
     * Pausa la actualización 3D sin desactivar completamente
     * el sistema.
     */
    public static var paused:Bool = false;


    /*
     * ============================================================
     * CÁMARA 3D
     * ============================================================
     */

    /**
     * Posición de la cámara.
     */
    public static var cameraX:Float = 0;
    public static var cameraY:Float = 0;
    public static var cameraZ:Float = 0;


    /**
     * Rotación de la cámara.
     */
    public static var cameraRotationX:Float = 0;
    public static var cameraRotationY:Float = 0;
    public static var cameraRotationZ:Float = 0;


    /**
     * Campo de visión.
     */
    public static var fieldOfView:Float = 90;


    /**
     * Distancia focal.
     */
    public static var focalLength:Float = 1;


    /**
     * Near clipping plane.
     */
    public static var nearClip:Float = 0.01;


    /**
     * Far clipping plane.
     */
    public static var farClip:Float = 100000;


    /*
     * ============================================================
     * PANTALLA
     * ============================================================
     */

    public static var screenWidth:Float = 1280;
    public static var screenHeight:Float = 720;


    /*
     * ============================================================
     * OBJETOS
     * ============================================================
     *
     * Objetos 3D registrados por el sistema.
     */

    public static var objects:Array<Dynamic> = [];


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
     * INIT
     * ============================================================
     *
     * Inicializa el sistema.
     *
     * ============================================================
 */

    public static function init(
        width:Float = 1280,
        height:Float = 720
    ):Void
    {
        if (initialized)
            return;


        screenWidth =
            width;

        screenHeight =
            height;


        ToScreen.setScreenSize(
            width,
            height
        );


        initialized =
            true;


        enabled =
            false;

        paused =
            false;
    }


    /*
     * ============================================================
     * ENABLE
     * ============================================================
 */

    public static function setEnabled(
        value:Bool
    ):Void
    {
        if (!initialized)
            init(
                screenWidth,
                screenHeight
            );


        enabled =
            value;
    }


    /*
     * ============================================================
     * ENABLE
     * ============================================================
 */

    public static function enable():Void
    {
        setEnabled(
            true
        );
    }


    /*
     * ============================================================
     * DISABLE
     * ============================================================
 */

    public static function disable():Void
    {
        setEnabled(
            false
        );
    }


    /*
     * ============================================================
     * IS ENABLED
     * ============================================================
 */

    public static function isEnabled():Bool
    {
        return enabled;
    }


    /*
     * ============================================================
     * PAUSE
     * ============================================================
 */

    public static function setPaused(
        value:Bool
    ):Void
    {
        paused =
            value;
    }


    /*
     * ============================================================
     * CAMERA POSITION
     * ============================================================
 */

    public static function setCameraPosition(
        x:Float,
        y:Float,
        z:Float
    ):Void
    {
        cameraX =
            x;

        cameraY =
            y;

        cameraZ =
            z;


        Perspective.setCameraPosition(
            x,
            y,
            z
        );
    }


    /*
     * ============================================================
     * CAMERA X
     * ============================================================
 */

    public static function setCameraX(
        value:Float
    ):Void
    {
        cameraX =
            value;


        Perspective.setCameraX(
            value
        );
    }


    /*
     * ============================================================
     * CAMERA Y
     * ============================================================
 */

    public static function setCameraY(
        value:Float
    ):Void
    {
        cameraY =
            value;


        Perspective.setCameraY(
            value
        );
    }


    /*
     * ============================================================
     * CAMERA Z
     * ============================================================
 */

    public static function setCameraZ(
        value:Float
    ):Void
    {
        cameraZ =
            value;


        Perspective.setCameraZ(
            value
        );
    }


    /*
     * ============================================================
     * CAMERA ROTATION
     * ============================================================
 */

    public static function setCameraRotation(
        x:Float,
        y:Float,
        z:Float
    ):Void
    {
        cameraRotationX =
            x;

        cameraRotationY =
            y;

        cameraRotationZ =
            z;


        Perspective.setCameraRotation(
            x,
            y,
            z
        );
    }


    /*
     * ============================================================
     * CAMERA ROTATION X
     * ============================================================
 */

    public static function setCameraRotationX(
        value:Float
    ):Void
    {
        cameraRotationX =
            value;


        Perspective.setCameraRotationX(
            value
        );
    }


    /*
     * ============================================================
     * CAMERA ROTATION Y
     * ============================================================
 */

    public static function setCameraRotationY(
        value:Float
    ):Void
    {
        cameraRotationY =
            value;


        Perspective.setCameraRotationY(
            value
        );
    }


    /*
     * ============================================================
     * CAMERA ROTATION Z
     * ============================================================
 */

    public static function setCameraRotationZ(
        value:Float
    ):Void
    {
        cameraRotationZ =
            value;


        Perspective.setCameraRotationZ(
            value
        );
    }


    /*
     * ============================================================
     * FIELD OF VIEW
     * ============================================================
 */

    public static function setFieldOfView(
        value:Float
    ):Void
    {
        if (value <= 0)
            value = 1;


        fieldOfView =
            value;


        Perspective.setFieldOfView(
            value
        );
    }


    /*
     * ============================================================
     * FOCAL LENGTH
     * ============================================================
 */

    public static function setFocalLength(
        value:Float
    ):Void
    {
        if (value <= 0)
            value = 0.01;


        focalLength =
            value;


        Perspective.setFocalLength(
            value
        );
    }


    /*
     * ============================================================
     * CLIPPING
     * ============================================================
 */

    public static function setClipping(
        near:Float,
        far:Float
    ):Void
    {
        if (near < 0.0001)
            near = 0.0001;


        if (far <= near)
            far = near + 1;


        nearClip =
            near;

        farClip =
            far;


        Perspective.setClipping(
            near,
            far
        );
    }


    /*
     * ============================================================
     * SCREEN SIZE
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


        ToScreen.setScreenSize(
            width,
            height
        );
    }


    /*
     * ============================================================
     * WORLD OFFSET
     * ============================================================
 */

    public static function setWorldOffset(
        x:Float,
        y:Float,
        z:Float
    ):Void
    {
        ToWorld.setOffset(
            x,
            y,
            z
        );
    }


    /*
     * ============================================================
     * WORLD SCALE
     * ============================================================
 */

    public static function setWorldScale(
        x:Float,
        y:Float,
        z:Float
    ):Void
    {
        ToWorld.setScale(
            x,
            y,
            z
        );
    }


    /*
     * ============================================================
     * UNIFORM WORLD SCALE
     * ============================================================
 */

    public static function setWorldUniformScale(
        value:Float
    ):Void
    {
        ToWorld.setUniformScale(
            value
        );
    }


    /*
     * ============================================================
     * REGISTER OBJECT
     * ============================================================
 */

    public static function register(
        object:Dynamic
    ):Void
    {
        if (object == null)
            return;


        if (
            objects.indexOf(
                object
            ) != -1
        )
        {
            return;
        }


        objects.push(
            object
        );
    }


    /*
     * ============================================================
     * UNREGISTER OBJECT
     * ============================================================
 */

    public static function unregister(
        object:Dynamic
    ):Void
    {
        if (object == null)
            return;


        var index:Int =
            objects.indexOf(
                object
            );


        if (index != -1)
        {
            objects.splice(
                index,
                1
            );
        }
    }


    /*
     * ============================================================
     * CLEAR OBJECTS
     * ============================================================
 */

    public static function clearObjects():Void
    {
        objects =
            [];
    }


    /*
     * ============================================================
     * GET OBJECT COUNT
     * ============================================================
 */

    public static function getObjectCount():Int
    {
        return objects.length;
    }


    /*
     * ============================================================
     * CREATE NOTE 3D
     * ============================================================
     *
     * Crea una Note3D directamente desde coordenadas del juego.
     *
     * ============================================================
 */

    public static function createNote3D(
        x:Float,
        y:Float,
        z:Float = 0,
        noteData:Int = -1,
        mustPress:Bool = false,
        isSustain:Bool = false
    ):Note3D
    {
        var note:Note3D =
            ToWorld.createNote(
                x,
                y,
                z,
                noteData,
                mustPress,
                isSustain
            );


        register(
            note
        );


        return note;
    }


    /*
     * ============================================================
     * SET NOTE POSITION
     * ============================================================
 */

    public static function setNotePosition(
        note:Note3D,
        x:Float,
        y:Float,
        z:Float
    ):Void
    {
        if (note == null)
            return;


        note.setPosition(
            x,
            y,
            z
        );
    }


    /*
     * ============================================================
     * SET NOTE ROTATION
     * ============================================================
 */

    public static function setNoteRotation(
        note:Note3D,
        x:Float,
        y:Float,
        z:Float
    ):Void
    {
        if (note == null)
            return;


        note.setRotation(
            x,
            y,
            z
        );
    }


    /*
     * ============================================================
     * SET NOTE SCALE
     * ============================================================
 */

    public static function setNoteScale(
        note:Note3D,
        x:Float,
        y:Float,
        z:Float
    ):Void
    {
        if (note == null)
            return;


        note.setScale(
            x,
            y,
            z
        );
    }


    /*
     * ============================================================
     * RESET NOTE TRANSFORM
     * ============================================================
 */

    public static function resetNote(
        note:Note3D
    ):Void
    {
        if (note == null)
            return;


        note.resetTransform();
    }


    /*
     * ============================================================
     * WORLD TO SCREEN
     * ============================================================
 */

    public static function worldToScreen(
        x:Float,
        y:Float,
        z:Float
    ):Dynamic
    {
        return ToScreen.point(
            x,
            y,
            z
        );
    }


    /*
     * ============================================================
     * NOTE TO SCREEN
     * ============================================================
 */

    public static function noteToScreen(
        note:Note3D
    ):Dynamic
    {
        if (note == null)
            return null;


        return ToScreen.note(
            note
        );
    }


    /*
     * ============================================================
     * NOTE CORNERS TO SCREEN
     * ============================================================
 */

    public static function noteCornersToScreen(
        note:Note3D
    ):Array<Dynamic>
    {
        if (note == null)
            return [];


        return ToScreen.noteCorners(
            note
        );
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
            return null;


        return ToScreen.getNoteBounds(
            note
        );
    }


    /*
     * ============================================================
     * NOTE VISIBILITY
     * ============================================================
 */

    public static function isNoteVisible(
        note:Note3D
    ):Bool
    {
        if (note == null)
            return false;


        return ToScreen.isNoteOnScreen(
            note
        );
    }


    /*
     * ============================================================
     * PROJECT
     * ============================================================
 */

    public static function project(
        x:Float,
        y:Float,
        z:Float
    ):Dynamic
    {
        return ToScreen.point(
            x,
            y,
            z
        );
    }


    /*
     * ============================================================
     * APPLY NOTE WORLD TRANSFORM
     * ============================================================
 *
 * Toma una posición de juego y la convierte al espacio de
 * mundo de Galaxy.
 *
     * ============================================================
 */

    public static function applyWorldTransform(
        x:Float,
        y:Float,
        z:Float = 0
    ):Dynamic
    {
        return ToWorld.point(
            x,
            y,
            z
        );
    }


    /*
     * ============================================================
     * UPDATE OBJECT
     * ============================================================
     *
     * Actualiza un objeto 3D registrado.
     *
     * Actualmente Note3D es el principal objeto soportado.
     *
     * ============================================================
 */

    public static function updateObject(
        object:Dynamic,
        elapsed:Float
    ):Void
    {
        if (object == null)
            return;


        /*
         * Note3D dispone de su propio sistema de actualización.
         */
        if (
            Std.isOfType(
                object,
                Note3D
            )
        )
        {
            var note:Note3D =
                cast object;


            note.update3D(
                elapsed
            );
        }
    }


    /*
     * ============================================================
     * UPDATE
     * ============================================================
     *
     * Actualiza todos los objetos registrados.
     *
     * Esta función NO dibuja.
     *
     * ============================================================
 */

    public static function update(
        elapsed:Float
    ):Void
    {
        if (!enabled)
            return;


        if (paused)
            return;


        for (object in objects)
        {
            updateObject(
                object,
                elapsed
            );
        }
    }


    /*
     * ============================================================
     * SORT BY DEPTH
     * ============================================================
     *
     * Ordena objetos según su profundidad.
     *
     * Esto es importante para renderizado por capas.
     *
     * ============================================================
 */

    public static function sortByDepth():Void
    {
        objects.sort(
            function(
                a:Dynamic,
                b:Dynamic
            ):Int
            {
                if (a == null)
                    return 1;


                if (b == null)
                    return -1;


                var az:Float =
                    getObjectZ(
                        a
                    );


                var bz:Float =
                    getObjectZ(
                        b
                    );


                /*
                 * Los objetos más alejados se procesan primero.
                 */
                if (az < bz)
                    return -1;


                if (az > bz)
                    return 1;


                return 0;
            }
        );
    }


    /*
     * ============================================================
     * GET OBJECT Z
     * ============================================================
 */

    public static function getObjectZ(
        object:Dynamic
    ):Float
    {
        if (object == null)
            return 0;


        if (
            Reflect.hasField(
                object,
                "z"
            )
        )
        {
            return object.z;
        }


        return 0;
    }


    /*
     * ============================================================
     * GET OBJECT SCREEN POSITION
     * ============================================================
 */

    public static function getObjectScreenPosition(
        object:Dynamic
    ):Dynamic
    {
        if (object == null)
            return null;


        if (
            Std.isOfType(
                object,
                Note3D
            )
        )
        {
            return ToScreen.note(
                cast object
            );
        }


        if (
            Reflect.hasField(
                object,
                "x"
            ) &&
            Reflect.hasField(
                object,
                "y"
            )
        )
        {
            var z:Float =
                getObjectZ(
                    object
                );


            return ToScreen.point(
                object.x,
                object.y,
                z
            );
        }


        return null;
    }


    /*
     * ============================================================
     * GET OBJECT CORNERS
     * ============================================================
 */

    public static function getObjectCorners(
        object:Dynamic
    ):Array<Dynamic>
    {
        if (object == null)
            return [];


        if (
            Std.isOfType(
                object,
                Note3D
            )
        )
        {
            return ToScreen.noteCorners(
                cast object
            );
        }


        return [];
    }


    /*
     * ============================================================
     * SET PERSPECTIVE
     * ============================================================
 */

    public static function setPerspective(
        fov:Float,
        focal:Float
    ):Void
    {
        setFieldOfView(
            fov
        );

        setFocalLength(
            focal
        );
    }


    /*
     * ============================================================
     * RESET CAMERA
     * ============================================================
 */

    public static function resetCamera():Void
    {
        cameraX = 0;
        cameraY = 0;
        cameraZ = 0;

        cameraRotationX = 0;
        cameraRotationY = 0;
        cameraRotationZ = 0;

        fieldOfView = 90;
        focalLength = 1;

        nearClip = 0.01;
        farClip = 100000;


        Perspective.reset();
    }


    /*
     * ============================================================
     * RESET WORLD
     * ============================================================
 */

    public static function resetWorld():Void
    {
        ToWorld.reset();
    }


    /*
     * ============================================================
     * RESET SCREEN
     * ============================================================
 */

    public static function resetScreen():Void
    {
        ToScreen.reset();


        ToScreen.setScreenSize(
            screenWidth,
            screenHeight
        );
    }


    /*
     * ============================================================
     * RESET
     * ============================================================
 *
 * Restablece completamente el sistema 3D.
 *
     * ============================================================
 */

    public static function reset():Void
    {
        enabled =
            false;

        paused =
            false;


        clearObjects();


        resetCamera();
        resetWorld();
        resetScreen();


        initialized =
            false;
    }


    /*
     * ============================================================
     * BEGIN FRAME
     * ============================================================
     *
     * Preparación de un frame 3D.
     *
     * Todavía no dibuja nada.
     *
     * ============================================================
 */

    public static function beginFrame():Void
    {
        if (!enabled)
            return;


        /*
         * Ordenamos antes del renderizado.
         */
        sortByDepth();
    }


    /*
     * ============================================================
     * END FRAME
     * ============================================================
     *
     * Punto reservado para futuras operaciones del renderer.
     *
     * ============================================================
 */

    public static function endFrame():Void
    {
        /*
         * Reservado para futuras operaciones.
         */
    }


    /*
     * ============================================================
     * RENDER OBJECT
     * ============================================================
     *
     * Esta función será el punto de conexión con RenderPath.
     *
     * No implementamos aquí el renderizado de triángulos.
     *
     * ============================================================
 */

    public static function renderObject(
        object:Dynamic
    ):Dynamic
    {
        if (!enabled)
            return null;


        if (object == null)
            return null;


        /*
         * Note3D:
         *
         *     Note3D
         *        ↓
         *     ToScreen
         *        ↓
         *     RenderPath
         */
        if (
            Std.isOfType(
                object,
                Note3D
            )
        )
        {
            var note:Note3D =
                cast object;


            var corners:Array<Dynamic> =
                ToScreen.noteCorners(
                    note
                );


            if (
                corners == null ||
                corners.length < 4
            )
            {
                return null;
            }


            /*
             * RenderPath recibirá posteriormente esta información
             * para construir los dos triángulos.
             */
            return RenderPath.createQuad(
                corners
            );
        }


        return null;
    }


    /*
     * ============================================================
     * RENDER ALL
     * ============================================================
     *
     * Genera los datos de render de todos los objetos.
     *
     * No dibuja directamente.
     *
     * ============================================================
 */

    public static function renderAll():Array<Dynamic>
    {
        var result:Array<Dynamic> =
            [];


        if (!enabled)
            return result;


        beginFrame();


        for (object in objects)
        {
            var renderData:Dynamic =
                renderObject(
                    object
                );


            if (renderData != null)
            {
                result.push(
                    renderData
                );
            }
        }


        endFrame();


        return result;
    }


    /*
     * ============================================================
     * GET CAMERA DATA
     * ============================================================
 */

    public static function getCameraData():Dynamic
    {
        return {
            x: cameraX,
            y: cameraY,
            z: cameraZ,

            rotationX:
                cameraRotationX,

            rotationY:
                cameraRotationY,

            rotationZ:
                cameraRotationZ,

            fieldOfView:
                fieldOfView,

            focalLength:
                focalLength,

            nearClip:
                nearClip,

            farClip:
                farClip
        };
    }


    /*
     * ============================================================
     * GET STATUS
     * ============================================================
 */

    public static function getStatus():Dynamic
    {
        return {
            enabled:
                enabled,

            initialized:
                initialized,

            paused:
                paused,

            objects:
                objects.length,

            cameraX:
                cameraX,

            cameraY:
                cameraY,

            cameraZ:
                cameraZ,

            fieldOfView:
                fieldOfView
        };
    }
}