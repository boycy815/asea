package com.alibado.asea
{
    import flash.events.EventDispatcher;

    public class EaDrop
    {
        
        public static const ERROR_CANOT_FOUND_DROP:int = 1001;
        public static const ERROR_IO_ERROR:int = 1002;
        public static const ERROR_CANOT_FOUND_CLASS:int = 1003;
        public static const ERROR_CANOT_FOUND_VALUE:int = 1004;
        public static const ERROR_NAME_INVALID:int = 1005;
        
        public static const TYPE_STRING:String = "string";
        public static const TYPE_NUMBER:String = "number";
        
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
         * @param onComplete function(result:* = null):void
         * @param onError function(errorCode:int, message:String, target:String, xml:XML):void
         */
        public function process(dom:XML, contexts:Array, onComplete:Function = null, onError:Function = null):void
        {
            function onReturn(result:* = null):void
            {
                if (contexts[0] is Array) contexts[0].push(result);
                if (dom.@id != null && result != null)
                {
                    setValue(dom.@id, result, contexts);
                }
                onComplete(result);
            }
            onProcess(dom, contexts, onReturn, onError);
        }
        
        protected function onProcess(dom:XML, contexts:Array, onComplete:Function = null, onError:Function = null):void
        {
            //process the xml
        }
        
        protected function getValue(name:String, contexts:Array):*
        {
            var nameArray:Array;
            if (name == null) return null;
            if ((nameArray = name.match("^(" + TYPE_STRING + "|" + TYPE_NUMBER + ")\/(.+)$")))
            {
                switch(nameArray[1])
                {
                    case TYPE_STRING:
                        return nameArray[2];
                        break;
                    case TYPE_NUMBER:
                        return Number(nameArray[2]);
                        break;
                }
            }
            nameArray = name.split(".");
            var tempObj:Object;
            if (nameArray[0] == "")
            {
                tempObj = contexts[contexts.length - 1];
            }
            else
            {
                for (var i:int = 0; i < contexts.length; i++)
                {
                    if (contexts[i][nameArray[0]] != null)
                    {
                        tempObj = contexts[i][nameArray[0]];
                        break;
                    }
                }
                if (tempObj == null) return;
            }
            for (var j:int = 1; j < nameArray.length; j++)
            {
                if (tempObj[nameArray[j]] == null) return null;
                else tempObj = tempObj[nameArray[j]];
            }
            return tempObj;
        }
        
        protected function setValue(name:String, value:*, contexts:Array):void
        {
            var nameArray:Array = name.split(".");
            var parent:Object = contexts[0];
            if (nameArray.length >= 2)
            {
                if (nameArray[0] == "")
                {
                    parent = contexts[contexts.length - 1];
                    nameArray.shift();
                }
                else
                {
                    for (var i:int = 0; i < contexts.length; i++)
                    {
                        if (contexts[i][nameArray[0]] != null)
                        {
                            parent = contexts[i][nameArray[0]];
                            nameArray.shift();
                            break;
                        }
                    }
                }
                for (var j:int = 0; j < nameArray.length - 1; j++)
                {
                    if (parent[nameArray[j]] == null)
                    {
                        parent[nameArray[j]] = {};
                        parent = parent[nameArray[j]];
                    }
                    parent = parent[nameArray[j]];
                }
            }
            parent[nameArray[nameArray.length - 1]] = value;
        }
    }
}