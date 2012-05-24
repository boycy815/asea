package com.alibado.falls
{
    public class OEaFallAction
    {
        private var _fall:OIEaFallAble;
        
        private var _args:Array;
        
        public function OEaFallAction(f:OIEaFallAble, a:Array = null)
        {
            _fall = f;
            _args = a || [];
        }
        
        internal function get fall():OIEaFallAble
        {
            return _fall;
        }
        
        internal function get args():Array
        {
            return _args;
        }
    }
}