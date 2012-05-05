package com.alibado.asea.brews
{
    import com.alibado.asea.EaBrew;
    import com.alibado.asea.drops.EaAsea;
    
    public class EaBeanMother extends EaBrew
    {
        
        private var _xml:XML;
        
        private var _contexts:Array;
        
        private var _asea:EaAsea;
        
        public function EaBeanMother(xml:XML, contexts:Array, asea:EaAsea)
        {
            _xml = xml.copy();
            _xml.@id = null;
            _xml.@value = null;
            _xml["new"][0].@id = "@this";
            _contexts = contexts;
            _asea = asea;
        }
        
        override public function getValue(onComplete:Function, onError:Function = null):void
        {
            function onReturn(result:* = null):void
            {
                onComplete(contextCopy[0]);
            }
            
            var contextCopy:Array = _contexts.slice();
            contextCopy.unshift({});
            _asea.process(_xml, contextCopy, onReturn, onError);
        }
    }
}