package com.alibado.fuildui.controls.buttons
{
    import alternativa.gui.mouse.CursorManager;
    
    import com.alibado.fuildui.container.AlignContainer;
    import com.alibado.fuildui.container.Container;
    import com.alibado.util.layout.AlignUtils;
    
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;

    /**
     * 带有一个icon和一个background的按钮
     */
    public class IconButton extends QuickButton
    {
        protected var _background:DisplayObject = null;
        protected var _container:Container = null;
        protected var _icon:DisplayObject = null;
        
        public function IconButton(icon:DisplayObject, bg:DisplayObject)
        {
            super();
            
            //没有背景可以建立一个空背景
            if (bg)
            {
                _background = bg;
            }
            else
            {
                _background = createEmptyBg();
            }
            
            //如果是容器则关闭其事件以提高效率
            if (_background is DisplayObjectContainer)
            {
                DisplayObjectContainer(_background).mouseEnabled = false;
                DisplayObjectContainer(_background).mouseChildren = false;
            }
            _icon = icon;
            if (_icon is DisplayObjectContainer)
            {
                DisplayObjectContainer(_icon).mouseEnabled = false;
                DisplayObjectContainer(_icon).mouseChildren = false;
            }
            
            //使用对齐容器
            _container = new AlignContainer();
            addChild(_background);
            addChild(_container);
            
            //按钮的初始大小取决于背景
            resize(_background.width, _background.height);
            
            //在后面添加是因为防止过度重绘
            if (_icon)
            {
                _container.addChild(_icon);
            }
            
            //鼠标样式
            cursorType = CursorManager.BUTTON;
        }
        
        //这里实现具体样式切换
        override public function drawGraphics():void
        {
            //获取最新的样式
            var bg:DisplayObject = darwBackground(_background);
            var icon:DisplayObject = darwIcon(_icon);
            
            //背景更新
            if (bg != _background)
            {
                //删除原来的背景
                if (_background) removeChild(_background);
                //添加新背景
                if (bg) addChildAt(bg, 0);
                _background = bg;
                if (_background)
                {
                    //重设背景大小
                    _background.width = width;
                    _background.height = height;
                    
                    //对齐到左上角
                    AlignUtils.align(_background);
                }
            }
            
            //icon更新
            if (icon != _icon)
            {
                //删除原icon
                if (_icon) _container.removeChild(_icon);
                //添加新icon
                if (icon) _container.addChild(icon);
                _icon = icon;
            }
            super.drawGraphics();
        }
        
        override protected function draw():void
        {
            super.draw();
            
            //改变背景和容器的大小
            if (_background)
            {
                _background.width = width;
                _background.height = height;
                
                AlignUtils.align(_background);
            }
            _container.resize(width, height);
        }
        
        /**
         * 获取当前状态的背景显示对象
         * @param bg 当前的背景
         * @return 新的显示对象
         */
        protected function darwBackground(bg:DisplayObject):DisplayObject
        {
            return bg;
        }
        
        /**
         * 获取当前状态的icon显示对象
         * @param bg 当前的背景
         * @return 新的显示对象
         */
        protected function darwIcon(icon:DisplayObject):DisplayObject
        {
            return icon;
        }
        
        private function createEmptyBg():DisplayObject
        {
            var sp:Sprite = new Sprite();
            sp.graphics.beginFill(0x000000, 0);
            sp.graphics.drawRect(0, 0, 100, 100);
            sp.graphics.endFill();
            return sp;
        }
    }
}