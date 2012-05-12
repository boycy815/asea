package com.alibado.fuildui.skin
{
    public class FdBlack extends FdSkinCore
    {
        public function FdBlack()
        {
            super();
        }
        
        override public function set status(val:int):void
        {
            this.graphics.clear();
            this.graphics.beginFill(0x000000);
            this.graphics.drawRect(0, 0, 100, 100);
            this.graphics.endFill();
            super.status = val;
        }
    }
}