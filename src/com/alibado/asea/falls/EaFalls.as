package com.alibado.asea.falls
{
    public class EaFalls
    {
        private var _handles:Vector.<IEaFallAble> = new Vector.<IEaFallAble>();
        
        private var _argsArray:Vector.<Array> = new Vector.<Array>();
        
        private var _currentDoing:int = -1;
        
        public function addFall(fall:IEaFallAble, ...args):void
        {
            _handles.push(fall);
            _argsArray.push(args);
        }
        
        public function clearAll():void
        {
            if (_currentDoing > 0)
            {
                _handles[_currentDoing].fallAbort();
                _currentDoing = -1;
            }
            _handles.length = 0;
        }
    }
}