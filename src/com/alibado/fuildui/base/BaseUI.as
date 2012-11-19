package com.alibado.fuildui.base
{
    import com.alibado.fuildui.events.StyleEvent;
    
    import flash.display.Sprite;
    import flash.events.Event;
    
    /**
     * UI基类
     */
    public class BaseUI extends Sprite
    {
        protected var _height:Number = 0;
        protected var _width:Number = 0;
        
        protected var _style:Object = {};
        
        public function BaseUI(na:String = null, style:Object = null)
        {
            super();
            if (na)
            {
                name = na;
            }
            if (style)
            {
                _style = style;
            }
        }
        
        public function setStyle(name:String, style:*):void
        {
            _style[name] = style;
            this.dispatchEvent(new StyleEvent(StyleEvent.STYLE_CHANGE, [style]));
        }
        
        public function getStyle(name:String):*
        {
            return _style[name];
        }
        
        /**
         * 设置UI的宽度，在_freezeHeight为true时触发重绘并受calculateHeight限制
         * 在_freezeHeight为false时直接对_height生效
         * @param value 欲设置的高度
         */
        override public function set height(value:Number):void
        {
            _height = calculateHeight(value);
            draw();
            onDrawed();
        }
        
        /**
         * 获取UI的高度
         * @return 获取高度
         */
        override public function get height():Number
        {
            return _height;
        }
        
        /**
         * 设置UI的宽度，在_freezeWidth为true时触发重绘并受calculateWidth限制
         * 在_freezeWidth为false时直接对_width生效
         * @param value 欲设置的宽度
         */
        override public function set width(value:Number):void
        {
            _width = calculateWidth(value);
            draw();
            onDrawed();
        }
        
        /**
         * 获取UI的宽度
         * @return 获取宽度
         */
        override public function get width():Number
        {
            return _width;
        }
        
        /**
         * 设置UI的尺寸，参考width和height
         * @param width 欲设置的宽度
         * @param height 欲设置的高度
         */
        public function resize(width:Number, height:Number):void
        {
            _height = calculateHeight(height);
            _width = calculateWidth(width);
            draw();
            onDrawed();
        }
        
        /**
         * 先调用drawGraphics，再依次调用子项的drawChildren
         */
        public function drawChildren():void
        {
            drawGraphics();
        }
        
        /**
         * 绘制样式
         */
        protected function drawGraphics():void
        {
            //empty
        }
        
        /**
         * 在尺寸被改变时调用
         */
        protected function draw():void
        {
            //
        }
        
        protected function onDrawed():void
        {
            this.dispatchEvent(new Event(Event.RESIZE));
        }
        
        /**
         * 验证设置的高度的合法性并且返回一个最接近的合法尺寸值
         * @param value 欲验证的高度
         * @return 最接近的和法值
         */
        protected function calculateHeight(value:Number):Number
        {
            return value;
        }
        
        /**
         * 验证设置的宽度的合法性并且返回一个最接近的合法尺寸值
         * @param value 欲验证的宽度
         * @return 最接近的和法值
         */
        protected function calculateWidth(value:Number):Number
        {
            return value;
        }
    }
}