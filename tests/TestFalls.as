package
{
    import com.alibado.asea.falls.EaFallAction;
    import com.alibado.asea.falls.EaFalls;
    
    import flash.display.Sprite;
    
    public class TestFalls extends Sprite
    {
        public function TestFalls()
        {
            super();
            var falls:EaFalls = new EaFalls();
            falls.actions.add(new EaFallAction(new FallsItem(), [0]));
            falls.actions.add(new EaFallAction(new FallsItem(), [1]));
            falls.actions.add(new EaFallAction(new FallsItem(), [2]));
            falls.actions.add(new EaFallAction(new FallsItem(), [3]));
            falls.actions.add(new EaFallAction(new FallsItem(), [4]));
            falls.actions.add(new EaFallAction(new FallsItem(), [5]));
            falls.actions.add(new EaFallAction(new FallsItem(), [6]));
            falls.actions.add(new EaFallAction(new FallsItem(), [7]));
            falls.actions.add(new EaFallAction(new FallsItem(), [8]));
            falls.setOnComplete(function(target:EaFalls):void{
                trace("complete!");
            });
            var count:int = 0;
            falls.setOnProgress(function(action:EaFallAction, target:EaFalls):void{
                trace("progress!");
                count++;
                trace("count:" + count);
                switch (count)
                {
                    case 2:
                        trace("delete")
                        falls.actions.removeAt(3);
                        break;
                }
            });
            falls.play();
        }
    }
}

import com.alibado.asea.falls.EaFalls;
import com.alibado.asea.falls.IEaFallAble;

import flash.events.TimerEvent;
import flash.utils.Timer;

class FallsItem implements IEaFallAble
{
    
    private var timer:Timer;
    private var falls:EaFalls;
    private var id:int;
    
    public function _fallRun(f:EaFalls, args:Array):void
    {
        falls = f;
        id = args[0];
        timer = new Timer(10, 5);
        timer.addEventListener(TimerEvent.TIMER, function(e:TimerEvent):void {
            trace(id + ":" + timer.currentCount);
        });
        timer.addEventListener(TimerEvent.TIMER_COMPLETE, function(e:TimerEvent):void {
            f._onNext();
        });
        timer.start();
    }
    
    public function _fallAbort():void
    {
        timer.stop();
    }
}