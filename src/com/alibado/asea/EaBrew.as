package com.alibado.asea
{
    public class EaBrew
    {
        /**
         * should be overrided
         * @param onComplete function(result:* = null):void
         * @param onError function(errorCode:int, target:String, value:String, xml:XML):void
         */
        public function getValue(onComplete:Function, onError:Function = null):void
        {
            //return the value of brew
        }
    }
}