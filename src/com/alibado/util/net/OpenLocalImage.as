package com.alibado.util.net
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Loader;
    import flash.events.ErrorEvent;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    import flash.net.FileFilter;
    import flash.net.FileReference;
    import flash.system.System;
    
    
    /**
    * 用于打开本地图片的工具类
    */
    public class OpenLocalImage extends EventDispatcher
    {
        //打开图片最大尺寸
        public static const MAX_SIZE:Number = 1000;
        
        //位图数据
        private var _data:BitmapData;
        
        //文件引用
        private var _fileReference:FileReference;
        
        //若打开图片大于尺寸则会进行缩放并设置缩放参数
        private var _scale:Number = 1;
        
        //是否已经打开
        private var _opened:Boolean = false;
        
        //文件最大体积限制
        private var _sizeLimite:Number = 2097152;
        
        //hack
        (new BitmapData(2000, 2000)).dispose();
        System.gc();
        
        public function OpenLocalImage()
        {
            super(null);
        }
        
        /**
        * 获取打开的图片位图数据，文件打开后才产生
        */
        public function get data():BitmapData
        {
            return _data;
        }
        
        /**
        * 获取图片缩放比例，若打开图片大于尺寸则会进行缩放并设置缩放参数。
        */
        public function get scale():Number
        {
            return _scale;
        }
        
        /**
        * 获取文件打开引用，文件打开后才产生
        */
        public function get fileReference():FileReference
        {
            return _fileReference;
        }
        
        /**
        * 
        * 触发打开命令
        * 
        * @param limit 打开文件的最大体积限制
        * 
        */
        public function open(limit:Number = 2097152):void
        {
            _sizeLimite = limit;
            var fr:FileReference = new FileReference();
            fr.addEventListener(Event.SELECT, onSelect);
            fr.browse([new FileFilter("图片(*.jpg,*.png,*.gif)", "*.jpg;*.png;*.gif")]);
            _fileReference = fr;
        }
        
        /**
        * 释放位图资源
        */
        public function dispose():void
        {
            if (_opened)
            {
                _data.dispose();
                _fileReference.data.clear();
            }
        }
        
        private function onSelect(e:Event):void
        {
            e.currentTarget.removeEventListener(Event.SELECT, onSelect);
            if (e.currentTarget.size < _sizeLimite)
            {
                e.currentTarget.addEventListener(Event.COMPLETE, onComplete);
                e.currentTarget.addEventListener(Event.OPEN, function(e:Event):void { } );
                e.currentTarget.load();
            }
            else
            {
                this.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "上传文件超过指定大小！"));
            }
        }
        
        private function onComplete(e:Event):void
        {
            e.currentTarget.removeEventListener(Event.COMPLETE, onComplete);
            var loader:Loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderOnComplete);
            loader.loadBytes(e.currentTarget.data);
        }
        
        private function loaderOnComplete(e:Event):void
        {
            e.currentTarget.removeEventListener(Event.COMPLETE, loaderOnComplete);
            
            //如果图片尺寸超过指定大小则对其进行缩放
            if (e.currentTarget.loader.width > MAX_SIZE || e.currentTarget.loader.height > MAX_SIZE)
            {
                if (e.currentTarget.loader.width > e.currentTarget.loader.height)
                {
                    _scale = MAX_SIZE / e.currentTarget.loader.width;
                }
                else
                {
                    _scale = MAX_SIZE / e.currentTarget.loader.height;
                }
                
                e.currentTarget.loader.content.scaleX = e.currentTarget.loader.content.scaleY = _scale;
            }
            
            _data = new BitmapData(e.currentTarget.loader.width, e.currentTarget.loader.height);
            _data.draw(e.currentTarget.loader);
            
            (e.currentTarget.content as Bitmap).bitmapData.dispose();
            e.currentTarget.loader.unload();
            
            _opened = true;
            
            dispatchEvent(new Event(Event.COMPLETE));
        }
    }
}