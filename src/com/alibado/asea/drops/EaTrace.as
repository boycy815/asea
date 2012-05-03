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
         * example: <trace value="string/hello world" />
         */
        override protected function onProcess(dom:XML, value:*, contexts:Array, onComplete:Function, onError:Function = null):void
        {
            trace(value);
            onComplete();
        }
    }
}