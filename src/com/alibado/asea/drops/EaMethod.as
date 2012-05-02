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
         *     <get value="@string/this is my title" />
         * </method>
         */
        override protected function onProcess(dom:XML, contexts:Array, onComplete:Function = null, onError:Function = null):void
        {
            function onParamGet(result:* = null):void
            {
                var result:* = fun.apply(null, contextsCopy[0]);
                if (onComplete != null) onComplete(result);
            }
            
            var fun:Function = getValue(dom.@value, contexts);
            if (fun == null)
            {
                if(onError != null) onError(ERROR_CANOT_FOUND_VALUE, "找不到值:value", dom.@value, dom);
                if (onComplete != null) onComplete();
            }
            else
            {
                var contextsCopy:Array = contexts.slice();
                contextsCopy.unshift([]);
                super.process(dom, contextsCopy, onParamGet, onError);
            }
        }
    }
}