package com.alibado.asea.drops
{
    import com.alibado.asea.EaContext;
    import com.alibado.asea.EaDrop;

    public class EaTrace extends EaDrop
    {
        public function EaTrace(context:EaContext)
        {
            super(context);
        }
        
        override public function get name():String
        {
            return "trace";
        }
        
        /**
         * example: <trace text="hello world" />
         */
        override public function process(dom:XML, onComplete:Function = null, onError:Function = null):void
        {
            trace(_context.uniformGetter(dom.@text));
            if (onComplete != null) onComplete();
        }
    }
}