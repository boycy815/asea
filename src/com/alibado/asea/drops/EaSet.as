package com.alibado.asea.drops
{
    import com.alibado.asea.EaContext;
    import com.alibado.asea.EaDrop;
    import com.alibado.asea.EaValue;
    
    public class EaSet extends EaDrop
    {
        public function EaSet(context:EaContext)
        {
            super(context);
        }
        
        override public function get name():String
        {
            return "set";
        }
        
        /**
         * example:
         * <set target="pen" >
         *     <attr name="aa" value="number/400" />
         *     <attr name="bb" value="number/300" />
         *     <attr name="cc" value="@string/this is my title" />
         * </set>
         */
        override public function process(dom:XML, onComplete:Function = null, onError:Function = null):void
        {
            var tempEaValue:EaValue = _context.uniformGetter(dom.@target);
            if (!tempEaValue)
            {
                if(onError != null) onError(EaContext.ERROR_CANOT_FOUND_VALUE, "找不到值:target", dom.@target, dom);
                return;
            }
            
            var target:Object = tempEaValue.value;
            var args:Array = [];
            var children:XMLList = dom.attr;
            for (var i:int = 0; i < children.length(); i++)
            {
                var tempArg:EaValue = _context.uniformGetter(children[i].@value);
                if (tempArg)
                {
                    if (!String(children[i].@name).match("^[_a-zA-Z]+$"))
                    {
                        if(onError != null) onError(EaContext.ERROR_NAME_INVALID, "命名无效:name", children[i].@name, children[i]);
                        return;
                    }
                    target[children[i].@name] = tempArg.value;
                }
                else
                {
                    if(onError != null) onError(EaContext.ERROR_CANOT_FOUND_VALUE, "找不到值:value", children[i].@value, children[i]);
                    return;
                }
            }
            if (onComplete != null) onComplete();
        }
    }
}