package ;

import hxsignal.Signal;

/**
 * ...
 * @author German Allemand
 */
class Emitter
{
	public var signal0(default, null) = new Signal<Void->Void>();
	public var signal1(default, null) = new Signal<String->Void>();
	public var signal2(default, null) = new Signal<Emitter->Int->Void>();
	public var signal0r(default, null) = new Signal<Void->Int>();
	public var signal2r(default, null) = new Signal<Int->Int->Int>();

	public function new()
	{

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

	public function action2r(x : Int, y : Int) : Int
	{
		return signal2r.emit(x, y);
	}
}