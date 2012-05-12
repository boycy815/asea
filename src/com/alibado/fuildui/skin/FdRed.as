package com.alibado.fuildui.skin
{
    public class FdRed extends FdSkinCore
    {
        public function FdRed()
        {
            super();
        }
        
        override public function set status(val:int):void
        {
            this.graphics.clear();
            this.graphics.beginFill(0xe37819);
            this.graphics.drawRect(0, 0, 100, 100);
            this.graphics.endFill();
            super.status = val;
        }
    }
}