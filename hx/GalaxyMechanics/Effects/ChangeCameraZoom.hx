/*
 * ============================================================
 * ChangeCameraZoom.hx
 * ============================================================
 *
 * FNF In The Galaxy -> Psych Engine 1.0.4
 *
 * Control independiente del zoom de las cámaras.
 *
 * ============================================================
 *
 * RESPONSABILIDAD:
 *
 *     - Cambiar el zoom de la cámara de juego
 *     - Cambiar el zoom del HUD
 *     - Establecer zoom absoluto
 *     - Añadir zoom relativo
 *     - Crear pulsos de zoom
 *     - Crear zoom por beat
 *     - Interpolar zoom
 *     - Limitar zoom mínimo/máximo
 *
 * ============================================================
 *
 * NO SE ENCARGA DE:
 *
 *     - Mover la cámara
 *     - Rotar la cámara
 *     - Seguir personajes
 *     - Controlar notas
 *     - Controlar HUD
 *     - Crear shaders
 *
 * ============================================================
 */

import flixel.FlxBasic;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;


/**
 * ChangeCameraZoom
 *
 * Controlador de zoom para las cámaras de Psych Engine.
 */
class ChangeCameraZoom
{
    /*
     * ============================================================
     * CONFIGURATION
     * ============================================================
     */

    private static var enabled:Bool = true;

    private static var minZoom:Float = 0.0;

    private static var maxZoom:Float = 10.0;


    /*
     * ============================================================
     * BEAT ZOOM
     * ============================================================
     */

    private static var beatZoomEnabled:Bool = false;

    private static var beatZoomAmount:Float = 0.03;

    private static var beatZoomDuration:Float = 0.15;

    private static var beatZoomInterval:Int = 1;

    private static var lastBeat:Int = -1;


    /*
     * ============================================================
     * TWEENS
     * ============================================================
     */

    private static var gameZoomTween:FlxTween = null;

    private static var hudZoomTween:FlxTween = null;


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
     * ENABLE
     * ============================================================
 */

    public static function enable():Void
    {
        enabled =
            true;
    }


    /*
     * ============================================================
     * DISABLE
     * ============================================================
 */

    public static function disable():Void
    {
        enabled =
            false;

        beatZoomEnabled =
            false;
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
     * SET LIMITS
     * ============================================================
 */

    public static function setLimits(
        minimum:Float,
        maximum:Float
    ):Void
    {
        minZoom =
            minimum;

        maxZoom =
            maximum;


        if (minZoom < 0)
            minZoom = 0;


        if (maxZoom < minZoom)
        {
            maxZoom =
                minZoom;
        }
    }


    /*
     * ============================================================
     * CLAMP
     * ============================================================
 */

    private static function clampZoom(
        value:Float
    ):Float
    {
        if (value < minZoom)
            value = minZoom;


        if (value > maxZoom)
            value = maxZoom;


        return value;
    }


    /*
     * ============================================================
     * GET GAME CAMERA
     * ============================================================
 */

    private static function getGameCamera():Dynamic
    {
        if (PlayState.instance == null)
            return null;


        return
            PlayState.instance.camGame;
    }


    /*
     * ============================================================
     * GET HUD CAMERA
     * ============================================================
 */

    private static function getHUDCamera():Dynamic
    {
        if (PlayState.instance == null)
            return null;


        return
            PlayState.instance.camHUD;
    }


    /*
     * ============================================================
     * GET GAME ZOOM
     * ============================================================
 */

    public static function getGameZoom():Float
    {
        var camera:Dynamic =
            getGameCamera();


        if (camera == null)
            return 0;


        return
            camera.zoom;
    }


    /*
     * ============================================================
     * GET HUD ZOOM
     * ============================================================
 */

    public static function getHUDZoom():Float
    {
        var camera:Dynamic =
            getHUDCamera();


        if (camera == null)
            return 0;


        return
            camera.zoom;
    }


    /*
     * ============================================================
     * SET GAME ZOOM
     * ============================================================
 */

    public static function setGameZoom(
        value:Float
    ):Void
    {
        if (!enabled)
            return;


        var camera:Dynamic =
            getGameCamera();


        if (camera == null)
            return;


        camera.zoom =
            clampZoom(
                value
            );
    }


    /*
     * ============================================================
     * SET HUD ZOOM
     * ============================================================
 */

    public static function setHUDZoom(
        value:Float
    ):Void
    {
        if (!enabled)
            return;


        var camera:Dynamic =
            getHUDCamera();


        if (camera == null)
            return;


        camera.zoom =
            clampZoom(
                value
            );
    }


    /*
     * ============================================================
     * ADD GAME ZOOM
     * ============================================================
 */

    public static function addGameZoom(
        amount:Float
    ):Void
    {
        if (!enabled)
            return;


        setGameZoom(
            getGameZoom() +
            amount
        );
    }


    /*
     * ============================================================
     * ADD HUD ZOOM
     * ============================================================
 */

    public static function addHUDZoom(
        amount:Float
    ):Void
    {
        if (!enabled)
            return;


        setHUDZoom(
            getHUDZoom() +
            amount
        );
    }


    /*
     * ============================================================
     * SET BOTH
     * ============================================================
 */

    public static function setBoth(
        value:Float
    ):Void
    {
        if (!enabled)
            return;


        setGameZoom(
            value
        );

        setHUDZoom(
            value
        );
    }


    /*
     * ============================================================
     * ADD BOTH
     * ============================================================
 */

    public static function addBoth(
        amount:Float
    ):Void
    {
        if (!enabled)
            return;


        addGameZoom(
            amount
        );

        addHUDZoom(
            amount
        );
    }


    /*
     * ============================================================
     * CANCEL GAME TWEEN
     * ============================================================
 */

    public static function cancelGameTween():Void
    {
        if (gameZoomTween != null)
        {
            gameZoomTween.cancel();

            gameZoomTween =
                null;
        }
    }


    /*
     * ============================================================
     * CANCEL HUD TWEEN
     * ============================================================
 */

    public static function cancelHUDTween():Void
    {
        if (hudZoomTween != null)
        {
            hudZoomTween.cancel();

            hudZoomTween =
                null;
        }
    }


    /*
     * ============================================================
     * TWEEN GAME ZOOM
     * ============================================================
 */

    public static function tweenGameZoom(
        target:Float,
        duration:Float,
        ease:Dynamic = null
    ):Void
    {
        if (!enabled)
            return;


        var camera:Dynamic =
            getGameCamera();


        if (camera == null)
            return;


        cancelGameTween();


        target =
            clampZoom(
                target
            );


        if (duration <= 0)
        {
            camera.zoom =
                target;

            return;
        }


        if (ease == null)
        {
            ease =
                FlxEase.linear;
        }


        gameZoomTween =
            FlxTween.tween(
                camera,
                {
                    zoom: target
                },
                duration,
                {
                    ease: ease,
                    onComplete: function(tween:FlxTween)
                    {
                        gameZoomTween =
                            null;
                    }
                }
            );
    }


    /*
     * ============================================================
     * TWEEN HUD ZOOM
     * ============================================================
 */

    public static function tweenHUDZoom(
        target:Float,
        duration:Float,
        ease:Dynamic = null
    ):Void
    {
        if (!enabled)
            return;


        var camera:Dynamic =
            getHUDCamera();


        if (camera == null)
            return;


        cancelHUDTween();


        target =
            clampZoom(
                target
            );


        if (duration <= 0)
        {
            camera.zoom =
                target;

            return;
        }


        if (ease == null)
        {
            ease =
                FlxEase.linear;
        }


        hudZoomTween =
            FlxTween.tween(
                camera,
                {
                    zoom: target
                },
                duration,
                {
                    ease: ease,
                    onComplete: function(tween:FlxTween)
                    {
                        hudZoomTween =
                            null;
                    }
                }
            );
    }


    /*
     * ============================================================
     * TWEEN BOTH
     * ============================================================
 */

    public static function tweenBoth(
        target:Float,
        duration:Float,
        ease:Dynamic = null
    ):Void
    {
        if (!enabled)
            return;


        tweenGameZoom(
            target,
            duration,
            ease
        );


        tweenHUDZoom(
            target,
            duration,
            ease
        );
    }


    /*
     * ============================================================
     * PULSE GAME
     * ============================================================
 *
 * Aumenta temporalmente el zoom y vuelve al original.
 *
 * ============================================================
 */

    public static function pulseGame(
        amount:Float,
        duration:Float = 0.15,
        ease:Dynamic = null
    ):Void
    {
        if (!enabled)
            return;


        var camera:Dynamic =
            getGameCamera();


        if (camera == null)
            return;


        var original:Float =
            camera.zoom;


        var target:Float =
            clampZoom(
                original +
                amount
            );


        cancelGameTween();


        if (duration <= 0)
        {
            camera.zoom =
                target;

            camera.zoom =
                original;

            return;
        }


        if (ease == null)
        {
            ease =
                FlxEase.quadOut;
        }


        gameZoomTween =
            FlxTween.tween(
                camera,
                {
                    zoom: target
                },
                duration,
                {
                    ease: ease,
                    onComplete: function(tween:FlxTween)
                    {
                        gameZoomTween =
                            FlxTween.tween(
                                camera,
                                {
                                    zoom: original
                                },
                                duration,
                                {
                                    ease: FlxEase.quadIn,
                                    onComplete: function(t:FlxTween)
                                    {
                                        gameZoomTween =
                                            null;
                                    }
                                }
                            );
                    }
                }
            );
    }


    /*
     * ============================================================
     * PULSE HUD
     * ============================================================
 */

    public static function pulseHUD(
        amount:Float,
        duration:Float = 0.15,
        ease:Dynamic = null
    ):Void
    {
        if (!enabled)
            return;


        var camera:Dynamic =
            getHUDCamera();


        if (camera == null)
            return;


        var original:Float =
            camera.zoom;


        var target:Float =
            clampZoom(
                original +
                amount
            );


        cancelHUDTween();


        if (duration <= 0)
        {
            camera.zoom =
                target;

            camera.zoom =
                original;

            return;
        }


        if (ease == null)
        {
            ease =
                FlxEase.quadOut;
        }


        hudZoomTween =
            FlxTween.tween(
                camera,
                {
                    zoom: target
                },
                duration,
                {
                    ease: ease,
                    onComplete: function(tween:FlxTween)
                    {
                        hudZoomTween =
                            FlxTween.tween(
                                camera,
                                {
                                    zoom: original
                                },
                                duration,
                                {
                                    ease: FlxEase.quadIn,
                                    onComplete: function(t:FlxTween)
                                    {
                                        hudZoomTween =
                                            null;
                                    }
                                }
                            );
                    }
                }
            );
    }


    /*
     * ============================================================
     * PULSE BOTH
     * ============================================================
 */

    public static function pulseBoth(
        amount:Float,
        duration:Float = 0.15
    ):Void
    {
        if (!enabled)
            return;


        pulseGame(
            amount,
            duration
        );


        pulseHUD(
            amount,
            duration
        );
    }


    /*
     * ============================================================
     * BEAT ZOOM SETUP
     * ============================================================
 *
 * Configura un zoom automático por beat.
 *
 * ============================================================
 */

    public static function setupBeatZoom(
        amount:Float = 0.03,
        duration:Float = 0.15,
        interval:Int = 1
    ):Void
    {
        beatZoomAmount =
            amount;


        beatZoomDuration =
            duration;


        beatZoomInterval =
            interval;


        if (beatZoomInterval < 1)
            beatZoomInterval = 1;


        beatZoomEnabled =
            true;


        lastBeat =
            -1;
    }


    /*
     * ============================================================
     * DISABLE BEAT ZOOM
     * ============================================================
 */

    public static function disableBeatZoom():Void
    {
        beatZoomEnabled =
            false;

        lastBeat =
            -1;
    }


    /*
     * ============================================================
     * ON BEAT
     * ============================================================
 *
 * Debe ser llamado desde onBeatHit().
 *
 * ============================================================
 */

    public static function onBeat(
        beat:Int
    ):Void
    {
        if (!enabled)
            return;


        if (!beatZoomEnabled)
            return;


        if (beat == lastBeat)
            return;


        if (beat < 0)
            return;


        if ((beat %
            beatZoomInterval) != 0)
        {
            return;
        }


        lastBeat =
            beat;


        pulseGame(
            beatZoomAmount,
            beatZoomDuration
        );
    }


    /*
     * ============================================================
     * RESET
     * ============================================================
 */

    public static function reset():Void
    {
        cancelGameTween();

        cancelHUDTween();


        enabled =
            true;


        minZoom =
            0.0;


        maxZoom =
            10.0;


        beatZoomEnabled =
            false;


        beatZoomAmount =
            0.03;


        beatZoomDuration =
            0.15;


        beatZoomInterval =
            1;


        lastBeat =
            -1;
    }
}