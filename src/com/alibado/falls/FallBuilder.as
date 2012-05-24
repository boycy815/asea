package com.alibado.falls
{
    public class FallBuilder implements IFallBuilder
    {
        public static const COVER_NONE:String = "none";
        
        public function start(args:Object, callback:Function, cover:String = null):IFall
        {
            return null;
        }
        
        protected function _coverSet(f:Fall, c:String):void
        {
            
        }
    }
}