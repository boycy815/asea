package com.alibado.collection
{
    /**
    * 表数据结构的接口
    */
    public interface IList
    {
        /**
        * 获取表的长度
        * @return 表长度
        */
        function get length():uint;
        
        /**
        * 清空表的内容
        * @return 有元素被清空则返回true，否则返回false
        */
        function clear():Boolean;
        
        /**
        * 在表的末尾添加元素
        * @param item 添加的内容
        * @return 被添加到的位置
        */
        function add(item:*):int;
        
        /**
        * 在指定位置插入一个元素
        * @param item 要插入的元素
        * @param i 要插入的位置，i不能超过表的大小
        * @return 若是有数据被插入则返回true，否则返回false
        */
        function addAt(item:*, i:uint):Boolean;
        
        /**
        * 在末位置插入一个表
        * @param items 被插入的表
        * @return 若是有数据被插入则返回true，否则返回false
        */
        function addAll(items:IList):Boolean;
        
        /**
         * 在末位置插入一个数组
         * @param items 被插入的数组
         * @return 若是有数据被插入则返回true，否则返回false
         */
        function addArray(items:Array):Boolean;
        
        /**
         * 在指定位置插入一个表
         * @param items 被插入的表
         * @param i 要插入的位置，i不能超过表的大小
         * @return 若是有数据被插入则返回true，否则返回false
         */
        function addAllAt(items:IList, i:uint):Boolean;
        
        /**
         * 在指定位置插入一个数组
         * @param items 被插入的数组
         * @param i 要插入的位置，i不能超过表的大小
         * @return 若是有数据被插入则返回true，否则返回false
         */
        function addArrayAt(items:Array, i:uint):Boolean;
        
        /**
        * 测试表中是否拥有这个元素
        * @param item 给定的测试元素
        * @return 若有给定元素则返回true，否则返回false
        */
        function contains(item:*):Boolean;
        
        /**
        * 测试表中是否拥有这些元素
        * @param items 要测试的表
        * @param and 若为true则表示只有全部拥有表中元素的时候才为true，为false表示只要有一个元素符合结果就为true
        * @return 返回测试结果
        */
        function containsAll(items:IList, and:Boolean):Boolean;
        
        /**
         * 测试表中是否拥有这些元素
         * @param items 要测试的数组
         * @param and 若为true则表示只有全部拥有表中元素的时候才为true，为false表示只要有一个元素符合结果就为true
         * @return 返回测试结果
         */
        function containsArray(items:Array, and:Boolean):Boolean;
        
        /**
        * 删除给定表中没有的元素
        * @param items 给定的表
        * @return 被删除的元素个数
        */
        function retainAll(items:IList):uint;
        
        /**
         * 删除给定数组中没有的元素
         * @param items 给定的数组
         * @return 被删除的元素个数
         */
        function retainArray(items:Array):uint;
        
        /**
        * 测试两个表是否元素序列完全相同
        * @param other 测试对象
        * @return 返回测试结果
        */
        function equals(other:IList):Boolean;
        
        /**
        * 从指定位置获取元素
        * @param i 给定的表索引
        * @return 返回获取到的元素，若索引超出返回则返回空
        */
        function getAt(i:uint):*;
        
        /**
        * 覆盖指定位置的元素
        * @param i 要覆盖的位置，若i等于length则相当于在末尾添加元素
        * @param item 新的元素
        * @return 被覆盖的元素，若没有任何元素被覆盖则返回空
        */
        function setAt(item:*, i:uint):*;
            
        /**
        * 删除某个元素
        * @param item 要被删除的元素
        * @return 被删除的元素位置，如果没有被删除则返回-1
        */
        function remove(item:*):uint;
        
        /**
        * 删除给定表中所有的元素
        * @param items 给定的表
        * @return 删除元素的个数
        */
        function removeAll(items:IList):uint;
        
        /**
         * 删除给定数组中所有的元素
         * @param items 给定的数组
         * @return 删除元素的个数
         */
        function removeArray(items:Array):uint;
        
        /**
        * 删除某个位置的元素
        * @param i 给定的位置
        * @return 被删除的元素，若没有元素被删除则返回空
        */
        function removeAt(i:uint):*;
        
        /**
        * 将集合转换生成一个Array对象
        * @return 生成的Array对象
        */
        function toArray():Array;
    }
}