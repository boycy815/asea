package com.alibado.asea.drops
{
    import com.alibado.asea.EaConfig;
    import com.alibado.asea.EaDrop;

    public class EaAsea extends EaDrop
    {
        
        override public function get name():String
        {
            return "asea";
        }
        
        override protected function onProcess(dom:XML, value:*, contexts:Array, onComplete:Function, onError:Function = null):void
        {
            var count:int = 0;
            var children:XMLList = dom.children();
            
            
            function processNext(result:* = null):void
            {
                if (count < children.length())
                {
                    var xml:XML = children[count];
                    count++;
                    if (EaConfig.getDrop(xml.localName()) != null)
                        EaConfig.getDrop(xml.localName()).process(xml, contexts, processNext, onError);
                    else
                    {
                        if(onError != null) onError(ERROR_CANOT_FOUND_DROP, "xml.localName()", xml.localName(), xml);
                        processNext();
                    }
                }
                else
                {
                    onComplete();
                }
            }
            
            processNext();
        }
    }
}