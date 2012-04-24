package com.alibado.asea.drops
{
    import com.alibado.net.SharedClass;
    
    import flash.display.LoaderInfo;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import com.alibado.asea.EaContext;
    import com.alibado.asea.EaDrop;

    public class EaLib extends EaDrop
    {
        public function EaLib(context:EaContext)
        {
            super(context);
        }
        
        override public function get name():String
        {
            return "lib";
        }
        
        /**
         * example: <lib src="http://www.alibado.com/lib/myLib.swf" />
         */
        override public function process(dom:XML, onComplete:Function = null, onError:Function = null):void
        {
            var info:LoaderInfo = SharedClass.instance.loadLib(dom.@src);
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
                if(onError != null) onError(EaContext.ERROR_IO_ERROR, e.text, dom.@src, dom);
            }
        }
    }
}