package com.alibado.fuildui.skin
{
    import com.alibado.fuildui.FdComponent;
    
    import flash.display.Sprite;
    
    public class FdSkinCore extends Sprite implements IFdSkin
    {
        protected var _status:int;
        
        public function FdSkinCore()
        {
            super();
        }
        
        public function get status():int
        {
            return _status;
        }
        
        public function set status(val:int):void
        {
            _status = val;
        }
    }
}