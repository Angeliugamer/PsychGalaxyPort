/*
 * ============================================================
 * GalaxyNote.hx
 * ============================================================
 *
 * Capa de abstracción para las Note de Psych Engine 1.0.4.
 *
 * Este archivo NO contiene mecánicas.
 *
 * Su función es proporcionar una interfaz común para que las
 * mecánicas Galaxy puedan trabajar con las notas sin tener que
 * acceder directamente a todas las propiedades internas de
 * Psych Engine.
 *
 * ============================================================
 */

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;

import objects.Note;
import states.PlayState;


class GalaxyNote
{
    /*
     * ============================================================
     * OBTENER NOTAS
     * ============================================================
     */

    /**
     * Obtiene una Note desde un grupo de notas de Psych.
     *
     * type:
     *
     * 0 = notas del oponente
     * 1 = notas del jugador
     *
     * index corresponde al índice dentro del grupo.
     */
    public static function get(index:Int, ?mustPress:Bool = true):Note
    {
        var group:Dynamic;

        if (mustPress)
            group = PlayState.instance.playerStrums;
        else
            group = PlayState.instance.opponentStrums;

        if (group == null)
            return null;

        if (index < 0 || index >= group.length)
            return null;

        return PlayState.instance.notes.members[index];
    }


    /**
     * Devuelve una nota del grupo principal de notas de la canción.
     *
     * Esta función será especialmente importante para las
     * mecánicas que necesitan trabajar con las notas que aparecen
     * durante la canción y no con los strums.
     */
    public static function getNote(index:Int):Note
    {
        if (PlayState.instance.notes == null)
            return null;

        if (index < 0 || index >= PlayState.instance.notes.length)
            return null;

        return PlayState.instance.notes.members[index];
    }


    /*
     * ============================================================
     * POSICIÓN
     * ============================================================
     */

    /**
     * Obtiene X.
     */
    public static function getX(note:Note):Float
    {
        if (note == null)
            return 0;

        return note.x;
    }


    /**
     * Obtiene Y.
     */
    public static function getY(note:Note):Float
    {
        if (note == null)
            return 0;

        return note.y;
    }


    /**
     * Establece X.
     */
    public static function setX(note:Note, value:Float):Void
    {
        if (note == null)
            return;

        note.x = value;
    }


    /**
     * Establece Y.
     */
    public static function setY(note:Note, value:Float):Void
    {
        if (note == null)
            return;

        note.y = value;
    }


    /**
     * Mueve X una cantidad determinada.
     */
    public static function addX(note:Note, amount:Float):Void
    {
        if (note == null)
            return;

        note.x += amount;
    }


    /**
     * Mueve Y una cantidad determinada.
     */
    public static function addY(note:Note, amount:Float):Void
    {
        if (note == null)
            return;

        note.y += amount;
    }


    /**
     * Establece X e Y.
     */
    public static function setPosition(
        note:Note,
        x:Float,
        y:Float
    ):Void
    {
        if (note == null)
            return;

        note.x = x;
        note.y = y;
    }


    /**
     * Mueve X e Y.
     */
    public static function addPosition(
        note:Note,
        x:Float,
        y:Float
    ):Void
    {
        if (note == null)
            return;

        note.x += x;
        note.y += y;
    }


    /*
     * ============================================================
     * ESCALA
     * ============================================================
     */

    /**
     * Obtiene escala X.
     */
    public static function getScaleX(note:Note):Float
    {
        if (note == null)
            return 1;

        return note.scale.x;
    }


    /**
     * Obtiene escala Y.
     */
    public static function getScaleY(note:Note):Float
    {
        if (note == null)
            return 1;

        return note.scale.y;
    }


    /**
     * Establece escala X.
     */
    public static function setScaleX(
        note:Note,
        value:Float
    ):Void
    {
        if (note == null)
            return;

        note.scale.x = value;
        note.updateHitbox();
    }


    /**
     * Establece escala Y.
     */
    public static function setScaleY(
        note:Note,
        value:Float
    ):Void
    {
        if (note == null)
            return;

        note.scale.y = value;
        note.updateHitbox();
    }


    /**
     * Establece escala X e Y.
     */
    public static function setScale(
        note:Note,
        x:Float,
        y:Float
    ):Void
    {
        if (note == null)
            return;

        note.scale.set(x, y);
        note.updateHitbox();
    }


    /**
     * Multiplica la escala actual.
     */
    public static function multiplyScale(
        note:Note,
        x:Float,
        y:Float
    ):Void
    {
        if (note == null)
            return;

        note.scale.x *= x;
        note.scale.y *= y;

        note.updateHitbox();
    }


    /*
     * ============================================================
     * ROTACIÓN
     * ============================================================
     */

    /**
     * Obtiene el ángulo.
     */
    public static function getAngle(note:Note):Float
    {
        if (note == null)
            return 0;

        return note.angle;
    }


    /**
     * Establece el ángulo.
     */
    public static function setAngle(
        note:Note,
        value:Float
    ):Void
    {
        if (note == null)
            return;

        note.angle = value;
    }


    /**
     * Añade rotación.
     */
    public static function addAngle(
        note:Note,
        amount:Float
    ):Void
    {
        if (note == null)
            return;

        note.angle += amount;
    }


    /*
     * ============================================================
     * ALPHA
     * ============================================================
     */

    /**
     * Obtiene alpha.
     */
    public static function getAlpha(note:Note):Float
    {
        if (note == null)
            return 0;

        return note.alpha;
    }


    /**
     * Establece alpha.
     */
    public static function setAlpha(
        note:Note,
        value:Float
    ):Void
    {
        if (note == null)
            return;

        note.alpha = FlxMath.bound(value, 0, 1);
    }


    /**
     * Añade alpha.
     */
    public static function addAlpha(
        note:Note,
        amount:Float
    ):Void
    {
        if (note == null)
            return;

        note.alpha = FlxMath.bound(
            note.alpha + amount,
            0,
            1
        );
    }


    /*
     * ============================================================
     * VISIBILIDAD
     * ============================================================
     */

    /**
     * Obtiene si la nota es visible.
     */
    public static function getVisible(note:Note):Bool
    {
        if (note == null)
            return false;

        return note.visible;
    }


    /**
     * Establece visibilidad.
     */
    public static function setVisible(
        note:Note,
        value:Bool
    ):Void
    {
        if (note == null)
            return;

        note.visible = value;
    }


    /*
     * ============================================================
     * PROPIEDADES DE LA NOTA
     * ============================================================
     */

    /**
     * Obtiene noteData.
     *
     * En Psych:
     *
     * 0 = izquierda
     * 1 = abajo
     * 2 = arriba
     * 3 = derecha
     */
    public static function getNoteData(note:Note):Int
    {
        if (note == null)
            return 0;

        return note.noteData;
    }


    /**
     * Obtiene si la nota pertenece al jugador.
     */
    public static function isPlayerNote(note:Note):Bool
    {
        if (note == null)
            return false;

        return note.mustPress;
    }


    /**
     * Obtiene si es una sustain note.
     */
    public static function isSustain(note:Note):Bool
    {
        if (note == null)
            return false;

        return note.isSustainNote;
    }


    /**
     * Obtiene si es una nota de la CPU.
     */
    public static function isOpponent(note:Note):Bool
    {
        if (note == null)
            return false;

        return !note.mustPress;
    }


    /*
     * ============================================================
     * TIEMPO
     * ============================================================
     */

    /**
     * Obtiene el tiempo de la nota.
     */
    public static function getStrumTime(note:Note):Float
    {
        if (note == null)
            return 0;

        return note.strumTime;
    }


    /**
     * Devuelve cuánto falta para que la nota llegue
     * al tiempo actual de la canción.
     */
    public static function getTimeDifference(note:Note):Float
    {
        if (note == null)
            return 0;

        return note.strumTime - Conductor.songPosition;
    }


    /*
     * ============================================================
     * ANGULO / DIRECCIÓN
     * ============================================================
     */

    /**
     * Establece el ángulo dependiendo de una dirección.
     *
     * 0 = normal
     * 1 = invertido
     */
    public static function setDirection(
        note:Note,
        downscroll:Bool
    ):Void
    {
        if (note == null)
            return;

        if (downscroll)
            note.angle = 180;
        else
            note.angle = 0;
    }


    /**
     * Invierte el ángulo actual.
     */
    public static function flipAngle(note:Note):Void
    {
        if (note == null)
            return;

        note.angle += 180;

        while (note.angle >= 360)
            note.angle -= 360;

        while (note.angle < 0)
            note.angle += 360;
    }


    /*
     * ============================================================
     * RESET
     * ============================================================
     */

    /**
     * Restablece las propiedades visuales básicas.
     *
     * IMPORTANTE:
     * Esto NO intenta restaurar automáticamente la posición
     * original de Psych.
     *
     * Solamente restaura las propiedades que esta capa controla.
     */
    public static function resetVisual(
        note:Note
    ):Void
    {
        if (note == null)
            return;

        note.alpha = 1;
        note.visible = true;
        note.angle = 0;

        note.scale.set(1, 1);
        note.updateHitbox();
    }


    /*
     * ============================================================
     * UTILIDADES
     * ============================================================
     */

    /**
     * Comprueba si la nota existe y sigue siendo válida.
     */
    public static function valid(note:Note):Bool
    {
        return note != null;
    }


    /**
     * Obtiene el número total de notas del PlayState.
     */
    public static function getNoteCount():Int
    {
        if (PlayState.instance.notes == null)
            return 0;

        return PlayState.instance.notes.length;
    }


    /**
     * Devuelve el tiempo actual de la canción.
     */
    public static function getSongPosition():Float
    {
        return Conductor.songPosition;
    }
}