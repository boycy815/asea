package com.alibado.log
{
    /**
     * Log接口
     */
    public interface ILog
    {
        //调试
        function debug(...message):void;
        
        //警告
        function warn(...message):void;
        
        //信息
        function info(...message):void;
        
        //错误
        function error(...message):void;
        
        //严重错误
        function fatal(...message):void;
    }
}