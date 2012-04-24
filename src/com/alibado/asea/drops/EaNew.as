package com.alibado.asea.drops
{
    import com.alibado.asea.EaContext;
    import com.alibado.asea.EaDrop;
    import com.alibado.asea.EaValue;
    import com.alibado.net.SharedClass;
    
    public class EaNew extends EaDrop
    {
        public function EaNew(context:EaContext)
        {
            super(context);
        }
        
        override public function get name():String
        {
            return "new";
        }
        
        /**
         * example:
         * <new name="myPic" constructor="Pic">
         *     <param value="box" />
         *     <param value="number/400" />
         *     <param value="number/300" />
         *     <param value="@string/this is my title" />
         * </new>
         */
        override public function process(dom:XML, onComplete:Function = null, onError:Function = null):void
        {
            var tempEaValue:EaValue = _context.uniformGetter(dom.@constructor);
            var tempClass:Class;
            if (!tempEaValue)
            {
                tempClass = SharedClass.instance.getClass(dom.@constructor);
                if (!tempClass)
                {
                    if(onError != null) onError(EaContext.ERROR_CANOT_FOUND_CLASS, "找不到类:constructor", dom.@constructor, dom);
                    return;
                }
            }
            else
            {
                tempClass = tempEaValue.value;
            }
            
            if (!String(dom.@name).match("^[_a-zA-Z]+$"))
            {
                if(onError != null) onError(EaContext.ERROR_NAME_INVALID, "命名无效:name", dom.@name, dom);
                return;
            }
            
            var args:Array = [];
            var children:XMLList = dom.children();
            for (var i:int = 0; i < children.length(); i++)
            {
                var tempArg:EaValue = _context.uniformGetter(children[i].@value);
                if (tempArg)
                {
                    args.push(tempArg.value);
                }
                else
                {
                    if(onError != null) onError(EaContext.ERROR_CANOT_FOUND_VALUE, "找不到值:value", children[i].@value, children[i]);
                    return;
                }
            }
            
            var tempObject:Object = getInstance(tempClass, args);
            _context.setObject(dom.@name, tempObject);
            if (onComplete != null) onComplete();
        }
        
        private function getInstance(myClass:Class, args:Array):Object
        {
            switch(args.length)
            {
                case 0:
                    return new myClass();break;
                case 1:
                    return new myClass(args[0]);break;
                case 2:
                    return new myClass(args[0], args[1]);break;
                case 3:
                    return new myClass(args[0], args[1], args[2]);break;
                case 4:
                    return new myClass(args[0], args[1], args[2], args[3]);break;
                case 5:
                    return new myClass(args[0], args[1], args[2], args[3], args[4]);break;
                case 6:
                    return new myClass(args[0], args[1], args[2], args[3], args[4], args[5]);break;
                case 7:
                    return new myClass(args[0], args[1], args[2], args[3], args[4], args[5], args[6]);break;
                case 8:
                    return new myClass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]);break;
                case 9:
                    return new myClass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8]);break;
                case 10:
                    return new myClass(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9]);break;
            }
            return null;
        }
    }
}