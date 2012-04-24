package com.alibado.net
{
    import flash.display.Loader;
    import flash.display.LoaderInfo;
    import flash.events.Event;
    import flash.net.URLRequest;
    import flash.system.ApplicationDomain;
    import flash.system.LoaderContext;

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
        
        public static function get instance():SharedClass
        {
            if (_instance) return _instance;
            return new SharedClass();
        }
        
        public function loadLib(url:String, domain:ApplicationDomain = null):LoaderInfo
        {
            var loader:Loader = new Loader();
            loader.load(new URLRequest(url), new LoaderContext(false, domain ? domain : ApplicationDomain.currentDomain));
            return loader.contentLoaderInfo;
        }
        
        public function getClass(name:String):Class
        {
            if (!ApplicationDomain.currentDomain.hasDefinition(name)) return null;
            return ApplicationDomain.currentDomain.getDefinition(name) as Class;
        }
        
    }
}