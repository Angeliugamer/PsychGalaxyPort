/*
 * ============================================================
 * RenderPath.hx
 * ============================================================
 *
 * Port de RenderPath.hx de FNF In The Galaxy / Kade Engine
 * para utilizarse desde Psych Engine 1.0.4 mediante HScript.
 *
 * ============================================================
 *
 * RenderPath NO es un renderer 3D completo.
 *
 * Su función es generar:
 *
 *     1. Coordenadas de los vértices
 *     2. Coordenadas UVT
 *
 * para posteriormente poder dibujar una superficie deformada
 * mediante FlxDrawTriangles / OpenFL.
 *
 * ============================================================
 *
 * MODOS ORIGINALES:
 *
 *     0 = circle
 *     1 = angle
 *
 * ============================================================
 *
 * MODE 0 - CIRCLE
 *
 * Parámetros:
 *
 *     par[0] = num
 *     par[1] = all
 *     par[2] = centerX
 *     par[3] = centerY
 *     par[4] = radius
 *
 *
 * MODE 1 - ANGLE
 *
 * Parámetros:
 *
 *     par[0] = startDistance
 *     par[1] = endDistance
 *     par[2] = centerX
 *     par[3] = centerY
 *     par[4] = width
 *     par[5] = angle
 *     par[6] = maxDistance
 *
 * ============================================================
 */

class RenderPath
{
    /*
     * ============================================================
     * PROPIEDADES
     * ============================================================
     */

    /**
     * Tipo de trayectoria.
     *
     * 0 = circle
     * 1 = angle
     */
    public var mode:Int;


    /**
     * Parámetros utilizados por el modo seleccionado.
     */
    public var par:Array<Float>;


    /**
     * Indica si esta trayectoria pertenece a un splash.
     *
     * Se mantiene porque forma parte de la implementación
     * original de GalaxyMod.
     */
    public var isSplash:Bool = false;


    /**
     * Factor utilizado por el sistema original.
     *
     * Se conserva para mantener compatibilidad con las
     * mecánicas que puedan acceder directamente a esta variable.
     */
    public var bili:Float = 1;


    /*
     * ============================================================
     * CONSTRUCTOR
     * ============================================================
     */

    public function new(
        mode:Int,
        pars:Array<Float>,
        isSplash:Bool = false
    )
    {
        this.mode = mode;
        this.par = pars;
        this.isSplash = isSplash;
    }


    /*
     * ============================================================
     * START
     * ============================================================
     *
     * Genera:
     *
     *     [0] = vertices
     *     [1] = UVT
     *
     *
     * vertices:
     *
     *     [
     *         x1, y1,
     *         x2, y2,
     *         x3, y3,
     *         x4, y4
     *     ]
     *
     *
     * UVT:
     *
     *     [
     *         u1, v1,
     *         u2, v2,
     *         u3, v3,
     *         u4, v4
     *     ]
     *
     * ============================================================
     */

    public function start(
        head:Float,
        tail:Float
    ):Array<Array<Float>>
    {
        /*
         * UV inicial.
         *
         * Mantiene exactamente la disposición utilizada
         * por el RenderPath original.
         */
        var uvt:Array<Float> = [
            0, head,
            1, head,
            0, tail,
            1, tail
        ];


        /*
         * ========================================================
         * MODE 0
         * CIRCLE
         * ========================================================
         *
         * Parámetros:
         *
         *     [0] num
         *     [1] all
         *     [2] x
         *     [3] y
         *     [4] radius
         *
         * ========================================================
         */

        switch (mode)
        {
            case 0:

                var sorder:Float =
                    (par[0] + head) / par[1];

                var eorder:Float =
                    (par[0] + tail) / par[1];


                var ang1:Float =
                    sorder * (2 * Math.PI);

                var ang2:Float =
                    eorder * (2 * Math.PI);


                /*
                 * Punto inicial de la trayectoria.
                 */
                var x1:Float =
                    par[2] -
                    Math.sin(ang1) *
                    par[4];

                var y1:Float =
                    par[3] +
                    Math.cos(ang1) *
                    par[4];


                /*
                 * Punto final de la trayectoria.
                 */
                var x2:Float =
                    par[2] -
                    Math.sin(ang2) *
                    par[4];

                var y2:Float =
                    par[3] +
                    Math.cos(ang2) *
                    par[4];


                /*
                 * El primer y tercer punto son el centro.
                 *
                 * Resultado:
                 *
                 *     center
                 *       |
                 *       +--- start
                 *
                 *       center
                 *       |
                 *       +--- end
                 */
                return [
                    [
                        par[2], par[3],
                        x1, y1,
                        par[2], par[3],
                        x2, y2
                    ],
                    uvt
                ];


            /*
             * ====================================================
             * MODE 1
             * ANGLE
             * ====================================================
             *
             * Parámetros:
             *
             *     [0] start distance
             *     [1] end distance
             *     [2] x
             *     [3] y
             *     [4] width
             *     [5] angle
             *     [6] max distance
             *
             * ====================================================
             */

            case 1:

                /*
                 * Interpolamos la distancia correspondiente
                 * al principio y final de la sustain.
                 */
                var sdist:Float =
                    lerp(
                        par[0],
                        par[1],
                        head
                    );

                var edist:Float =
                    lerp(
                        par[0],
                        par[1],
                        tail
                    );


                /*
                 * tail puede ser recortado si se alcanza
                 * maxDistance.
                 */
                var tael:Float = tail;


                /*
                 * Si el comienzo ya está fuera del límite,
                 * no dibujamos nada.
                 */
                if (par[6] > 0 && sdist > par[6])
                {
                    return [
                        [
                            0, 0,
                            0, 0,
                            0, 0,
                            0, 0
                        ],
                        uvt
                    ];
                }


                /*
                 * Si el final supera maxDistance,
                 * recortamos la sustain.
                 */
                if (par[6] > 0 && edist > par[6])
                {
                    tael =
                        head +
                        (
                            (par[6] - sdist) /
                            (edist - sdist)
                        ) *
                        (tail - head);

                    edist = par[6];
                }


                /*
                 * Convertimos grados a radianes.
                 */
                var ang:Float =
                    par[5] / 180 * Math.PI;


                /*
                 * =================================================
                 * VÉRTICES DEL EXTREMO INICIAL
                 * =================================================
                 */

                var x1:Float =
                    par[2] -
                    Math.cos(ang) *
                    par[4] / 2 -
                    Math.sin(ang) *
                    sdist;

                var y1:Float =
                    par[3] -
                    Math.sin(ang) *
                    par[4] / 2 +
                    Math.cos(ang) *
                    sdist;


                var x2:Float =
                    par[2] +
                    Math.cos(ang) *
                    par[4] / 2 -
                    Math.sin(ang) *
                    sdist;

                var y2:Float =
                    par[3] +
                    Math.sin(ang) *
                    par[4] / 2 +
                    Math.cos(ang) *
                    sdist;


                /*
                 * =================================================
                 * VÉRTICES DEL EXTREMO FINAL
                 * =================================================
                 */

                var x3:Float =
                    par[2] -
                    Math.cos(ang) *
                    par[4] / 2 -
                    Math.sin(ang) *
                    edist;

                var y3:Float =
                    par[3] -
                    Math.sin(ang) *
                    par[4] / 2 +
                    Math.cos(ang) *
                    edist;


                var x4:Float =
                    par[2] +
                    Math.cos(ang) *
                    par[4] / 2 -
                    Math.sin(ang) *
                    edist;

                var y4:Float =
                    par[3] +
                    Math.sin(ang) *
                    par[4] / 2 +
                    Math.cos(ang) *
                    edist;


                /*
                 * UV actualizado en caso de recorte.
                 */
                uvt = [
                    0, head,
                    1, head,
                    0, tael,
                    1, tael
                ];


                return [
                    [
                        x1, y1,
                        x2, y2,
                        x3, y3,
                        x4, y4
                    ],
                    uvt
                ];
        }


        /*
         * ========================================================
         * MODO DESCONOCIDO
         * ========================================================
         */

        return null;
    }


    /*
     * ============================================================
     * LERP
     * ============================================================
     *
     * Equivalente al FlxMath.lerp utilizado originalmente.
     *
     * Mantenerlo aquí evita que RenderPath dependa de
     * FlxMath únicamente para una operación matemática básica.
     * ============================================================
     */

    private static function lerp(
        a:Float,
        b:Float,
        ratio:Float
    ):Float
    {
        return a + (b - a) * ratio;
    }
}