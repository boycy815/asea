package com.alibado.fuildui
{
    import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    import flash.ui.Mouse;
    import flash.ui.MouseCursor;

    public class FdMouse
    {
        public static const ARROW:String = MouseCursor.ARROW;
        public static const AUTO:String = MouseCursor.AUTO;
        public static const BUTTON:String = MouseCursor.BUTTON;
        public static const HAND:String = MouseCursor.HAND;
        public static const IBEAM:String = MouseCursor.IBEAM;
        public static const MOVE:String = "move";
        public static const SCALE_RB:String = "scale_rb";
        
        private static var _instance:FdMouse;
        
        //source
        [Embed(source="asset/cursors/move.png")]
        private var _moveClass:Class;
        private var _move:Bitmap = new _moveClass();
        
        [Embed(source="asset/cursors/scale_rb.png")]
        private var _scaleRbClass:Class;
        private var _scaleRb:Bitmap = new _scaleRbClass();
        
        private var _current:Bitmap;
        
        private var _stage:Stage;
        
        private var _top:Sprite;
        
        private var _area:Rectangle;
        
        
        public function FdMouse()
        {
            if (_instance) throw new Error("Single Instace Error - FdMouse");
            else
            {
                _stage = FdStageManager.stage;
                _top = FdStageManager.top;
                
                _instance = this;
            }
        }
        
        public static function init():void
        {
            if (!_instance) new FdMouse();
        }
        
        public static function set coursors(val:String):void
        {
            switch (val)
            {
                case MOVE:
                    _instance.setMouse(_instance._move);
                    break;
                case SCALE_RB:
                    _instance.setMouse(_instance._scaleRb);
                    break;
                case ARROW:
                    _instance.setMouse();
                    Mouse.cursor = MouseCursor.ARROW;
                    break;
                case AUTO:
                    _instance.setMouse();
                    Mouse.cursor = MouseCursor.AUTO;
                    break;
                case BUTTON:
                    _instance.setMouse();
                    Mouse.cursor = MouseCursor.BUTTON;
                    break;
                case HAND:
                    _instance.setMouse();
                    Mouse.cursor = MouseCursor.HAND;
                    break;
                case IBEAM:
                    _instance.setMouse();
                    Mouse.cursor = MouseCursor.IBEAM;
                    break;
                default:
                    break;
            }
        }
        
        public static function set validArea(area:Rectangle):void
        {
            _instance._area = area;
        }
        
        private function setMouse(target:Bitmap = null):void
        {
            if (_current != target)
            {
                if (_current)
                {
                    stopFollow();
                    _top.removeChild(_current);
                }
                _current = target;
                if (target)
                {
                    _top.addChild(target);
                    target.x = _stage.mouseX - target.width / 2;
                    target.y = _stage.mouseY - target.height / 2;
                    startFollow();
                    Mouse.hide();
                }
                else
                {
                    Mouse.show();
                }
            }
        }
        
        private function startFollow():void
        {
            _stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
        }
        
        private function stopFollow():void
        {
            _stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
        }
        
        private function onMove(e:MouseEvent):void
        {
            _current.x = e.stageX - _current.width / 2;
            _current.y = e.stageY - _current.height / 2;
            if (_area)
            {
                if (_area.contains(_current.x, _current.y))
                {
                    _current.visible = true;
                }
                else
                {
                    _current.visible = false;
                }
            }
            else
            {
                _current.visible = true;
            }
        }
    }
}