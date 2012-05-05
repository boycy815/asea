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
        override protected function onProcess(dom:XML, value:*, contexts:Array, onComplete:Function, onError:Function = null):void
        {
            var constructor:String = value is String ? value : dom.@value;
            if (!constructor)
            {
                if(onError != null) onError(ERROR_CANOT_FOUND_CLASS, "dom.@value", dom.@value, dom);
                onComplete();
                return;
            }
            var tempClass:Class = SharedClass.instance.getClass(constructor);
            
            if (tempClass is Class)
            {
                onComplete(tempClass);
            }
            else
            {
                if(onError != null) onError(ERROR_CANOT_FOUND_CLASS, "dom.@value", dom.@value, dom);
                onComplete();
            }
        }
    }
}