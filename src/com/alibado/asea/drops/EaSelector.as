package com.alibado.asea.drops
{
    import com.alibado.asea.EaContext;
    import com.alibado.asea.EaDrop;
    
    public class EaSelector extends EaAsea
    {
        public function EaSelector(context:EaContext)
        {
            super(context);
        }
        
        override public function get name():String
        {
            return "selector";
        }
        
        /**
         * example:
         * <selector>
         *     <if left="number/1" logic="@function/equal" right="@number/other">
         *         <lib src="http://www.alibado.com/lib/myLib.swf" />
         *         <class name="MyClass" value="com.alibado.lib.DemoClass" />
         *     </if>
         *     <if left="number/2" logic="@function/equal" right="@number/other">
         *         <lib src="http://www.alibado.com/lib/myLib.swf" />
         *         <class name="MyClass" value="com.alibado.lib.DemoClass" />
         *     </if>
         * </selector>
         * 
         * 子节点规则：onComplete参数第一个为true则跳出，否则继续。
         */
        override protected function processNext(...args):void
        {
            if (args[0])
            {
                if(_onComplete != null) _onComplete();
            }
            else
            {
                super.processNext();
            }
        }
    }
}