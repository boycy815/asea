package com.alibado.asea
{
    /**
    * 
    * 一种特殊的对象，该对象被保存到上下文中后，若是在xml中对他进行读取操作，
    * 则会调用getValue并且在onComplete回调中抛回结果。
    * 
    * 该对象一般用于异步获取数据
    * 
    */
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