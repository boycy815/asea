package com.alibado.asea
{
    import flash.events.EventDispatcher;

    /**
    * 
    * 标签处理器基类，封装了对上下文的值写入与读取操作
    * 主要功能有：
    * 1. 自动获取value标签内的值对应的上线文值。
    * 2. 自动将标签执行结果赋值到id属性对应的上下文对象中。
    * 3. 若是当前上下文对象是数组，则自动将标签执行结果按顺序加入其中。
    * 
    */
    
    public class EaDrop
    {
        
        /**
        * 错误代码常量
        */
        
        //找不到对应的标签处理
        public static const ERROR_CANOT_FOUND_DROP:int = 1001;
        
        //流加载错误
        public static const ERROR_IO_ERROR:int = 1002;
        
        //找不到类对象
        public static const ERROR_CANOT_FOUND_CLASS:int = 1003;
        
        //找不到值
        public static const ERROR_CANOT_FOUND_VALUE:int = 1004;
        
        //找不到路径对象
        public static const ERROR_CANOT_FOUND_PATH:int = 1005;
        
        //找不到方法对象
        public static const ERROR_CANOT_FOUND_FUNCTION:int = 1006;
        
        
        /**
        * 类型常量
        * example: string/hello  number/110  boolean/true
        */
        
        //字符串
        public static const TYPE_STRING:String = "string";
        
        //数字
        public static const TYPE_NUMBER:String = "number";
        
        //布尔值
        public static const TYPE_BOOLEAN:String = "boolean";
        
        
        /**
        * 关键字常量
        */
        
        //当前上下文
        public static const KEY_WORD_THIS:String = "@this";
        
        //根上下文
        public static const KEY_WORD_ROOT:String = "@root";
        
        
        /**
         * 需要被覆盖
         * @return 该标签处理器的处理的标签名
         */
        public function get name():String
        {
            //return the name of drop
            return null;
        }
        
        /**
         * 需要被覆盖 调用后处理给定的xml标签并在回调中通知处理完成
         * @param dom XML 处理的xml标签
         * @param onComplete function(result:* = null):void 回调后将执行下一个标签，回调参数为标签执行结果
         * @param onError function(errorCode:int, target:String, value:String, xml:XML):void 回调后输出错误信息，四个参数分别是 错误代码 出错属性 出错属性值 出错的标签
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