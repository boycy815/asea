/**
 * 代码必须在Flash之前被引入并且实例化成一个能从window对象访问到的对象
 * @example window.dumpTest1 = new Dump('myFlashId');
 * 插入flash时则使用这样的src:myFlash.swf?dump=dumpTest1
 */
var Dump = function(flashId) {
	//还未初始化的时候的任务缓存
	this._invokeTask = [];

	//flash的id
	this._targetId = flashId;
};

Dump.prototype._init = function() {
	//初始化标记
	this._inited = true;
	//注册的方法
	this._funMap = [];
	//任务缓存
	this._taskMap = [];
	//调用as时产生的回调
	this._callbacks = [];
	
	//处理掉初始化前的任务
	var l = this._invokeTask.length;
	for (var i = 0; i < l; i++) {
		this.invoke.apply(this, this._invokeTask[i]);
	}
	this._invokeTask = null;
}

Dump.prototype._triggle = function(alias, args) {
	var result;
	if (this._funMap[alias])
	{
		result = this._funMap[alias].apply(null, args);
		document.getElementById(this._targetId)._return(alias, result);
	}
	else
	{
		if (!this._taskMap[alias]) this._taskMap[alias] = [];
		this._taskMap[alias].push([args, alias]);
	}
};

Dump.prototype._return = function(alias, result) {
	if (this._callbacks[alias])
	{
		var callback = this._callbacks[alias].shift();
		if (callback != null)
		{
			callback(result);
		}
	}
};

/**
 * 调用as的方法
 * @param alias String as的方法名
 * @param args Array 给方法传递的参数，不支持复合数据
 * @param callback function(result) 调用成功后的回调
 */
Dump.prototype.invoke = function(alias, args, callback) {
	if (this._inited) {
		var result;
        if (!callback) callback = function(d){};
		if (!this._callbacks[alias]) this._callbacks[alias] = [];
		this._callbacks[alias].push(callback);
		document.getElementById(this._targetId)._triggle(alias, args);
	} else {
		this._invokeTask.push(arguments);
	}
};

/**
 * 注册给as调用的方法
 * @param alias String js的方法名
 * @param fun function 实际调用的方法，不绑定this
 */
Dump.prototype.register = function(alias, fun){
	this._funMap[alias] = fun;
	if (this._taskMap[alias])
	{
		var tasks = this._taskMap[alias];
		var task;
		var result;
		this._taskMap[alias] = null;
		while(task = tasks.shift())
		{
			result = fun.apply(null, task[0]);
			document.getElementById(this._targetId)._return(task[1], result)
		}
	}
}