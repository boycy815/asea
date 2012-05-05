package com.alibado.asea
{
    import flash.events.EventDispatcher;

    public class EaDrop
    {
        
        public static const ERROR_CANOT_FOUND_DROP:int = 1001;
        public static const ERROR_IO_ERROR:int = 1002;
        public static const ERROR_CANOT_FOUND_CLASS:int = 1003;
        public static const ERROR_CANOT_FOUND_VALUE:int = 1004;
        public static const ERROR_CANOT_FOUND_PATH:int = 1005;
        public static const ERROR_CANOT_FOUND_FUNCTION:int = 1006;
        
        public static const TYPE_STRING:String = "string";
        public static const TYPE_NUMBER:String = "number";
        public static const TYPE_BOOLEAN:String = "boolean";
        
        public static const KEY_WORD_THIS:String = "@this";
        public static const KEY_WORD_ROOT:String = "@root";
        
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
         * @param onError function(errorCode:int, target:String, value:String, xml:XML):void
         */
        public function process(dom:XML, contexts:Array, onComplete:Function = null, onError:Function = null):void
        {
            function onReturn(result:* = null):void
            {
                if (contexts[0] is Array) contexts[0].push(result);
                if (dom.@id != null && dom.@id != "" && result != null)
                {
                    setValue(dom.@id, result, contexts);
                }
                if (onComplete != null) onComplete(result);
            }
            
            function onGetValue(result:* = null):void
            {
                onProcess(dom, result, contexts, onReturn, onError);
            }
            
            var value:* = getValue(dom.@value, contexts);
            if (value is EaBrew)
            {
                EaBrew(value).getValue(onGetValue, onError);
            }
            else
            {
                onProcess(dom, value, contexts, onReturn, onError);
            }
        }
        
        protected function onProcess(dom:XML, value:*, contexts:Array, onComplete:Function, onError:Function = null):void
        {
            //process the xml
        }
        
        protected function getValue(name:String, contexts:Array):*
        {
            var nameArray:Array;
            if (name == null || name == "") return null;
            
            //mathc the const
            if ((nameArray = name.match("^(" + TYPE_STRING + "|" + TYPE_NUMBER + "|" + TYPE_BOOLEAN + ")\/(.+)$")))
            {
                switch(nameArray[1])
                {
                    case TYPE_STRING:
                        return nameArray[2];
                        break;
                    case TYPE_NUMBER:
                        return Number(nameArray[2]);
                        break;
                    case TYPE_BOOLEAN:
                        if (nameArray[2] == "true") return true;
                        else if (nameArray[2] == "false") return false;
                        break;
                }
            }
            
            
            nameArray = name.split(".");
            
            for (var v:int = 0; v < nameArray.length; v++)
            {
                if (!nameArray[v].match("^@?[_a-zA-Z]+$"))
                    return null;
            }
            
            var tempObj:Object;
            
            //search the first object
            if (nameArray[0] == KEY_WORD_ROOT)
            {
                tempObj = contexts[contexts.length - 1];
            }
            else if (nameArray[0] == KEY_WORD_THIS)
            {
                tempObj = contexts[0];
            }
            else
            {
                for (var i:int = 0; i < contexts.length; i++)
                {
                    try
                    {
                        if (contexts[i][nameArray[0]] != null)
                        {
                            tempObj = contexts[i][nameArray[0]];
                            break;
                        }
                    }
                    catch (e:ReferenceError)
                    {
                        continue;
                    }
                }
                if (tempObj == null) return;
            }
            
            //sreach the following object
            for (var j:int = 1; j < nameArray.length; j++)
            {
                try
                {
                    if (tempObj[nameArray[j]] == null) return null;
                    else tempObj = tempObj[nameArray[j]];
                }
                catch (e:ReferenceError)
                {
                    return null;
                }
            }
            return tempObj;
        }
        
        protected function setValue(name:String, value:*, contexts:Array):void
        {
            if (name == null || name == "") return;
            var nameArray:Array = name.split(".");
            
            for (var v:int = 0; v < nameArray.length; v++)
            {
                if (!nameArray[v].match("^@?[_a-zA-Z]+$"))
                    return;
            }
            
            var parent:Object = contexts;
            if (nameArray[0] == KEY_WORD_ROOT)
            {
                nameArray.shift();
                nameArray.unshift(contexts.length - 1);
            }
            else if (nameArray[0] == KEY_WORD_THIS)
            {
                nameArray.shift();
                nameArray.unshift(0);
            }
            else
            {
                parent = contexts[0];
                for (var i:int = 0; i < contexts.length; i++)
                {
                    try
                    {
                        if (contexts[i][nameArray[0]] != null)
                        {
                            parent = contexts[i];
                            break;
                        }
                    }
                    catch (e:ReferenceError)
                    {
                        continue;
                    }
                }
            }
            for (var j:int = 0; j < nameArray.length - 1; j++)
            {
                if (parent[nameArray[j]] == null)
                {
                    parent[nameArray[j]] = {};
                }
                parent = parent[nameArray[j]];
            }
            parent[nameArray[nameArray.length - 1]] = value;
        }
    }
}