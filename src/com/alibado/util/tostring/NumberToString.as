package com.alibado.util.tostring
{
    
    /**
     * 数字格式化工具
     */
    public class NumberToString
    {
        
        /**
         * 秒数到 时:分:秒 格式的转换
         */
        public static function secondsToHHMMSS(val:Number):String
        {
            var ret:String = "";
            if (val >= 0)
            {
                var temp:int;
                temp = int(val / 3600);
                if (temp < 10) ret = ret + "0";
                ret = ret + temp + ":";
                val %= 3600;
                temp = int(val / 60);
                if (temp < 10) ret = ret + "0";
                ret = ret + temp + ":";
                val %= 60;
                temp = int(val);
                if (temp < 10) ret = ret + "0";
                ret = ret + temp;
            }
            return ret;
        }
        
        /**
         * 秒数到 分:秒 格式的转换
         */
        public static function secondsToMMSS(val:Number):String
        {
            var ret:String = "";
            if (val >= 0)
            {
                var temp:int;
                temp = int(val / 60);
                if (temp < 10) ret = ret + "0";
                ret = ret + temp + ":";
                val %= 60;
                temp = int(val);
                if (temp < 10) ret = ret + "0";
                ret = ret + temp;
            }
            return ret;
        }
    }
}