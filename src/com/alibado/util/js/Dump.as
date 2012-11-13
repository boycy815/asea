package com.alibado.util.js
{
    import flash.display.DisplayObject;
    import flash.external.ExternalInterface;
    import flash.utils.Dictionary;
    import flash.utils.setTimeout;

    /**
     * @param alias 方法名
     * @param args 传递的参数
     * @param fun 方法
     * @param callback function(result:Object):void{}
     */
    public class Dump
    {
        
        private var _dumpName:String;
        private var _funMap:Dictionary = new Dictionary();
        private var _taskMap:Dictionary = new Dictionary();
        private var _callbacks:Dictionary = new Dictionary();
        private var _available:Boolean = false;
        private var _initing:Boolean = false;
        
        private static var _instance:Dump;
        
        public static function get instance():Dump
        {
            if (!_instance)
            {
                _instance = new Dump();
            }
            return _instance;
        }
        
        public function Dump()
        {
            //
        }
        
        /**
         * flash初始化后调用此方法通知js，此方法尽量在整个程序的最开始执行
         * @param main 主显示对象
         * @param onReady js初始化完毕的回调，function(sta:Boolean):void，最好是程序入口
         */ 
        public static function notifyReady(main:DisplayObject, onReady:Function):void
        {
            instance.notifyReady(main, onReady);
        }
        
        /**
         * flash初始化后调用此方法通知js，此方法尽量在整个程序的最开始执行
         * @param main 主显示对象
         * @param onReady js初始化完毕的回调，function(sta:Boolean):void，最好是程序入口
         */ 
        public function notifyReady(main:DisplayObject, onReady:Function):void
        {
            //防止重复初始化
            if (!_initing)
            {
                //伪安全沙箱bug，通过延迟500解决
                setTimeout(function():void
                {
                    init(main, onReady);
                }, 500);
                _initing = true;
            }
        }
        
        private function init(main:DisplayObject, onReady:Function):void
        {
            if (ExternalInterface.available && main && main.stage)
            {
                if (main.stage.loaderInfo.parameters.dump)
                {
                    //js调用as的接口
                    //@param alias 注册的as函数别名
                    //@param args 传递给函数的参数 不支持复合对象
                    ExternalInterface.addCallback("_triggle", function(alias:String, args:Array = null):void
                    {
                        var result:Object;
                        
                        //查询是否注册了js所调用的方法，如果有则立即执行并且返回值
                        if (_funMap[alias])
                        {
                            result = _funMap[alias].apply(null, args);
                            ExternalInterface.call(_dumpName + "._return", alias, result);
                        }
                        //如果没有找到对应的方法，则暂时先缓存调用的方法名以及参数
                        else
                        {
                            if (!_taskMap[alias]) _taskMap[alias] = [];
                            
                            //先请求的方法先压入队列，当方法注册时先从队列出来被执行，和js方的回调存放顺序是相同的
                            _taskMap[alias].push([args, alias]);
                        }
                    });
                    
                    //js触发as的完成回调，这个回调是as调用js的时候注册的
                    //@param alias as调用js时的函数名
                    //@param result 传递给函数的参数 不支持复合对象
                    ExternalInterface.addCallback("_return", function(alias:String, result:Object):void
                    {
                        if (_callbacks[alias])
                        {
                            //取出原先存入的回调，通过队列的方式进行管理
                            var callback:Function = _callbacks[alias].shift();
                            if (callback != null)
                            {
                                callback(result);
                            }
                        }
                    });
                    
                    //js对象名
                    _dumpName = main.stage.loaderInfo.parameters.dump;
                    
                    //内部初始化完成标记位
                    _available = true;
                    
                    //通知js初始化完成
                    ExternalInterface.call(_dumpName + "._init");
                    
                    onReady(true);
                    return;
                }
            }
            onReady(false);
        }
        
        
        /**
         * 验证是否可以使用js
         */
        public static function get available():Boolean
        {
            return instance.available;
        }
        
        /**
         * 验证是否可以使用js
         */
        public function get available():Boolean
        {
            return ExternalInterface.available && _available;
        }
        
        /**
         * as调用js的方法
         * @param alias 调用的js方法名
         * @param args js方法的参数，不支持复合类型
         * @param callback 调用完成后的回调 function(result:*):void
         */
        public static function invoke(alias:String, args:Array = null, callback:Function = null):void
        {
            instance.invoke(alias, args, callback);
        }
        
        /**
         * as调用js的方法
         * @param alias 调用的js方法名
         * @param args js方法的参数，不支持复合类型
         * @param callback 调用完成后的回调 function(result:*):void
         */
        public function invoke(alias:String, args:Array = null, callback:Function = null):void
        {
            if (!available) return;
            var result:Object;
            if (callback == null) callback = function(d:Object):void{};
            if (!_callbacks[alias]) _callbacks[alias] = [];
            
            //将回调存入本地队列，在_return被触发时取出回调执行。这有别于直接把方法传过去
            _callbacks[alias].push(callback);
            
            //触发js对应的函数
            ExternalInterface.call(_dumpName + "._triggle", alias, args);
        }
        
        /**
         * 在as中注册供js调用的方法
         * @param alias 方法别名
         * @param fun 实际调用的方法
         */
        public static function register(alias:String, fun:Function):void
        {
            instance.register(alias, fun);
        }
        
        /**
         * 在as中注册供js调用的方法
         * @param alias 方法别名
         * @param fun 实际调用的方法
         */
        public function register(alias:String, fun:Function):void
        {
            if (!available) return;
            _funMap[alias] = fun;
            
            //将缓存在那等待执行的任务按照队列的顺序执行掉
            if (_taskMap[alias])
            {
                var tasks:Array = _taskMap[alias];
                var task:Array;
                var result:Object;
                _taskMap[alias] = null;
                while(task = tasks.shift())
                {
                    result = fun.apply(null, task[0]);
                    ExternalInterface.call(_dumpName + "._return", task[1], result);
                }
            }
        }
    }
}