package com.alibado.fuildui.container
{
    import com.alibado.fuildui.container.Content;
    import com.alibado.fuildui.events.StyleEvent;
    
    import flash.display.DisplayObject;
    
    public class LinearContent extends Content
    {
        public static const LEFT:int = 0;
        public static const RIGHT:int = 1;
        public static const TOP:int = 2;
        public static const BOTTOM:int = 3;
        
        protected var _lingAlgin:int;
        
        public function LinearContent(algin:int = 0, na:String = null, style:Object = null)
        {
            super(na, style);
        }
        
        override protected function onChildAdded(item:DisplayObject):void
        {
            resize(width, height);
            item.addEventListener(StyleEvent.STYLE_CHANGE, onItemStyleChange);
        }
        
        override protected function draw():void
        {
            
            super.draw();
        }
        
        override protected function calculateHeight(value:Number):Number
        {
            
            return value;
        }
        
        override protected function calculateWidth(value:Number):Number
        {
            
            return value;
        }
        
        private function onItemStyleChange(e:StyleEvent):void
        {
            //
        }
    }
}