package com.alibado.fuildui.util
{
    import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.errors.IllegalOperationError;
    import flash.display.Stage;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    import flash.ui.Mouse;
    import flash.ui.MouseCursor;

    
    /**
    * 切换鼠标样式的工具类
    */
    public class FdMouse
    {
        //内置鼠标样式
        public static const ARROW:String = MouseCursor.ARROW;
        public static const AUTO:String = MouseCursor.AUTO;
        public static const BUTTON:String = MouseCursor.BUTTON;
        public static const HAND:String = MouseCursor.HAND;
        public static const IBEAM:String = MouseCursor.IBEAM;
        
        //自定义鼠标样式
        public static const MOVE:String = "move";
        public static const SCALE_RB:String = "scale_rb";
        
        //单例实例
        private static var _instance:FdMouse;
        
        //source
        [Embed(source="../asset/cursors/move.png")]
        private var _moveClass:Class;
        private var _move:Bitmap = new _moveClass();
        
        [Embed(source="../asset/cursors/scale_rb.png")]
        private var _scaleRbClass:Class;
        private var _scaleRb:Bitmap = new _scaleRbClass();
        
        //当前的鼠标位图
        private var _current:Bitmap;
        
        //舞台
        private var _stage:Stage;
        
        //鼠标容器
        private var _mouseContainer:Sprite;
        
        //有效的鼠标区域
        private var _area:Rectangle;
        
        
        /**
        * 单例构造函数
        */
        public function FdMouse()
        {
            if (_instance) throw new IllegalOperationError("尝试在单例类中实例化多个实例 - FdMouse");
            else
            {
                _stage = FdStage.stage;
                _mouseContainer = new Sprite();
                new FdTopSpriteUtil(_stage).top = _mouseContainer;
                _mouseContainer.mouseChildren = false;
                _mouseContainer.mouseEnabled = false;
                
                _instance = this;
            }
        }
        
        /**
        * 获取单例
        */
        public static function get instance():FdMouse
        {
            if (_instance) return _instance;
            return new FdMouse();
        }
        
        /**
        * set coursors(val:String)静态化
        */
        public static function set coursors(val:String):void
        {
            instance.coursors = val;
        }
        
        /**
         * set validArea(area:Rectangle)静态化
         */
        public static function set validArea(area:Rectangle):void
        {
            instance.validArea = area;
        }
        
        /**
        * 设置鼠标样式，可以设置自定义样式和默认样式
        * @param val 鼠标样式代号
        */
        public function set coursors(val:String):void
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
        
        /**
        * 设置鼠标样式有效的区域，鼠标移出有效区域则恢复默认
        */
        public function set validArea(area:Rectangle):void
        {
            _instance._area = area;
        }
        
        //设置鼠标图案
        private function setMouse(target:Bitmap = null):void
        {
            if (_current != target)
            {
                if (_current)
                {
                    stopFollow();
                    _mouseContainer.removeChild(_current);
                }
                _current = target;
                if (target)
                {
                    _mouseContainer.addChild(target);
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
        
        //开始鼠标跟随
        private function startFollow():void
        {
            _stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
        }
        
        //停止鼠标跟随
        private function stopFollow():void
        {
            _stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
        }
        
        //鼠标移动响应
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