package com.alibado.asea.drops
{
    import com.alibado.asea.EaDrop;
    import com.alibado.util.net.SharedClass;
    
    public class EaNew extends EaAsea
    {
        override public function get name():String
        {
            return "new";
        }
        
        /**
         * example:
         * <new id="myPic" value="Pic">
         *     <get value="box" />
         *     <get value="number/400" />
         *     <get value="number/300" />
         *     <get value="string/this is my title" />
         * </new>
         */
        override protected function onProcess(dom:XML, value:*, contexts:Array, onComplete:Function, onError:Function = null):void
        {
            function onParamGet(result:* = null):void
            {
                var result:* = getInstance(con, contextsCopy[0]);
                onComplete(result);
            }
            
            var con:Class;
            if (!(value is Class))
            {
                con = SharedClass.getClass(dom.@value);
                if (con == null)
                {
                    if(onError != null) onError(ERROR_CANOT_FOUND_CLASS, "dom.@value", dom.@value, dom);
                    onComplete();
                    return;
                }
            }
            else
            {
                con = value;
            }
            var contextsCopy:Array = contexts.slice();
            contextsCopy.unshift([]);
            super.onProcess(dom, value, contextsCopy, onParamGet, onError);
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