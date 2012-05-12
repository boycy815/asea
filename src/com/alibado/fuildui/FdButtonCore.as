package com.alibado.fuildui
{
    import com.alibado.fuildui.layout.FdLayoutOption;
    import com.alibado.fuildui.skin.FdSkinCore;
    import com.alibado.fuildui.skin.FdSkinStatusConstant;
    
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.ui.Mouse;
    
    public class FdButtonCore extends FdComponent
    {
        
        private var _clickCallBack:Function;
        
        private var _isOver:Boolean = false;
        
        private var _isDown:Boolean = false;
        
        public function FdButtonCore(sk:FdSkinCore=null, callBack:Function = null)
        {
            super(sk);
            this.addEventListener(MouseEvent.CLICK, onClick);
            this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
            this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
            this.buttonMode = true;
        }
        
        public function get clickCallBack():Function
        {
            return _clickCallBack;
        }
        
        public function set clickCallBack(val:Function):void
        {
            _clickCallBack = val;
        }
        
        private function onClick(e:Event):void
        {
            if (_clickCallBack != null) _clickCallBack();
        }
        
        private function onMouseDown(e:Event):void
        {
            stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
            this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            _isDown = true;
            mouseCheck();
        }
        
        private function onMouseOver(e:Event):void
        {
            this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
            this.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
            _isOver = true;
            mouseCheck();
        }
        
        private function onMouseUp(e:Event):void
        {
            stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
            this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            _isDown = false;
            mouseCheck();
        }
        
        private function onMouseOut(e:Event):void
        {
            this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
            this.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
            _isOver = false;
            mouseCheck();
        }
        
        private function mouseCheck():void
        {
            if (_isDown)
            {
                this.status = FdSkinStatusConstant.MOUSE_DOWN;
            }
            else
            {
                if (_isOver)
                {
                    this.status = FdSkinStatusConstant.MOUSE_OVER;
                }
                else
                {
                    this.status = FdSkinStatusConstant.NORMAL;
                }
            }
        }
        
        /*覆盖父类*/
        
        override public function dispose():void
        {
            super.dispose();
            this.removeEventListener(MouseEvent.CLICK, onClick);
            this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            this.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
            FdStageManager.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
        }
    }
}