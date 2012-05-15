package com.alibado.fuildui.util
{
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    import flash.utils.Dictionary;

    /**
    * 一个让显示对象里面的某个元素始终保持在其容器最顶端的工具类
    */
    public class FdTopSpriteUtil
    {
        //记录容器的绑定历史
        private static var _history:Dictionary;
        
        //当前容器
        private var _container:DisplayObjectContainer;
        
        /**
        * 构造函数
        * @param container 要操作的容器
        */
        public function FdTopSpriteUtil(container:DisplayObjectContainer)
        {
            _container = container;
        }
        
        /**
        * 设置某个显示对象保持在其最顶端，如果已经有显示显示对象在其最顶端则取消原来的现实对象在最顶端
        * @param 保持在其最顶端的显示对象
        */
        public function set top(obj:DisplayObject):void
        {
            removeOldCallback(_container);
            _container.addChild(obj);
            var callback:Function = function(e:Event):void
            {
                if (_container.getChildIndex(obj) != _container.numChildren - 1)
                {
                    _container.addChild(obj);
                }
            };
            _container.addEventListener(Event.ADDED, callback);
            _history[_container] = [obj, callback];
        }
        
        /**
        * 获取当前正在最顶端的显示对象
        * @return 当前正在最顶端的显示对象，若没有最顶端元素则返回null
        */
        public function get top():DisplayObject
        {
            if (_history[_container] == null) return null;
            return _history[_container][0];
        }
        
        /**
        * 取消当前容器其最顶端的显示对象始终保持最顶端
        */
        public function cancelTop():void
        {
            removeOldCallback(_container);
        }
        
        private function removeOldCallback(container:DisplayObjectContainer):void
        {
            if (!_history) _history = new Dictionary();
            var callback:Function = _history[container] ? _history[container][1] : null;
            if (callback == null) return;
            container.removeEventListener(Event.ADDED, callback);
            delete _history[container];
        }
    }
}