package com.alibado.consts
{
    /**
     * 报错的文案常量
     */
    public class EW
    {
        public static const NOT_AT_SAME_CONTAINER:String = "不在同一层级";
        public static const WRONG_DISPLAY_LIST:String = "错误的显示列表关系";
        public static const NULL_OBJECT:String = "空对象";
        public static const INDEX_OUT_OF_RANGE:String = "访问的下标超出范围";
        
        /**
         * 错误文案合成
         * @param name 出错的对象，值或者源
         * @param ...args 错误原因
         */
        public static function m(name:String, ...args):String
        {
            if (args.length < 1)
            {
                return name + "错误";
            }
            var l:int = args.length;
            var result:String = name + args[0];
            for (var i:int = 1; i < l; i++)
            {
                result = result + "或" + args[i];
            }
            return result;
        }
    }
}