package
{
    import com.alibado.asea.*;
    
    import flash.display.Sprite;
    
    public class AseaTest extends Sprite
    {
        public function AseaTest()
        {
            testCase5();
        }
        
        public function testCase1():void
        {
            var xml:XML = new XML(<asea><trace value="string/hello world"/></asea>);
            var asea:EaDrop = EaConfig.getDrop("asea");
            var context:Object = {};
            asea.process(xml, [context]);
        }
        
        public function testCase2():void
        {
            var xml:XML = new XML(<asea><trace value="hel.lo"/></asea>);
            var asea:EaDrop = EaConfig.getDrop("asea");
            var context:Object = {"hello":"hello world 2", "hel":{"lo":"miss you!"}};
            asea.process(xml, [context]);
        }
        
        public function testCase3():void
        {
            var xml:XML = new XML(<asea><with value="hel"><get id="hello" value="string/你好" /><trace value="hello"/></with></asea>);
            var asea:EaDrop = EaConfig.getDrop("asea");
            var context:Object = {"hello":"hello world 2", "hel":{"lo":"miss you!"}};
            asea.process(xml, [context]);
        }
        
        public function testCase4():void
        {
            var xml:XML = new XML(
                  <asea>
                    <lib src="c.swf" />
                    <selector>
                        <if value="boolean/true">
                            <trace value="string/case2" />
                            <class id="Shape" constructor="ball" />
                        </if>
                        <if value="boolean/true">
                            <trace value="string/case1" />
                            <class id="Shape" constructor="rect" />
                        </if>
                    </selector>
                    <new id="shape" value="Shape" />
                    <get id="sb.sb.sb" value="string/sb" />
                    <trace value="sb.sb.sb" />
                    <trace value="shape" />
                    <with value="stage">
                        <method value="stage.addChild">
                            <get value="shape" />
                        </method>
                        <get id="@root.cc" value="string/cc" />
                        <trace value="cc" />
                    </with>
                </asea>
            );
            var asea:EaDrop = EaConfig.getDrop("asea");
            var context:Object = {"hello":"hello world 2", "hel":{"lo":"miss you!"}, "stage":stage};
            asea.process(xml, [context]);
        }
        
        public function testCase5():void
        {
            var xml:XML = new XML(
                  <asea>
                    <lib src="c.swf" />
                    <selector>
                        <if value="boolean/true">
                            <trace value="string/case2" />
                            <class id="Shape" constructor="ball" />
                        </if>
                        <if value="boolean/true">
                            <trace value="string/case1" />
                            <class id="Shape" constructor="rect" />
                        </if>
                    </selector>
                    <bean id="firstBean">
                        <new value="Shape" />
                        <get id="x" value="number/200" />
                        <method value="addChild">
                            <get value="sedBean" />
                        </method>
                    </bean>
                    <bean id="sedBean">
                        <new value="rect" />
                        <get id="width" value="number/50" />
                        <get id="height" value="number/50" />
                    </bean>
                    <method value="stage.addChild">
                        <get value="firstBean" />
                    </method>
                </asea>
            );
            var asea:EaDrop = EaConfig.getDrop("asea");
            var context:Object = {"hello":"hello world 2", "hel":{"lo":"miss you!"}, "stage":stage};
            asea.process(xml, [context]);
        }
    }
}