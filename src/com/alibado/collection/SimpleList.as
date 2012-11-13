package com.alibado.collection
{
    import com.alibado.consts.EW;

    /**
    * 一个IList的简单实现，通过回调函数通知元素的变化
    */
    
    public class SimpleList implements IList
    {
        
        private var _user:IUseSimpleList;
        private var _data:Array;
        
        /**
        * 构造函数
        * @param u 数据结构数据改变的通知对象
        */
        public function SimpleList(u:IUseSimpleList, data:Array = null)
        {
            _user = u;
            if (data) _data = [];
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
            
            //全部删除后向外分发删除事件
            for (var i:int = dc.length - 1; i >= 0; i--)
            {
                _user.onRemove(dc[i], i);
            }
            return true;
        }
        
        public function toArray():Array
        {
            return _data.slice();
        }
        
        public function removeAt(i:uint):*
        {
            if (i >= _data.length)
            {
                throw new RangeError(EW.m("i", EW.INDEX_OUT_OF_RANGE));
                return null;
            }
            
            var item:Object = _data[i];
            
            _data.splice(i, 1);
            
            _user.onRemove(item, i);
            
            return item;
        }
        
        public function removeAll(items:IList):uint
        {
            var l:int = _data.length;
            var count:int = 0;
            if (l == 0) return 0;
            if (items.length == 0) return 0;
            
            var result:Array = [];
            
            //吧所有在_data中且存在于items中的元素从_data中删除
            for (var i:int = l - 1; i >= 0; i--)
            {
                var item:Object = _data[i];
                if (items.contains(item))
                {
                    _data.splice(i, 1);
                    count++;
                    result.push([item, i]);
                }
            }
            
            //全部删除完毕之后分发事件
            for (i = 0; i < result.length; i++)
            {
                _user.onRemove(result[i][0], result[i][1]);
            }
            return count;
        }
        
        public function remove(item:*):uint
        {
            var i:int = _data.indexOf(item);
            
            if(i >= 0)
            {
                _data.splice(i, 1);
                _user.onRemove(item, i);
            }
            
            return i;
        }
        
        public function setAt(item:*, i:uint):*
        {
            if (i > _data.length)
            {
                throw new RangeError(EW.m("i", EW.INDEX_OUT_OF_RANGE));
                return null;
            }
            var old:Object = null;
            
            //设置最后一个时视为从尾部增加数据
            if (i == _data.length)
            {
                _data[i] = item;
                _user.onAdd(item, i);
            }
            else
            {
                old = _data[i];
                _data[i] = item;
                _user.onReplace(old, i);
            }
            return old;
        }
        
        public function getAt(i:uint):*
        {
            if (i >= _data.length)
            {
                throw new RangeError(EW.m("i", EW.INDEX_OUT_OF_RANGE));
                return null;
            }
            return _data[i];
        }
        
        public function equals(other:IList):Boolean
        {
            if (other.length != _data.length) return false;
            var l:int = _data.length;
            for (var i:int = 0; i < l; i++)
            {
                if (_data[i] !== other.getAt(i)) return false;
            }
            return true;
        }
        
        public function retainAll(items:IList):uint
        {
            if (_data.length == 0) return 0;
            var l:int = _data.length;
            var dc:Array;
            var i:int = 0;
            
            //如果items长度为0则_data全部清空
            if (items.length == 0)
            {
                dc = _data.slice();
                _data.length = 0;
                
                //删除完毕之后发送事件
                for (i = l - 1; i >= 0; i--)
                {
                    _user.onRemove(dc[i], i);
                }
                return l;
            }
            
            
            var c:int = 0;
            var result:Array = [];
            for (i = l - 1; i >= 0; i--)
            {
                var item:Object = _data[i];
                if (!items.contains(item))
                {
                    _data.splice(i, 1);
                    c++;
                    result.push([item, i]);
                }
            }
            
            //删除完毕之后发送事件
            for (i = 0; i < result.length; i++)
            {
                _user.onRemove(result[i][0], result[i][1]);
            }
            return c;
        }
        
        public function contains(item:*):Boolean
        {
            if (_data.indexOf(item) == -1) return false;
            else return true;
        }
        
        public function containsAll(items:IList, and:Boolean):Boolean
        {
            var i:int = 0;
            var l:int = items.length;
            if (l == 0) return false;
            if (_data.length == 0) return false;
            
            //且运算逻辑：只要有一个不存在就是false
            if (and)
            {
                for (; i < l; i++)
                {
                    if (!contains(items.getAt(i))) return false;
                }
                return true;
            }
                //或运算逻辑：只要有一个存在就true
            else
            {
                for (; i < l; i++)
                {
                    if (contains(items.getAt(i))) return true;
                }
                return false;
            }
        }
        
        public function addAll(items:IList):Boolean
        {
            if (items.length == 0) return false;
            var l:int = items.length;
            var ie:int = _data.length;
            _data.push.apply(null, items.toArray());
            
            //全部添加完毕后分发添加事件
            for (var i:int = 0; i < l; i++)
            {
                _user.onAdd(items.getAt(i), ie + i);
            }
            return true;
        }
        
        public function addAllAt(items:IList, i:uint):Boolean
        {
            if (items.length == 0 || i > _data.length)
            {
                throw new RangeError(EW.m("i", EW.INDEX_OUT_OF_RANGE));
                return false;
            }
            var l:int = items.length;
            if (l == 0) return false;
            
            //制造splice的参数，i,0,...items
            var args:Array = items.toArray();
            args.unshift(i, 0);
            _data.splice.apply(null, args);
            
            //全部添加完毕后分发添加事件
            for (var j:int = 0; j < l; j++)
            {
                _user.onAdd(items.getAt(j), j + i);
            }
            return true;
        }
        
        public function addAt(item:*, i:uint):Boolean
        {   
            if (i > _data.length)
            {
                throw new RangeError(EW.m("i", EW.INDEX_OUT_OF_RANGE));
                return false;
            }
            
            _data.splice(i, 0, item);
            
            _user.onAdd(item, i);
            
            return true;
        }
        
        public function add(item:*):int
        {
            var i:int = _data.length;
            _data[i] = item;
            _user.onAdd(item, i);
            return i;
        }
        
        public function addArray(items:Array):Boolean
        {
            if (items.length == 0) return false;
            _data.push.apply(null, items);
            var l:int = items.length;
            var ie:int = _data.length;
            for (var i:int = 0; i < l; i++)
            {
                _user.onAdd(items[i], ie + i);
            }
            return true;
        }
        
        public function addArrayAt(items:Array, i:uint):Boolean
        {
            if (items.length == 0 || i > _data.length)
            {
                throw new RangeError(EW.m("i", EW.INDEX_OUT_OF_RANGE));
                return false;
            }
            var l:int = items.length;
            if (l == 0) return false;
            var args:Array = [];
            args.push(i, 0);
            args.push.apply(null, items);
            _data.splice.apply(null, args);
            for (var j:int = 0; j < l; j++)
            {
                _user.onAdd(items[j], j + i);
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
            var dc:Array;
            var i:int = 0;
            if (items.length == 0)
            {
                dc = _data.slice();
                _data.length = 0;
                
                //删除完毕之后发送事件
                for (i = l - 1; i >= 0; i--)
                {
                    _user.onRemove(dc[i], i);
                }
                return l;
            }
            var c:int = 0;
            var result:Array = [];
            for (i = l - 1; i >= 0; i--)
            {
                var item:Object = _data[i];
                if (items.indexOf(item) == -1)
                {
                    _data.splice(i, 1);
                    c++;
                    result.push([item, i]);
                }
            }
            //删除完毕之后发送事件
            for (i = 0; i < result.length; i++)
            {
                _user.onRemove(result[i][0], result[i][1]);
            }
            return c;
        }
        
        public function removeArray(items:Array):uint
        {
            var l:int = _data.length;
            var count:int = 0;
            if (l == 0) return 0;
            if (items.length == 0) return 0;
            var result:Array = [];
            for (var i:int = l - 1; i >= 0; i--)
            {
                var item:Object = _data[i];
                if (items.indexOf(item) != -1)
                {
                    _data.splice(i, 1);
                    count++;
                    result.push([item, i]);
                }
            }
            //全部删除完毕之后分发事件
            for (i = 0; i < result.length; i++)
            {
                _user.onRemove(result[i][0], result[i][1]);
            }
            return count;
        }
    }
}