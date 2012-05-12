package com.alibado.asea
{
    import com.alibado.asea.drops.*;

    /**
    * 
    * 用于配置和获取标签处理器的工厂
    * 
    */
    
    public class EaConfig
    {
        //默认支持的标签处理器
        private static const drops:Vector.<Class> = new<Class>[EaAsea, EaClass, EaGet, EaIf, EaLib, EaMethod, EaNew, EaSelector, EaTrace, EaWith, EaBean, EaInclude];
        
        //标签处理器实例
        private static var instances:Array;
        
        /**
        * 
        * 增加某种自定义的标签处理器支持。
        * 新增的标签处理器若是与之前的标签处理器同名则将覆盖之前的标签处理器
        * 
        * @param dropClass EaDrop的子类 要新增的标签处理器 若非EaDrop的子类则后果自负
        */
        public static function addDrop(dropClass:Class):void
        {
            if (instances == null)
            {
                drops.push(dropClass);
            }
            else
            {
                var drop:EaDrop = new dropClass();
                instances[drop.name] = drop;
            }
        }
        
        /**
        * 
        * 获取标签名对应的标签处理器实例，该实例为单例
        * 若没有对应的标签处理器则返回null
        * 
        * @param name 标签名
        * 
        * @return 对应的标签处理器，若找不到则返回null
        * 
        */
        public static function getDrop(name:String):EaDrop
        {
            if (instances == null)
            {
                instances = [];
                for (var i:int = 0; i < drops.length; i++)
                {
                    var drop:EaDrop = new drops[i]();
                    instances[drop.name] = drop;
                }
            }
            return instances[name];
        }
    }
}