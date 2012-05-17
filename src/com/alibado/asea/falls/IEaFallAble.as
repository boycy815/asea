package com.alibado.asea.falls
{
    /**
    * 
    */
    public interface IEaFallAble
    {
        function _fallRun(falls:EaFalls, args:Array):void;
        
        function _fallAbort():void;
    }
}