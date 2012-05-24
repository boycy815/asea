package com.alibado.falls
{
    public interface IFallBuilder
    {
        function start(args:Object, callback:Function, cover:String = null):IFall;
    }
}