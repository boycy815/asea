package com.alibado.asea.drops
{
    import com.alibado.asea.EaContext;
    import com.alibado.asea.EaDrop;

    public class EaAsea extends EaDrop
    {
        public function EaAsea(context:EaContext)
        {
            super(context);
        }
        
        override public function get name():String
        {
            return "asea";
        }
        
        protected var _count:int;
        protected var _children:XMLList;
        protected var _onComplete:Function;
        protected var _onError:Function;
        
        override public function process(dom:XML, onComplete:Function = null, onError:Function = null):void
        {
            _count = 0;
            _children = dom.children();
            _onComplete = onComplete;
            _onError = onError;
            
            processNext();
        }
        
        protected function processNext(...args):void
        {
            if (_count < _children.length())
            {
                var xml:XML = _children[_count];
                _count++;
                if (_context.getDrop(xml.localName()))
                    _context.getDrop(xml.localName()).process(xml, processNext, processError);
                else if(_onError != null)
                    _onError(EaContext.ERROR_CANOT_FOUND_DROP, "找不到节点值处理器", xml.localName(), xml);
            }
            else
            {
                if(_onComplete != null) _onComplete();
            }
        }
        
        protected function processError(errorCode:int, message:String, target:String, xml:XML):void
        {
            if(_onError != null) _onError(errorCode, message, target, xml);
        }
    }
}