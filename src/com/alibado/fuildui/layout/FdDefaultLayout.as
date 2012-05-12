package com.alibado.fuildui.layout
{
    import com.alibado.util.ICollectionList;
    import com.alibado.fuildui.FdContainer;
    
    public class FdDefaultLayout implements IFdLayoutManager
    {
        public function doLayout(target:FdContainer):void
        {
            var collection:ICollectionList = target.collection;
            var length:int = collection.length;
            var parent:FdLayoutOption = target.layoutOption;
            for (var i:int = 0; i < length; i++)
            {
                var temp:FdLayoutOption = collection.getAt(i).layoutOption;
                var hasLeft:Boolean = temp.getLayoutOption(FdLayoutOptionConstant.LEFT) != undefined;
                var hasRight:Boolean = temp.getLayoutOption(FdLayoutOptionConstant.RIGHT) != undefined;
                var hasTop:Boolean = temp.getLayoutOption(FdLayoutOptionConstant.TOP) != undefined;
                var hasBottom:Boolean = temp.getLayoutOption(FdLayoutOptionConstant.BOTTOM) != undefined;
                var hasWidth:Boolean = temp.getLayoutOption(FdLayoutOptionConstant.WIDTH) != undefined;
                var hasHeight:Boolean = temp.getLayoutOption(FdLayoutOptionConstant.HEIGHT) != undefined;
                
                if (hasLeft)
                {
                    temp._x = temp.getLayoutOption(FdLayoutOptionConstant.LEFT);
                    if (hasWidth)
                    {
                        temp._width = temp.getLayoutOption(FdLayoutOptionConstant.WIDTH);
                    }
                    else if (hasRight)
                    {
                        temp._width = parent.width - temp.x - temp.getLayoutOption(FdLayoutOptionConstant.RIGHT);
                    }
                }
                else if (hasWidth)
                {
                    temp._width = temp.getLayoutOption(FdLayoutOptionConstant.WIDTH);
                    if (hasRight)
                    {
                        temp._x = parent.width - temp.getLayoutOption(FdLayoutOptionConstant.RIGHT) - temp.width;
                    }
                }
                else if (hasRight)
                {
                    temp._x = parent.width - temp.getLayoutOption(FdLayoutOptionConstant.RIGHT) - temp.width;
                }
                
                if (hasTop)
                {
                    temp._y = temp.getLayoutOption(FdLayoutOptionConstant.TOP);
                    if (hasHeight)
                    {
                        temp._height = temp.getLayoutOption(FdLayoutOptionConstant.HEIGHT);
                    }
                    else if (hasBottom)
                    {
                        temp._height = parent.height - temp.y - temp.getLayoutOption(FdLayoutOptionConstant.BOTTOM);
                    }
                }
                else if (hasHeight)
                {
                    temp._height = temp.getLayoutOption(FdLayoutOptionConstant.HEIGHT);
                    if (hasBottom)
                    {
                        temp._y = parent.height - temp.getLayoutOption(FdLayoutOptionConstant.RIGHT) - temp.height;
                    }
                }
                else if (hasBottom)
                {
                    temp._y = parent.height - temp.getLayoutOption(FdLayoutOptionConstant.BOTTOM) - temp.height;
                }
            }
        }
    }
}