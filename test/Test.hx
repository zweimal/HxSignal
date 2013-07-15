package ;

import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.Lib;
import haxe.unit.TestRunner;

/**
 * ...
 * @author German Allemand
 */

class Test 
{
	static function main() 
	{
		var stage = Lib.current.stage;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		
		var r = new TestRunner();
		r.add(new SignalTest());
		
		r.run();
	}
}