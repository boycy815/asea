package com.alibado.fuildui.container
{
    import com.alibado.fuildui.base.BaseUI;
    
    import flash.display.DisplayObject;
    
    public class Container extends BaseUI
    {
        public function Container(na:String = null, style:Object = null)
        {
            super(na, style);
        }
        
        override public function addChild(child:DisplayObject):DisplayObject
        {
            var result:DisplayObject = super.addChild(child);
            onChildAdded(result);
            return result;
        }
        
        override public function addChildAt(child:DisplayObject, index:int):DisplayObject
        {
            var result:DisplayObject = super.addChildAt(child, index);
            onChildAdded(result);
            return result;
        }
        
        override public function removeChild(child:DisplayObject):DisplayObject
        {
            var result:DisplayObject = super.removeChild(child);
            onChildRemoved(result);
            return result;
        }
        
        override public function removeChildAt(index:int):DisplayObject
        {
            var result:DisplayObject = super.removeChildAt(index);
            onChildRemoved(result);
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
        
        protected function onChildAdded(item:DisplayObject):void
        {
            //
        }
        
        protected function onChildRemoved(item:DisplayObject):void
        {
            //
        }
    }
}