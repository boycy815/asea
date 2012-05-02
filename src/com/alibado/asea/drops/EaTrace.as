package com.alibado.asea.drops
{
    import com.alibado.asea.EaDrop;

    public class EaTrace extends EaDrop
    {
        
        override public function get name():String
        {
            return "trace";
        }
        
        /**
         * example: <trace value="hello world" />
         */
        override protected function onProcess(dom:XML, contexts:Array, onComplete:Function = null, onError:Function = null):void
        {
            trace(getValue(dom.@text, contexts));
            if (onComplete != null) onComplete();
        }
    }
}