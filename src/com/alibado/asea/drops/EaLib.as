package com.alibado.asea.drops
{
    import com.alibado.net.SharedClass;
    
    import flash.display.LoaderInfo;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import com.alibado.asea.EaDrop;

    public class EaLib extends EaDrop
    {
        override public function get name():String
        {
            return "lib";
        }
        
        /**
         * example: <lib value="http://www.alibado.com/lib/myLib.swf" />
         */
        override protected function onProcess(dom:XML, contexts:Array, onComplete:Function = null, onError:Function = null):void
        {
            var info:LoaderInfo = SharedClass.instance.loadLib(dom.@value);
            info.addEventListener(Event.COMPLETE, onLoadComplete);
            info.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
            
            function onLoadComplete(e:Event):void
            {
                e.currentTarget.removeEventListener(Event.COMPLETE, onLoadComplete);
                if(onComplete != null) onComplete();
            }
            
            function onIoError(e:IOErrorEvent):void
            {
                e.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);
                if(onError != null) onError(ERROR_IO_ERROR, e.text, dom.@value, dom);
            }
        }
    }
}