package com.alibado.asea.drops
{
    import com.alibado.asea.EaConfig;
    import com.alibado.asea.EaDrop;
    
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    
    public class EaInclude extends EaDrop
    {
        override public function get name():String
        {
            return "include";
        }
        
        /**
         * example:
         * <include value="pen.xml" >
         */
        override protected function onProcess(dom:XML, value:*, contexts:Array, onComplete:Function, onError:Function = null):void
        {
            var xml:XML;
            var url:String;
            
            function processXML():void
            {
                if (EaConfig.getDrop(xml.localName()) != null)
                {
                    EaConfig.getDrop(xml.localName()).process(xml, contexts, onComplete, onError);
                }
                else
                {
                    if(onError != null) onError(ERROR_CANOT_FOUND_DROP, "xml.localName()", xml.localName(), xml);
                    onComplete();
                }
            }
            
            function loadOnComplete(e:Event):void
            {
                e.currentTarget.removeEventListener(Event.COMPLETE, loadOnComplete);
                xml = new XML(e.currentTarget.data);
                processXML();
            }
            
            function loadOnError(e:IOErrorEvent):void
            {
                e.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, loadOnError);
                if(onError != null) onError(ERROR_IO_ERROR, "dom.@value", dom.@value, dom);
                onComplete();
            }
            
            if (value is XML)
            {
                xml = value;
                processXML();
                return;
            }
            else if (value is String)
            {
                url = value;
            }
            else if (dom.@value)
            {
                url = dom.@value;
            }
            else
            {
                if(onError != null) onError(ERROR_CANOT_FOUND_VALUE, "dom.@value", dom.@value, dom);
                onComplete();
                return;
            }
            var urlLoader:URLLoader = new URLLoader();
            urlLoader.addEventListener(Event.COMPLETE, loadOnComplete);
            urlLoader.addEventListener(IOErrorEvent.IO_ERROR, loadOnError);
            urlLoader.load(new URLRequest(url));
        }
    }
}