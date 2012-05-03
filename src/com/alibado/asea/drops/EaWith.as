package com.alibado.asea.drops
{
    public class EaWith extends EaAsea
    {
        override public function get name():String
        {
            return "with";
        }
        
        /**
         * example:
         * <with value="ball">
         *     <get id="aa" value="number/400" />
         *     <get id="bb" value="number/300" />
         *     <get id="cc" value="string/this is my title" />
         * </with>
         */
        override protected function onProcess(dom:XML, value:*, contexts:Array, onComplete:Function, onError:Function = null):void
        {
            if (value == null)
            {
                if(onError != null) onError(ERROR_CANOT_FOUND_VALUE, "找不到值:value", dom.@value, dom);
                onComplete();
            }
            else
            {
                var contextsCopy:Array = contexts.slice();
                contextsCopy.unshift(value);
                super.onProcess(dom, value, contextsCopy, onComplete, onError);
            }
        }
    }
}