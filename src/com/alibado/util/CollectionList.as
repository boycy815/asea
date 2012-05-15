package com.alibado.util
{
    
    import flash.events.EventDispatcher;
    
    
    /**
     * 一个ICollectionList的基于事件机制实现，通过事件通知元素的变化
     */
    public class CollectionList extends EventDispatcher implements ICollectionList
    {
        
        protected var _data:Array = [];
        
        public function CollectionList()
        {
            //
        }
        
        public function get length():uint
        {
            return _data.length;
        }
        
        public function clear():Boolean
        {
            if (_data.length == 0) return false;
            var dc:Array = _data.slice();
            _data.length = 0;
            for (var i:int = dc.length - 1; i >= 0; i--)
            {
                dispatchEvent(new CollectionListEvent(CollectionListEvent.ITEM_REMOVED, dc[i], i));
            }
            return true;
        }
        
        public function toArray():Array
        {
            return _data.slice();
        }
        
        public function removeAt(i:uint):*
        {
            if (i >= _data.length) return null;
            
            var item:Object = _data[i];
            
            _data.splice(i, 1);
            
            dispatchEvent(new CollectionListEvent(CollectionListEvent.ITEM_REMOVED, item, i));
            
            return item;
        }
        
        public function removeAll(items:ICollectionList):uint
        {
            var l:int = _data.length;
            var count:int = 0;
            if (l == 0) return 0;
            if (items.length == 0) return 0;
            for (var i:int = l - 1; i >= 0; i--)
            {
                var item:Object = _data[i];
                if (items.contains(item))
                {
                    _data.splice(i, 1);
                    count++;
                    dispatchEvent(new CollectionListEvent(CollectionListEvent.ITEM_REMOVED, item, i));
                }
            }
            return count;
        }
        
        public function remove(item:*):Boolean
        {
            var i:int = _data.indexOf(item);
            
            if (i == -1) return false;
            
            _data.splice(i, 1);
            
            dispatchEvent(new CollectionListEvent(CollectionListEvent.ITEM_REMOVED, item, i));
            
            return true;
        }
        
        public function setAt(i:uint, item:*):*
        {
            if (i > _data.length) return null;
            var old:Object = null;
            if (i == _data.length)
            {
                add(item);
            }
            else
            {
                old = _data[i];
                _data[i] = item;
                dispatchEvent(new CollectionListEvent(CollectionListEvent.ITEM_REPLACED, old, i));
            }
            return old;
        }
        
        public function getAt(i:uint):*
        {
            return _data[i];
        }
        
        public function equals(other:ICollectionList):Boolean
        {
            if (other.length != _data.length) return false;
            var l:int = _data.length;
            for (var i:int = 0; i < l; i++)
            {
                if (_data[i] !== other.getAt(i)) return false;
            }
            return true;
        }
        
        public function retainAll(items:ICollectionList):uint
        {
            if (_data.length == 0) return 0;
            var l:int = _data.length;
            if (items.length == 0)
            {
                clear();
                return l;
            }
            var c:int = 0;
            for (var i:int = l - 1; i >= 0; i--)
            {
                var item:Object = _data[i];
                if (!items.contains(item))
                {
                    _data.splice(i, 1);
                    c++;
                    dispatchEvent(new CollectionListEvent(CollectionListEvent.ITEM_REMOVED, item, i));
                }
            }
            return c;
        }
        
        public function contains(item:*):Boolean
        {
            if (_data.indexOf(item) == -1) return false;
            else return true;
        }
        
        public function containsAll(items:ICollectionList, and:Boolean):Boolean
        {
            var i:int = 0;
            var l:int = items.length;
            if (l == 0) return false;
            if (_data.length == 0) return false;
            if (and)
            {
                for (; i < l; i++)
                {
                    if (!contains(items.getAt(i))) return false;
                }
                return true;
            }
            else
            {
                for (; i < l; i++)
                {
                    if (contains(items.getAt(i))) return true;
                }
                return false;
            }
        }
        
        public function addAll(items:ICollectionList):Boolean
        {
            if (items.length == 0) return false;
            var l:int = items.length;
            for (var i:int = 0; i < l; i++)
            {
                add(items.getAt(i));
            }
            return true;
        }
        
        public function addAllAt(items:ICollectionList, i:uint):Boolean
        {
            if (items.length == 0 || i > _data.length) return false;
            var l:int = items.length;
            for (var j:int = 0; j < l; j++)
            {
                addAt(items.getAt(j), i + j);
            }
            return true;
        }
        
        public function addAt(item:*, i:uint):Boolean
        {
            if (i > _data.length) return false;
            
            _data.splice(i, 0, item);
            
            dispatchEvent(new CollectionListEvent(CollectionListEvent.ITEM_ADDED, item, i));
            
            return true;
        }
        
        public function add(item:*):int
        {
            var i:int = _data.length;
            _data[i] = item;
            dispatchEvent(new CollectionListEvent(CollectionListEvent.ITEM_ADDED, item, i));
            return i;
        }
        
        public function addArray(items:Array):Boolean
        {
            if (items.length == 0) return false;
            var l:int = items.length;
            for (var i:int = 0; i < l; i++)
            {
                add(items[i]);
            }
            return true;
        }
        
        public function addArrayAt(items:Array, i:uint):Boolean
        {
            if (items.length == 0 || i > _data.length) return false;
            var l:int = items.length;
            for (var j:int = 0; j < l; j++)
            {
                addAt(items[j], i + j);
            }
            return true;
        }
        
        public function containsArray(items:Array, and:Boolean):Boolean
        {
            var i:int = 0;
            var l:int = items.length;
            if (l == 0) return false;
            if (_data.length == 0) return false;
            if (and)
            {
                for (; i < l; i++)
                {
                    if (!contains(items[i])) return false;
                }
                return true;
            }
            else
            {
                for (; i < l; i++)
                {
                    if (contains(items[i])) return true;
                }
                return false;
            }
        }
        
        public function retainArray(items:Array):uint
        {
            if (_data.length == 0) return 0;
            var l:int = _data.length;
            if (items.length == 0)
            {
                clear();
                return l;
            }
            var c:int = 0;
            for (var i:int = l - 1; i >= 0; i--)
            {
                var item:Object = _data[i];
                if (items.indexOf(item) == -1)
                {
                    _data.splice(i, 1);
                    c++;
                    dispatchEvent(new CollectionListEvent(CollectionListEvent.ITEM_REMOVED, item, i));
                }
            }
            return c;
        }
        
        public function removeArray(items:Array):uint
        {
            var l:int = _data.length;
            var count:int = 0;
            if (l == 0) return 0;
            if (items.length == 0) return 0;
            for (var i:int = l - 1; i >= 0; i--)
            {
                var item:Object = _data[i];
                if (items.indexOf(item) != -1)
                {
                    _data.splice(i, 1);
                    count++;
                    dispatchEvent(new CollectionListEvent(CollectionListEvent.ITEM_REMOVED, item, i));
                }
            }
            return count;
        }
    }
}