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
        override protected function onProcess(dom:XML, value:*, contexts:Array, onComplete:Function, onError:Function = null):void
        {
            onComplete(value);
        }
    }
    
}