﻿/*
  Version: MPL 1.1/GPL 2.0/LGPL 2.1
 
  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at
  http://www.mozilla.org/MPL/
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the
  License.
  
  The Original Code is [maashaack framework].
  
  The Initial Developers of the Original Code are
  Zwetan Kjukov <zwetan@gmail.com> and Marc Alcaraz <ekameleon@gmail.com>.
  Portions created by the Initial Developers are Copyright (C) 2006-2010
  the Initial Developers. All Rights Reserved.
  
  Contributor(s):
  
  Alternatively, the contents of this file may be used under the terms of
  either the GNU General Public License Version 2 or later (the "GPL"), or
  the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
  in which case the provisions of the GPL or the LGPL are applicable instead
  of those above. If you wish to allow use of your version of this file only
  under the terms of either the GPL or the LGPL, and not to allow others to
  use your version of this file under the terms of the MPL, indicate your
  decision by deleting the provisions above and replace them with the notice
  and other provisions required by the LGPL or the GPL. If you do not delete
  the provisions above, a recipient may use your version of this file under
  the terms of any one of the MPL, the GPL or the LGPL.
*/

package graphics.geom 
{
    /**
     * Manipulates and transforms the regular polygons.
     */
    public final class RegularPolygon 
    {
        /**
         * By definition, all sides of a regular polygon are equal in length. 
         * If you know the length of one of the sides, the apothem length is given by the formula: s/(2*tan(PI/n))
         * where 
         * s is the length of any side, 
         * n  is the number of sides, 
         * PI approximately Math.PI, 
         * tan is the tangent function calculated in radians
         * @param side The length of any side.
         * @param sides The number of sides.
         */
        public static function apothemeByRadius( radius:Number , sides:uint ):Number
        {
            if ( radius == 0 || sides == 0 )
            {
                return 0 ;
            }
            return radius * Math.cos( Math.PI / sides ) ;
        }
        
        /**
         * By definition, all sides of a regular polygon are equal in length. 
         * If you know the length of one of the sides, the apothem length is given by the formula: s/(2*tan(PI/n))
         * where 
         * s is the length of any side, 
         * n  is the number of sides, 
         * PI approximately Math.PI, 
         * tan is the tangent function calculated in radians
         * @param side The length of any side.
         * @param sides The number of sides.
         */
        public static function apothemeBySide( side:Number , sides:uint ):Number
        {
            if ( sides == 0 || side == 0 )
            {
                return 0 ;
            }
            return side / ( 2 * Math.tan( Math.PI / sides ) ) ;
        }
        
        /**
         * Calculates the central angle of the specified regular polygon. 
         * The central angle is the angle made at the center of the polygon by any two adjacent vertices of the polygon.
         * @param sides The number of sides
         * @param degrees Indicates if the angle is in degrees or in radians (by default in radians).
         */
        public static function centralAngle( sides:uint , degrees:Boolean = false ):Number
        {
            var angle:Number = 360 / sides ;
            if ( !degrees )
            {
                angle *= Math.PI / 180 ;
            }
            return angle ;
        }
        

    }
}
