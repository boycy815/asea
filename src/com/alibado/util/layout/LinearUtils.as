package com.alibado.util.layout
{
    import com.alibado.consts.EW;
    
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    /**
     * 线性布局算法
     */
    public class LinearUtils
    {
        private static var _emptyDisplay:Sprite = new Sprite();
        
        /**
         * 自左向右的布局
         * @param items 要排列的对象数组
         * @param x 第一个元素的x位置
         * @param parent 所有要排列对象的父元素
         * @param space 元素的间隔
         * @return 布局的宽度
         */
        public static function horizontalLayout(items:Vector.<DisplayObject>, x:Number, parent:DisplayObjectContainer = null, space:Number = 0):Number
        {
            if (!items)
            {
                throw new ArgumentError(EW.m("items", EW.NULL_OBJECT));
                return;
            }
            if (items.length == 0)
            {
                return 0;
            }
            parent = parent || _emptyDisplay;
            var baseline:Number = x;
            var l:int = items.length;
            var tempBox:Rectangle;
            for (var i:int = 0; i < l; i++)
            {
                if (items[i])
                {
                    tempBox = items[i].getBounds(parent);
                    items[i].x += baseline - tempBox.x;
                    baseline += tempBox.width + space;
                }
            }
            return baseline - x - space;
        }
        
        /**
         * 自右向左的布局
         * @param items 要排列的对象数组
         * @param x 第一个元素的x位置
         * @param parent 所有要排列对象的父元素
         * @param space 元素的间隔
         * @return 布局的宽度
         */
        public static function horizontalLayoutUn(items:Vector.<DisplayObject>, x:Number, parent:DisplayObjectContainer = null, space:Number = 0):Number
        {
            if (!items)
            {
                throw new ArgumentError(EW.m("items", EW.NULL_OBJECT));
                return;
            }
            if (items.length == 0)
            {
                return 0;
            }
            parent = parent || _emptyDisplay;
            var baseline:Number = x;
            var l:int = items.length;
            var tempBox:Rectangle;
            for (var i:int = 0; i < l; i++)
            {
                if (items[i])
                {
                    tempBox = items[i].getBounds(parent);
                    items[i].x += baseline - tempBox.x - tempBox.width;
                    baseline -= tempBox.width + space;
                }
            }
            return x - baseline - space;
        }
        
        /**
         * 自上向下的布局
         * @param items 要排列的对象数组
         * @param y 第一个元素的y位置
         * @param parent 所有要排列对象的父元素
         * @param space 元素的间隔
         * @return 布局的高度
         */
        public static function verticalLayout(items:Vector.<DisplayObject>, y:Number, parent:DisplayObjectContainer = null, space:Number = 0):Number
        {
            if (!items)
            {
                throw new ArgumentError(EW.m("items", EW.NULL_OBJECT));
                return;
            }
            if (items.length == 0)
            {
                return 0;
            }
            parent = parent || _emptyDisplay;
            var baseline:Number = y;
            var l:int = items.length;
            var tempBox:Rectangle;
            for (var i:int = 0; i < l; i++)
            {
                if (items[i])
                {
                    tempBox = items[i].getBounds(parent);
                    items[i].y += baseline - tempBox.y;
                    baseline += tempBox.height + space;
                }
            }
            return baseline - y - space;
        }
        
        /**
         * 自下向上的布局
         * @param items 要排列的对象数组
         * @param y 第一个元素的y位置
         * @param parent 所有要排列对象的父元素
         * @param space 元素的间隔
         * @return 布局的高度
         */
        public static function verticalLayoutUn(items:Vector.<DisplayObject>, y:Number, parent:DisplayObjectContainer = null, space:Number = 0):Number
        {
            if (!items)
            {
                throw new ArgumentError(EW.m("items", EW.NULL_OBJECT));
                return;
            }
            if (items.length == 0)
            {
                return 0;
            }
            parent = parent || _emptyDisplay;
            var baseline:Number = y;
            var l:int = items.length;
            var tempBox:Rectangle;
            for (var i:int = 0; i < l; i++)
            {
                if (items[i])
                {
                    tempBox = items[i].getBounds(parent);
                    items[i].y += baseline - tempBox.y - tempBox.height;
                    baseline -= tempBox.height + space;
                }
            }
            return y - baseline - space;
        }
    }
}