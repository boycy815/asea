package com.alibado.fuildui.base
{
    import flash.display.Sprite;
    import flash.events.Event;
    
    /**
     * UI基类
     */
    public class BaseUI extends Sprite
    {
        protected var _freezeHeight:Boolean = false;
        protected var _freezeWidth:Boolean = false;
        
        protected var _height:Number = 0;
        protected var _width:Number = 0;
        
        public function BaseUI()
        {
            super();
        }
        
        /**
         * 设置UI的宽度，在_freezeHeight为true时触发重绘并受calculateHeight限制
         * 在_freezeHeight为false时直接对_height生效
         * @param value 欲设置的高度
         */
        override public function set height(value:Number):void
        {
            if (_freezeHeight)
            {
                _height = value;
            }
            else
            {
                _height = calculateHeight(value);
                onDrawing();
                draw();
                onDrawed();
            }
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
            if (_freezeWidth)
            {
                _width = value;
            }
            else
            {
                _width = calculateWidth(value);
                onDrawing();
                draw();
                onDrawed();
            }
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
            var isResize:Boolean = false;
            if (_freezeHeight)
            {
                _height = height;
            }
            else
            {
                _height = calculateHeight(height);
                isResize = true;
            }
            if (_freezeWidth)
            {
                _width = width;
            }
            else
            {
                _width = calculateWidth(width);
                isResize = true;
            }
            if (isResize)
            {
                onDrawing();
                draw();
                onDrawed();
            }
        }
        
        /**
         * 设置是否在改变尺寸时不进行重绘
         */
        public function set freezeHeight(value:Boolean):void
        {
            _freezeHeight = value;
        }
        
        /**
         * 设置是否在改变尺寸时不进行重绘
         */
        public function get freezeHeight():Boolean
        {
            return _freezeHeight;
        }
        
        /**
         * 设置是否在改变尺寸时不进行重绘
         */
        public function set freezeWidth(value:Boolean):void
        {
            _freezeWidth = value;
        }
        
        /**
         * 设置是否在改变尺寸时不进行重绘
         */
        public function get freezeWidth():Boolean
        {
            return _freezeWidth;
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
        
        protected function onDrawing():void
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