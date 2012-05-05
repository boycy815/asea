package com.alibado.asea.drops
{
    import com.alibado.asea.EaDrop;
    
    public class EaMethod extends EaAsea
    {
        override public function get name():String
        {
            return "method";
        }
        
        /**
         * example:
         * <method id="pic" value="draw">
         *     <get value="number/400" />
         *     <get value="number/300" />
         *     <get value="string/this is my title" />
         * </method>
         */
        override protected function onProcess(dom:XML, value:*, contexts:Array, onComplete:Function, onError:Function = null):void
        {
            function onParamGet(result:* = null):void
            {
                var r:* = fun.apply(null, contextsCopy[0]);
                onComplete(r);
            }
            
            var fun:Function;
            if (value is Function)
            {
                fun = value;
            }
            else
            {
                if(onError != null) onError(ERROR_CANOT_FOUND_FUNCTION, "dom.@value", dom.@value, dom);
                onComplete();
                return;
            }
            var contextsCopy:Array = contexts.slice();
            contextsCopy.unshift([]);
            super.onProcess(dom, value, contextsCopy, onParamGet, onError);
        }
    }
}