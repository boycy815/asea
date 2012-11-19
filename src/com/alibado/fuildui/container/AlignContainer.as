package com.alibado.fuildui.container
{
    import com.alibado.consts.EW;
    import com.alibado.fuildui.base.BaseUI;
    import com.alibado.fuildui.consts.StyleNames;
    import com.alibado.fuildui.events.StyleEvent;
    import com.alibado.util.layout.AlignUtils;
    
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.Dictionary;
    
    /**
     * 支持对齐布局的容器
     * 支持的style:
     * StyleNames.ALIGN AlignUtils.xxx
     * StyleNames.OFFSET Point
     * 对加入的每个元素通过对齐的方式对他们的位置进行设置
     */
    public class AlignContainer extends Container
    {
        //默认为居中布局
        protected const _DEFAULT_ALIGN:int = AlignUtils.CENTER_X | AlignUtils.CENTER_Y;
        
        //容器尺寸
        protected var _rect:Rectangle;
        
        public function AlignContainer(na:String = null, style:Object = null)
        {
            super(na, style);
            
            //保存尺寸数据
            _rect = new Rectangle();
        }
        
        override protected function onChildAdded(item:DisplayObject):void
        {
            drawItem(item);
            item.addEventListener(StyleEvent.STYLE_CHANGE, onItemStyleChange);
        }
        
        override protected function draw():void
        {
            //取得容器大小
            _rect.width = width;
            _rect.height = height;
            
            var l:int = numChildren;
            
            for (var i:int = 0; i < l; i++)
            {
                drawItem(getChildAt(i));
            }
            
            super.draw();
        }
        
        private function onItemStyleChange(e:StyleEvent):void
        {
            drawItem(e.target as DisplayObject);
        }
        
        //重绘单个元素
        private function drawItem(item:DisplayObject):void
        {
            var algin:int;
            var offset:Point;
            //计算位置
            if (item is BaseUI)
            {
                var ib:BaseUI = item as BaseUI;
                algin = ib.getStyle(StyleNames.ALIGN) != null ? ib.getStyle(StyleNames.ALIGN) : _DEFAULT_ALIGN;
                offset = ib.getStyle(StyleNames.OFFSET) || new Point();
            }
            else
            {
                algin = _DEFAULT_ALIGN;
                offset = new Point();
            }
            AlignUtils.alignBox(item, _rect, algin, offset);
        }
    }
}