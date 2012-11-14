package com.alibado.fuildui.container
{
    import com.alibado.fuildui.base.BaseUI;
    
    import flash.display.DisplayObject;
    
    public class Container extends BaseUI
    {
        public function Container()
        {
            super();
        }
        
        override public function addChild(child:DisplayObject):DisplayObject
        {
            var result:DisplayObject = super.addChild(child);
            onChildadded(result);
            return result;
        }
        
        override public function addChildAt(child:DisplayObject, index:int):DisplayObject
        {
            var result:DisplayObject = super.addChildAt(child, index);
            onChildadded(result);
            return result;
        }
        
        override public function removeChild(child:DisplayObject):DisplayObject
        {
            var result:DisplayObject = super.removeChild(child);
            onChildremoved(result);
            return result;
        }
        
        override public function removeChildAt(index:int):DisplayObject
        {
            var result:DisplayObject = super.removeChildAt(index);
            onChildremoved(result);
            return result;
        }
        
        /**
         * 先调用drawGraphics，再依次调用子项的drawChildren
         */
        override public function drawChildren():void
        {
            super.drawChildren();
            var l:int = numChildren;
            var temp:DisplayObject;
            for (var i:int = 0; i < l; i++)
            {
                temp = getChildAt(i);
                if (temp is BaseUI)
                {
                    (temp as BaseUI).drawChildren();
                }
            }
        }
        
        protected function onChildadded(item:DisplayObject):void
        {
            //
        }
        
        protected function onChildremoved(item:DisplayObject):void
        {
            //
        }
    }
}