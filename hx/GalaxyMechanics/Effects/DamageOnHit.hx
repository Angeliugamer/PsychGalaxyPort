/*
 * ============================================================
 * DamageOnHit.hx
 * ============================================================
 *
 * FNF In The Galaxy -> Psych Engine 1.0.4
 *
 * Sistema de daño al golpear notas.
 *
 * ============================================================
 *
 * RESPONSABILIDAD:
 *
 *     - Aplicar daño al jugador al golpear una nota
 *     - Configurar daño fijo
 *     - Configurar daño dependiendo del tipo de nota
 *     - Configurar daño dependiendo de la dirección
 *     - Configurar daño dependiendo de la dificultad
 *     - Permitir activar/desactivar el sistema
 *     - Permitir limitar el daño
 *     - Permitir ignorar notas específicas
 *
 * ============================================================
 *
 * NO SE ENCARGA DE:
 *
 *     - Crear notas
 *     - Detectar input directamente
 *     - Crear HUD
 *     - Crear efectos visuales
 *     - Controlar cámara
 *     - Controlar animaciones
 *
 * Lua debe llamar:
 *
 *     DamageOnHit.onHit(noteIndex)
 *
 * desde goodNoteHit().
 *
 * ============================================================
 */

import flixel.FlxBasic;

import states.PlayState;


/**
 * DamageOnHit
 *
 * Controlador de daño producido por golpes.
 */
class DamageOnHit
{
    /*
     * ============================================================
     * CONFIGURATION
     * ============================================================
     */

    private static var enabled:Bool = false;

    private static var damageAmount:Float = 0.05;

    private static var minimumHealth:Float = 0.0;

    private static var maximumHealth:Float = 2.0;

    private static var allowDeath:Bool = true;

    private static var affectOpponent:Bool = false;


    /*
     * ============================================================
     * NOTE FILTER
     * ============================================================
     *
     * Si está vacío:
     *
     *     todas las notas.
     *
     * Si contiene valores:
     *
     *     solamente esos tipos de nota.
     *
     * ============================================================
     */

    private static var allowedNoteTypes:Array<String> =
        [];


    /*
     * ============================================================
     * IGNORED NOTES
     * ============================================================
     *
     * Índices que no deben producir daño.
     *
     * ============================================================
     */

    private static var ignoredNotes:Array<Int> =
        [];


    /*
     * ============================================================
     * DIRECTION FILTER
     * ============================================================
     *
     * -1 = todas
     *
     * ============================================================
 */

    private static var directionFilter:Int = -1;


    /*
     * ============================================================
     * COUNTER
     * ============================================================
 */

    private static var damageHits:Int = 0;


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
     * SET DAMAGE
     * ============================================================
 */

    public static function setDamage(
        amount:Float
    ):Void
    {
        damageAmount =
            amount;

        if (damageAmount < 0)
            damageAmount = 0;
    }


    /*
     * ============================================================
     * GET DAMAGE
     * ============================================================
 */

    public static function getDamage():Float
    {
        return damageAmount;
    }


    /*
     * ============================================================
     * SET HEALTH LIMITS
     * ============================================================
 */

    public static function setHealthLimits(
        minimum:Float,
        maximum:Float
    ):Void
    {
        minimumHealth =
            minimum;

        maximumHealth =
            maximum;


        if (minimumHealth < 0)
            minimumHealth = 0;


        if (maximumHealth < minimumHealth)
        {
            maximumHealth =
                minimumHealth;
        }
    }


    /*
     * ============================================================
     * SET MINIMUM HEALTH
     * ============================================================
 */

    public static function setMinimumHealth(
        value:Float
    ):Void
    {
        minimumHealth =
            value;


        if (minimumHealth < 0)
            minimumHealth = 0;
    }


    /*
     * ============================================================
     * SET MAXIMUM HEALTH
     * ============================================================
 */

    public static function setMaximumHealth(
        value:Float
    ):Void
    {
        maximumHealth =
            value;


        if (maximumHealth < minimumHealth)
        {
            maximumHealth =
                minimumHealth;
        }
    }


    /*
     * ============================================================
     * ALLOW DEATH
     * ============================================================
 */

    public static function setAllowDeath(
        value:Bool
    ):Void
    {
        allowDeath =
            value;
    }


    /*
     * ============================================================
     * AFFECT OPPONENT
     * ============================================================
 *
 * Normalmente el daño se aplica al jugador.
 *
 * ============================================================
 */

    public static function setAffectOpponent(
        value:Bool
    ):Void
    {
        affectOpponent =
            value;
    }


    /*
     * ============================================================
     * ADD NOTE TYPE
     * ============================================================
 */

    public static function addNoteType(
        noteType:String
    ):Void
    {
        if (noteType == null)
            return;


        if (noteType == "")
            return;


        if (!allowedNoteTypes.contains(
            noteType
        ))
        {
            allowedNoteTypes.push(
                noteType
            );
        }
    }


    /*
     * ============================================================
     * REMOVE NOTE TYPE
     * ============================================================
 */

    public static function removeNoteType(
        noteType:String
    ):Void
    {
        allowedNoteTypes.remove(
            noteType
        );
    }


    /*
     * ============================================================
     * CLEAR NOTE TYPES
     * ============================================================
 */

    public static function clearNoteTypes():Void
    {
        allowedNoteTypes =
            [];
    }


    /*
     * ============================================================
     * SET NOTE TYPES
     * ============================================================
 */

    public static function setNoteTypes(
        noteTypes:Array<String>
    ):Void
    {
        allowedNoteTypes =
            noteTypes != null
            ? noteTypes.copy()
            : [];
    }


    /*
     * ============================================================
     * SET DIRECTION
     * ============================================================
 *
 * direction:
 *
 *     -1 = todas
 *      0 = LEFT
 *      1 = DOWN
 *      2 = UP
 *      3 = RIGHT
 *
 * ============================================================
 */

    public static function setDirection(
        direction:Int
    ):Void
    {
        directionFilter =
            direction;


        if (directionFilter < -1)
            directionFilter = -1;

        if (directionFilter > 3)
            directionFilter = -1;
    }


    /*
     * ============================================================
     * IGNORE NOTE
     * ============================================================
 */

    public static function ignoreNote(
        noteIndex:Int
    ):Void
    {
        if (!ignoredNotes.contains(
            noteIndex
        ))
        {
            ignoredNotes.push(
                noteIndex
            );
        }
    }


    /*
     * ============================================================
     * UNIGNORE NOTE
     * ============================================================
 */

    public static function unignoreNote(
        noteIndex:Int
    ):Void
    {
        ignoredNotes.remove(
            noteIndex
        );
    }


    /*
     * ============================================================
     * CLEAR IGNORED
     * ============================================================
 */

    public static function clearIgnored():Void
    {
        ignoredNotes =
            [];
    }


    /*
     * ============================================================
     * GET NOTE
     * ============================================================
 */

    private static function getNote(
        noteIndex:Int
    ):Dynamic
    {
        if (PlayState.instance == null)
            return null;


        if (PlayState.instance.notes == null)
            return null;


        if (noteIndex < 0)
            return null;


        if (noteIndex >=
            PlayState.instance.notes.length)
        {
            return null;
        }


        return
            PlayState.instance
                .notes
                .members[noteIndex];
    }


    /*
     * ============================================================
     * GET NOTE TYPE
     * ============================================================
 */

    private static function getNoteType(
        note:Dynamic
    ):String
    {
        if (note == null)
            return "";


        try
        {
            if (note.noteType != null)
            {
                return
                    Std.string(
                        note.noteType
                    );
            }
        }
        catch (e:Dynamic)
        {
        }


        return "";
    }


    /*
     * ============================================================
     * GET NOTE DIRECTION
     * ============================================================
 */

    private static function getNoteDirection(
        note:Dynamic
    ):Int
    {
        if (note == null)
            return -1;


        try
        {
            return
                Std.int(
                    note.noteData
                );
        }
        catch (e:Dynamic)
        {
        }


        return -1;
    }


    /*
     * ============================================================
     * CHECK NOTE TYPE
     * ============================================================
 */

    private static function acceptsNoteType(
        note:Dynamic
    ):Bool
    {
        /*
         * Sin filtros:
         * aceptar cualquier tipo.
         */

        if (allowedNoteTypes.length <= 0)
            return true;


        var noteType:String =
            getNoteType(
                note
            );


        return
            allowedNoteTypes.contains(
                noteType
            );
    }


    /*
     * ============================================================
     * CHECK DIRECTION
     * ============================================================
 */

    private static function acceptsDirection(
        note:Dynamic
    ):Bool
    {
        if (directionFilter < 0)
            return true;


        var direction:Int =
            getNoteDirection(
                note
            );


        return
            direction ==
            directionFilter;
    }


    /*
     * ============================================================
     * CHECK IGNORED
     * ============================================================
 */

    private static function isIgnored(
        noteIndex:Int
    ):Bool
    {
        return
            ignoredNotes.contains(
                noteIndex
            );
    }


    /*
     * ============================================================
     * APPLY PLAYER DAMAGE
     * ============================================================
 */

    private static function applyPlayerDamage(
        amount:Float
    ):Void
    {
        if (PlayState.instance == null)
            return;


        /*
         * Obtener salud actual.
         */

        var health:Float =
            PlayState.instance.health;


        /*
         * Aplicar daño.
         */

        health -=
            amount;


        /*
         * Limitar salud.
         */

        if (!allowDeath &&
            health < minimumHealth)
        {
            health =
                minimumHealth;
        }


        if (health > maximumHealth)
        {
            health =
                maximumHealth;
        }


        /*
         * Evitar valores negativos.
         */

        if (health < minimumHealth)
        {
            health =
                minimumHealth;
        }


        PlayState.instance.health =
            health;
    }


    /*
     * ============================================================
     * APPLY OPPONENT DAMAGE
     * ============================================================
 *
 * Algunas mecánicas de Galaxy pueden necesitar que el efecto
 * afecte al oponente.
 *
 * Psych no posee un sistema estándar de "salud del oponente"
 * equivalente al del jugador, por lo que esta función queda
 * separada para permitir futuras extensiones.
 *
 * ============================================================
 */

    private static function applyOpponentDamage(
        amount:Float
    ):Void
    {
        /*
         * Reservado para mecánicas futuras.
         *
         * Actualmente no se modifica la salud del oponente.
         */
    }


    /*
     * ============================================================
     * ON HIT
     * ============================================================
 *
 * Debe llamarse desde goodNoteHit().
 *
 * ============================================================
 */

    public static function onHit(
        noteIndex:Int
    ):Void
    {
        if (!enabled)
            return;


        if (isIgnored(
            noteIndex
        ))
        {
            return;
        }


        var note:Dynamic =
            getNote(
                noteIndex
            );


        if (note == null)
            return;


        /*
         * Comprobar tipo.
         */

        if (!acceptsNoteType(
            note
        ))
        {
            return;
        }


        /*
         * Comprobar dirección.
         */

        if (!acceptsDirection(
            note
        ))
        {
            return;
        }


        /*
         * Aplicar daño.
         */

        if (affectOpponent)
        {
            applyOpponentDamage(
                damageAmount
            );
        }
        else
        {
            applyPlayerDamage(
                damageAmount
            );
        }


        damageHits++;
    }


    /*
     * ============================================================
     * DAMAGE DIRECT
     * ============================================================
 *
 * Aplica daño inmediatamente sin necesitar una Note.
 *
 * ============================================================
 */

    public static function damage(
        amount:Float
    ):Void
    {
        if (amount < 0)
            amount = 0;


        if (affectOpponent)
        {
            applyOpponentDamage(
                amount
            );
        }
        else
        {
            applyPlayerDamage(
                amount
            );
        }
    }


    /*
     * ============================================================
     * GET HIT COUNT
     * ============================================================
 */

    public static function getHitCount():Int
    {
        return damageHits;
    }


    /*
     * ============================================================
     * RESET HIT COUNT
     * ============================================================
 */

    public static function resetHitCount():Void
    {
        damageHits =
            0;
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


        damageAmount =
            0.05;


        minimumHealth =
            0.0;


        maximumHealth =
            2.0;


        allowDeath =
            true;


        affectOpponent =
            false;


        allowedNoteTypes =
            [];


        ignoredNotes =
            [];


        directionFilter =
            -1;


        damageHits =
            0;
    }
}