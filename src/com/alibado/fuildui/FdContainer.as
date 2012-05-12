package com.alibado.fuildui
{
    import com.alibado.util.CollectionListEvent;
    import com.alibado.fuildui.layout.FdDefaultLayout;
    import com.alibado.fuildui.layout.FdLayoutOption;
    import com.alibado.fuildui.layout.IFdLayoutManager;
    import com.alibado.fuildui.skin.FdSkinCore;
    import com.alibado.util.ICollectionList;
    import com.alibado.util.CollectionList;
    
    import flash.events.EventDispatcher;
    
    public class FdContainer extends FdComponent
    {
        
        private var _layoutManager:IFdLayoutManager;
        
        private var _collection:ICollectionList = new CollectionList();
        
        public function FdContainer(sk:FdSkinCore = null, lay:IFdLayoutManager = null)
        {
            super(sk);
            layout = lay;
            EventDispatcher(_collection).addEventListener(CollectionListEvent.ITEM_ADDED, onItemAdded);
            EventDispatcher(_collection).addEventListener(CollectionListEvent.ITEM_REMOVED, onItemRemoved);
        }
        
        /**
         * 修改或者设置布局对象，如果设置为空则为默认布局对象
         */
        public function get layout():IFdLayoutManager {return _layoutManager;}
        public function set layout(val:IFdLayoutManager):void
        {
            if (val)
            {
                _layoutManager = val;
            }
            else
            {
                _layoutManager = new FdDefaultLayout();
            }
        }
        
        /**
         * 获取子元素集合
         */
        public function get collection():ICollectionList
        {
            return _collection;
        }
        
        /**
         * 计算布局
         */
        protected function _doLayout():void
        {
            _layoutManager.doLayout(this);
        }
        
        private function onItemAdded(e:CollectionListEvent):void
        {
            var d:FdComponent = FdComponent(e.value);
            addChild(d);
            d._setParent(this);
        }
        
        private function onItemRemoved(e:CollectionListEvent):void
        {
            var d:FdComponent = FdComponent(e.value);
            removeChild(d);
            d._setParent(null);
        }
        
        /****************覆盖子类****************/
        
        override public function dispose():void
        {
            for (var i:int = 0; i < _collection.length; i++)
            {
                _collection.getAt(i).dispose();
            }
            EventDispatcher(_collection).removeEventListener(CollectionListEvent.ITEM_ADDED, onItemAdded);
            EventDispatcher(_collection).removeEventListener(CollectionListEvent.ITEM_REMOVED, onItemRemoved);
            super.dispose();
        }
        
        override public function set enable(val:Boolean):void
        {
            if (enable == val) return;
            for (var i:int = 0; i < _collection.length; i++)
            {
                _collection.getAt(i).enable = val;
            }
            super.enable = val;
        }
        
        override internal function _paint():void
        {
            _doLayout();
            for (var i:int = 0; i < _collection.length; i++)
            {
                _collection.getAt(i)._paint();
            }
            super._paint();
        }
    }
}