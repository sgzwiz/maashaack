﻿/*  Version: MPL 1.1/GPL 2.0/LGPL 2.1   The contents of this file are subject to the Mozilla Public License Version  1.1 (the "License"); you may not use this file except in compliance with  the License. You may obtain a copy of the License at  http://www.mozilla.org/MPL/    Software distributed under the License is distributed on an "AS IS" basis,  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License  for the specific language governing rights and limitations under the  License.    The Original Code is [maashaack framework].    The Initial Developers of the Original Code are  Zwetan Kjukov <zwetan@gmail.com> and Marc Alcaraz <ekameleon@gmail.com>.  Portions created by the Initial Developers are Copyright (C) 2006-2009  the Initial Developers. All Rights Reserved.    Contributor(s):    Alternatively, the contents of this file may be used under the terms of  either the GNU General Public License Version 2 or later (the "GPL"), or  the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),  in which case the provisions of the GPL or the LGPL are applicable instead  of those above. If you wish to allow use of your version of this file only  under the terms of either the GPL or the LGPL, and not to allow others to  use your version of this file under the terms of the MPL, indicate your  decision by deleting the provisions above and replace them with the notice  and other provisions required by the LGPL or the GPL. If you do not delete  the provisions above, a recipient may use your version of this file under  the terms of any one of the MPL, the GPL or the LGPL.*/package graphics.geom {    import graphics.geom.Line;    import graphics.geom.Lines;    import graphics.geom.Vector2;        /**     * Static tool class to creates and manipulates Bezier curves.     * <p><b>Thanks :</b>     * <ul>      * <li>Robert Penner : <a href="http://www.robertpenner.com">http://www.robertpenner.com</a></li>     * <li>Timothee Groleau : <a href="http://timotheegroleau.com/Flash/articles/cubic_bezier/bezier_lib.as">http://timotheegroleau.com/Flash/articles/cubic_bezier/bezier_lib.as</a></li>     * </ul>     * </p>     */    public class Beziers     {        /**         * Calculates an array representation of Point elements to create a quadratic Bezier curve looped or not in n-points.         * @return an array representation of Point elements to create a quadratic Bezier curve looped or not in n-points.         */        public static function create( points:Array , step:Number = 0.1 , precision:Number = 0, loop:Boolean=true ):Array         {            precision = isNaN(precision) ? 0 : precision ;                        var result:Array = [];            var len:int      = points.length ;                        var i:int ;                        var current:Vector2 ;            var last:Vector2    ;                        var _p0:* ;            var _p1:* ;            var _p2:* ;                        var t:Number ;                        var c1:Number ;            var c2:Number ;            var c3:Number ;            var u1:Number ;                        var p0:Vector2 = new Vector2() ;            var p1:Vector2 = new Vector2() ;            var p2:Vector2 = new Vector2() ;                        while ( i < len )            {                t = 0 ;                _p0 = points[i] ;                _p1 = loop ? points[(i+1)%len] : (points[(i+1)]) ? points[(i+1)] : _p0 ;                _p2 = loop ? points[(i+2)%len] : (points[(i+2)]) ? points[(i+2)] : _p1 ;                while (t<=1)                {                    p0.x = (_p0.x + _p1.x)/2 ;                    p0.y = (_p0.y + _p1.y)/2 ;                                        p1.x = _p1.x ;                    p1.y = _p1.y ;                                        p2.x = ( _p2.x + _p1.x ) / 2 ;                    p2.y = ( _p2.y + _p1.y ) / 2 ;                                        u1 = 1 - t ;                    c1 = u1 * u1 ;                    c2 = 2 * t * u1 ;                    c3 = t * t ;                                        current = new Vector2                    (                        c1 * p0.x + c2 * p1.x + c3 * p2.x ,                         c1 * p0.y + c2 * p1.y + c3 * p2.y                    );                                        if ( last != null )                     {                        if ( Vector2.distance( last , current ) > precision )                        {                            last = current ;                            result.push( current );                        }                    }                     else                     {                        last = current ;                        result.push( current ) ;                    }                    t += step ;                }                i++ ;            }            return result ;        }                /**         * Returns the baryCenter of a collection of points.         * @return the baryCenter of a collection of points.         */        public static function getBaryCenter( points:Array ):Vector2         {            var x:Number = 0;            var y:Number = 0;            var l:int   = points.length ;            var len:int = l ;            while (--l > -1 )            {                x += points[l].x ;                y += points[l].y ;            }            return new Vector2( x/len , y/len ) ;        }                /**         * Split 4 Vector2 reference and return an Object.         */        public static function split( p0:Vector2 , p1:Vector2 , p2:Vector2 , p3:Vector2 ):Object        {            var p0_1:Vector2 = p0.middle( p1 ) ;            var p1_2:Vector2 = p1.middle( p2 ) ;            var p2_3:Vector2 = p2.middle( p3 ) ;            var p0_2:Vector2 = p0_1.middle( p1_2 ) ;            var p1_3:Vector2 = p1_2.middle( p2_3 ) ;            var p0_3:Vector2 = p0_2.middle( p1_3 ) ;            var o:Object =             {                b0 : { a:p0  , b:p0_1 , c:p0_2 , d:p0_3 } ,                b1 : { a:p0_3 , b:p1_3 , c:p2_3 , d:p3 }              } ;            return o ;         }                /**         * Returns the cubic tangente object of the specified vectors.         * @return the cubic tangente object of the specified vectors.         */        public static function getCubicTangente( p0:Vector2 , p1:Vector2 , p2:Vector2 , p3:Vector2 , t:Number ):Object         {            var p:Vector2 = new Vector2() ;            p.x = _getCubicPoint(p0.x, p1.x, p2.x, p3.x, t);            p.y = _getCubicPoint(p0.y, p1.y, p2.y, p3.y, t);            var v:Vector2 = new Vector2() ;            v.x = _getCubicDerivative(p0.x, p1.x, p2.x, p3.x, t);            v.y = _getCubicDerivative(p0.y, p1.y, p2.y, p3.y, t);            var l:Line = Lines.getVectorLine(p, v);            return { p : p , l : l } ;        }                /**         * @private         */        private static function _getCubicDerivative(c0:Number, c1:Number, c2:Number, c3:Number, t:Number):Number         {            var g:Number = 3 * (c1 - c0) ;            var b:Number = (3 * (c2 - c1)) - g ;            var a:Number = c3 - c0 - b - g ;            return ( 3*a*t*t + 2*b*t + g ) ;        }                /**         * @private         */        private static function _getCubicPoint(c0:Number, c1:Number, c2:Number, c3:Number, t:Number):Number         {            var ts:Number = t * t ;            var g:Number  = 3 * (c1 - c0);            var b:Number  = (3 * (c2 - c1)) - g;            var a:Number  = c3 - c0 - b - g;            return ( a*ts*t + b*ts + g*t + c0 ) ;        }    }}