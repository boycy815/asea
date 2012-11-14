package com.alibado.fuildui.container
{
    import com.alibado.consts.EW;
    import com.alibado.util.layout.AlignUtils;
    
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.Dictionary;
    
    /**
     * 支持对齐布局的容器
     * 对加入的每个元素通过对齐的方式对他们的位置进行设置
     */
    public class AlignContainer extends Container
    {
        //默认为居中布局
        protected const _DEFAULT_ALIGN:int = AlignUtils.CENTER_X | AlignUtils.CENTER_Y;
        
        //每个元素的布局设置
        protected var _alignOptions:Dictionary;
        
        //容器尺寸
        protected var _rect:Rectangle;
        
        public function AlignContainer()
        {
            super();
            _alignOptions = new Dictionary();
            
            //保存尺寸数据
            _rect = new Rectangle();
        }
        
        override protected function onChildremoved(item:DisplayObject):void
        {
            if (_alignOptions[item])
            {
                _alignOptions[item] = null;
                delete _alignOptions[item];
            }
        }
        
        /**
         * 在容器中添加带有布局属性的显示对象
         * @param child 加入容器的显示对象
         * @param align 对齐属性 参考AlignUtils
         * @param offset 向右下的偏移量
         */
        public function addChildWithAlign(child:DisplayObject, align:int, offset:Point = null):DisplayObject
        {
            //判空
            if (!child)
            {
                throw new ArgumentError(EW.m("child", EW.NULL_OBJECT));
                return null;
            }
            
            //加入容器
            var result:DisplayObject = super.addChild(child);
            
            //设置布局参数
            if (offset)
            {
                _alignOptions[child] = [align, offset];
            }
            else
            {
                _alignOptions[child] = [align, new Point()];
            }
            
            //绘制该节点
            drawItem(child);
            return result;
        }
        
        /**
         * 在容器中添加带有布局属性的显示对象
         * @param child 加入容器的显示对象
         * @param index 加入的位置
         * @param align 对齐属性 参考AlignUtils
         * @param offset 向右下的偏移量
         */
        public function addChildWithAlignAt(child:DisplayObject, index:int, align:int, offset:Point = null):DisplayObject
        {
            //判空
            if (!child)
            {
                throw new ArgumentError(EW.m("child", EW.NULL_OBJECT));
                return null;
            }
            //节点范围判断
            if (index < 0 || index > numChildren)
            {
                throw new RangeError(EW.m("index", EW.INDEX_OUT_OF_RANGE));
                return null;
            }
            
            //加入容器
            var result:DisplayObject = super.addChildAt(child, index);
            
            //布局属性设置
            if (offset)
            {
                _alignOptions[child] = [align, offset];
            }
            else
            {
                _alignOptions[child] = [align, new Point()];
            }
            
            //绘制
            drawItem(child);
            return result;
        }
        
        /**
         * 设置布局中元素的属性
         * @param index 元素的索引
         * @param align 对齐属性 参考AlignUtils
         */
        public function setChildAlign(item:DisplayObject, align:int):void
        {
            //节点范围判断
            if (item.parent == this)
            {
                //设置布局参数
                if (!_alignOptions[item])
                {
                    _alignOptions[item] = [align, new Point()];
                }
                else
                {
                    _alignOptions[item][0] = align;
                }
                
                //绘制该点
                drawItem(item);
            }
            else
            {
                throw new RangeError(EW.m("item", EW.WRONG_DISPLAY_LIST));
            }
        }
        
        /**
         * 设置布局中元素的偏移量属性
         * @param index 元素的索引
         * @param offset 偏移量属性 参考AlignUtils
         */
        public function setChildOffset(item:DisplayObject, offset:Point):void
        {
            //节点范围判断
            if (item.parent == this)
            {
                //设置布局参数
                if (!_alignOptions[item])
                {
                    _alignOptions[item] = [_DEFAULT_ALIGN, offset];
                }
                else
                {
                    _alignOptions[item][1] = offset;
                }
                
                //绘制该点
                drawItem(item);
            }
            else
            {
                throw new RangeError(EW.m("item", EW.WRONG_DISPLAY_LIST));
            }
        }
        
        override protected function draw():void
        {
            //取得容器大小
            _rect.width = width;
            _rect.height = height;
            
            for (var i:* in _alignOptions)
            {
                drawItem(i);
            }
            super.draw();
        }
        
        //重绘单个元素
        private function drawItem(item:DisplayObject):void
        {
            //计算位置
            AlignUtils.alignBox(item, _rect, _alignOptions[item][0], _alignOptions[item][1]);
        }
    }
}