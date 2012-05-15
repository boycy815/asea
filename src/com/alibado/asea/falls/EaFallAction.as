package com.alibado.asea.falls
{
    public class EaFallAction
    {
        private var _fall:IEaFallAble;
        
        private var _args:Array;
        
        public function EaFallAction(fall:IEaFallAble, args:Array)
        {
            _fall = fall;
            _args = args;
        }
        
        internal function get fall():IEaFallAble
        {
            return _fall;
        }
        
        internal function get args():Array
        {
            return _args;
        }
    }
}