package com.alibado.asea
{
    import com.alibado.asea.drops.*;

    public class EaConfig
    {
        private static const drops:Vector.<Class> = new<Class>[EaAsea, EaTrace, EaClass, EaIf, EaLib, EaMethod, EaNew, EaSelector, EaGet];
        
        private static var instances:Array;
        
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