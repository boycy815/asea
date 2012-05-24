package com.alibado.util
{
    public interface IMultipleKeyMap
    {
        function getValue(key:Array):*;
        
        function getKey(value:*):Array;
        
        function put(key:Array):Boolean;
        
        function has(key:Array):Boolean;
        
        function remove(Key:Array):Boolean;
        
        function size():uint;
    }
}