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
  Portions created by the Initial Developers are Copyright (C) 2006-2008
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

package system.data.lists 
{
    import system.Equatable;
    import system.Reflection;
    import system.data.Collection;
    import system.data.Iterator;
    import system.data.List;
    import system.data.ListIterator;
    import system.data.Queue;
    import system.data.collections.formatter;
    import system.data.errors.NoSuchElementError;
    import system.data.iterators.LinkedListIterator;
    import system.serializers.eden.BuiltinSerializer;    

    /**
     *  Linked list implementation of the List and Queue interface. 
     * <p>Implements all optional list operations, and permits all elements (including null).</p>
     * <p>In addition to implementing the List interface, the <code class="prettyprint">LinkedList</code> class provides uniformly named methods to get, remove and insert an element at the beginning and end of the list.</p>
     * <p>These operations allow linked lists to be used as a stack, queue, etc.</p>
     */
    public class LinkedList implements Equatable, List , Queue
    {
        
        /**
         * Creates a new LinkedList instance.
         * <p><b>Usage :</b></p>
         * <pre class="prettyprint">
         * var list:LinkedList = new LinkedList() ;
         * </pre>
         * @param c The optional Collection used to fill and initialize this LinkedList instance.
         */
        public function LinkedList( c:Collection = null )
        {
           _header      = new LinkedListEntry( null, null, null ) ;
           _header.next = _header.previous = _header ;
           if ( c != null && c.size() > 0 )
           {
                addAll( c ) ;
           }
        }
        
        /**
         * This property is a protector used in the ListIterator object of this List.
         */
        public function get modCount():int 
        {
            return _modCount ;
        }
        
        /**
         * @private
         */
        public function set modCount( i:int ):void
        {
            _modCount = i ;
        }        

        /**
         * Appends the specified element to the end of this list.
         * @param o element to be appended to this list.
         * @return <code class="prettyprint">true</code> (as per the general contract of <code class="prettyprint">Collection.add</code>).
         */
        public function add(o:*):Boolean
        {
            addBefore( o, _header ) ;
            return true ;
        }
        
        /**
         * Appends all of the elements in the specified collection to the end of this list, in the order that they are returned by the specified collection's iterator.
         * The behavior of this operation is undefined if the specified collection is modified while the operation is in progress.  
         * (This implies that the behavior of this call is undefined if the specified Collection is this list, and this list is nonempty.)
         * @param c the elements to be inserted into this list.
         * @return <code class="prettyprint">true</code> if this list changed as a result of the call.
         * @throws NullPointerException if the specified collection is null.
         */        
        public function addAll(c:Collection):Boolean
        {
            return addAllAt( _size , c ) ;    
        }
        
        /**
         * Inserts the specified element at the specified position in this list (optional operation).
         * @param id index at which the specified element is to be inserted.
         * @param o element to be inserted.
         */        
        public function addAt(index:uint, o:*):void
        {
            var i:ListIterator = listIterator( index ) ;
            i.add(o);
        }
        
        /**
         * Inserts all of the elements in the specified collection into this list at the specified position (optional operation).
         * @param index the index to insert the new elements from the specified Collection.
         * @param c the collection of elements to insert in the List.
         */
        public function addAllAt( index:uint , c:Collection ):Boolean
        {
            if ( index > _size)
            {
                throw new RangeError("LinkedList insertAllAt method failed, index:"+index+ ", size: " + _size + "." ) ;
            }
            
            if ( c == null )
            {
                return false ;
            }
            
            var a:Array = c.toArray() ;
            
            if ( a == null )
            {
                return false ;
            }
            
            var l:Number = a.length ;
            
            if (l == 0)
            {
                return false;
            }
                    
            _modCount ++ ;
            
            var successor:LinkedListEntry = (index == _size) ? _header : _entry(index) ;
            var predecessor:LinkedListEntry = successor.previous ;
            
            var e:LinkedListEntry ;
            
            for ( var i:Number = 0 ; i < l ; i++) 
            {
                e = new LinkedListEntry( a[i] , successor, predecessor ) ;
                predecessor.next = e ;
                predecessor = e ;
            }
            
            successor.previous = predecessor ;
            
            _size += l ;
            
            return true;
        }        
        
        /**
         * Inserts the given element in the list before the given entry.
         * This method is "protected" only the LinkedList and the LinkedListIterator must use this method.
         * @param o the element to be inserted at the beginning of this list.
         * @param e the entry instance to defined where inserted the element.
         * @private
         */
        public function addBefore( o:* , e:LinkedListEntry ):LinkedListEntry
        {
            var newEntry:LinkedListEntry = new LinkedListEntry( o, e, e.previous ) ;
            newEntry.previous.next = newEntry ;
            newEntry.next.previous = newEntry ;
            _size ++ ;
            _modCount ++ ;
            return newEntry ;
        }        
        
        /**
         * Inserts the given element at the beginning of this list.
         * @param o the element to be inserted at the beginning of this list.
         */
        public function addFirst( o:* ):void
        {
            addBefore( o, _header.next ) ;    
        }

        /**
         * Appends the given element to the end of this list.  
         * @param o the element to be inserted at the end of this list.
         */
        public function addLast( o:* ):void
        {
            addBefore(o , _header) ;    
        }        
        
        /**
         * Removes all of the elements from this queue (optional operation).
         */        
        public function clear():void
        {
            var e:LinkedListEntry = _header.next;
            var next:LinkedListEntry ;
            while (e != _header) 
            {
                next = e.next ;
                e.next = e.previous = null ;
                e.element = null ;
                e = next ;
            }
            _header.next = _header.previous = _header ;
            _size = 0 ;
            _modCount++ ;
        }
        
        /**
         * Returns the shallow copy of this LinkedList.
         * @return the shallow copy of this LinkedList.
         */
        public function clone():*
        {
            var list:LinkedList = new LinkedList() ;
            for ( var e:LinkedListEntry = _header.next ; e != _header ; e = e.next )
            {
                list.add( e.element ) ;
            }
            return list ;    
        }     
        
        /**
         * Returns <code class="prettyprint">true</code> if this list contains the specified element.
         * <p><b>Example :</b></p>
         * <pre class="prettyprint">
         * import system.data.lists.LinkedList ;
         * 
         * var list:LinkedList = new LinkedList() ;
         * list.add("item1") ;
         * trace(list.contains( "item1" ) ; // output : true
         * </pre>
         * @param o element whose presence in this list is to be tested.
         * @return <code class="prettyprint">true</code> if this list contains the specified element.
         */
        public function contains( o:* ):Boolean
        {
            return indexOf(o) != -1 ;
        }
        
        /**
         * Returns <code class="prettyprint">true</code> if this collection contains the specified element.
         * @return <code class="prettyprint">true</code> if this collection contains the specified element.
         */
        public function containsAll(c : Collection):Boolean 
        {
            var it:Iterator = c.iterator() ;
            while(it.hasNext())
            {
                if ( ! contains( it.next() ) )
                {
                    return false ;    
                }     
            }
            return true ;
        }
        
        /**
         * Retrieves and removes the head of this queue.
         * @return <code class="prettyprint">true</code> if the head of the queue is remove.
         */
        public function dequeue():Boolean 
        {
            if ( _size == 0 )
            {
                return false ;
            }
            return removeFirst() != null ;
        }
        
        /**
         * Retrieves, but does not remove, the head (first element) of this list.
         * @return the head of this queue.
         * @throws NoSuchElementException if this queue is empty.
         */
        public function element():* 
        {
            return getFirst();
        }
        
        /**
         * Indicates whether some other object is "equal to" this one.
         */
        public function equals( o:* ):Boolean 
        {
            
            if (o == null)
            {
                return false ;
            }
            if ( ! o is LinkedList )
            {
                return false ;
            }
            else
            {
            	var l:LinkedList = o as LinkedList ;
                if ( l.size() != size())
                {
                    return false ;    
                } 
                var i1:Iterator = iterator() ;
                var i2:Iterator = l.iterator() ;
                while( i1.hasNext() )
                {
                    if (i1.next() != i2.next()) 
                    {
                        return false ;
                    }    
                }
                return true ;
            }
        }        
        
        /**
         * Adds the specified element as the tail (last element) of this list.
         * @param o the element to add.
         * @return <code class="prettyprint">true</code> if the element in inserted in the list.
         */
        public function enqueue(o:*):Boolean 
        {
            return add(o);
        }
        
        /**
         * Returns the element at the specified position in this list.
         * @param index index of element to return.
         * @return the element at the specified position in this list.  
         * @throws IndexOutOfBoundsException if the specified index is out of range.
         */
        public function get( key :* ) :*
        {
            var i:ListIterator = listIterator( key ) ;
            try 
            {
                return( i.next() ) ;
            } 
            catch( e:NoSuchElementError ) 
            {
                throw new NoSuchElementError("LinkedList.get() method failed, index:" + key ) ;
            }
        }
        
        /**
         * Returns the first element in this list.
         * @return the first element in this list.
         * @throws NoSuchElementException if this list is empty.
         */
        public function getFirst():*
        {
            if (_size == 0)
            {
                throw new NoSuchElementError("LinkedList.getFirstList() method failed, the list is empty.") ;    
            }
            return _header.next.element ;
        }
        
        /**
         * Returns the last element in the list.
         * @return the last element in the list.
         * @throws NoSuchElementException if this list is empty.
         */
        public function getLast():*
        {
            if (_size == 0)
            {
                throw new NoSuchElementError("LinkedList.getLast() method failed, the list is empty.") ;        
            }
            return _header.previous.element ;
        }        
        
        /**
         * Returns the header entry of this list.
         * @return the header entry of this list.
         */
        public function getHeader():LinkedListEntry
        {
            return _header ;    
        }        
        
        /**
         * Returns the position of the passed object in the collection.
         * @param o the object to search in the collection.
         * @param fromIndex the index to begin the search in the collection.
         * @return the index of the object or -1 if the object isn't find in the collection.
         */
        public function indexOf(o:*, fromIndex:uint=0):int
        {
            var index:int = 0 ;
            var e:LinkedListEntry ;
            if ( o == null ) 
            {
                for ( e = _header.next ; e != _header ; e = e.next) 
                {
                    if ( e.element == null )
                    {
                        return index ;
                    }
                    index++ ;
                }
            } 
            else 
            {
                for ( e = _header.next ; e != _header ; e = e.next ) 
                {
                    if (o is Equatable)
                    {
                        if ( ( o as Equatable).equals(e.element) )
                        {
                            return index ;
                        }
                    }
                    else
                    {
                        if (o == e.element)
                        {
                            return index ;    
                        }
                    }    
                    index++ ;
                }
            }
            return -1 ;
        }
        
        /**
         * Returns <code class="prettyprint">true</code> if this queue contains no elements.
         * @return <code class="prettyprint">true</code> if this queue is empty else <code class="prettyprint">false</code>.
         */
        public function isEmpty():Boolean 
        {
            return _size == 0 ;    
        }
        
       /**
        * Returns the iterator of this object.
        * @return the iterator of this object.
        */
        public function iterator():Iterator 
        {
            return listIterator(0) ;
        }    
        
        /**
         * Returns the index in this list of the last occurrence of the specified element, or -1 if the list does not contain this element.
         * @param o element to search for.
         * @return the index in this list of the last occurrence of the specified element, or -1 if the list does not contain this element.
         */
        public function lastIndexOf( o:*  , fromIndex:int = 0x7FFFFFFF ):int 
        {
        	// TODO implement the fromIndex argument !!!
            var index:int = _size ;
            var e:LinkedListEntry ;
            if ( o == null ) 
            {
                for ( e = _header.previous ; e != _header ; e = e.previous) 
                {
                    index--;
                    if ( e.element == null )
                    {
                        return index ;
                    }
                }
            } 
            else 
            {
                for ( e = _header.previous ; e != _header ; e = e.previous ) 
                {
                    index-- ;
                    if (o is Equatable)
                    {
                        if ( (o as Equatable).equals(e.element) )
                        {
                            return index;
                        }
                    }
                    else
                    {
                        if (o == e.element)
                        {
                            return index ;
                        }    
                    }
                }
            }
            return -1 ;
        }
        
        /**
         * Returns a list iterator of the elements in this list (in proper sequence).
         * @return a list iterator of the elements in this list (in proper sequence).
         */
        public function listIterator( position:uint=0 ):ListIterator
        {
            return new LinkedListIterator( this , position ) ;
        }        
        
        /**
         * Retrieves, but does not remove, the head (first element) of this list.
         * @return the head of this queue, or <code class="prettyprint">null</code> if this queue is empty.
         */
        public function peek():* 
        {
            if ( _size == 0 )
            {
                return null;
            }
            return getFirst() ;
        }
        
        /**
         * Retrieves and removes the head (first element) of this list.
         * @return the head of this queue, or <code class="prettyprint">null</code> if this queue is empty.
         */
        public function poll():* 
        {
            if ( _size == 0 )
            {
                return null;
            }
            return removeFirst() ;
        }        
        
        /**
         * Removes the first occurrence of the specified element in this list.  
         * If the list does not contain the element, it is unchanged.
         * @param o element to be removed from this list, if present.
         * @return <tt>true</tt> if the list contained the specified element.
         */
        public function remove(o:*):* 
        {
            var e:LinkedListEntry ;
            if ( o == null ) 
            {
                for ( e = _header.next ; e != _header ; e = e.next ) 
                {
                    if ( e.element == null ) 
                    {
                        removeEntry(e) ;
                        return true;
                    }
                }
            } 
            else 
            {
                for ( e = _header.next ; e != _header ; e = e.next ) 
                {
                    if ( o is Equatable )
                    {
                        if ( (o as Equatable).equals( e.element ) ) 
                        {
                            removeEntry(e);
                            return true;
                        }
                    }
                    else 
                    {     
                        if ( o == e.element ) 
                        {
                            removeEntry(e);
                            return true;
                        }
                    }
                }
            }
            return false;
        }
        
        /**
         * Removes all elements defined in the specified Collection in the list.
         * <p><b>Example :</b></p>
         * <code class="prettyprint">
         * import system.data.collections.ArrayCollection ;
         * import system.data.lists.LinkedList ;
         * 
         * var list:LinkedList = new LinkedList() ;
         * 
         * list.add("item1") ;
         * list.add("item2") ;
         * 
         * trace(list.removeAll(new ArrayCollection(["item1"])) ; // true
         * trace(list) ; // {item2}
         * </code>
         * @return <code class="prettyprint">true</code> if all elements are find and remove in the list.
         */
        public function removeAll( c:Collection ):Boolean 
        {
            if (c.size() > 0)
            {
                var b:Boolean ;
                var result:Boolean = true ;
                var i:Iterator = c.iterator() ;
                while( i.hasNext() )
                {
                    b = remove( i.next()) ;
                    if ( b = false )
                    {
                        result = false ;
                    }
                }
                return result ;
            }
            else
            {
                return false ;    
            }
        }
        
        /**
         * Removes an element at the specified position in this list. 
         * This implementation first gets a list iterator pointing to the indexed element (with <code class="prettyprint">listIterator(index)</code>). 
         * Then, it removes the element with <b>ListIterator</b> remove method.
         * <p><b>Example :</b></p>
         * <pre class="prettyprint">
         * import system.data.lists.LinkedList ;
         * 
         * var list:LinkedList = new LinkedList() ;
         * 
         * list.add("item1") ;
         * list.add("item2") ;
         * 
         * trace(list.removeAt(1)) ; // item2
         * trace(list) ; // {item1}
         * </pre>
         * @param id index of the element to be removed from the List.
         * @return the Array representation of all removed elements in the list.
         */
        public function removeAt( index:uint , len:int=1):* 
        {
        	len = len > 1 ? len : 1 ;
        	if ( len == 1 )
        	{
                return [ removeEntry( _entry( index ) ) ] ;
        	}
        	else
        	{
        		var ar:Array = [] ;
        		while( len-- > 0 )
        		{
        			removeEntry( _entry( index ) ) ;
        		}
        		return ar ;
        	}
        }        
        
        /**
         * Removes an Entry in the list.
         */
        public function removeEntry( e:LinkedListEntry ):*
        {
            if ( e == _header )
            {
                throw new NoSuchElementError("LinkedList.removeEntry() method failed.");
            }
            var result:* = e.element ;
            e.previous.next = e.next;
            e.next.previous = e.previous;
            e.next = e.previous = null ;
            e.element = null ;
            _size-- ;
            _modCount++ ;
            return result ;
        }        
        
        /**
         * Removes and returns the first element from this list.
         * <p><b>Example :</b></p>
         * <pre class="prettyprint">
         * import system.data.lists.LinkedList ;
         * 
         * var list:LinkedList = new LinkedList() ;
         * 
         * list.add("item1") ;
         * list.add("item2") ;
         * list.add("item3") ;
         * list.add("item4") ;
         * 
         * var result = list.removeFirst() ;
         * trace(result + " : " + list) ; // item1 : {item2,item3,item4}
         * </pre>
         * @return the first element from this list.
         * @throws NoSuchElementException if this list is empty.
         */
        public function removeFirst():*
        {
            return removeEntry( _header.next );
        }        
        
        /**
         * Removes and returns the last element from this list.
         * <p><b>Example :</b></p>
         * <pre class="prettyprint">
         * import systel.data.lists.LinkedList ;
         * var list:LinkedList = new LinkedList() ;
         * 
         * list.add("item1") ;
         * list.add("item2") ;
         * list.add("item3") ;
         * list.add("item4") ;
         * 
         * var result = list.removeLast() ;
         * 
         * trace(result + " : " + list) ; // item4 : {item1,item2,item3}
         * </pre>
         * @return the last element from this list.
         * @throws NoSuchElementException if this list is empty.
         */
        public function removeLast():*
        {
            return removeEntry( _header.previous );
        }        
        
        /**
         * Removes from this list all the elements that are contained between the specific <code class="prettyprint">from</code> and the specific <code class="prettyprint">to</code> position in this list (optional operation).
         * <p><b>Example :</b></p>
         * <pre class="prettyprint">
         * import system.data.lists.LinkedList ;
         * 
         * var list:LinkedList = new LinkedList() ;
         * 
         * list.add("item1") ;
         * list.add("item2") ;
         * list.add("item3") ;
         * list.add("item4") ;
         * list.add("item5") ;
         * 
         * list.removeRange(2, 4) ;
         * 
         * trace(list) ; // {item1,item2,item5}
         * </pre>
         * @throws ArgumentError if the 'from' or 'to' argument is NaN.
         * @throws RangeError if the 'to' > 'from'
         */
        public function removeRange( fromIndex:uint, toIndex:uint ):*
        {
            if ( fromIndex >= _size )
            {
                throw new RangeError( "LinkedList.removeRange() failed with a fromIndex '" + fromIndex + "' value out of bounds, fromIndex > size().") ;
            }            
            if ( toIndex < fromIndex )
            {
                throw new RangeError( "LinkedList.removeRange() failed if the toIndex > from value : " + toIndex ) ;
            }
            else if ( fromIndex == toIndex )
            {
                return removeAt( fromIndex ) ;
            } 
            else
            {
            	var ar:Array = [] ;
                var it:ListIterator = listIterator( fromIndex ) ;
                var l:int = toIndex - fromIndex ;
                for (var i:int ; i<l ; i++) 
                {
                    ar.push(it.next()) ; 
                    it.remove() ;
                }   
                return ar ; 
            }
        }

        /**
         * Retains only the elements in this list that are contained in the specified collection (optional operation).
         * <p><b>Example :</b></p>
         * <pre class="prettyprint">
         * import system.data.collections.ArrayCollection ;
         * import system.data.lists.LinkedList ;
         * 
         * var list:LinkedList = new LinkedList() ;
         * 
         * list.add("item1") ;
         * list.add("item2") ;
         * list.add("item3") ;
         * list.add("item4") ;
         * list.add("item5") ;
         * 
         * var c:ArrayCollection = new ArrayCollection( ["item2", "item4"] ) ;
         * 
         * var b:Boolean = list.retainAll( c ) ;
         * trace("list : " + list + ", is retain ? : " + b) ;
         * </pre>
         * @return <code class="prettyprint">true</code> if the retainAll operation is success.
         */
        public function retainAll(c : Collection):Boolean 
        {
            var it:Iterator = iterator() ;
            while(it.hasNext())
            {
                var next:* = it.next() ;
                if ( !c.contains( next ) )
                {
                    it.remove() ;
                } 
            }
            return c.size() == size() ;
        }      
        
        /**
         * Replaces the element at the specified position in this list with the specified element.
         * <p><b>Example :</b></p>
         * <pre class="prettyprint">
         * import system.data.lists.LinkedList ;
         * 
         * var list:LinkedList = new LinkedList() ;
         * 
         * list.add("item1") ;
         * list.add("item2") ;
         * 
         * var old:* = list.setAt( 1, "ITEM2" ) ;
         * 
         * trace("list : " + list + ", old : " + old) ; // list : {item1,ITEM2}, old : item2
         * </pre>
         * @param id index of element to replace.
         * @param o element to be stored at the specified position.
         * @return the element previously at the specified position.
         */        
        public function set( index:uint, o:*):*
        {
            var i:ListIterator = listIterator( index ) ;
            try 
            {
                var old:* = i.next() ;
                i.set(o) ;
                return old ;
            }
            catch( e:NoSuchElementError ) 
            {
                throw new RangeError("LinkedList.setAt() method failed, index:" + index ) ;
            }
        }        
        
        /**
         * Returns the number of elements in this list.
         * <p><b>Example :</b></p>
         * <pre class="prettyprint">
         * import system.data.lists.LinkedList ;
         * 
         * var list:LinkedList = new LinkedList() ;
         * 
         * list.add("item1") ;
         * list.add("item2") ;
         * 
         * trace(list.size()) ; // 2
         * </pre>
         * @return the number of elements in this list.
         */
        public function size():uint
        {
            return _size ;    
        }
        
        /**
         * Returns a subList of the LinkedList.
         * <p><b>Example :</b></p>
         * <pre class="prettyprint">
         * import system.data.lists.LinkedList ;
         * 
         * var list:LinkedList = new LinkedList() ;
         * 
         * list.add("item1") ;
         * list.add("item2") ;
         * list.add("item3") ;
         * list.add("item4") ;
         * list.add("item5") ;
         * 
         * trace( list.subList(2, 10) ) ; // {item3,item4,item5}
         * trace( list.subList(2, -1) ) ; // {}
         * trace( list.subList(2, 3) ) ; // {item3}
         * trace( list.subList() ) ; // {item1,item2,item3,item4,item5}
         * </pre>
         * @return a subList of the LinkedList. The subList is an ArrayList instance.
         */        
        public function subList(fromIndex:uint, toIndex:uint):List
        {
            if ( fromIndex == 0 )
            {
                return clone() ;    
            }
            if (toIndex < fromIndex)
            {
                toIndex = fromIndex ;
            }
            else if (toIndex > size())
            {
                toIndex = size() ;    
            }
            var l:List = new LinkedList() ;
            var it:ListIterator = listIterator(fromIndex) ;
            var d:Number = (toIndex - fromIndex) + 1 ; 
            for ( var i:int = fromIndex ; i<= d ; i++ ) 
            {
                l.add( it.next() ) ;
            }
            return l ;
        }        
        
        /**
         * Returns an array containing all of the elements in this list in the correct order.
         * <p><b>Example :</b></p>
         * <pre class="prettyprint">
         * import system.data.lists.LinkedList ;
         * 
         * var list:LinkedList = new LinkedList() ;
         * 
         * list.add("item1") ;
         * list.add("item2") ;
         * list.add("item3") ;
         * list.add("item4") ;
         * trace( list.toArray() ) ; // item1,item2,item3,item4
         * </pre>
         * @return an array containing all of the elements in this list in the correct order.
         */        
        public function toArray():Array
        {
            var ar:Array = new Array( _size ) ;
            var i:int = 0 ;
            var e:LinkedListEntry ;
            for ( e = _header.next ; e != _header ; e = e.next )
            {
                ar[i++] = e.element ;
            }
            return ar ;
        }        
        
        /**
         * Returns the source code string representation of the object.
         * @return the source code string representation of the object.
         */
        public function toSource(indent:int = 0):String
        {
            var source:String = "new " + Reflection.getClassPath(this) + "(" ;
            var ar:Array = toArray() ;
            if ( ar.length > 0 )
            {
                source += BuiltinSerializer.emitArray( ar ) ;
            } 
            source += ")" ;
            return source ;
        }
        
        /**
         * Returns the string representation of this instance.
         * @return the string representation of this instance.
         */
        public function toString():String
        {
            return formatter.format( this ) ;
        }
        
        /**
         * Returns the indexed entry.
         * @return the indexed entry.
         * @private
         */
        private function _entry( index:uint ):LinkedListEntry
        {
            if ( index >= _size)
            {
                throw new RangeError("LinkedList._entry() method failed, index:" + index + ", size:" + _size + "." ) ;
            }
            var e:LinkedListEntry = _header ;
            var i:int ;
            if ( index < (_size >> 1))
            {
                for ( i = 0 ; i<= index ; i++ )
                {
                    e = e.next ;
                }
            }
            else
            {
                for ( i = _size ; i > index ; i-- )
                {
                    e = e.previous ;    
                }
            }
            return e ;
        }        
        
        /**
         * The internal header of this list.
         * @private
         */
        private var _header:LinkedListEntry ;
    
        /**
         * The mod count value used by the LinkedListIterator.
         * @private
         */
        private var _modCount:uint = 0 ;
    
        /**
         * The internal size of the list.
         * @private
         */
        private var _size:uint = 0 ;
        
        
    }
    
}
