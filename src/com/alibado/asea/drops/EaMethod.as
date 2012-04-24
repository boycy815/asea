package com.alibado.asea.drops
{
    import com.alibado.asea.EaContext;
    import com.alibado.asea.EaDrop;
    import com.alibado.asea.EaValue;
    
    public class EaMethod extends EaDrop
    {
        public function EaMethod(context:EaContext)
        {
            super(context);
        }
        
        override public function get name():String
        {
            return "method";
        }
        
        /**
         * example:
         * <method name="draw" target="pen" result="pic">
         *     <param value="number/400" />
         *     <param value="number/300" />
         *     <param value="@string/this is my title" />
         * </method>
         */
        override public function process(dom:XML, onComplete:Function = null, onError:Function = null):void
        {
            var tempEaValue:EaValue = _context.uniformGetter(dom.@target);
            if (!tempEaValue)
            {
                if(onError != null) onError(EaContext.ERROR_CANOT_FOUND_VALUE, "找不到值:target", dom.@target, dom);
                return;
            }
            
            if (!String(dom.@name).match("^[_a-zA-Z]+$"))
            {
                if(onError != null) onError(EaContext.ERROR_NAME_INVALID, "命名无效:name", dom.@name, dom);
                return;
            }
            
            var target:Object = tempEaValue.value;
            var args:Array = [];
            var children:XMLList = dom.param;
            for (var i:int = 0; i < children.length(); i++)
            {
                var tempArg:EaValue = _context.uniformGetter(children[i].@value);
                if (tempArg)
                {
                    args.push(tempArg.value);
                }
                else
                {
                    if(onError != null) onError(EaContext.ERROR_CANOT_FOUND_VALUE, "找不到值:value", children[i].@value, children[i]);
                    return;
                }
            }
            var result:* = target[dom.@name].apply(target, args);
            if (result && String(dom.@result).match("^[_a-zA-Z]+$"))
            {
                _context.setObject(dom.@result, result);
            }
            if (onComplete != null) onComplete();
        }
    }
}