package ;

import haxe.unit.TestCase;

/**
 * ...
 * @author German Allemand
 */
class SignalTest extends TestCase
{
	var emitter : Emitter;
	
	public function new() 
	{
		super();
		emitter = new Emitter();
	}
	
	public function testSlot2()
	{
		emitter.signal2 << slot2;
		assertTrue(emitter.signal2.isConnected(slot2));
		
		emitter.action2(2);
		assertFalse(emitter.signal2.isConnected(slot2));
	}
		
	public function testSlot0()
	{
		emitter.signal0 << slot0_1;
		assertTrue(emitter.signal0.numSlots == 1);
		
		emitter.signal0 += slot0_1;
		assertTrue(emitter.signal0.numSlots == 1);
		
		emitter.signal0 << slot0_2;
		assertTrue(emitter.signal0.numSlots == 2);
		
		emitter.signal0 += slot0_3; 
		assertTrue(emitter.signal0.numSlots == 3);
		
		emitter.action0();
		assertTrue(emitter.signal0.numSlots == 1);
		
		emitter.signal0 -= slot0_1;
		assertTrue(emitter.signal0.numSlots == 0);
	}
	
	public function testSlot1()
	{
		var list = new List<String>();
		
		emitter.signal1 << slot1_unmatched.bind(_, "no problem");
		emitter.signal1 << function(name) list.add("1");
		emitter.signal1.connect(slot1_0, 1, AtBack);
		emitter.signal1.connect(slot1_1, 1, AtFront);
		emitter.signal1 << function(name) list.add("2"); // never called
		
		emitter.action1();
		
		assertTrue(list.join(",") == "1");
		assertTrue(emitter.signal1.numSlots == 0);
	}
	
	function slot0_1() : Void
	{
		trace("hello1");
	}
	
	function slot0_2() : Void
	{
		trace("hello2");
	}
	
	function slot0_3() : Void
	{
		emitter.signal0 -= slot0_3;
		trace("hello3");
	}
	
	function slot1_0(name : String) : Void
	{
		emitter.signal1.disconnectGroup(1);
	}
	
	function slot1_1(name : String) : Void
	{
		trace("hello 1_1");
	}
	
	function slot1_unmatched(name : String, p2 : String) : Void
	{
		trace("hello unmatched " + name + " " + p2);
	}
	
	function slot2(origin : Emitter, num : Int) : Void
	{
		assertTrue(num == 2);
	}
	
	
}