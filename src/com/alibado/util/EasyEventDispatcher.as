package com.alibado.util
{
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    import flash.utils.Dictionary;
    
    public class EasyEventDispatcher implements IEventDispatcher
    {
        private var _defaultEvent:String = Event.COMPLETE;
        
        private var _history:Array = [];
        
        private var _target:IEventDispatcher;
        
        public function EasyEventDispatcher(target:IEventDispatcher = null)
        {
            if (target)
            {
                _target = target;
            }
            else
            {
                _target = new EventDispatcher(this);
            }
        }
        
        public function set defaultEvent(de:String):void
        {
            _defaultEvent = de;
        }
        
        public function get defaultEvent():String
        {
            return _defaultEvent;
        }
        
        public function simpleSignal(callback:Function, type:String = null):void
        {
            if (!type) type = _defaultEvent;
            addEventListener(type, callbackWrap);
            
            function callbackWrap(e:Event):void
            {
                callback();
            }
        }
        
        public function once(listener:Function, type:String = null, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
        {
            if (!type) type = _defaultEvent;
            addEventListener(type, callbackWrap, useCapture, priority, useWeakReference);
            
            function callbackWrap(e:Event):void
            {
                removeEventListener(e.type, callbackWrap, useCapture);
                listener(e);
            }
        }
        
        
        //implements
        
        public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
        {
            if (!_history[type]) _history[type] = new Dictionary();
            if (!_history[type][listener]) _history[type][listener] = [];
            if (useCapture)
            {
                _history[type][listener][1] = true;
            }
            else
            {
                _history[type][listener][0] = true;
            }
            _target.addEventListener(type, listener, useCapture, priority, useWeakReference);
        }
        
        public function dispatchEvent(event:Event):Boolean
        {
            return _target.dispatchEvent(event);
        }
        
        public function hasEventListener(type:String):Boolean
        {
            return _target.hasEventListener(type);
        }
        
        public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
        {
            if (_history[type])
            {
                if (_history[type][listener])
                {
                    var a:Dictionary = new Dictionary();
                }
            }
        }
        
        public function willTrigger(type:String):Boolean
        {
            return _target.willTrigger(type);
        }
    }
}