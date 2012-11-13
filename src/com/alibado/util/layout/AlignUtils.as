package com.alibado.util.layout
{
    import com.alibado.consts.EW;
    
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    /**
     * 对齐算法
     */
    public class AlignUtils
    {
        private static var _emptyRect:Rectangle = new Rectangle();
        private static var _emptyPoint:Point = new Point();
        private static var _emptyDisplay:Sprite = new Sprite();
        private static var _xAlignAlgorithm:Vector.<Function> = new<Function>[boxAlignLeftOutside, boxAlignLeft, boxAlignXCenter, boxAlignRight, boxAlignRightOutside];
        private static var _yAlignAlgorithm:Vector.<Function> = new<Function>[boxAlignTopOutside, boxAlignTop, boxAlignYCenter, boxAlignBottom, boxAlignBottomOutside];
        
        /**
         * O|    | 像这样的对齐方式
         */ 
        public static const LEFT_OUTSIDE:int = 0;
        
        /**
         * |O    | 像这样的对齐方式
         */ 
        public static const LEFT:int = 1;
        
        /**
         * |  O  | 像这样的对齐方式
         */
        public static const CENTER_X:int = 2;
        
        /**
         * |    O| 像这样的对齐方式
         */ 
        public static const RIGHT:int = 3;
        
        /**
         * |    |O 像这样的对齐方式
         */
        public static const RIGHT_OUTSIDE:int = 4;
        
        
        /**
         * _O_
         * 
         *         像这样的对齐方式
         * 
         * ___
         * 
         */
        public static const TOP_OUTSIDE:int = 0 << 4;
        
        /**
         * ___
         *  O
         * 
         *         像这样的对齐方式
         * 
         * ___
         * 
         */
        public static const TOP:int = 1 << 4;
        
        /**
         * ___
         * 
         * 
         *  O      像这样的对齐方式
         * 
         * ___
         * 
         */
        public static const CENTER_Y:int = 2 << 4;
        
        /**
         * ___
         * 
         *         像这样的对齐方式
         * 
         * _O_
         * 
         */
        public static const BOTTOM:int = 3 << 4;
        
        /**
         * ___
         * 
         *         像这样的对齐方式
         * 
         * ___
         *  O
         * 
         */
        public static const BOTTOM_OUTSIDE:int = 4 << 4;
        
        /**
         * 横向对齐计算
         * @param item 要被对齐的显示对象
         * @param target 要被对齐到的显示对象 其中两个显示对象必须在同个容器
         * @param type 对齐方式 LEFT_OUTSIDE，LEFT，CENTER_X，RIGHT，RIGHT_OUTSIDE
         * @param offset 对齐之后向右的偏移量
         */
        public static function alignX(item:DisplayObject, target:DisplayObject = null, type:int = 1, offset:Number = 0):void
        {
            var itemBox:Rectangle;
            var targetBox:Rectangle;
            var p:DisplayObject;
            
            //判空
            if (!item)
            {
                throw new ArgumentError(EW.m("item", EW.NULL_OBJECT));
                return;
            }
            
            //对齐类型存在性判断
            if (type < LEFT_OUTSIDE || type > RIGHT_OUTSIDE)
            {
                throw new RangeError(EW.m("type", EW.INDEX_OUT_OF_RANGE));
                return;
            }
            
            //获取item外框
            if (item.parent)
            {
                p = item.parent;
            }
            else
            {
                p = _emptyDisplay;
            }
            itemBox = item.getBounds(p);
            
            //获取对齐到的显示对象外框，其中给定的target必须和item在同一容器中
            if (!target)
            {
                targetBox = _emptyRect;
            }
            else if (item.parent === target.parent)
            {
                targetBox = target.getBounds(p);
            }
            else
            {
                throw new ArgumentError(EW.m("item和target", EW.NOT_AT_SAME_CONTAINER));
                return;
            }
            
            //取得相应的算法进行对齐计算
            item.x = _xAlignAlgorithm[type](item.x, itemBox, targetBox, offset);
        }
        
        /**
         * 纵向对齐计算
         * @param item 要被对齐的显示对象
         * @param target 要被对齐到的显示对象 其中两个显示对象必须在同个容器
         * @param type 对齐方式 TOP_OUTSIDE，TOP，CENTER_Y，BOTTOM，BOTTOM_OUTSIDE
         * @param offset 对齐之后向下的偏移量
         */
        public static function alignY(item:DisplayObject, target:DisplayObject = null, type:int = 16, offset:Number = 0):void
        {
            var itemBox:Rectangle;
            var targetBox:Rectangle;
            var p:DisplayObject;
            
            //判空
            if (!item)
            {
                throw new ArgumentError(EW.m("item", EW.NULL_OBJECT));
                return;
            }
            
            //对齐类型存在性判断
            if (type < TOP_OUTSIDE || type > BOTTOM_OUTSIDE)
            {
                throw new RangeError(EW.m("type", EW.INDEX_OUT_OF_RANGE));
                return;
            }
            
            //获取item外框
            if (item.parent)
            {
                p = item.parent;
            }
            else
            {
                p = _emptyDisplay;
            }
            itemBox = item.getBounds(p);
            
            //获取对齐到的显示对象外框，其中给定的target必须和item在同一容器中
            if (!target)
            {
                targetBox = _emptyRect;
            }
            else if (item.parent === target.parent)
            {
                targetBox = target.getBounds(p);
            }
            else
            {
                throw new ArgumentError(EW.m("item和target", EW.NOT_AT_SAME_CONTAINER));
                return;
            }
            
            //取得相应的算法进行对齐计算
            item.y = _yAlignAlgorithm[type >> 4](item.y, itemBox, targetBox, offset);
        }
        
        /**
         * 横纵对齐计算
         * @param item 要被对齐的显示对象
         * @param target 要被对齐到的显示对象 其中两个显示对象必须在同个容器
         * @param type 对齐方式 （横向 | 纵向）
         * @param offset 对齐之后的偏移量
         */
        public static function align(item:DisplayObject, target:DisplayObject = null, type:int = 17, offset:Point = null):void
        {
            var itemBox:Rectangle;
            var targetBox:Rectangle;
            var p:DisplayObject;
            var typeX:int = type & 0x000f;
            var typeY:int = type >> 4;
            
            //判空
            if (!item)
            {
                throw new ArgumentError(EW.m("item", EW.NULL_OBJECT));
                return;
            }
            
            //对齐类型存在性判断
            if (typeX < LEFT_OUTSIDE || typeX > RIGHT_OUTSIDE)
            {
                throw new RangeError(EW.m("typeX", EW.INDEX_OUT_OF_RANGE));
                return;
            }
            if (typeY < TOP_OUTSIDE || typeY > BOTTOM_OUTSIDE)
            {
                throw new RangeError(EW.m("typeY", EW.INDEX_OUT_OF_RANGE));
                return;
            }
            
            //获取item外框
            if (item.parent)
            {
                p = item.parent;
            }
            else
            {
                p = _emptyDisplay;
            }
            itemBox = item.getBounds(p);
            
            //获取对齐到的显示对象外框，其中给定的target必须和item在同一容器中
            if (!target)
            {
                targetBox = _emptyRect;
            }
            else if (item.parent === target.parent)
            {
                targetBox = target.getBounds(p);
            }
            else
            {
                throw new ArgumentError(EW.m("item和target", EW.NOT_AT_SAME_CONTAINER));
                return;
            }
            
            if (!offset) offset = _emptyPoint;
            
            //取得相应的算法进行对齐计算
            item.x = _xAlignAlgorithm[typeX](item.x, itemBox, targetBox, offset.x);
            item.y = _yAlignAlgorithm[typeY](item.y, itemBox, targetBox, offset.y);
        }
        
        /**
         * 横向对齐计算
         * @param item 要被对齐的显示对象
         * @param target 要被对齐到的方框
         * @param type 对齐方式 LEFT_OUTSIDE，LEFT，CENTER_X，RIGHT，RIGHT_OUTSIDE
         * @param offset 对齐之后向右的偏移量
         */
        public static function alignBoxX(item:DisplayObject, target:Rectangle = null, type:int = 1, offset:Number = 0):void
        {
            var itemBox:Rectangle;
            var targetBox:Rectangle;
            var p:DisplayObject;
            
            //判空
            if (!item)
            {
                throw new ArgumentError(EW.m("item", EW.NULL_OBJECT));
                return;
            }
            
            //type类型存在性判断
            if (type < LEFT_OUTSIDE || type > RIGHT_OUTSIDE)
            {
                throw new RangeError(EW.m("type", EW.INDEX_OUT_OF_RANGE));
                return;
            }
            
            //获取item外框
            if (item.parent)
            {
                p = item.parent;
            }
            else
            {
                p = _emptyDisplay;
            }
            itemBox = item.getBounds(p);
            
            //获取对齐到的显示对象外框
            if (target)
            {
                targetBox = target;
            }
            else
            {
                targetBox = _emptyRect;
            }
            
            //取得相应的算法进行对齐计算
            item.x = _xAlignAlgorithm[type](item.x, itemBox, targetBox, offset);
        }
        
        /**
         * 纵向对齐计算
         * @param item 要被对齐的显示对象
         * @param target 要被对齐到的方框
         * @param type 对齐方式 TOP_OUTSIDE，TOP，CENTER_Y，BOTTOM，BOTTOM_OUTSIDE
         * @param offset 对齐之后向下的偏移量
         */
        public static function alignBoxY(item:DisplayObject, target:Rectangle = null, type:int = 16, offset:Number = 0):void
        {
            var itemBox:Rectangle;
            var targetBox:Rectangle;
            var p:DisplayObject;
            
            //判空
            if (!item)
            {
                throw new ArgumentError(EW.m("item", EW.NULL_OBJECT));
                return;
            }
            
            //type类型存在性判断
            if (type < TOP_OUTSIDE || type > BOTTOM_OUTSIDE)
            {
                throw new RangeError(EW.m("type", EW.INDEX_OUT_OF_RANGE));
                return;
            }
            
            //获取item外框
            if (item.parent)
            {
                p = item.parent;
            }
            else
            {
                p = _emptyDisplay;
            }
            itemBox = item.getBounds(p);
            
            //获取对齐到的显示对象外框
            if (target)
            {
                targetBox = target;
            }
            else
            {
                targetBox = _emptyRect;
            }
            
            //取得相应的算法进行对齐计算
            item.y = _yAlignAlgorithm[type >> 4](item.y, itemBox, targetBox, offset);
        }
        
        /**
         * 横纵对齐计算
         * @param item 要被对齐的显示对象
         * @param target 要被对齐到的方框
         * @param type 对齐方式 （横向 | 纵向）
         * @param offset 对齐之后的偏移量
         */
        public static function alignBox(item:DisplayObject, target:Rectangle = null, type:int = 17, offset:Point = null):void
        {
            var itemBox:Rectangle;
            var targetBox:Rectangle;
            var p:DisplayObject;
            var typeX:int = type & 0x000f;
            var typeY:int = type >> 4;
            
            //判空
            if (!item)
            {
                throw new ArgumentError(EW.m("item", EW.NULL_OBJECT));
                return;
            }
            
            //type类型存在性判断
            if (typeX < LEFT_OUTSIDE || typeX > RIGHT_OUTSIDE)
            {
                throw new RangeError(EW.m("typeX", EW.INDEX_OUT_OF_RANGE));
                return;
            }
            if (typeY < TOP_OUTSIDE || typeY > BOTTOM_OUTSIDE)
            {
                throw new RangeError(EW.m("typeY", EW.INDEX_OUT_OF_RANGE));
                return;
            }
            
            //获取item的外框
            if (item.parent)
            {
                p = item.parent;
            }
            else
            {
                p = _emptyDisplay;
            }
            itemBox = item.getBounds(p);
            
            //获取容器方框
            if (target)
            {
                targetBox = target;
            }
            else
            {
                targetBox = _emptyRect;
            }
            
            if (!offset) offset = _emptyPoint;
            
            //使用相应的算法进行计算
            item.x = _xAlignAlgorithm[typeX](item.x, itemBox, targetBox, offset.x);
            item.y = _yAlignAlgorithm[typeY](item.y, itemBox, targetBox, offset.y);
        }
        
        public static function boxAlignLeftOutside(x:Number, content:Rectangle, target:Rectangle, offset:Number = 0):Number
        {
            return - content.width + target.x + offset - content.x + x;
        }
        
        public static function boxAlignLeft(x:Number, content:Rectangle, target:Rectangle, offset:Number = 0):Number
        {
            return target.x - offset - content.x + x;
        }
        
        public static function boxAlignRightOutside(x:Number, content:Rectangle, target:Rectangle, offset:Number = 0):Number
        {
            return target.width + target.x + offset - content.x + x;
        }
        
        public static function boxAlignRight(x:Number, content:Rectangle, target:Rectangle, offset:Number = 0):Number
        {
            return target.width - content.width + target.x - offset - content.x + x;
        }
        
        public static function boxAlignXCenter(x:Number, content:Rectangle, target:Rectangle, offset:Number = 0):Number
        {
            return (target.width - content.width) / 2 + target.x + offset - content.x + x;
        }
        
        public static function boxAlignYCenter(y:Number, content:Rectangle, target:Rectangle, offset:Number = 0):Number
        {
            return (target.height - content.height) / 2 + target.y + offset - content.y + y;
        }
        
        public static function boxAlignTopOutside(y:Number, content:Rectangle, target:Rectangle, offset:Number = 0):Number
        {
            return - content.height + target.y - offset - content.y + y;
        }
        
        public static function boxAlignTop(y:Number, content:Rectangle, target:Rectangle, offset:Number = 0):Number
        {
            return target.y + offset - content.y + y;
        }
        
        public static function boxAlignBottomOutside(y:Number, content:Rectangle, target:Rectangle, offset:Number = 0):Number
        {
            return target.height + target.y + offset - content.y + y;
        }
        
        public static function boxAlignBottom(y:Number, content:Rectangle, target:Rectangle, offset:Number = 0):Number
        {
            return target.height - content.height + target.y - offset - content.y + y;
        }
    }
}