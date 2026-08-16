/*
 * ============================================================
 * BeatCharacterAnimation.hx
 * ============================================================
 *
 * FNF In The Galaxy -> Psych Engine 1.0.4
 *
 * Sistema de animaciones de personajes sincronizadas con el beat.
 *
 * ============================================================
 *
 * RESPONSABILIDAD:
 *
 *     - Reproducir animaciones de personajes por beat
 *     - Controlar intervalos de beats
 *     - Controlar animaciones diferentes por beat
 *     - Controlar Dad / Boyfriend / GF
 *     - Controlar personajes mediante tag
 *     - Permitir animaciones alternadas
 *     - Permitir detener el sistema
 *
 * ============================================================
 *
 * NO SE ENCARGA DE:
 *
 *     - Crear personajes
 *     - Cambiar personajes
 *     - Cambiar sprites
 *     - Controlar notas
 *     - Controlar cámara
 *     - Controlar BPM
 *
 * ============================================================
 */

import flixel.FlxBasic;


/**
 * BeatCharacterAnimation
 *
 * Controlador de animaciones sincronizadas con beats.
 */
class BeatCharacterAnimation
{
    /*
     * ============================================================
     * CONFIGURATION
     * ============================================================
     */

    private static var enabled:Bool = false;

    private static var targetTag:String = "";

    private static var animationName:String = "";

    private static var beatInterval:Int = 1;

    private static var nextBeat:Int = 0;

    private static var forceAnimation:Bool = false;

    private static var alternateAnimations:Array<String> = [];

    private static var alternateIndex:Int = 0;


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
     * GET CHARACTER
     * ============================================================
 *
 * Obtiene un personaje por su tag.
 *
 * Soporta:
 *
 *     boyfriend
 *     dad
 *     gf
 *
 * Y personajes añadidos mediante Psych.
 *
 * ============================================================
 */

    private static function getCharacter(
        tag:String
    ):Dynamic
    {
        if (PlayState.instance == null)
            return null;


        switch (tag)
        {
            case "boyfriend":
                return PlayState.instance.boyfriend;

            case "dad":
                return PlayState.instance.dad;

            case "gf":
                return PlayState.instance.gf;
        }


        /*
         * Intentar obtener un personaje mediante
         * los sistemas internos de Psych.
         */

        try
        {
            var character:Dynamic =
                PlayState.instance.getLuaObject(
                    tag
                );

            if (character != null)
                return character;
        }
        catch (e:Dynamic)
        {
        }


        return null;
    }


    /*
     * ============================================================
     * PLAY
     * ============================================================
 *
 * Reproduce una animación inmediatamente.
 *
 * ============================================================
 */

    public static function play(
        tag:String,
        animation:String,
        force:Bool = false
    ):Void
    {
        var character:Dynamic =
            getCharacter(
                tag
            );


        if (character == null)
            return;


        try
        {
            character.playAnim(
                animation,
                force
            );
        }
        catch (e:Dynamic)
        {
        }
    }


    /*
     * ============================================================
     * SETUP
     * ============================================================
 *
 * Activa el sistema de beat.
 *
 * ============================================================
 *
 * Ejemplo:
 *
 *     setup("dad", "idle", 1);
 *
 * ============================================================
 */

    public static function setup(
        tag:String,
        animation:String,
        interval:Int = 1,
        force:Bool = false
    ):Void
    {
        targetTag =
            tag;

        animationName =
            animation;

        beatInterval =
            interval;


        if (beatInterval < 1)
            beatInterval = 1;


        forceAnimation =
            force;


        alternateAnimations =
            [];

        alternateIndex =
            0;


        enabled =
            true;


        nextBeat =
            Conductor.songPosition >= 0
            ? Math.ceil(
                Conductor.songPosition /
                Conductor.crochet
            )
            : 0;
    }


    /*
     * ============================================================
     * SET INTERVAL
     * ============================================================
 */

    public static function setInterval(
        interval:Int
    ):Void
    {
        if (interval < 1)
            interval = 1;


        beatInterval =
            interval;
    }


    /*
     * ============================================================
     * SET ANIMATION
     * ============================================================
 */

    public static function setAnimation(
        animation:String
    ):Void
    {
        animationName =
            animation;
    }


    /*
     * ============================================================
     * SET FORCE
     * ============================================================
 */

    public static function setForce(
        value:Bool
    ):Void
    {
        forceAnimation =
            value;
    }


    /*
     * ============================================================
     * ALTERNATE
     * ============================================================
 *
 * Permite alternar entre varias animaciones.
 *
 * Ejemplo:
 *
 *     setAlternate([
 *         "idle",
 *         "idle-alt"
 *     ]);
 *
 * ============================================================
 */

    public static function setAlternate(
        animations:Array<String>
    ):Void
    {
        alternateAnimations =
            animations.copy();

        alternateIndex =
            0;
    }


    /*
     * ============================================================
     * ADD ALTERNATE
     * ============================================================
 */

    public static function addAlternate(
        animation:String
    ):Void
    {
        alternateAnimations.push(
            animation
        );
    }


    /*
     * ============================================================
     * CLEAR ALTERNATE
     * ============================================================
 */

    public static function clearAlternate():Void
    {
        alternateAnimations =
            [];

        alternateIndex =
            0;
    }


    /*
     * ============================================================
     * ON BEAT
     * ============================================================
 *
 * Esta función debe ser llamada desde el callback
 * onBeatHit() de Lua.
 *
 * ============================================================
 */

    public static function onBeat(
        beat:Int
    ):Void
    {
        if (!enabled)
            return;


        if (beatInterval <= 0)
            beatInterval = 1;


        if (beat < nextBeat)
            return;


        /*
         * Determinar el siguiente beat.
         */

        while (nextBeat <= beat)
        {
            nextBeat +=
                beatInterval;
        }


        /*
         * Animaciones alternadas.
         */

        if (alternateAnimations.length > 0)
        {
            var animation:String =
                alternateAnimations[
                    alternateIndex
                ];


            play(
                targetTag,
                animation,
                forceAnimation
            );


            alternateIndex++;


            if (alternateIndex >=
                alternateAnimations.length)
            {
                alternateIndex =
                    0;
            }


            return;
        }


        /*
         * Animación normal.
         */

        if (animationName != "")
        {
            play(
                targetTag,
                animationName,
                forceAnimation
            );
        }
    }


    /*
     * ============================================================
     * PLAY ALTERNATE NOW
     * ============================================================
 *
 * Reproduce inmediatamente la siguiente animación
 * de la lista alternativa.
 *
 * ============================================================
 */

    public static function playAlternateNow():Void
    {
        if (alternateAnimations.length <= 0)
            return;


        var animation:String =
            alternateAnimations[
                alternateIndex
            ];


        play(
            targetTag,
            animation,
            forceAnimation
        );


        alternateIndex++;


        if (alternateIndex >=
            alternateAnimations.length)
        {
            alternateIndex =
                0;
        }
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
    }


    /*
     * ============================================================
     * RESET
     * ============================================================
 */

    public static function reset():Void
    {
        enabled =
            false;

        targetTag =
            "";

        animationName =
            "";

        beatInterval =
            1;

        nextBeat =
            0;

        forceAnimation =
            false;

        alternateAnimations =
            [];

        alternateIndex =
            0;
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
     * GET TARGET
     * ============================================================
 */

    public static function getTarget():String
    {
        return targetTag;
    }


    /*
     * ============================================================
     * GET ANIMATION
     * ============================================================
 */

    public static function getAnimation():String
    {
        return animationName;
    }


    /*
     * ============================================================
     * GET INTERVAL
     * ============================================================
 */

    public static function getInterval():Int
    {
        return beatInterval;
    }
}