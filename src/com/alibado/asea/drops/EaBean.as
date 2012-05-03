package com.alibado.asea.drops
{
    import com.alibado.asea.EaConfig;
    import com.alibado.asea.EaDrop;
    import com.alibado.asea.brews.EaBeanMother;
    
    public class EaBean extends EaDrop
    {
        override public function get name():String
        {
            return "bean";
        }
        
        /**
         * example:
         * <bean id="myBean">
         *     <new id="newObj" value="Pic">
         *         <get value="box" />
         *         <get value="number/400" />
         *         <get value="number/300" />
         *         <get value="string/this is my title" />
         *     </new>
         *     <get id="newObj.a" value="box" />
         *     <get id="newObj.b" value="number/400" />
         *     <get id="newObj.c" value="number/300" />
         *     <get id="newObj.d" value="string/this is my title" />
         * </bean>
         */
        override protected function onProcess(dom:XML, value:*, contexts:Array, onComplete:Function, onError:Function = null):void
        {
            onComplete(new EaBeanMother(dom, contexts, EaConfig.getDrop("asea") as EaAsea));
        }
    }
}