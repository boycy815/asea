asea
====

An ioc library for as3

====

作者：Clifford http://www.cnblogs.com/flash3d/

该库的设计最初是为了方便配置RSL，后来发现功能逐渐与Spring接近，所以干脆对功能重新规划了一次取名为Asea，在AS3上实现了基本的IOC功能。

以下内容让您学会如何使用Asea。

一. Hello World

//	package
//	{
//		import com.alibado.asea.*;
//		
//		import flash.display.Sprite;
//		
//		public class AseaTest extends Sprite
//		{
//			public function AseaTest()
//			{
//				//定义配置xml
//				var xml:XML = new XML(<asea><trace value="string/hello world"/></asea>);
//				
//				//获取根节点处理器
//				var asea:EaDrop = EaConfig.getDrop("asea");
//				
//				//定义上下文对象
//				var context:Object = {};
//				
//				//执行
//				asea.process(xml, [context]);
//			}
//		}
//		
//	}

除非您打算扩展它，否则使用Asea的仅需要四步。

配置xml中定义了您要执行的命令，命令的具体语法将在下面介绍。

上下文对象是xml命令执行的数据环境，换句话说，您可以在xml命令中从上下文对象中获取数据和写入数据，您可以尝试把上下文对象另外保存起来，这样您就可以通过它获取到处理后的结果了。这里提醒一点，如果您的上下文对象并非动态对象，那么当您尝试在xml上写入上下文环境中不存在的属性时，系统将报错（ReferenceError），当然一般来说您没有必要这么做。

根节点处理器就是一个大烤箱，您把执行命令和上下文数据交给它，它帮您处理。根节点处理器从EaConfig中获取，一般来说获取名字是“asea”的根节点处理器是不会错的，除非您非常确切得知道您的根节点是什么标签。另外方法process的第三个参数是成功后的回调，其定义应该是function(result:* = null):void，result处理后的结果，如果您的根节点是“asea”，那么result肯定是null，该回调存在的意义在于，考虑您的xml可能是异步处理的，比如在xml中加载个数据什么的。。process的第四个参数是出错后的回调，定义是function(errorCode:int, message:String, target:String, xml:XML):void。

对了，您可能还注意到process的第二个参数并非直接是context对象，而是一个只有context一个元素的数组。这个问题涉及到作用域链，作用域链的作用将在后面讲到。我知道这样看起来不太友好，希望哪个好人能帮它再封装一层吧。
 

二. 标签处理器

Asea目前提供的标签有：asea，class，get，if，lib，method，new，selector，trace，with，bean。

您可以在EaConfig这个类的drops属性中找到这些定义，drops是个包含所有标签处理器的数组，如果您定义了自己的标签处理器，可以push到这个数组中即可生效。

所有的标签处理器都继承EaDrop这个类，您只需覆盖onProcess方法和get name方法即可定义自己的标签处理器。另外提醒一点，标签处理器是无状态的，全局唯一实例，所以如果您的变量不是定义在方法体内，就要小心处理了。

这里贴出了最简单的标签处理器

//	package com.alibado.asea.drops
//	{
//		import com.alibado.asea.EaDrop;
//		
//		public class EaGet extends EaDrop
//		{
//			
//			override public function get name():String
//			{
//				return "get";
//			}
//			
//			
//			/**
//			 * example:
//			 * <get id="myPen" value="pen" >
//			 */
//			override protected function onProcess(dom:XML, value:*, contexts:Array, onComplete:Function, onError:Function = null):void
//			{
//				onComplete(value);
//			}
//		}
//		
//	}

在EaGet中覆盖了public function get name():String，需要在该方法中返回该标签处理器的要处理的标签名。

另外还要覆盖protected function onProcess(dom:XML, value:*, contexts:Array, onComplete:Function, onError:Function = null):void，该方法的第一个参数是处理的xml，系统会保证该xml的根节点名就是get name中指定的名字；第二个参数value是在标签中的value属性在上下文环境中查询到的数据，如果您不想知道查询的结果想自己处理value属性，那么您就去访问xml.@value吧；contexts是上下文环境；onComplete是处理成功后的回调，如果您的标签处理器会产生结果，那么就往onComplete里面传递结果吧，如果您的处理不产生结果，那也要调用一次onComplete，因为整个处理链是依赖onComplete进行的，如果您的标签有id属性且您传递了结果，那么系统会自动把您的结果保存在id属性指定的地方，onError是处理出错后的回调，定义已经在上文中提到过了。除非是特别严重的错误，否则我们不建议因为出错而不调用onComplete。因为如果您不调用onComplete，系统会认为您的标签尚未处理完成，整个处理过程将无法继续。


三. 上下文环境的操作

上下文环境是个数组，其中下标为0的对象为“当前上下文”，数组末尾的对象为“根上下文”，一般来说“根上下文”是我们人为提供的，就像Hello World程序里定义的那个上下文对象。其他上下文对象则是在运行xml时产生的，至于为什么产生，什么时候会产生，这些问题在下文中介绍具体介绍标签时讲解。

有了上下文环境，我们就需要在上下文环境总读取和写入数据，通过标签的value属性可从上下文环境中读取数据。

读取的量可分常量与变量，常量分为string，number，boolean三种类型，例如"string/hello world"是字符串常量，"number/110"是数字常量，"boolean/true"是布尔型常量，其余写法都算作变量。

@root是一个关键字，代表根上下文，我们可以以@root.attr的方式访问根上下文的属性，也可以@root.attr.attr2的方式进一步访问。@this也是一个关键字，代表当前上下文环境。如果不使用关键字，比如myBall.x这样的方式，则系统首先搜索当前上下文环境是否有myBall属性，若是没有，则再向上一级搜索，直到搜索到根上下文环境，这一点类似与JS的属性访问规则。

通过id属性可保存标签执行的结果，若是id为myBall.x，那么首先系统将在上下文环境中由内向外搜索myBall属性，找到myBall对象后往其内设置x属性。若是myBall属性不存在，则将会在其当前上下文对象中建立myBall属性，并且设置x属性。同样的myBall.positon.x的话，若是myBall不存在，则建立之，而后建立positon，最后设置x。id的设置同样支持@root和@this，若是id直接等于@this或者@root，那么你就能直接把上下文对象给覆盖了。。这相当危险但是有用。

 

四. 标签详解

asea：所有标签中最重要的一个，该标签什么属性也不支持，但是它却是其他标签正常运行的容器，它一般作为根节点或者被其他标签处理器作为父类；

bean：

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


定义一个对象的定义（并不直接执行内部代码），内部第一个标签必须是new标签，new标签执行前当前上下文对象是个空对象，new标签之后当前上下文对象变成new出来的对象。而后的代码可对new出来的对象设置属性等操作。。。bean标签的执行结果是一个对象定义，当每次被访问时，都会执行一次对应的bean标签内部的代码并得到构造出来的内容。

class：

        /**
         * example: <class id="MyClass" constructor="com.alibado.lib.DemoClass" />
         */

定义一个类的别名，constructor属性是类的完整命名，id是类的别名。实际上该别名就是上下文环境中的一个Class对象。

get：

        /**
         * example:
         * <get id="myPen" value="pen" >
         */

获取属性或者转存属性，get标签的执行结果就是value属性中指定的属性。

if：

        /**
         * example:
         * <if value="id">
         *     <lib value="http://www.alibado.com/lib/myLib.swf" />
         *     <class id="MyClass" value="com.alibado.lib.DemoClass" />
         * </if>
         * 
         */


逻辑判断功能的标签，若是value内的值是布尔型true，则执行内部内容，否则不执行任何操作。

lib：

        /**
         * example: <lib src="http://www.alibado.com/lib/myLib.swf" />
         */

该标签是动态加载swf库到当前applicationDomain。

method：

        /**
         * example:
         * <method id="pic" value="draw">
         *     <get value="number/400" />
         *     <get value="number/300" />
         *     <get value="string/this is my title" />
         * </method>
         */


该标签是执行一个方法，其value值对应的对象必须是个Function，否则结果你懂的。。标签的输出是函数执行结果。标签的子标签是参数。实际上参数可以是任何标签，只要能产生输出均可，内部标签的当前上下文对象是个数组，该数组将最终成为Function执行的参数。

new：

        /**
         * example:
         * <new id="myPic" value="Pic">
         *     <get value="box" />
         *     <get value="number/400" />
         *     <get value="number/300" />
         *     <get value="string/this is my title" />
         * </new>
         */


该标签的功能是实例化一个对象，value的值可以是上下文中的Class对象，也可以是类的全名（先搜索上下文内容）。new标签输出结果是实例化的结果。new标签内部的标签是构造函数参数，其实现原理与method标签一样，另外，构造函数参数个数不能超过十个。。。

selector：

        /**
         * example:
         * <selector>
         *     <if value="id1">
         *         <lib value="http://www.alibado.com/lib/myLib.swf" />
         *         <class id="MyClass" value="com.alibado.lib.DemoClass" />
         *     </if>
         *     <if value="id2">
         *         <lib value="http://www.alibado.com/lib/myLib.swf" />
         *         <class id="MyClass" value="com.alibado.lib.DemoClass" />
         *     </if>
         * </selector>
         * 
         * 子节点规则：onComplete参数第一个为true则跳出，否则继续。
         */


该标签类似于switch，当其内部标签的执行结果是true的时候，才停止执行，否则将一直执行下去。

trace：

        /**
         * example: <trace value="string/hello world" />
         */

该标签直接在控制台输出value的内容，用于调试。

with：

        /**
         * example:
         * <with value="ball">
         *     <get id="aa" value="number/400" />
         *     <get id="bb" value="number/300" />
         *     <get id="cc" value="string/this is my title" />
         * </with>
         */


该标签为其内部的标签创造一个当前上下文对象，内部标签的当前上下文对象变成由value指定的对象。