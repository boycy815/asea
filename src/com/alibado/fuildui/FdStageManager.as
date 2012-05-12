package com.alibado.fuildui
{
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    
    
    /**
    * 这个类有点烂 不打算把它放体系里
    */
    public class FdStageManager extends EventDispatcher
    {
        
        private static var _instance:FdStageManager;
        
        private var _stage:Stage;
        
        private var _top:Sprite;
        
        public function FdStageManager(stage:Stage)
        {
            super();
            if (_instance) throw new Error("Single Instace Error - FdManager");
            else
            {
                _stage = stage;
                
                _stage.scaleMode = StageScaleMode.NO_SCALE;
                
                _top = new Sprite();
                _top.mouseEnabled = false;
                _stage.addChild(_top);
                _stage.addEventListener(Event.ADDED, onStageAdded);
                
                _instance = this;
            }
        }
        
        public static function set lock(val:Boolean):void
        {
            _instance._stage.mouseChildren = !val;
        }
        
        public static function init(stage:Stage):void
        {
            if (!_instance) new FdStageManager(stage);
        }
        
        
        public static function get top():Sprite
        {
            return _instance._top;
        }
        
        public static function get stage():Stage
        {
            return _instance._stage;
        }
        
        private function onStageAdded(e:Event):void
        {
            if (_stage.getChildIndex(_top) != _stage.numChildren - 1)
                _stage.setChildIndex(_top, _stage.numChildren - 1);
        }
    }
}