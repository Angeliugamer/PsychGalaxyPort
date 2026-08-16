/*
 * ============================================================
 * GalaxyStrum.hx
 * ============================================================
 *
 * Capa base para trabajar con StrumNote en Psych Engine 1.0.4.
 *
 * Este archivo NO implementa una mecánica concreta.
 *
 * Su objetivo es proporcionar una API común para las mecánicas
 * que trabajan con los receptors/strums.
 *
 * ============================================================
 *
 * Estructura:
 *
 *                  GalaxyStrum
 *                       |
 *          +------------+------------+
 *          |            |            |
 *       Position     Rotation      Visual
 *          |            |            |
 *          v            v            v
 *       x / y          angle      alpha/visible
 *
 * Las mecánicas individuales utilizan esta capa:
 *
 *     MoverStrums.hx
 *     MoverStrumsVertical.hx
 *     MoverStrumsCircular.hx
 *     RotarStrums.hx
 *     StrumPerspective.hx
 *
 * ============================================================
 */

import objects.StrumNote;
import states.PlayState;


class GalaxyStrum
{
    /*
     * ============================================================
     * CONSTANTES
     * ============================================================
     */

    /**
     * Número de strums estándar por jugador.
     *
     * Psych Engine normalmente utiliza 4K:
     *
     *     0 = LEFT
     *     1 = DOWN
     *     2 = UP
     *     3 = RIGHT
     */
    public static inline var STRUM_COUNT:Int = 4;


    /*
     * ============================================================
     * DATOS DE POSICIÓN BASE
     * ============================================================
     *
     * Estos arrays permiten que una mecánica pueda modificar
     * temporalmente la posición de un strum sin perder la
     * posición original.
     *
     * Ejemplo:
     *
     *     baseX + desplazamiento
     *
     * ============================================================
     */

    public static var playerBaseX:Array<Float> = [];
    public static var playerBaseY:Array<Float> = [];

    public static var opponentBaseX:Array<Float> = [];
    public static var opponentBaseY:Array<Float> = [];


    /*
     * ============================================================
     * ESTADO
     * ============================================================
     */

    public static var initialized:Bool = false;


    /*
     * ============================================================
     * INIT
     * ============================================================
     *
     * Guarda las posiciones actuales de todos los strums.
     *
     * Debe llamarse después de que Psych Engine haya creado
     * playerStrums y opponentStrums.
     *
     * Normalmente:
     *
     *     onCreatePost()
     *
     * ============================================================
     */

    public static function init():Void
    {
        playerBaseX = [];
        playerBaseY = [];

        opponentBaseX = [];
        opponentBaseY = [];

        var playerGroup:Dynamic =
            getPlayerGroup();

        var opponentGroup:Dynamic =
            getOpponentGroup();


        /*
         * Player
         */
        if (playerGroup != null)
        {
            for (i in 0...playerGroup.length)
            {
                var strum:StrumNote =
                    playerGroup.members[i];

                if (strum == null)
                    continue;

                playerBaseX[i] = strum.x;
                playerBaseY[i] = strum.y;
            }
        }


        /*
         * Opponent
         */
        if (opponentGroup != null)
        {
            for (i in 0...opponentGroup.length)
            {
                var strum:StrumNote =
                    opponentGroup.members[i];

                if (strum == null)
                    continue;

                opponentBaseX[i] = strum.x;
                opponentBaseY[i] = strum.y;
            }
        }


        initialized = true;
    }


    /*
     * ============================================================
     * PLAYSTATE
     * ============================================================
     */

    public static function getPlayState():Dynamic
    {
        return PlayState.instance;
    }


    /*
     * ============================================================
     * GROUPS
     * ============================================================
     */

    /**
     * Obtiene el grupo de strums del jugador.
     */
    public static function getPlayerGroup():Dynamic
    {
        if (PlayState.instance == null)
            return null;

        return PlayState.instance.playerStrums;
    }


    /**
     * Obtiene el grupo de strums del oponente.
     */
    public static function getOpponentGroup():Dynamic
    {
        if (PlayState.instance == null)
            return null;

        return PlayState.instance.opponentStrums;
    }


    /*
     * ============================================================
     * GET
     * ============================================================
     */

    /**
     * Obtiene un strum.
     *
     * noteData:
     *
     *     0 = LEFT
     *     1 = DOWN
     *     2 = UP
     *     3 = RIGHT
     *
     * mustPress:
     *
     *     true  = jugador
     *     false = oponente
     */
    public static function get(
        noteData:Int,
        mustPress:Bool = true
    ):StrumNote
    {
        if (noteData < 0 ||
            noteData >= STRUM_COUNT)
        {
            return null;
        }

        var group:Dynamic =
            mustPress
                ? getPlayerGroup()
                : getOpponentGroup();

        return getFromGroup(
            group,
            noteData
        );
    }


    /**
     * Obtiene un strum directamente de un grupo.
     */
    public static function getFromGroup(
        group:Dynamic,
        index:Int
    ):StrumNote
    {
        if (group == null)
            return null;

        if (index < 0 ||
            index >= group.length)
        {
            return null;
        }

        return group.members[index];
    }


    /*
     * ============================================================
     * PLAYER / OPPONENT
     * ============================================================
     */

    public static function getPlayer(
        noteData:Int
    ):StrumNote
    {
        return get(
            noteData,
            true
        );
    }


    public static function getOpponent(
        noteData:Int
    ):StrumNote
    {
        return get(
            noteData,
            false
        );
    }


    /*
     * ============================================================
     * NOTE DATA
     * ============================================================
     */

    /**
     * Devuelve el ID/NoteData del strum.
     */
    public static function getNoteData(
        strum:StrumNote
    ):Int
    {
        if (strum == null)
            return -1;

        return strum.ID;
    }


    /*
     * ============================================================
     * POSITION
     * ============================================================
     */

    public static function getX(
        strum:StrumNote
    ):Float
    {
        if (strum == null)
            return 0;

        return strum.x;
    }


    public static function getY(
        strum:StrumNote
    ):Float
    {
        if (strum == null)
            return 0;

        return strum.y;
    }


    public static function setX(
        strum:StrumNote,
        value:Float
    ):Void
    {
        if (strum == null)
            return;

        strum.x = value;
    }


    public static function setY(
        strum:StrumNote,
        value:Float
    ):Void
    {
        if (strum == null)
            return;

        strum.y = value;
    }


    public static function setPosition(
        strum:StrumNote,
        x:Float,
        y:Float
    ):Void
    {
        if (strum == null)
            return;

        strum.x = x;
        strum.y = y;
    }


    public static function addPosition(
        strum:StrumNote,
        x:Float,
        y:Float
    ):Void
    {
        if (strum == null)
            return;

        strum.x += x;
        strum.y += y;
    }


    /*
     * ============================================================
     * BASE POSITION
     * ============================================================
     */

    /**
     * Obtiene X base de un strum.
     */
    public static function getBaseX(
        noteData:Int,
        mustPress:Bool = true
    ):Float
    {
        var array:Array<Float> =
            mustPress
                ? playerBaseX
                : opponentBaseX;

        if (noteData < 0 ||
            noteData >= array.length)
        {
            return 0;
        }

        return array[noteData];
    }


    /**
     * Obtiene Y base de un strum.
     */
    public static function getBaseY(
        noteData:Int,
        mustPress:Bool = true
    ):Float
    {
        var array:Array<Float> =
            mustPress
                ? playerBaseY
                : opponentBaseY;

        if (noteData < 0 ||
            noteData >= array.length)
        {
            return 0;
        }

        return array[noteData];
    }


    /**
     * Obtiene la posición base completa.
     */
    public static function getBasePosition(
        noteData:Int,
        mustPress:Bool = true
    ):Dynamic
    {
        return {
            x: getBaseX(
                noteData,
                mustPress
            ),

            y: getBaseY(
                noteData,
                mustPress
            )
        };
    }


    /**
     * Guarda manualmente una posición como base.
     */
    public static function setBasePosition(
        noteData:Int,
        x:Float,
        y:Float,
        mustPress:Bool = true
    ):Void
    {
        var xArray:Array<Float> =
            mustPress
                ? playerBaseX
                : opponentBaseX;

        var yArray:Array<Float> =
            mustPress
                ? playerBaseY
                : opponentBaseY;


        while (xArray.length <= noteData)
            xArray.push(0);

        while (yArray.length <= noteData)
            yArray.push(0);


        xArray[noteData] = x;
        yArray[noteData] = y;
    }


    /**
     * Restaura un strum a su posición base.
     */
    public static function resetPosition(
        noteData:Int,
        mustPress:Bool = true
    ):Void
    {
        var strum:StrumNote =
            get(
                noteData,
                mustPress
            );

        if (strum == null)
            return;


        strum.x =
            getBaseX(
                noteData,
                mustPress
            );

        strum.y =
            getBaseY(
                noteData,
                mustPress
            );
    }


    /*
     * ============================================================
     * ROTATION
     * ============================================================
     */

    public static function getAngle(
        strum:StrumNote
    ):Float
    {
        if (strum == null)
            return 0;

        return strum.angle;
    }


    public static function setAngle(
        strum:StrumNote,
        value:Float
    ):Void
    {
        if (strum == null)
            return;

        strum.angle = value;
    }


    public static function addAngle(
        strum:StrumNote,
        value:Float
    ):Void
    {
        if (strum == null)
            return;

        strum.angle += value;
    }


    /*
     * ============================================================
     * ESCALA
     * ============================================================
     */

    public static function getScaleX(
        strum:StrumNote
    ):Float
    {
        if (strum == null)
            return 1;

        return strum.scale.x;
    }


    public static function getScaleY(
        strum:StrumNote
    ):Float
    {
        if (strum == null)
            return 1;

        return strum.scale.y;
    }


    public static function setScale(
        strum:StrumNote,
        x:Float,
        y:Float
    ):Void
    {
        if (strum == null)
            return;

        strum.scale.x = x;
        strum.scale.y = y;

        strum.updateHitbox();
    }


    public static function addScale(
        strum:StrumNote,
        x:Float,
        y:Float
    ):Void
    {
        if (strum == null)
            return;

        strum.scale.x += x;
        strum.scale.y += y;

        strum.updateHitbox();
    }


    public static function multiplyScale(
        strum:StrumNote,
        x:Float,
        y:Float
    ):Void
    {
        if (strum == null)
            return;

        strum.scale.x *= x;
        strum.scale.y *= y;

        strum.updateHitbox();
    }


    /*
     * ============================================================
     * ALPHA
     * ============================================================
     */

    public static function getAlpha(
        strum:StrumNote
    ):Float
    {
        if (strum == null)
            return 0;

        return strum.alpha;
    }


    public static function setAlpha(
        strum:StrumNote,
        value:Float
    ):Void
    {
        if (strum == null)
            return;

        strum.alpha = clamp(
            value,
            0,
            1
        );
    }


    public static function addAlpha(
        strum:StrumNote,
        value:Float
    ):Void
    {
        if (strum == null)
            return;

        setAlpha(
            strum,
            strum.alpha + value
        );
    }


    /*
     * ============================================================
     * VISIBILITY
     * ============================================================
     */

    public static function isVisible(
        strum:StrumNote
    ):Bool
    {
        if (strum == null)
            return false;

        return strum.visible;
    }


    public static function setVisible(
        strum:StrumNote,
        value:Bool
    ):Void
    {
        if (strum == null)
            return;

        strum.visible = value;
    }


    /*
     * ============================================================
     * RESET VISUAL
     * ============================================================
     *
     * Restaura propiedades visuales básicas.
     *
     * No restaura posición.
     */
    public static function resetVisual(
        strum:StrumNote
    ):Void
    {
        if (strum == null)
            return;

        strum.angle = 0;

        strum.scale.x = 1;
        strum.scale.y = 1;

        strum.alpha = 1;

        strum.visible = true;

        strum.updateHitbox();
    }


    /*
     * ============================================================
     * GROUP OPERATIONS
     * ============================================================
     */

    /**
     * Ejecuta una función sobre todos los strums de un grupo.
     *
     * mustPress:
     *
     *     true  = player
     *     false = opponent
     */
    public static function forEach(
        mustPress:Bool,
        callback:StrumNote->Int->Void
    ):Void
    {
        var group:Dynamic =
            mustPress
                ? getPlayerGroup()
                : getOpponentGroup();

        if (group == null)
            return;


        for (i in 0...group.length)
        {
            var strum:StrumNote =
                group.members[i];

            if (strum == null)
                continue;

            callback(
                strum,
                i
            );
        }
    }


    /**
     * Mueve todos los strums de un grupo.
     */
    public static function moveGroup(
        mustPress:Bool,
        x:Float,
        y:Float
    ):Void
    {
        forEach(
            mustPress,
            function(
                strum:StrumNote,
                index:Int
            )
            {
                strum.x += x;
                strum.y += y;
            }
        );
    }


    /**
     * Añade un desplazamiento relativo a todos los strums.
     */
    public static function offsetGroup(
        mustPress:Bool,
        x:Float,
        y:Float
    ):Void
    {
        forEach(
            mustPress,
            function(
                strum:StrumNote,
                index:Int
            )
            {
                strum.x =
                    getBaseX(
                        index,
                        mustPress
                    ) + x;

                strum.y =
                    getBaseY(
                        index,
                        mustPress
                    ) + y;
            }
        );
    }


    /**
     * Restaura todos los strums de un grupo a su posición base.
     */
    public static function resetGroupPosition(
        mustPress:Bool
    ):Void
    {
        forEach(
            mustPress,
            function(
                strum:StrumNote,
                index:Int
            )
            {
                strum.x =
                    getBaseX(
                        index,
                        mustPress
                    );

                strum.y =
                    getBaseY(
                        index,
                        mustPress
                    );
            }
        );
    }


    /**
     * Restaura las propiedades visuales de un grupo.
     */
    public static function resetGroupVisual(
        mustPress:Bool
    ):Void
    {
        forEach(
            mustPress,
            function(
                strum:StrumNote,
                index:Int
            )
            {
                resetVisual(strum);
            }
        );
    }


    /*
     * ============================================================
     * CENTER
     * ============================================================
     *
     * Obtiene el centro aproximado del receptor.
     *
     * Útil posteriormente para:
     *
     *     MoverStrumsCircular
     *     StrumPerspective
     *     etc.
     */
    public static function getCenter(
        strum:StrumNote
    ):Dynamic
    {
        if (strum == null)
            return {
                x: 0,
                y: 0
            };

        return {
            x: strum.x + strum.width / 2,
            y: strum.y + strum.height / 2
        };
    }


    /*
     * ============================================================
     * DISTANCIA
     * ============================================================
     */

    public static function distance(
        a:StrumNote,
        b:StrumNote
    ):Float
    {
        if (a == null ||
            b == null)
        {
            return 0;
        }

        var dx:Float =
            a.x - b.x;

        var dy:Float =
            a.y - b.y;

        return Math.sqrt(
            dx * dx +
            dy * dy
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


    /*
     * ============================================================
     * RESET
     * ============================================================
     */

    /**
     * Borra la información almacenada por GalaxyStrum.
     *
     * No elimina ni modifica los strums de Psych.
     */
    public static function reset():Void
    {
        playerBaseX = [];
        playerBaseY = [];

        opponentBaseX = [];
        opponentBaseY = [];

        initialized = false;
    }
}