package com.alibado.util
{
    /**
    * 作为SimpleCollectionList的元素改变通知对象
    */
    public interface IUseCollectionList
    {
        /**
        * 元素增加时的回调
        * @param item 增加的元素
        * @param i 新增元素的位置
        */
        function onAdd(item:*, i:uint):void;
        
        /**
        * 元素被删除是的回调
        * @param item 被删除的元素
        * @param oi 元素被删除前的位置
        */
        function onRemove(item:*, oi:uint):void;
        
        /**
        * 元素被覆盖后的回调
        * @param oldItem 被覆盖的元素
        * @param 覆盖的位置
        */
        function onReplace(oldItem:*, i:uint):void;
    }
}