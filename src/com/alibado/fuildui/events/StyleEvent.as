package com.alibado.fuildui.events
{
    import flash.events.Event;
    
    /*
     * 元素样式发生改变时发生的事件
     */
    public class StyleEvent extends Event
    {
        public static const STYLE_CHANGE:String = "style_change";
        
        private var _styles:Array;
        
        public function StyleEvent(type:String, _newStyles:Array, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
            _styles = _newStyles;
        }
        
        /*
         * 考虑效率，所以返回数组不做副本
         */
        public function get style():Array
        {
            return _styles;
        }
        
        override public function clone():Event
        {
            return new StyleEvent(type, _styles, bubbles, cancelable);
        }
    }
}