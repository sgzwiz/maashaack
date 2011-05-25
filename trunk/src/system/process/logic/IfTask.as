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
  Portions created by the Initial Developers are Copyright (C) 2006-2011
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

package system.process.logic
{
    import system.process.Action;
    import system.process.Task;
    import system.rules.Condition;
    
    /**
     * Perform some tasks based on whether a given condition holds true or not.
     * <p>Usage :</p>
     * <pre>
     * // if( cond ) then{} else{} ...elseif{}
     * var task:IfTask = new IfTask( condition:Condition , thenTask:Action , elseTask:Action , ...elseIfTasks:Array )
     * </pre>
     */
    public class IfTask extends Task
    {
        /**
         * Creates a new IfTask instance.
         * @param condition The condition of the 'if' conditional task.
         * @param thenTask The Action reference to defines the 'then' block in the 'if' conditional task.
         * @param elseTask The Action reference to defines the 'else' block in the 'if' conditional task.
         * @param ...elseIfTasks The Array of ElseIf instance to initialize the 'elseif' blocks in the 'if' conditional task.
         */
        public function IfTask( condition:Condition = null , thenTask:Action = null , elseTask:Action = null , ...elseIfTasks:Array )
        {
            _elseIfTasks = new Vector.<ElseIf>() ;
            _condition   = condition ;
            _thenTask    = thenTask  ;
            if ( elseIfTasks && elseIfTasks.length > 0 )
            {
                addElseIf.apply( this , elseIfTasks ) ;
            }
            _elseTask = elseTask  ;
        }
        
        /**
         * Indicates if the class throws errors or notify a finished event when the task failed.
         */
        public var throwError:Boolean ;
        
        /**
         * Defines the main condition of the task.
         * @param condition The main Condition of the task.
         * @return The current IfTask reference.
         * @throws Error if a 'condition' is already register.
         */
        public function addCondition( condition:Condition ):IfTask
        {
            if ( _condition ) 
            {
                throw new Error( this + " addCondition failed, you must not nest more than one <condition> into <if>");
            }
            else
            {
                _condition = condition ;
            }
            return this ;
        }
        
        /**
         * Defines the action when the condition block use the else condition.
         * @param action The action to defines with the else condition in the IfTask reference.
         * @return The current IfTask reference.
         * @throws Error if an 'else' action is already register.
         */
        public function addElse( action:Action ):IfTask
        {
            if ( _elseTask ) 
            {
                throw new Error( this + " addElse failed, you must not nest more than one <else> into <if>");
            }
            else
            {
                _elseTask = action ;
            }
            return this ;
        }
        
        /**
         * Defines an action when the condition block use the elseif condition.
         * @param condition The condition of the 'elseif' element.
         * @param task The task to invoke if the 'elseif' condition is succeed.
         * @return The current IfTask reference.
         * @throws Error The condition and action reference not must be null.
         */
        public function addElseIf( ...elseIfTask:Array  ):IfTask
        {
            if ( elseIfTask && elseIfTask.length > 0 )
            {
                var ei:ElseIf ;
                var len:int = elseIfTask.length ;
                for( var i:int ; i<len ; i++ )
                {
                    ei = null ;
                    if( elseIfTask[i] is ElseIf )
                    {
                        ei = elseIfTask[i] as ElseIf ;
                    }
                    else if ( elseIfTask[i] is Condition && elseIfTask[i+1] is Task )
                    {
                        ei = new ElseIf( elseIfTask[i] , elseIfTask[i+1] ) ;
                        i++ ;
                    }
                    if ( ei )
                    {
                        _elseIfTasks.push( ei ) ;
                    }
                }
            }
            return this ;
        }
        
        /**
         * Defines the action when the condition block success and must run the 'then' action.
         * @param action Defines the 'then' action in the IfTask reference.
         * @return The current IfTask reference.
         * @throws Error if the 'then' action is already register.
         */
        public function addThen( action:Action ):IfTask
        {
            if ( _thenTask ) 
            {
                throw new Error( this + " addThen failed, you must not nest more than one <then> into <if>");
            }
            else
            {
                _thenTask = action ;
            }
            return this ;
        }
        
        /**
         * Removes the 'condition' of the task.
         * @return The current IfTask reference.
         */
        public function removeCondition():IfTask
        {
            _condition = null ;
            return this ;
        }
        
        /**
         * Removes the 'else' action.
         * @return The current IfTask reference.
         */
        public function removeElse():IfTask
        {
            _elseTask = null ;
            return this ;
        }
        
        /**
         * Removes the 'then' action.
         * @return The current IfTask reference.
         */
        public function removeThen():IfTask
        {
            _thenTask = null ;
            return this ;
        }
        
        /**
         * Removes the 'then' action.
         * @return The current IfTask reference.
         */
        public function removeAllElseIf():IfTask
        {
            _elseIfTasks.length = 0 ;
            return this ;
        }
        
        /**
         * Run the process.
         */
        public override function run( ...arguments:Array ):void 
        {
            _done = false ;
            
            if ( running )
            {
                return ;
            }
            
            notifyStarted() ;
            
            if ( throwError && !_condition )
            {
                throw new Error( this + " run failed, the 'condition' of the task not must be null.") ;
            }
            
            if ( _condition && _condition.eval() )
            {
                if( _thenTask )
                {
                    _execute( _thenTask ) ;
                }
                else if ( throwError )
                {
                    throw new Error( this + " run failed, the 'then' action not must be null.") ;
                }
            }
            else
            {
                if ( _elseIfTasks.length > 0 )
                {
                    var ei:ElseIf ;
                    var len:int = _elseIfTasks.length ;
                    for (var i:int ; (i<len) && !_done ; i++ )
                    {
                        ei = _elseIfTasks[i] as ElseIf ;
                        if ( ei.eval() )
                        {
                            _execute( ei.thenTask ) ;
                        }
                    }
                }
                
                if( !_done && _elseTask )
                {
                    _execute( _elseTask ) ;
                }
            }
            
            if( !_done )
            {
                if ( throwError )
                {
                    throw new Error( this + " run failed, the 'then' action not must be null.") ;
                }
                else
                {
                    notifyFinished() ;
                }
            }
        }
        
        /**
         * @private
         */
        protected var _condition:Condition ;
        
        /**
         * @private
         */
        protected var _done:Boolean ;
        
        /**
         * @private
         */
        protected var _elseIfTasks:Vector.<ElseIf> ;
        
        /**
         * @private
         */
        protected var _elseTask:Action ;
        
        /**
         * @private
         */
        protected var _thenTask:Action ;
        
        /**
         * @private
         */
        protected function _execute( action:Action ):void
        {
            if ( action )
            {
                _done = true ;
                action.finishIt.connect( _finishTask , 1 , true ) ;
                action.run() ;
            }
        }
        
        /**
         * @private
         */
        protected function _finishTask( a:Action ):void
        {
            notifyFinished() ;
        }
    }
}
