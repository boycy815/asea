package com.alibado.asea
{
    import flash.display.DisplayObjectContainer;

    public class EaContext
    {
        public static const ERROR_CANOT_FOUND_DROP:int = 1001;
        public static const ERROR_IO_ERROR:int = 1002;
        public static const ERROR_CANOT_FOUND_CLASS:int = 1003;
        public static const ERROR_CANOT_FOUND_VALUE:int = 1004;
        public static const ERROR_NAME_INVALID:int = 1005;
        
        public static const TYPE_OBJECT:String = "object";
        public static const TYPE_STRING:String = "string";
        public static const TYPE_NUMBER:String = "number";
        public static const TYPE_FUNCTION:String = "function";
        
        private var _varObject:Object = {};
        
        private var _dropsMap:Object = {};
        
        public function EaContext()
        {
            var config:Vector.<Class> = EaConfig.drops;
            for (var i:int = 0; i < config.length; i++)
            {
                var drop:EaDrop = new config[i](this);
                _dropsMap[drop.name] = drop;
            }
        }
        
        public function process(dom:XML, onComplete:Function = null, onError:Function = null):void
        {
            if (getDrop(dom.localName()))
                getDrop(dom.localName()).process(dom, onComplete, onError);
            else if(onError != null)
                onError(EaContext.ERROR_CANOT_FOUND_DROP, "找不到节点值处理器", dom.localName(), dom);
        }
        
        public function getDrop(name:String):EaDrop
        {
            return _dropsMap[name];
        }
        
        public function setObject(name:String, value:Object):void
        {
            _varObject[name] = new EaValue(value, TYPE_OBJECT);
        }
        
        public function setString(name:String, value:String):void
        {
            _varObject[name] = new EaValue(value, TYPE_STRING);
        }
        
        public function setNumber(name:String, value:Number):void
        {
            _varObject[name] = new EaValue(value, TYPE_NUMBER);
        }
        
        public function setFunction(name:String, value:Function):void
        {
            _varObject[name] = new EaValue(value, TYPE_FUNCTION);
        }
        
        public function getVarObject(name:String):EaValue
        {
            return _varObject[name] as EaValue;
        }
        
        public function uniformGetter(name:String):EaValue
        {
            var nameArray:Array;
            var result:EaValue;
            if ((nameArray = name.match("^(" + TYPE_STRING + "|" + TYPE_NUMBER + ")\/(.+)$")))
            {
                switch(nameArray[1])
                {
                    case TYPE_STRING:
                        result = new EaValue(nameArray[2], TYPE_STRING);
                        break;
                    case TYPE_NUMBER:
                        result = new EaValue(Number(nameArray[2]), TYPE_NUMBER);
                        break;
                }
            }
            else if ((nameArray = name.match("^[_a-zA-Z]+$")))
            {
                result = getVarObject(nameArray[0]);
            }
            return result;
        }
        
    }
}