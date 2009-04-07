﻿/*  Version: MPL 1.1/GPL 2.0/LGPL 2.1   The contents of this file are subject to the Mozilla Public License Version  1.1 (the "License"); you may not use this file except in compliance with  the License. You may obtain a copy of the License at  http://www.mozilla.org/MPL/    Software distributed under the License is distributed on an "AS IS" basis,  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License  for the specific language governing rights and limitations under the  License.    The Original Code is [maashaack framework].    The Initial Developers of the Original Code are  Zwetan Kjukov <zwetan@gmail.com> and Marc Alcaraz <ekameleon@gmail.com>.  Portions created by the Initial Developers are Copyright (C) 2006-2009  the Initial Developers. All Rights Reserved.    Contributor(s):    Alternatively, the contents of this file may be used under the terms of  either the GNU General Public License Version 2 or later (the "GPL"), or  the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),  in which case the provisions of the GPL or the LGPL are applicable instead  of those above. If you wish to allow use of your version of this file only  under the terms of either the GPL or the LGPL, and not to allow others to  use your version of this file under the terms of the MPL, indicate your  decision by deleting the provisions above and replace them with the notice  and other provisions required by the LGPL or the GPL. If you do not delete  the provisions above, a recipient may use your version of this file under  the terms of any one of the MPL, the GPL or the LGPL.*/package system {    import buRRRn.ASTUce.framework.ArrayAssert;    import buRRRn.ASTUce.framework.TestCase;        import system.samples.NoRegisterClass;    import system.samples.RegisterClass;        public class ObjectsTest extends TestCase     {        public function ObjectsTest(name:String = "")        {            super(name);        }                public function testCopyPrimitiveBasic():void        {            var n:Number  =  1.5 ;            var i:int     = -1   ;            var u:uint    =  2   ;            var s:String  = "hello world" ;            var b:Boolean = true ;                        var copy:* ;                        copy = Objects.copyPrimitive( n ) ;            assertEquals( n , copy , "01 - The numbers must be copied with the Objects.copyPrimitive method." ) ;            copy = Objects.copyPrimitive( i ) ;            assertEquals( i , copy , "02 - The ints must be copied with the Objects.copyPrimitive method." ) ;            copy = Objects.copyPrimitive( u ) ;            assertEquals( u , copy , "03 - The uints must be copied with the Objects.copyPrimitive method." ) ;                        copy = Objects.copyPrimitive( s ) ;            assertEquals( s , copy , "04 - The String must be copied with the Objects.copyPrimitive method." ) ;                        copy = Objects.copyPrimitive( b ) ;            assertEquals( b , copy , "05 - The Boolean must be copied with the Objects.copyPrimitive method." ) ;        }        public function testCopyPrimitiveObject():void        {            var o:Object = { prop1:"value1" , prop2:"value2" , prop3:999 , prop4:true } ;                        var copy:* = Objects.copyPrimitive( o ) ;                        assertFalse( o == copy , "01 - The generic object must be copied with the Objects.copyPrimitive method." ) ;            assertEquals( o.prop1 , copy.prop1 , "02 - The generic object must be copied with the Objects.copyPrimitive method." ) ;            assertEquals( o.prop2 , copy.prop2 , "03 - The generic object must be copied with the Objects.copyPrimitive method." ) ;            assertEquals( o.prop3 , copy.prop3 , "04 - The generic object must be copied with the Objects.copyPrimitive method." ) ;            assertEquals( o.prop4 , copy.prop4 , "05 - The generic object must be copied with the Objects.copyPrimitive method." ) ;        }        public function testCopyPrimitiveArray():void        {                        var a:Array = [ "value1" , "value2" , 999 , true ] ;                        var copy:* = Objects.copyPrimitive( a ) ;                        assertFalse( a == copy , "01 - The Arrays must be copied with the Objects.copyPrimitive method." ) ;            ArrayAssert.assertEquals( a , copy as Array , "02 - The Arrays object must be copied with the Objects.copyPrimitive method." ) ;        }                public function testCopyPrimitiveWidthDepth():void        {            var o:Object =             {                prop1 : "hello" ,                prop2 : { prop3 : "world" } ,                ar : [ "value1" , "value2" , 999 , true ]             };                        var copy:* = Objects.copyPrimitive( o ) ;                        assertFalse( o == copy , "01 - The Object and this memebers must be copied with the Objects.copyPrimitive method." ) ;            assertEquals( o.prop2.prop3 , copy.prop2.prop3 , "02 - The Object and this members must be copied with the Objects.copyPrimitive method."  ) ;            ArrayAssert.assertEquals( o.ar , copy.ar , "03 - The Arrays object in a generic Object must be copied with the Objects.copyPrimitive method." ) ;        }                public function testCopyPrimitiveWidthNoRegisterObject():void        {            var o:NoRegisterClass = new NoRegisterClass("system") ;            var copy:*            = Objects.copyPrimitive( o ) ;                        assertFalse( o == copy , "01 - The NoRegisterClass must be copied with the Objects.copyPrimitive method." ) ;            assertTrue( o is NoRegisterClass , "02 - The NoRegisterClass must be copied with the Objects.copyPrimitive method, but the copy type is not NoRegisterClass." ) ;            assertTrue( o is Object , "03 - The NoRegisterClass must be copied with the Objects.copyPrimitive method, the copy type is Object." ) ;            assertEquals( o.name , copy.name , "04 - The NoRegisterClass 'name' property is copied."  ) ;         }                public function testCopyPrimitiveWidthRegisterObject():void        {            var o:RegisterClass = new RegisterClass("system") ;            var copy:*          = Objects.copyPrimitive( o ) ;            assertFalse( o == copy , "01 - The RegisterClass must be copied with the Objects.copyPrimitive method." ) ;            assertTrue( o is RegisterClass , "02 - The RegisterClass must be copied with the Objects.copyPrimitive method, but the copy type is not NoRegisterClass." ) ;            assertEquals( o.name , copy.name , "03 - The RegisterClass 'name' property is copied."  ) ;        }                 public function testCopyPrimitiveWidthNoRegisterObjectInArray():void        {            var o:Array = [ new NoRegisterClass("system") ] ;            var copy:*          = Objects.copyPrimitive( o ) ;            assertFalse( o[0] == copy[0] , "01 - The NoRegisterClass in the Array must be copied with the Objects.copyPrimitive method." ) ;            assertTrue( o[0] is NoRegisterClass , "02 - The NoRegisterClass in the Array must be copied with the Objects.copyPrimitive method, but the copy type is not NoRegisterClass." ) ;            assertEquals( o[0].name , copy[0].name , "03 - The NoRegisterClass 'name' property in the Array is copied."  ) ;        }                public function testCopyPrimitiveWidthRegisterObjectInArray():void        {            var o:Array = [ new RegisterClass("system") ] ;            var copy:*          = Objects.copyPrimitive( o ) ;            assertFalse( o[0] == copy[0] , "01 - The RegisterClass in the Array must be copied with the Objects.copyPrimitive method." ) ;            assertTrue( o[0] is RegisterClass , "02 - The RegisterClass in the Array must be copied with the Objects.copyPrimitive method, but the copy type is not NoRegisterClass." ) ;            assertEquals( o[0].name , copy[0].name , "03 - The RegisterClass 'name' property in the Array is copied."  ) ;         }    }}