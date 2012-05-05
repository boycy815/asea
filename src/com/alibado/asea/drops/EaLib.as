package com.alibado.asea.drops
{
    import com.alibado.asea.EaDrop;
    import com.alibado.net.SharedClass;
    
    import flash.display.LoaderInfo;
    import flash.events.Event;
    import flash.events.IOErrorEvent;

    public class EaLib extends EaDrop
    {
        override public function get name():String
        {
            return "lib";
        }
        
        /**
         * example: <lib value="http://www.alibado.com/lib/myLib.swf" />
         */
        override protected function onProcess(dom:XML, value:*, contexts:Array, onComplete:Function, onError:Function = null):void
        {
            var url:String;
            if (value is String) url = value;
            else url = dom.@value;
            if (!url)
            {
                if(onError != null) onError(ERROR_CANOT_FOUND_PATH, "dom.@value", dom.@value, dom);
                onComplete();
                return;
            }
            var info:LoaderInfo = SharedClass.instance.loadLib(url);
            info.addEventListener(Event.COMPLETE, onLoadComplete);
            info.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
            
            function onLoadComplete(e:Event):void
            {
                e.currentTarget.removeEventListener(Event.COMPLETE, onLoadComplete);
                onComplete();
            }
            
            function onIoError(e:IOErrorEvent):void
            {
                e.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);
                if(onError != null) onError(ERROR_IO_ERROR, "dom.@value", dom.@value, dom);
                onComplete();
            }
        }
    }
}