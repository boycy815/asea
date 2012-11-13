package com.alibado.collection
{
    import flash.events.Event;
    
    /**
    * List的元素发生改变时候发送的事件
    */
    public class BroadcastListEvent extends Event
    {
        //元素删除事件
        public static const ITEM_REMOVED:String = "fd_item_removed";
        
        //元素添加事件
        public static const ITEM_ADDED:String = "fd_item_added";
        
        //元素替换事件
        public static const ITEM_REPLACED:String = "fd_item_replaced";
        
        //被添加或者被删除的元素
        public var value:*;
        
        //新添加的位置或者被删除的位置
        public var index:int;
        
        /**
        * 构造函数
        */
        public function BroadcastListEvent(type:String, val:*, idx:int, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
            value = val;
            index = idx;
        }
        
        override public function clone():Event
        {
            return new BroadcastListEvent(type, value, index, bubbles, cancelable);
        }
    }
}