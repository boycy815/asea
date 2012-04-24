package com.alibado.asea.drops
{
    import com.alibado.asea.EaContext;
    import com.alibado.asea.EaDrop;
    import com.alibado.asea.EaValue;
    
    public class EaGet extends EaDrop
    {
        public function EaGet(context:EaContext)
        {
            super(context);
        }
        
        override public function get name():String
        {
            return "get";
        }
        
        
        /**
         * example:
         * <get target="pen" >
         *     <attr name="aa" to="dd" />
         *     <attr name="bb" to="dd" />
         *     <attr name="cc" to="dd" />
         * </get>
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
                if (!String(children[i].@name).match("^[_a-zA-Z]+$"))
                {
                    if(onError != null) onError(EaContext.ERROR_NAME_INVALID, "命名无效:name", children[i].@name, children[i]);
                    return;
                }
                if (!String(children[i].@to).match("^[_a-zA-Z]+$"))
                {
                    if(onError != null) onError(EaContext.ERROR_NAME_INVALID, "命名无效:to", children[i].@to, children[i]);
                    return;
                }
                _context.setObject(children[i].@to, target[children[i].@name]);
            }
            if (onComplete != null) onComplete();
        }
    }
    
}