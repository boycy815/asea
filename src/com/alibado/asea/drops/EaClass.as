package com.alibado.asea.drops
{
    import com.alibado.asea.EaDrop;
    import com.alibado.net.SharedClass;

    public class EaClass extends EaDrop
    {
        
        override public function get name():String
        {
            return "class";
        }
        
        /**
         * example: <class id="MyClass" value="com.alibado.lib.DemoClass" />
         */
        override protected function onProcess(dom:XML, contexts:Array, onComplete:Function = null, onError:Function = null):void
        {
            var tempClass:Class = SharedClass.instance.getClass(dom.@value);
            
            if (tempClass)
            {
                if (onComplete != null) onComplete(tempClass);
            }
            else
            {
                if(onError != null) onError(ERROR_CANOT_FOUND_CLASS, "找不到类:value", dom.@value, dom);
                if (onComplete != null) onComplete();
            }
        }
    }
}