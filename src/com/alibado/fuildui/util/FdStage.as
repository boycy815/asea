package com.alibado.fuildui.util
{
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.errors.IllegalOperationError;
    import flash.display.Stage;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    
    
    /**
    * 能用它来获取stage以及相关功能的工具类
    * 单例
    */
    public class FdStage extends EventDispatcher
    {
        //单例
        private static var _instance:FdStage;
        
        //stage内容
        private var _stage:Stage;
        
        /**
        * 单例构造函数
        * @param stage 传入stage
        */
        public function FdStage(stage:Stage)
        {
            super();
            if (_instance) throw new IllegalOperationError("尝试在单例类中实例化多个实例 - FdStage");
            else
            {
                _stage = stage;
                _instance = this;
            }
        }
        
        /**
         * 获取stage的引用
         */
        public function get stage():Stage
        {
            return _stage;
        }
        
        /**
        * 获取单例
        */
        public static function getInstance(stage:Stage):FdStage
        {
            if (_instance) return _instance;
            return new FdStage(stage);;
        }
        
        /**
        * get stage() 静态化
        */
        public static function get stage():Stage
        {
            return _instance.stage;
        }
    }
}