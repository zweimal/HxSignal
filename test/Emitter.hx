package ;

import hxsignal.Signal;

/**
 * ...
 * @author German Allemand
 */
class Emitter
{
	public var signal0 : Signal< Void -> Void >;
	public var signal1 : Signal< String -> Void > ;
	public var signal2 : Signal< Emitter -> Int -> Void >;
	
	public function new() 
	{
		signal0 = new Signal();
		signal1 = new Signal();
		signal2 = new Signal();
	}
	
	public function action0() : Void
	{
		(signal0.emit)();
	}
	
	public function action1() : Void
	{
		(signal1.emit)("World!!!");
	}
	
	public function action2(num : Int) : Void
	{
		(signal2.emit)(this, num);
	}
}