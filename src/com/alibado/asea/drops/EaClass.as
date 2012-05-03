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
         * example: <class id="MyClass" constructor="com.alibado.lib.DemoClass" />
         */
        override protected function onProcess(dom:XML, value:*, contexts:Array, onComplete:Function, onError:Function = null):void
        {
            var tempClass:Class = SharedClass.instance.getClass(dom.@constructor);
            
            if (tempClass)
            {
                onComplete(tempClass);
            }
            else
            {
                if(onError != null) onError(ERROR_CANOT_FOUND_CLASS, "找不到类:constructor", dom.@constructor, dom);
                onComplete();
            }
        }
    }
}