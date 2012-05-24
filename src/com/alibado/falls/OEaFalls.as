package com.alibado.falls
{
    import com.alibado.util.ICollectionList;
    import com.alibado.util.IUseCollectionList;
    import com.alibado.util.SinpleCollectionList;

    
    /**
    * 控制异步执行链
    */
    
    public class OEaFalls implements IUseCollectionList, OIEaFallAble
    {
        //数据列表
        private var _handles:ICollectionList;
        
        //下一个执行的任务标号
        private var _nextPoint:int = 0;
        
        //当前执行的action，若此不为空则说明当前有任务在执行（可能是暂停或者执行）
        private var _currentAction:OEaFallAction;
        
        //若是当前的falls发生的另外一个母falls中，则保存之
        //若是其不为空则说明外部falls在等待本falls的回调
        //为空则说明没有关心他的falls
        private var _parentFalls:OEaFalls;
        
        //有多个母falls的等待队列
        //若目前有falls关心本falls或者本falls在执行中则将新加入的母falls加入等待队列
        //直到执行结束后从等待队列里取出一个母falls
        private var _parentFallsWaiting:Vector.<OEaFalls>;
        
        //当前是否为正在执行状态，如果为true说明有任务正在执行并且非暂停
        //为false则有可能为暂停或者停止状态
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
        public function OEaFalls()
        {
            _handles = new SinpleCollectionList(this);
            _parentFallsWaiting = new Vector.<OEaFalls>();
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
            if (!(item is OEaFallAction))
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
        * 若当前fall正在执行或者有母falls等待其结束则将其加入的母falls放到等待队列
        * 否则则立即开始执行
        */
        public function _fallRun(falls:OEaFalls, args:Array):void
        {
            //若是仍然有人关心执行结果则将falls加入等待队列
            if (_currentAction || _parentFalls)
            {
                _parentFallsWaiting.push(falls);
            }
            else
            {
                _parentFalls = falls;
                play();
            }
        }
        
        /**
        * 母falls调用其中止执行，使其下个指针头复位并清空其母falls
        * 好像没事儿人一样准备下一次被母falls或者用户调用
        */
        public function _fallAbort():void
        {
            //中止当前执行
            abort();
            
            //复位
            _nextPoint = 0;
            
            //由于母falls调用该方法故母falls已经不关心它
            _parentFalls = null;
            
            //检查是否还有别的falls想要执行本falls，有则执行
            checkWaitingFalls();
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
        public function addAction(fall:OIEaFallAble, args:Array):void
        {
            _handles.add(new OEaFallAction(fall, args));
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
        * 从停止状态转换成播放状态
        */
        public function play():void
        {
            //切换为播放状态
            _isPlaying = true;
            
            //若是当前没有任务在执行
            if (_currentAction == null)
            {
                //去执行一个任务
                _onNext();
            }
            //若是当前有任务在执行，我要检测下他是否已经完成任务但是没告知的
            else if (_tempComplete)
            {
                //跑去告知任务
                _tempComplete = false;
                _onNext();
            }
            //其余情况属于已有任务在执行而且还没完成的，没有必要做什么事
        }
        
        /**
        * 人工正常结束链的执行，好像是链真的执行结束了一样
        * 一样发生了complete回调，一样将next复位，一样通知了母falls并清空母falls
        */
        public function stop():void
        {
            //中止当前执行的任务
            abort();
            
            //复位
            _nextPoint = 0;
            
            //发送complete回调
            if (_onComplete != null)
            {
                _onComplete(this);
            }
            
            //通知母falls已经完成，之后母falls已经不关心本falls了
            if (_parentFalls)
            {
                _parentFalls._onNext();
                _parentFalls = null;
            }
            
            //现在状态属于完成状态，此时检测是否还有母falls要使用本falls
            checkWaitingFalls();
        }
        
        /**
        * 暂停链的执行，纯粹的暂停，链里面不会发生任何回调，链也不会继续下去
        * 但是当前执行的action其本身并未停止，也许他已经执行完毕，但是没有通知外界，
        * 因为他知道你在睡觉，所以自个儿玩去了，直到你用play方法恢复才会告知你他已经完成并且继续往下执行。
        * 如果你睡觉中直接调用了stop，那么相当于睡死了。。睡死了当然就不会关心那个action完成没有
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
            //调用next时，如果当前是执行状态且非暂停状态，则可以发生progress回调
            if(_onProgress != null && _isPlaying) _onProgress(_currentAction, this);
            
            //如果当前是执行且非暂停状态
            if (_isPlaying)
            {
                //如果下个action位置未超过界限
                if (_nextPoint < _handles.length && _nextPoint >= 0)
                {
                    //获取下一个action
                    _currentAction = _handles.getAt(_nextPoint);
                    
                    //产生新的下一个action位置
                    _nextPoint++;
                    
                    //执行这个action
                    _currentAction.fall._fallRun(this, _currentAction.args);
                }
                //如果下一个action超过界限则认为执行结束
                else
                {
                    //转换为非执行状态
                    _currentAction = null;
                    
                    //像正常人一样停止
                    stop();
                }
            }
            //当前为暂停状态
            else if (_currentAction)
            {
                //暂时将成功的喜讯保存起来吧
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
         * 中止当前执行的action
         * 可能你不满意当前执行的action，所以你要中止他
         * 然后你可以做一些小动作之后继续falls的执行。
         * 对于你的母falls，它并不很知道你究竟对这个falls做了啥
         */
        public function abort():void
        {
            //若是当前为执行状态
            if (_currentAction != null)
            {
                //将正在执行的action停止
                _currentAction.fall._fallAbort();
                
                //并切换为非执行状态
                _currentAction = null;
            }
            
            //转换为非执行状态也要改变的数据
            _isPlaying = false;
            
            //暂停时候完成的喜讯因为中止执行也没有了
            _tempComplete = false;
        }
        
        //检测等待队列中是否有falls，若有则让其执行
        private function checkWaitingFalls():void
        {
            if (_parentFallsWaiting.length > 0)
            {
                _fallRun(_parentFallsWaiting.shift(), null);
            }
        }
    }
}