package com.alibado.asea.drops
{
    import com.alibado.asea.EaConfig;
    import com.alibado.asea.EaDrop;
    
    public class EaSelector extends EaDrop
    {
        
        override public function get name():String
        {
            return "selector";
        }
        
        /**
         * example:
         * <selector>
         *     <if value="id1">
         *         <lib value="http://www.alibado.com/lib/myLib.swf" />
         *         <class id="MyClass" value="com.alibado.lib.DemoClass" />
         *     </if>
         *     <if value="id2">
         *         <lib value="http://www.alibado.com/lib/myLib.swf" />
         *         <class id="MyClass" value="com.alibado.lib.DemoClass" />
         *     </if>
         * </selector>
         * 
         * 子节点规则：onComplete参数第一个为true则跳出，否则继续。
         */
        override protected function onProcess(dom:XML, value:*, contexts:Array, onComplete:Function, onError:Function = null):void
        {
            var count:int = 0;
            var children:XMLList = dom.children();
            
            
            function processNext(result:* = null):void
            {
                if (result == true)
                {
                    onComplete();
                    return;
                }
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