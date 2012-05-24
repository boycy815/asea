package com.alibado.falls
{
    /**
    * 
    */
    public interface OIEaFallAble
    {
        function _fallRun(falls:OEaFalls, args:Array):void;
        
        function _fallAbort():void;
    }
}