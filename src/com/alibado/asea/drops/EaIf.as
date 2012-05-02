package com.alibado.asea.drops
{
    public class EaIf extends EaAsea
    {
        override public function get name():String
        {
            return "if";
        }
        
        /**
         * example:
         * <if value="id">
         *     <lib value="http://www.alibado.com/lib/myLib.swf" />
         *     <class id="MyClass" value="com.alibado.lib.DemoClass" />
         * </if>
         * 
         */
        override protected function onProcess(dom:XML, contexts:Array, onComplete:Function = null, onError:Function = null):void
        {
            function onAseaComplete(result:* = null):void
            {
                if (onComplete != null) onComplete(true);
            }
            
            if (getValue(dom.@value, contexts) == true)
            {
                super.process(dom, contexts, onAseaComplete, onError);
            }
            else
            {
                if (onComplete != null) onComplete(false);
            }
        }
    }
}