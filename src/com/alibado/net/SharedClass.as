package com.alibado.net
{
    import flash.display.Loader;
    import flash.display.LoaderInfo;
    import flash.events.Event;
    import flash.net.URLRequest;
    import flash.system.ApplicationDomain;
    import flash.system.LoaderContext;

    
    /**
    * 用于加载RSL以及获取Class
    * 单例
    */
    public class SharedClass
    {
        
        private static var _instance:SharedClass;
        
        public function SharedClass()
        {
            if (_instance) throw new Error("Single Instace Error - SharedClass");
            else
            {
                _instance = this;
            }
        }
        
        /**
        * 获取单例
        */
        public static function get instance():SharedClass
        {
            if (_instance) return _instance;
            return new SharedClass();
        }
        
        /**
        * loadLib的静态化
        */
        public static function loadLib(url:String, domain:ApplicationDomain = null):LoaderInfo
        {
            return instance.loadLib(url, domain);
        }
        
        /**
        * getClass的静态化
        */
        public static function getClass(name:String, domain:ApplicationDomain = null):Class
        {
            return instance.getClass(name, domain);
        }
        
        /**
        * 加载RSL到指定域
        * @param url RSL的路径
        * @param domain 指定的域，若是为空则为当前域；默认为空
        * @return 返回加载信息，可对其进行监听
        */
        public function loadLib(url:String, domain:ApplicationDomain = null):LoaderInfo
        {
            var loader:Loader = new Loader();
            loader.load(new URLRequest(url), new LoaderContext(false, domain ? domain : ApplicationDomain.currentDomain));
            return loader.contentLoaderInfo;
        }
        
        /**
        * 从指定域中获取Class
        * @param name 完整类名
        * @param domain 指定的域，若是为空则为当前域；默认为空
        * @return 返回获取到的类，若是类没有定义则返回空
        */
        public function getClass(name:String, domain:ApplicationDomain = null):Class
        {
            if (!domain) domain = ApplicationDomain.currentDomain;
            if (!domain.hasDefinition(name)) return null;
            return domain.getDefinition(name) as Class;
        }
        
    }
}