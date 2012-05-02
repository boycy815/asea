package com.alibado.asea.drops
{
    import com.alibado.asea.EaDrop;
    
    public class EaGet extends EaDrop
    {
        
        override public function get name():String
        {
            return "get";
        }
        
        
        /**
         * example:
         * <get id="myPen" value="pen" >
         */
        override protected function onProcess(dom:XML, contexts:Array, onComplete:Function = null, onError:Function = null):void
        {
            if (onComplete != null) onComplete(getValue(dom.@value, contexts));
        }
    }
    
}