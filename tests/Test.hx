package;

#if flash
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.Lib;
#end
import haxe.unit.TestRunner;

/**
 * ...
 * @author German Allemand
 */
class Test {
  static function main() {
    #if flash
    var stage = Lib.current.stage;
    stage.scaleMode = StageScaleMode.NO_SCALE;
    stage.align = StageAlign.TOP_LEFT;
    #end

    var r = new TestRunner();
    r.add(new SignalTest());

    r.run();
  }
}
