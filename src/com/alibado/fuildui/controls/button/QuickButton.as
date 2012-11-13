package com.alibado.fuildui.controls.button
{
    import alternativa.gui.base.ActiveObject;
    
    /**
     * 拥有四种状态的按钮
     * 通过在重绘时判断其状态来实现不同的效果
     */
    public class QuickButton extends ActiveObject
    {
        public static const STATE_UP:int = 0;
        public static const STATE_OVER:int = 1;
        public static const STATE_DOWN:int = 2;
        public static const STATE_OFF:int = 3;
        
        protected var _currentState:int = 0;
        
        public function QuickButton()
        {
            super();
        }
        
        override public function set locked(value:Boolean):void
        {
            super.locked = value;
            updateState();
            drawGraphics();
        }
        
        override public function set over(value:Boolean):void
        {
            super.over = value;
            updateState();
            drawGraphics();
        }
        
        override public function set pressed(value:Boolean):void
        {
            super.pressed = value;
            updateState();
            drawGraphics();
        }
        
        private function updateState():void
        {
            if (_locked)
            {
                _currentState = STATE_OFF;
            }
            else if (_pressed)
            {
                _currentState = STATE_DOWN;
            }
            else if (_over)
            {
                _currentState = STATE_OVER;
            }
            else
            {
                _currentState = STATE_UP;
            }
        }
    }
}