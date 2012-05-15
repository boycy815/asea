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
        function _onAdd(item:*, i:uint):void;
        
        /**
        * 元素被删除是的回调
        * @param item 被删除的元素
        * @param oi 元素被删除前的位置
        */
        function _onRemove(item:*, oi:uint):void;
        
        /**
        * 元素被覆盖后的回调
        * @param oldItem 被覆盖的元素
        * @param 覆盖的位置
        */
        function _onReplace(oldItem:*, i:uint):void;
        
        /**
        * 元素被添加前进行类型验证，验证通过才允许被添加到表中
        * @param 要被添加的元素
        * @return 如果验证通过则返回true，否则返回false
        */
        function _typeValidate(item:*):Boolean;
    }
}