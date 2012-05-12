package com.alibado.fuildui.skin
{
    public class FdBlue extends FdSkinCore
    {
        public function FdBlue()
        {
            super();
        }
        
        override public function set status(val:int):void
        {
            this.graphics.clear();
            this.graphics.beginFill(0xa5c5e3);
            this.graphics.drawRect(0, 0, 100, 100);
            this.graphics.endFill();
            super.status = val;
        }
    }
}