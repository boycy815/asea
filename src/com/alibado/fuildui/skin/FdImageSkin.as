package com.alibado.fuildui.skin
{
    import flash.display.DisplayObject;

    public class FdImageSkin extends FdSkinCore
    {
        private var _images:Array;
        
        private var _temp:DisplayObject;
        
        public function FdImageSkin(images:Array)
        {
            super();
            if (images == null || images.length == 0)
            {
                throw new ArgumentError("FdImageSkin的图片不能为空");
                return;
            }
            _images = images;
            var tw:Number = _images[0].width;
            var th:Number = _images[0].height;
            for each(var i:DisplayObject in _images)
            {
                i.x = (tw - i.width) / 2;
                i.y = (th - i.height) / 2;
            }
        }
        
        private function changeCurrent(val:DisplayObject):void
        {
            if (_temp)
            {
                removeChild(_temp);
            }
            _temp = val;
            addChildAt(_temp, 0);
        }
        
        override public function set status(val:int):void
        {
            trace(val)
            super.status = val;
            if (!_images[val])
            {
                changeCurrent(_images[0]);
            }
            else
            {
                changeCurrent(_images[val]);
            }
        }
    }
}