package com.alibado.util
{
    public class MultipleKeyMap implements IMultipleKeyMap
    {
        public function MultipleKeyMap()
        {
        }
        
        public function getValue(key:Array):*
        {
            
            
        }
        
        public function getKey(value:*):Array
        {
            return null;
        }
        
        public function put(key:Array):Boolean
        {
            return false
        }
        
        public function has(key:Array):Boolean
        {
            return false;
        }
        
        public function remove(Key:Array):Boolean
        {
            return false;
        }
        
        public function size():uint
        {
            return 0;
        }
    }
}