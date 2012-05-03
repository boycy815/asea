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
        override protected function onProcess(dom:XML, value:*, contexts:Array, onComplete:Function, onError:Function = null):void
        {
            function onAseaComplete(result:* = null):void
            {
                onComplete(true);
            }
            
            if (value == true)
            {
                super.onProcess(dom, value, contexts, onAseaComplete, onError);
            }
            else
            {
                onComplete(false);
            }
        }
    }
}