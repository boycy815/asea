package com.alibado.asea
{
    import flash.events.EventDispatcher;

    public class EaDrop
    {
        protected var _context:EaContext;
        
        public function EaDrop(context:EaContext)
        {
            _context = context;
        }
        
        /**
         * override
         */
        public function get name():String
        {
            //return the name of drop
            return null;
        }
        
        /**
         * override
         * @param dom XML
         * @param onComplete function(...args):void
         * @param onError function(errorCode:int, message:String, target:String, xml:XML):void
         */
        public function process(dom:XML, onComplete:Function = null, onError:Function = null):void
        {
            //process the xml
        }
    }
}