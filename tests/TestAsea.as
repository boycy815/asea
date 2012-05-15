package
{
    import com.alibado.asea.*;
    
    import flash.display.Sprite;
    import flash.utils.getTimer;
    
    public class TestAsea extends Sprite
    {
        
        private var time:int;
        
        public function TestAsea()
        {
            testCase1();
        }
        
        public function testCase1():void
        {
            time = getTimer();
            var xml:XML = new XML(
                <asea>
                  <lib value="c.swf" />
                  <method id="isEqual" value="equal">
                      <get value="number/100" />
                      <get value="number/101" />
                  </method>
                  <selector>
                      <if value="isEqual">
                          <trace value="string/case1" />
                          <class id="Shape" value="ball" />
                      </if>
                      <if value="boolean/true">
                          <trace value="string/case2" />
                          <class id="Shape" value="rect" />
                      </if>
                  </selector>
                  <get id="xCount" value="number/0" />
                  <bean id="firstBean">
                      <new value="Shape" />
                      <get id="x" value="number/200" />
                      <get id="y" value="number/100" />
                      <method value="addChild">
                          <get value="sedBean" />
                      </method>
                      <method value="addChild">
                          <get value="sedBean" />
                      </method>
                      <method value="addChild">
                          <get value="sedBean" />
                      </method>
                      <method value="addChild">
                          <get value="sedBean" />
                      </method>
                      <method value="addChild">
                          <get value="sedBean" />
                      </method>
                  </bean>
                  <bean id="sedBean">
                      <new value="ball" />
                      <get id="width" value="number/10" />
                      <get id="height" value="number/10" />
                      <get id="x" value="xCount" />
                      <get id="y" value="xCount" />
                      <method id="xCount" value="add">
                          <get value="xCount" />
                          <get value="number/20" />
                      </method>
                  </bean>
                  <method value="stage.addChild">
                      <get id="@root.box" value="firstBean" />
                  </method>
                  <with value="box">
                      <get id="scaleX" value="number/0.5" />
                  </with>
                  <include value="included.xml" />
              </asea>
            );
            var asea:EaDrop = EaConfig.getDrop(xml.localName());
            var context:Object = {"equal":function(num1:Number, num2:Number):Boolean{return num1 == num2;}, "add":function(num1:Number, num2:Number):Number{return num1 + num2;}, "stage":stage};
            asea.process(xml, [context], onComplete, onError);
            
            trace("直接完成时间:" + (getTimer() - time));
        }
        
        private function onComplete(result:* = null):void
        {
            trace("完全完成时间:" + (getTimer() - time));
        }
        
        private function onError(errorCode:int, target:String, value:String, xml:XML):void
        {
            var message:String;
            switch(errorCode)
            {
                case 1001:
                    message = "找不到对应的节点处理器！";
                    break;
                case 1002:
                    message = "网络流错误！";
                    break;
                case 1003:
                    message = "找不到类！";
                    break;
                case 1004:
                    message = "找不到值！";
                    break;
                case 1005:
                    message = "找不到路径！";
                    break;
                case 1006:
                    message = "找不到函数！";
                    break;
                default:
                    message = "未知错误！";
                    break;
            }
            trace(message + ":" + target + "=" + value + "@" + xml.toXMLString());
        }
    }
}