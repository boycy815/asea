package com.alibado.fuildui.container
{
    import alternativa.gui.container.Container;
    
    import com.alibado.consts.EW;
    import com.alibado.util.layout.AlignUtils;
    
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    /**
     * 支持对齐布局的容器
     * 对加入的每个元素通过对齐的方式对他们的位置进行设置
     */
    public class AlignContainer extends Container
    {
        //默认为居中布局
        protected const _DEFAULT_ALIGN:int = AlignUtils.CENTER_X | AlignUtils.CENTER_Y;
        
        //每个元素的布局设置
        protected var _alignOptions:Vector.<Array>;
        
        //容器尺寸
        protected var _rect:Rectangle;
        
        public function AlignContainer()
        {
            super();
            _alignOptions = new Vector.<Array>();
            
            //保存尺寸数据
            _rect = new Rectangle();
        }
        
        override public function addChild(child:DisplayObject):DisplayObject
        {
            //判空
            if (!child)
            {
                throw new ArgumentError(EW.m("child", EW.NULL_OBJECT));
                return null;
            }
            
            //重复元素从数组中删除
            var i:int = _objects.indexOf(child);
            if (i >= 0)
            {
                _alignOptions.splice(i, 1);
            }
            
            //添加到容器
            var result:DisplayObject = super.addChild(child);
            
            //设置布局属性
            _alignOptions.push([_DEFAULT_ALIGN, new Point()]);
            
            //重绘最后一个元素
            drawItem(_objects.length - 1);
            return result;
        }
        
        override public function addChildAt(child:DisplayObject, index:int):DisplayObject
        {
            //判空
            if (!child)
            {
                throw new ArgumentError(EW.m("child" + EW.NULL_OBJECT, EW.WRONG_DISPLAY_LIST));
                return null;
            }
            //下标范围判断
            if (index < 0 || index > _objects.length)
            {
                throw new RangeError(EW.m("index" + EW.INDEX_OUT_OF_RANGE));
                return null;
            }
            
            //重复元素从数组中删除
            var i:int = _objects.indexOf(child);
            if (i >= 0)
            {
                _alignOptions.splice(i, 1);
            }
            
            //添加到容器
            var result:DisplayObject = super.addChildAt(child, index);
            
            //设置布局属性
            i = _objects.indexOf(child);
            _alignOptions.splice(i, 0, [_DEFAULT_ALIGN, new Point()]);
            
            //重绘最后一个元素
            drawItem(i);
            return result;
        }
        
        override public function removeChild(child:DisplayObject):DisplayObject
        {
            var i:int = _objects.indexOf(child);
            if (!child || i < 0) return null;
            _alignOptions.splice(i, 1);
            return super.removeChild(child);
        }
        
        override public function removeChildAt(index:int):DisplayObject
        {
            if (index >= 0 && index < _objects.length)
            {
                _alignOptions.splice(index, 1);
                return super.removeChildAt(index)
            }
            else
            {
                throw new RangeError(EW.m("index", EW.INDEX_OUT_OF_RANGE));
                return null;
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
            
            //重复检车
            var i:int = _objects.indexOf(child);
            if (i >= 0)
            {
                _alignOptions.splice(i, 1);
            }
            
            //加入容器
            var result:DisplayObject = super.addChild(child);
            
            //设置布局参数
            if (offset)
            {
                _alignOptions.push([align, offset]);
            }
            else
            {
                _alignOptions.push([align, new Point()]);
            }
            
            //绘制该节点
            drawItem(_objects.length - 1);
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
            if (index < 0 || index > _objects.length)
            {
                throw new RangeError(EW.m("index", EW.INDEX_OUT_OF_RANGE));
                return null;
            }
            
            //重复判断
            var i:int = _objects.indexOf(child);
            if (i >= 0)
            {
                _alignOptions.splice(i, 1);
            }
            
            //加入容器
            var result:DisplayObject = super.addChildAt(child, index);
            i = _objects.indexOf(child);
            
            //布局属性设置
            if (offset)
            {
                _alignOptions.splice(i, 0, [align, offset]);
            }
            else
            {
                _alignOptions.splice(i, 0, [align, new Point()]);
            }
            
            //绘制
            drawItem(i);
            return result;
        }
        
        /**
         * 设置布局中元素的属性
         * @param index 元素的索引
         * @param align 对齐属性 参考AlignUtils
         */
        public function setChildAlign(index:int, align:int):void
        {
            //节点范围判断
            if (index >= 0 && index < _objects.length)
            {
                //设置布局参数
                _alignOptions[index][0] = align;
                
                //绘制该点
                drawItem(index);
            }
            else
            {
                throw new RangeError(EW.m("index", EW.INDEX_OUT_OF_RANGE));
            }
        }
        
        /**
         * 设置布局中元素的偏移量属性
         * @param index 元素的索引
         * @param offset 偏移量属性 参考AlignUtils
         */
        public function setChildOffset(index:int, offset:Point):void
        {
            //节点范围判断
            if (index >= 0 && index < _objects.length)
            {
                //节点范围判断
                _alignOptions[index][1] = offset;
                
                //绘制该点
                drawItem(index);
            }
            else
            {
                throw new RangeError(EW.m("index", EW.INDEX_OUT_OF_RANGE));
            }
        }
        
        override public function get objects():Vector.<DisplayObject>
        {
            return _objects.slice();
        }
        
        override protected function draw():void
        {
            var l:int = _objects.length;
            for (var i:int = 0; i < l; i++)
            {
                drawItem(i);
            }
            super.draw();
        }
        
        //重绘单个元素
        private function drawItem(index:int):void
        {
            //取得容器大小
            _rect.width = width;
            _rect.height = height;
            
            //计算位置
            AlignUtils.alignBox(_objects[index], _rect, _alignOptions[index][0], _alignOptions[index][1]);
        }
    }
}