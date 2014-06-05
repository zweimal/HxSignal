package ;

import hxsignal.Signal;

/**
 * ...
 * @author German Allemand
 */
class Emitter
{
	public var signal0(default, null) : Signal<Void->Void>;
	public var signal1(default, null) : Signal<String->Void>;
	public var signal2(default, null) : Signal<Emitter->Int->Void>;
	public var signal0r(default, null) : Signal<Void->Int>;
	
	public function new() 
	{
		signal0 = new Signal<Void->Void>();
		signal1 = new Signal<String->Void>();
		signal2 = new Signal<Emitter->Int->Void>();
		signal0r = new Signal<Void->Int>();
	}
	
	public function action0() : Void
	{
		signal0.emit();
	}
	
	public function action1() : Void
	{
		signal1.emit("World!!!");
	}
	
	public function action2(num : Int) : Void
	{
		signal2.emit(this, num);
	}
	
	public function action0r() : Int
	{
		return signal0r.emit();
	}
}