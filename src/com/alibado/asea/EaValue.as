package com.alibado.asea
{
    public class EaValue
    {
        
        private var _value:*;
        
        private var _type:String;
        
        public function EaValue(v:*, t:String)
        {
            _value = v;
            _type = t;
        }
        
        public function get value():*
        {
            return _value;
        }
        
        public function get type():String
        {
            return _type;
        }
        
        public function toString():String
        {
            return _type + ":" + _value;
        }
    }
}