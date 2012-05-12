package com.alibado.asea.falls
{
    public interface IEaFallAble
    {
        function fallRun(falls:EaFalls, ...args):void;
        
        function fallAbort():void;
    }
}