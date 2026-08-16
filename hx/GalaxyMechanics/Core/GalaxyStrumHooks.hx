/*
 * ============================================================
 * GalaxyStrumHooks.hx
 * ============================================================
 *
 * Sistema de Hooks para los Strum/Receptors de
 * Psych Engine 1.0.4.
 *
 * Este archivo NO contiene mecánicas específicas.
 *
 * Su función es proporcionar los puntos de entrada que
 * posteriormente utilizarán las mecánicas individuales
 * relacionadas con los strums.
 *
 * ============================================================
 *
 * Arquitectura:
 *
 *                 Psych Engine
 *                       |
 *                       v
 *              GalaxyStrumHooks
 *                       |
 *          +------------+------------+
 *          |            |            |
 *          v            v            v
 *       position      angle        alpha
 *          |
 *          v
 *     MoverStrums.hx
 *
 * ============================================================
 */

import objects.StrumNote;
import states.PlayState;


class GalaxyStrumHooks
{
    /*
     * ============================================================
     * ESTADO
     * ============================================================
     */

    /**
     * Activa/desactiva completamente el sistema.
     */
    public static var enabled:Bool = true;

    /**
     * Permite bloquear las modificaciones de posición.
     */
    public static var positionHooksEnabled:Bool = true;

    /**
     * Permite bloquear las modificaciones de rotación.
     */
    public static var rotationHooksEnabled:Bool = true;

    /**
     * Permite bloquear las modificaciones de escala.
     */
    public static var scaleHooksEnabled:Bool = true;

    /**
     * Permite bloquear las modificaciones de alpha/visibilidad.
     */
    public static var visibilityHooksEnabled:Bool = true;


    /*
     * ============================================================
     * INICIALIZACIÓN
     * ============================================================
     */

    public static function init():Void
    {
        enabled = true;

        positionHooksEnabled = true;
        rotationHooksEnabled = true;
        scaleHooksEnabled = true;
        visibilityHooksEnabled = true;
    }


    /**
     * Activa los hooks.
     */
    public static function enable():Void
    {
        enabled = true;
    }


    /**
     * Desactiva los hooks.
     */
    public static function disable():Void
    {
        enabled = false;
    }


    /*
     * ============================================================
     * OBTENER STRUM
     * ============================================================
     *
     * 0 = izquierda
     * 1 = abajo
     * 2 = arriba
     * 3 = derecha
     *
     * mustPress:
     *
     * true  = jugador
     * false = oponente
     *
     * ============================================================
     */

    public static function get(
        noteData:Int,
        mustPress:Bool = true
    ):StrumNote
    {
        if (PlayState.instance == null)
            return null;

        if (noteData < 0 || noteData > 3)
            return null;

        var group:Dynamic;

        if (mustPress)
            group = PlayState.instance.playerStrums;
        else
            group = PlayState.instance.opponentStrums;

        if (group == null)
            return null;

        if (noteData >= group.length)
            return null;

        return group.members[noteData];
    }


    /**
     * Obtiene un strum directamente de un grupo.
     *
     * Esta función se mantiene separada de get() para que las
     * mecánicas puedan trabajar con grupos personalizados
     * posteriormente.
     */
    public static function getFromGroup(
        group:Dynamic,
        index:Int
    ):StrumNote
    {
        if (group == null)
            return null;

        if (index < 0 || index >= group.length)
            return null;

        return group.members[index];
    }


    /*
     * ============================================================
     * UPDATE
     * ============================================================
     *
     * Hook general ejecutado durante la actualización.
     *
     * Aquí posteriormente podrán intervenir mecánicas como:
     *
     * MoverStrums
     * RotarStrums
     * StrumPerspective
     * etc.
     *
     * ============================================================
     */

    public static function update(elapsed:Float):Void
    {
        if (!enabled)
            return;

        /*
         * No modificamos ningún strum directamente.
         *
         * El dispatcher de Galaxy se encargará posteriormente
         * de enviar este callback a las mecánicas cargadas.
         */
    }


    /**
     * Actualiza un strum individual.
     */
    public static function updateStrum(
        strum:StrumNote,
        elapsed:Float
    ):Void
    {
        if (!enabled)
            return;

        if (strum == null)
            return;

        /*
         * Reservado para las mecánicas individuales.
         */
    }


    /*
     * ============================================================
     * POSITION
     * ============================================================
     *
     * Hook principal para modificaciones de posición.
     *
     * Conceptualmente:
     *
     *     spos()
     *
     * de los sistemas de Kade/Galaxy.
     *
     * ============================================================
     */

    public static function position(
        strum:StrumNote,
        elapsed:Float
    ):Void
    {
        if (!enabled || !positionHooksEnabled)
            return;

        if (strum == null)
            return;

        /*
         * NO modificar strum.x / strum.y aquí.
         *
         * Ejemplo futuro:
         *
         * MoverStrums.position(strum, elapsed);
         * WaveStrums.position(strum, elapsed);
         * PerspectiveStrums.position(strum, elapsed);
         */
    }


    /**
     * Modifica conceptualmente la posición de un strum.
     *
     * Esta función existe como segundo hook para mecánicas que
     * necesiten distinguir entre:
     *
     * posición base
     *
     * y
     *
     * posición modificada.
     */
    public static function setPosition(
        strum:StrumNote,
        x:Float,
        y:Float
    ):Void
    {
        if (!enabled || !positionHooksEnabled)
            return;

        if (strum == null)
            return;

        strum.x = x;
        strum.y = y;
    }


    /*
     * ============================================================
     * POSITION X
     * ============================================================
     */

    public static function setX(
        strum:StrumNote,
        value:Float
    ):Void
    {
        if (!enabled || !positionHooksEnabled)
            return;

        if (strum == null)
            return;

        strum.x = value;
    }


    /*
     * ============================================================
     * POSITION Y
     * ============================================================
     */

    public static function setY(
        strum:StrumNote,
        value:Float
    ):Void
    {
        if (!enabled || !positionHooksEnabled)
            return;

        if (strum == null)
            return;

        strum.y = value;
    }


    /*
     * ============================================================
     * ADD POSITION
     * ============================================================
     */

    public static function addPosition(
        strum:StrumNote,
        x:Float,
        y:Float
    ):Void
    {
        if (!enabled || !positionHooksEnabled)
            return;

        if (strum == null)
            return;

        strum.x += x;
        strum.y += y;
    }


    /*
     * ============================================================
     * ROTATION
     * ============================================================
     */

    public static function rotation(
        strum:StrumNote,
        elapsed:Float
    ):Void
    {
        if (!enabled || !rotationHooksEnabled)
            return;

        if (strum == null)
            return;

        /*
         * Reservado para:
         *
         * RotarStrums.hx
         * PerspectiveStrums.hx
         * etc.
         */
    }


    /**
     * Establece directamente el ángulo.
     */
    public static function setAngle(
        strum:StrumNote,
        value:Float
    ):Void
    {
        if (!enabled || !rotationHooksEnabled)
            return;

        if (strum == null)
            return;

        strum.angle = value;
    }


    /**
     * Añade una cantidad al ángulo actual.
     */
    public static function addAngle(
        strum:StrumNote,
        value:Float
    ):Void
    {
        if (!enabled || !rotationHooksEnabled)
            return;

        if (strum == null)
            return;

        strum.angle += value;
    }


    /*
     * ============================================================
     * ESCALA
     * ============================================================
     */

    public static function scale(
        strum:StrumNote,
        elapsed:Float
    ):Void
    {
        if (!enabled || !scaleHooksEnabled)
            return;

        if (strum == null)
            return;

        /*
         * Reservado para:
         *
         * ScaleStrums.hx
         * PerspectiveStrums.hx
         * etc.
         */
    }


    /**
     * Establece escala X/Y.
     */
    public static function setScale(
        strum:StrumNote,
        x:Float,
        y:Float
    ):Void
    {
        if (!enabled || !scaleHooksEnabled)
            return;

        if (strum == null)
            return;

        strum.scale.set(x, y);
        strum.updateHitbox();
    }


    /**
     * Multiplica la escala actual.
     */
    public static function multiplyScale(
        strum:StrumNote,
        x:Float,
        y:Float
    ):Void
    {
        if (!enabled || !scaleHooksEnabled)
            return;

        if (strum == null)
            return;

        strum.scale.x *= x;
        strum.scale.y *= y;

        strum.updateHitbox();
    }


    /*
     * ============================================================
     * ALPHA / VISIBILIDAD
     * ============================================================
     */

    public static function visibility(
        strum:StrumNote,
        elapsed:Float
    ):Void
    {
        if (!enabled || !visibilityHooksEnabled)
            return;

        if (strum == null)
            return;

        /*
         * Reservado para:
         *
         * HideStrums.hx
         * FadeStrums.hx
         * etc.
         */
    }


    /**
     * Establece alpha.
     */
    public static function setAlpha(
        strum:StrumNote,
        value:Float
    ):Void
    {
        if (!enabled || !visibilityHooksEnabled)
            return;

        if (strum == null)
            return;

        strum.alpha = value;
    }


    /**
     * Modifica alpha.
     */
    public static function addAlpha(
        strum:StrumNote,
        value:Float
    ):Void
    {
        if (!enabled || !visibilityHooksEnabled)
            return;

        if (strum == null)
            return;

        strum.alpha += value;

        if (strum.alpha < 0)
            strum.alpha = 0;

        if (strum.alpha > 1)
            strum.alpha = 1;
    }


    /**
     * Establece visibilidad.
     */
    public static function setVisible(
        strum:StrumNote,
        value:Bool
    ):Void
    {
        if (!enabled || !visibilityHooksEnabled)
            return;

        if (strum == null)
            return;

        strum.visible = value;
    }


    /*
     * ============================================================
     * STRUM DATA
     * ============================================================
     */

    /**
     * Obtiene el noteData asociado al strum.
     *
     * 0 = izquierda
     * 1 = abajo
     * 2 = arriba
     * 3 = derecha
     */
    public static function getNoteData(
        strum:StrumNote
    ):Int
    {
        if (strum == null)
            return -1;

        return strum.ID;
    }


    /**
     * Obtiene un strum del jugador.
     */
    public static function getPlayerStrum(
        noteData:Int
    ):StrumNote
    {
        return get(noteData, true);
    }


    /**
     * Obtiene un strum del oponente.
     */
    public static function getOpponentStrum(
        noteData:Int
    ):StrumNote
    {
        return get(noteData, false);
    }


    /*
     * ============================================================
     * STRUM LINE
     * ============================================================
     *
     * Estas funciones serán especialmente útiles para portar
     * las partes de Galaxy/Kade que mueven la línea completa
     * de strums.
     * ============================================================
     */

    /**
     * Mueve todos los strums de un lado.
     *
     * mustPress:
     *
     * true  = jugador
     * false = oponente
     */
    public static function moveGroup(
        mustPress:Bool,
        x:Float,
        y:Float
    ):Void
    {
        if (!enabled || !positionHooksEnabled)
            return;

        var group:Dynamic;

        if (mustPress)
            group = PlayState.instance.playerStrums;
        else
            group = PlayState.instance.opponentStrums;

        if (group == null)
            return;

        for (strum in group.members)
        {
            if (strum == null)
                continue;

            strum.x += x;
            strum.y += y;
        }
    }


    /**
     * Establece la posición de todos los strums de un lado.
     */
    public static function setGroupPosition(
        mustPress:Bool,
        x:Float,
        y:Float
    ):Void
    {
        if (!enabled || !positionHooksEnabled)
            return;

        var group:Dynamic;

        if (mustPress)
            group = PlayState.instance.playerStrums;
        else
            group = PlayState.instance.opponentStrums;

        if (group == null)
            return;

        for (strum in group.members)
        {
            if (strum == null)
                continue;

            strum.x = x;
            strum.y = y;
        }
    }


    /*
     * ============================================================
     * RESET
     * ============================================================
     */

    /**
     * Restablece el estado de los hooks.
     *
     * NO modifica las posiciones de los strums.
     */
    public static function reset():Void
    {
        enabled = true;

        positionHooksEnabled = true;
        rotationHooksEnabled = true;
        scaleHooksEnabled = true;
        visibilityHooksEnabled = true;
    }
}