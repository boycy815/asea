package com.alibado.asea.drops
{
    import com.alibado.asea.EaContext;
    import com.alibado.asea.EaValue;
    
    public class EaIf extends EaAsea
    {
        public function EaIf(context:EaContext)
        {
            super(context);
        }
        
        override public function get name():String
        {
            return "if";
        }
        
        /**
         * example:
         * <if left="number/1" logic="@function/equal" right="@number/other">
         *     <lib src="http://www.alibado.com/lib/myLib.swf" />
         *     <class name="MyClass" value="com.alibado.lib.DemoClass" />
         * </if>
         * 
         * onComplete(result:Boolean)
         */
        override public function process(dom:XML, onComplete:Function = null, onError:Function = null):void
        {
            var logicEaValue:EaValue = _context.uniformGetter(dom.@logic);
            var leftEaValue:EaValue = _context.uniformGetter(dom.@left);
            var rightEaValue:EaValue = _context.uniformGetter(dom.@right);
            if (!logicEaValue)
            {
                if(onError != null) onError(EaContext.ERROR_CANOT_FOUND_VALUE, "找不到值:logic", dom.@logic, dom);
                return;
            }
            if (!leftEaValue)
            {
                if(onError != null) onError(EaContext.ERROR_CANOT_FOUND_VALUE, "找不到值:left", dom.@left, dom);
                return;
            }
            if (!rightEaValue)
            {
                if(onError != null) onError(EaContext.ERROR_CANOT_FOUND_VALUE, "找不到值:right", dom.@right, dom);
                return;
            }
            if (logicEaValue.value.call(logicEaValue.value, leftEaValue.value, rightEaValue.value))
            {
                super.process(dom, onProcessComplete, onError);
            }
            else
            {
                if (onComplete != null) onComplete(false);
            }
            
            function onProcessComplete(...args):void
            {
                if (onComplete != null) onComplete(true);
            }
        }
    }
}