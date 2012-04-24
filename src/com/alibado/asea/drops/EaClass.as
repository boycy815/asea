package com.alibado.asea.drops
{
    import com.alibado.asea.EaContext;
    import com.alibado.asea.EaDrop;
    import com.alibado.net.SharedClass;

    public class EaClass extends EaDrop
    {
        public function EaClass(context:EaContext)
        {
            super(context);
        }
        
        override public function get name():String
        {
            return "class";
        }
        
        /**
         * example: <class name="MyClass" value="com.alibado.lib.DemoClass" />
         */
        override public function process(dom:XML, onComplete:Function = null, onError:Function = null):void
        {
            var tempClass:Class = SharedClass.instance.getClass(dom.@value);
            
            if (!String(dom.@name).match("^[_a-zA-Z]+$"))
            {
                if(onError != null) onError(EaContext.ERROR_NAME_INVALID, "命名无效:name", dom.@name, dom);
                return;
            }
            
            if (tempClass)
            {
                _context.setObject(dom.@name, tempClass);
                if (onComplete != null) onComplete();
            }
            else
            {
                if(onError != null) onError(EaContext.ERROR_CANOT_FOUND_CLASS, "找不到类:value", dom.@value, dom);
            }
        }
    }
}