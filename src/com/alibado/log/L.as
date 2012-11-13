package com.alibado.log
{
    public class L
    {
        private static var _log:ILog;
        
        /**
         * 初始化log实现
         * @param 一个log的实现 
         */ 
        public static function init(log:ILog):void
        {
            _log = log;
        }
        
        /**
         * 调试
         */
        public static function d(...message):void
        {
            if (_log) _log.debug.apply(null, message);
        }
        
        /**
         * 警告
         */ 
        public static function w(...message):void
        {
            if (_log) _log.warn.apply(null, message);
        }
        
        /**
         * 信息
         */ 
        public static function i(...message):void
        {
            if (_log) _log.info.apply(null, message);
        }
        
        /**
         * 错误
         */ 
        public static function e(...message):void
        {
            if (_log) _log.error.apply(null, message);
        }
        
        /**
         * 严重错误
         */
        public static function f(...message):void
        {
            if (_log) _log.fatal.apply(null, message);
        }
    }
}