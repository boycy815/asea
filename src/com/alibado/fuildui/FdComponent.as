package com.alibado.fuildui
{
    import com.alibado.fuildui.layout.FdLayoutOption;
    import com.alibado.fuildui.layout.FdLayoutOptionConstant;
    import com.alibado.fuildui.layout.IFdBeLayoutAble;
    import com.alibado.fuildui.skin.FdSkinCore;
    import com.alibado.fuildui.skin.FdSkinStatusConstant;
    import com.alibado.fuildui.skin.IFdSkin;
    
    import flash.display.Sprite;
    
    public class FdComponent extends Sprite implements IFdSkin,IFdBeLayoutAble
    {
        
        private var _enable:Boolean = true;
        
        private var _skin:FdSkinCore;
        
        private var _layoutOption:FdLayoutOption;
        
        private var _parent:FdContainer;
        
        private var _sourceWidth:Number;
        
        private var _sourceHeight:Number;
        
        /**
         * @param sk 皮肤
         */ 
        public function FdComponent(sk:FdSkinCore = null)
        {
            super();
            if (!sk) sk = new FdSkinCore();
            sk.x = sk.y = 0;
            _skin = sk;
            addChild(_skin);
            _skin.status = FdSkinStatusConstant.NORMAL;
            _layoutOption = new FdLayoutOption(_skin.width, _skin.height);
            _sourceWidth = _skin.width;
            _sourceHeight = _skin.height;
        }
        
        /**
         * @param pa 母容器 被加入容器的时候容器必须调用这个方法
         */ 
        internal function _setParent(pa:FdContainer):void
        {
            _parent = pa;
        }
        
        /**
         * 清空对象
         */ 
        public function dispose():void
        {
            if (this.parent)
                this.parent.removeChild(this);
        }
        
        
        /**
         * 设置可操作性
         */ 
        public function get enable():Boolean {return _enable;}
        public function set enable(val:Boolean):void
        {
            if (_enable == val) return;
            if (val)
            {
                _skin.status = FdSkinStatusConstant.NORMAL;
                this.mouseChildren = true;
            }
            else
            {
                _skin.status = FdSkinStatusConstant.DISENABLE;
                this.mouseChildren = false;
            }
            _enable = val;
        }
        
        /**
         * 换肤操作
         */
        public function get skin():FdSkinCore {return _skin;}
        public function set skin(val:FdSkinCore):void
        {
            if (_skin.parent)
                removeChild(_skin);
            if (!val) val = new FdSkinCore();
            val.x = val.y = 0;
            _skin = val;
            addChildAt(_skin, 0);
            _skin.status = FdSkinStatusConstant.NORMAL;
            _sourceWidth = _skin.width;
            _sourceHeight = _skin.height;
        }
        
        /**
         * 获得布局引擎所需的属性
         */
        public function get layoutOption():FdLayoutOption
        {
            return _layoutOption;
        }
        
        /**
         * 修改了布局属性后更新布局
         * 其本质是调用父容器的重绘，所以可能会影响其他元素
         */
        public function updata():void
        {
            if (_parent)
            {
                _parent._paint();
            }
            else
            {
                _paint();
            }
        }
        
        /**
         * 将布局引擎计算出来的数据绘制出来
         * 容器绘制中应该被覆盖
         */
        internal function _paint():void
        {
            x = _layoutOption.x;
            y = _layoutOption.y;
            _skin.scaleX = _layoutOption.width / _sourceWidth;
            _skin.scaleY = _layoutOption.height / _sourceHeight;
            //_skin.width = _layoutOption.width;
            //_skin.height = _layoutOption.height;
        }
        
        /**
         * 组件的状态设置 覆盖它必须注意皮肤状态与交互状态同步
         */
        public function get status():int {return _skin.status;}
        public function set status(val:int):void
        {
            switch(val)
            {
                case FdSkinStatusConstant.DISENABLE:
                    enable = false;
                    return;
                    break;
                default:
                    enable = true;
                    break;
            }
            _skin.status = val;
        }
        
    }
}