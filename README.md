asea
====

An ioc library for as3

====

���ߣ�Clifford http://www.cnblogs.com/flash3d/

�ÿ����������Ϊ�˷�������RSL���������ֹ�������Spring�ӽ������Ըɴ�Թ������¹滮��һ��ȡ��ΪAsea����AS3��ʵ���˻�����IOC���ܡ�

������������ѧ�����ʹ��Asea��

һ. Hello World

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
//				//��������xml
//				var xml:XML = new XML(<asea><trace value="string/hello world"/></asea>);
//				
//				//��ȡ���ڵ㴦����
//				var asea:EaDrop = EaConfig.getDrop("asea");
//				
//				//���������Ķ���
//				var context:Object = {};
//				
//				//ִ��
//				asea.process(xml, [context]);
//			}
//		}
//		
//	}

������������չ��������ʹ��Asea�Ľ���Ҫ�Ĳ���

����xml�ж�������Ҫִ�е��������ľ����﷨����������ܡ�

�����Ķ�����xml����ִ�е����ݻ��������仰˵����������xml�����д������Ķ����л�ȡ���ݺ�д�����ݣ������Գ��԰������Ķ������Ᵽ���������������Ϳ���ͨ������ȡ�������Ľ���ˡ���������һ�㣬������������Ķ��󲢷Ƕ�̬������ô����������xml��д�������Ļ����в����ڵ�����ʱ��ϵͳ������ReferenceError������Ȼһ����˵��û�б�Ҫ��ô����

���ڵ㴦��������һ�����䣬����ִ����������������ݽ��������������������ڵ㴦������EaConfig�л�ȡ��һ����˵��ȡ�����ǡ�asea���ĸ��ڵ㴦�����ǲ����ģ��������ǳ�ȷ�е�֪�����ĸ��ڵ���ʲô��ǩ�����ⷽ��process�ĵ����������ǳɹ���Ļص����䶨��Ӧ����function(result:* = null):void��result�����Ľ����������ĸ��ڵ��ǡ�asea������ôresult�϶���null���ûص����ڵ��������ڣ���������xml�������첽����ģ�������xml�м��ظ�����ʲô�ġ���process�ĵ��ĸ������ǳ����Ļص���������function(errorCode:int, message:String, target:String, xml:XML):void��

���ˣ������ܻ�ע�⵽process�ĵڶ�����������ֱ����context���󣬶���һ��ֻ��contextһ��Ԫ�ص����顣��������漰�������������������������ý��ں��潲������֪��������������̫�Ѻã�ϣ���ĸ������ܰ����ٷ�װһ��ɡ�
 

��. ��ǩ������

AseaĿǰ�ṩ�ı�ǩ�У�asea��class��get��if��lib��method��new��selector��trace��with��bean��

��������EaConfig������drops�������ҵ���Щ���壬drops�Ǹ��������б�ǩ�����������飬������������Լ��ı�ǩ������������push����������м�����Ч��

���еı�ǩ���������̳�EaDrop����࣬��ֻ�踲��onProcess������get name�������ɶ����Լ��ı�ǩ����������������һ�㣬��ǩ����������״̬�ģ�ȫ��Ψһʵ��������������ı������Ƕ����ڷ������ڣ���ҪС�Ĵ����ˡ�

������������򵥵ı�ǩ������

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

��EaGet�и�����public function get name():String����Ҫ�ڸ÷����з��ظñ�ǩ��������Ҫ����ı�ǩ����

���⻹Ҫ����protected function onProcess(dom:XML, value:*, contexts:Array, onComplete:Function, onError:Function = null):void���÷����ĵ�һ�������Ǵ����xml��ϵͳ�ᱣ֤��xml�ĸ��ڵ�������get name��ָ�������֣��ڶ�������value���ڱ�ǩ�е�value�����������Ļ����в�ѯ�������ݣ����������֪����ѯ�Ľ�����Լ�����value���ԣ���ô����ȥ����xml.@value�ɣ�contexts�������Ļ�����onComplete�Ǵ���ɹ���Ļص���������ı�ǩ������������������ô����onComplete���洫�ݽ���ɣ�������Ĵ��������������ҲҪ����һ��onComplete����Ϊ����������������onComplete���еģ�������ı�ǩ��id�������������˽������ôϵͳ���Զ������Ľ��������id����ָ���ĵط���onError�Ǵ�������Ļص��������Ѿ����������ᵽ���ˡ��������ر����صĴ��󣬷������ǲ�������Ϊ�����������onComplete����Ϊ�����������onComplete��ϵͳ����Ϊ���ı�ǩ��δ������ɣ�����������̽��޷�������


��. �����Ļ����Ĳ���

�����Ļ����Ǹ����飬�����±�Ϊ0�Ķ���Ϊ����ǰ�����ġ�������ĩβ�Ķ���Ϊ���������ġ���һ����˵���������ġ���������Ϊ�ṩ�ģ�����Hello World�����ﶨ����Ǹ������Ķ������������Ķ�������������xmlʱ�����ģ�����Ϊʲô������ʲôʱ����������Щ�����������н��ܾ�����ܱ�ǩʱ���⡣

���������Ļ��������Ǿ���Ҫ�������Ļ����ܶ�ȡ��д�����ݣ�ͨ����ǩ��value���Կɴ������Ļ����ж�ȡ���ݡ�

��ȡ�����ɷֳ����������������Ϊstring��number��boolean�������ͣ�����"string/hello world"���ַ���������"number/110"�����ֳ�����"boolean/true"�ǲ����ͳ���������д��������������

@root��һ���ؼ��֣�����������ģ����ǿ�����@root.attr�ķ�ʽ���ʸ������ĵ����ԣ�Ҳ����@root.attr.attr2�ķ�ʽ��һ�����ʡ�@thisҲ��һ���ؼ��֣�����ǰ�����Ļ����������ʹ�ùؼ��֣�����myBall.x�����ķ�ʽ����ϵͳ����������ǰ�����Ļ����Ƿ���myBall���ԣ�����û�У���������һ��������ֱ���������������Ļ�������һ��������JS�����Է��ʹ���

ͨ��id���Կɱ����ǩִ�еĽ��������idΪmyBall.x����ô����ϵͳ���������Ļ�����������������myBall���ԣ��ҵ�myBall���������������x���ԡ�����myBall���Բ����ڣ��򽫻����䵱ǰ�����Ķ����н���myBall���ԣ���������x���ԡ�ͬ����myBall.positon.x�Ļ�������myBall�����ڣ�����֮��������positon���������x��id������ͬ��֧��@root��@this������idֱ�ӵ���@this����@root����ô�����ֱ�Ӱ������Ķ���������ˡ������൱Σ�յ������á�

 

��. ��ǩ���

asea�����б�ǩ������Ҫ��һ�����ñ�ǩʲô����Ҳ��֧�֣�������ȴ��������ǩ�������е���������һ����Ϊ���ڵ���߱�������ǩ��������Ϊ���ࣻ

bean��

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


����һ������Ķ��壨����ֱ��ִ���ڲ����룩���ڲ���һ����ǩ������new��ǩ��new��ǩִ��ǰ��ǰ�����Ķ����Ǹ��ն���new��ǩ֮��ǰ�����Ķ�����new�����Ķ��󡣶���Ĵ���ɶ�new�����Ķ����������ԵȲ���������bean��ǩ��ִ�н����һ�������壬��ÿ�α�����ʱ������ִ��һ�ζ�Ӧ��bean��ǩ�ڲ��Ĵ��벢�õ�������������ݡ�

class��

        /**
         * example: <class id="MyClass" constructor="com.alibado.lib.DemoClass" />
         */

����һ����ı�����constructor�������������������id����ı�����ʵ���ϸñ������������Ļ����е�һ��Class����

get��

        /**
         * example:
         * <get id="myPen" value="pen" >
         */

��ȡ���Ի���ת�����ԣ�get��ǩ��ִ�н������value������ָ�������ԡ�

if��

        /**
         * example:
         * <if value="id">
         *     <lib value="http://www.alibado.com/lib/myLib.swf" />
         *     <class id="MyClass" value="com.alibado.lib.DemoClass" />
         * </if>
         * 
         */


�߼��жϹ��ܵı�ǩ������value�ڵ�ֵ�ǲ�����true����ִ���ڲ����ݣ�����ִ���κβ�����

lib��

        /**
         * example: <lib src="http://www.alibado.com/lib/myLib.swf" />
         */

�ñ�ǩ�Ƕ�̬����swf�⵽��ǰapplicationDomain��

method��

        /**
         * example:
         * <method id="pic" value="draw">
         *     <get value="number/400" />
         *     <get value="number/300" />
         *     <get value="string/this is my title" />
         * </method>
         */


�ñ�ǩ��ִ��һ����������valueֵ��Ӧ�Ķ�������Ǹ�Function���������㶮�ġ�����ǩ������Ǻ���ִ�н������ǩ���ӱ�ǩ�ǲ�����ʵ���ϲ����������κα�ǩ��ֻҪ�ܲ���������ɣ��ڲ���ǩ�ĵ�ǰ�����Ķ����Ǹ����飬�����齫���ճ�ΪFunctionִ�еĲ�����

new��

        /**
         * example:
         * <new id="myPic" value="Pic">
         *     <get value="box" />
         *     <get value="number/400" />
         *     <get value="number/300" />
         *     <get value="string/this is my title" />
         * </new>
         */


�ñ�ǩ�Ĺ�����ʵ����һ������value��ֵ�������������е�Class����Ҳ���������ȫ�������������������ݣ���new��ǩ��������ʵ�����Ľ����new��ǩ�ڲ��ı�ǩ�ǹ��캯����������ʵ��ԭ����method��ǩһ�������⣬���캯�������������ܳ���ʮ��������

selector��

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
         * �ӽڵ����onComplete������һ��Ϊtrue�����������������
         */


�ñ�ǩ������switch�������ڲ���ǩ��ִ�н����true��ʱ�򣬲�ִֹͣ�У�����һֱִ����ȥ��

trace��

        /**
         * example: <trace value="string/hello world" />
         */

�ñ�ǩֱ���ڿ���̨���value�����ݣ����ڵ��ԡ�

with��

        /**
         * example:
         * <with value="ball">
         *     <get id="aa" value="number/400" />
         *     <get id="bb" value="number/300" />
         *     <get id="cc" value="string/this is my title" />
         * </with>
         */


�ñ�ǩΪ���ڲ��ı�ǩ����һ����ǰ�����Ķ����ڲ���ǩ�ĵ�ǰ�����Ķ�������valueָ���Ķ���