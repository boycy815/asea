package com.alibado.asea.falls
{
    import com.alibado.util.ICollectionList;
    import com.alibado.util.IUseCollectionList;
    import com.alibado.util.SinpleCollectionList;

    
    /**
    * 控制异步执行链
    */
    
    public class EaFalls implements IUseCollectionList, IEaFallAble
    {
        //数据列表
        private var _handles:ICollectionList;
        
        //下一个执行的任务标号
        private var _nextPoint:int = 0;
        
        //当前执行的action
        private var _currentAction:EaFallAction;
        
        //若是当前的falls发生的另外一个母falls中，则保存之，否则为空
        private var _parentFalls:EaFalls;
        
        //当前是否为处理状态
        private var _isPlaying:Boolean = false;
        
        //暂停状态时若当前action完成则标记该标记位
        private var _tempComplete:Boolean = false;
        
        //链处理完成后的回调
        private var _onComplete:Function;
        
        
        //单个action处理完成后的回调
        private var _onProgress:Function;
        
        /**
        * 构造函数
        */
        public function EaFalls()
        {
            _handles = new SinpleCollectionList(this);
        }
        
        
        //IUseCollectionList
        
        /**
         * 元素增加时的回调
         * @param item 增加的元素
         * @param i 新增元素的位置
         */
        public function _onAdd(item:*, i:uint):void
        {
            if(i < _nextPoint) _nextPoint++;
        }
        
        /**
         * 元素被删除是的回调
         * @param item 被删除的元素
         * @param oi 元素被删除前的位置
         */
        public function _onRemove(item:*, oi:uint):void
        {
            if(oi < _nextPoint) _nextPoint--;
        }
        
        /**
         * 元素被覆盖后的回调
         * @param oldItem 被覆盖的元素
         * @param 覆盖的位置
         */
        public function _onReplace(oldItem:*, i:uint):void
        {
            //
        }
        
        /**
         * 元素被添加前进行类型验证，验证通过才允许被添加到表中
         * @param 要被添加的元素
         * @return 如果验证通过则返回true，否则返回false
         */
        public function _typeValidate(item:*):Boolean
        {
            if (!(item is EaFallAction))
            {
                throw new ArgumentError("必须在CollectionList中添加EaFallAction类型的元素 - EaFalls");
                return false;
            }
            else
            {
                return true;
            }
        }
        
        
        
        //IEaFallAble
        
        /**
        * 母falls调用其执行
        */
        public function _fallRun(falls:EaFalls, args:Array):void
        {
            if (_parentFalls) _parentFalls.stop();
            _parentFalls = falls;
            play();
        }
        
        /**
        * 母falls调用其中止执行
        */
        public function _fallAbort():void
        {
            abort();
            _parentFalls = null;
        }
        
        
        //EaFalls
        
        /**
        * 获取falls的数据列表
        * @return 数据列表
        */
        public function get actions():ICollectionList
        {
            return _handles;
        }
        
        /**
        * 获取下一个将要执行的action的节点
        * @return 下一个将要执行的action的节点
        */
        public function get nextPoint():uint
        {
            return _nextPoint;
        }
        
        /**
        * 设置下一个将要执行的action的节点，若下一个执行节点无效则在本次任务执行完之后直接发生complete回调
        * @param val 下一个将要执行的action的节点
        */
        public function set nextPoint(val:uint):void
        {
            _nextPoint = val;
        }
        
        /**
        * 往action的数据列表中添加数据
        * @param fall 一个执行对象
        * @param args 执行的参数
        */
        public function addAction(fall:IEaFallAble, args:Array):void
        {
            _handles.add(new EaFallAction(fall, args));
        }
        
        /**
        * 清除数据列表中所有的数据
        * 若是当前有正在执行的对象，将不会中止他
        */
        public function clear():void
        {
            _handles.clear();
        }
        
        /**
        * 若是当前处于暂停状态，则恢复为播放状态
        * 若是当前处于播放状态则无效
        */
        public function play():void
        {
            _isPlaying = true;
            if (_currentAction == null)
            {
                _onNext();
            }
            else if (_tempComplete)
            {
                _tempComplete = false;
                _onNext();
            }
        }
        
        /**
        * 人工结束链的执行，其具体过程是
        * 中止当前执行的action并将下一个执行头重置到0，然后发生Complete回调
        */
        public function stop():void
        {
            abort();
            if (_onComplete != null)
            {
                _onComplete(this);
            }
            if (_parentFalls) _parentFalls._onNext();
        }
        
        /**
        * 暂停链的执行，但是不会中止其正在执行的action
        * 当前action执行完成之后不会发生progress回调，而是等到下次执行play的时候回调
        */
        public function pause():void
        {
            _isPlaying = false;
        }
        
        
        /**
        * 不要随便调用，是给IEaFallAble用的
        * action执行完成后将回调这个方法
        */
        public function _onNext():void
        {
            if(_onProgress != null && _currentAction && _isPlaying) _onProgress(_currentAction, this);
            if (_isPlaying)
            {
                if (_nextPoint < _handles.length && _nextPoint >= 0)
                {
                    _currentAction = _handles.getAt(_nextPoint);
                    _nextPoint++;
                    _currentAction.fall._fallRun(this, _currentAction.args);
                }
                else
                {
                    _currentAction = null;
                    stop();
                }
            }
            else if (_currentAction)
            {
                _tempComplete = true;
            }
        }
        
        /**
        * 设置单个action执行完成后调用的方法
        * @param val function(action:EaFallAction, target:EaFalls):void
        */
        public function setOnProgress(val:Function):void
        {
            _onProgress = val;
        }
        
        /**
        * 设置整个处理链完成后调用的方法
        * @param val function(target:EaFalls):void
        */
        public function setOnComplete(val:Function):void
        {
            _onComplete = val;
        }
        
        /**
        * 确定当前的执行状态
        * @return 当前正在执行则返回true，反之返回false
        */
        public function isPlaying():Boolean
        {
            return _isPlaying;
        }
        
        
        /**
         * 中止当前执行的action并将下一个执行头重置到0
         */
        private function abort():void
        {
            if (_currentAction != null)
            {
                _currentAction.fall._fallAbort();
                _currentAction = null;
            }
            _isPlaying = false;
            _tempComplete = false;
            _nextPoint = 0;
        }
    }
}