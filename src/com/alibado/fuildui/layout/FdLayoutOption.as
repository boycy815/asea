package com.alibado.fuildui.layout
{
    public class FdLayoutOption
    {
        private var _tx:Number;
        private var _ty:Number;
        private var _twidth:Number;
        private var _theight:Number;
        private var _option:Array = [];
        
        public function FdLayoutOption(tw:Number, th:Number, tx:Number = 0, ty:Number = 0)
        {
            _tx = tx;
            _ty = ty;
            _twidth = tw;
            _theight = th;
        }
        
        public function get x():Number
        {
            return _tx;
        }
        
        internal function set _x(val:Number):void
        {
            _tx = val;
        }
        
        public function get y():Number
        {
            return _ty;
        }
        
        internal function set _y(val:Number):void
        {
            _ty = val;
        }
        
        public function get width():Number
        {
            return _twidth;
        }
        
        internal function set _width(val:Number):void
        {
            if (val < 0) val = 0;
            _twidth = val;
        }
        
        public function get height():Number
        {
            return _theight;
        }
        
        internal function set _height(val:Number):void
        {
            if (val < 0) val = 0;
            _theight = val;
        }
        
        public function setLayoutOption(name:uint, value:*):void
        {
            defaultSynch(name, value);
            _option[name] = value;
        }
        
        public function getLayoutOption(name:uint):*
        {
            return _option[name];
        }
        
        private function defaultSynch(name:uint, value:*):void
        {
            if (value == null || value == undefined) return;
            switch(name)
            {
                case FdLayoutOptionConstant.LEFT:
                    _tx = value;
                    break;
                case FdLayoutOptionConstant.TOP:
                    _ty = value;
                    break;
                case FdLayoutOptionConstant.WIDTH:
                    _twidth = value;
                    break;
                case FdLayoutOptionConstant.HEIGHT:
                    _theight = value;
                    break;
            }
        }
    }
}