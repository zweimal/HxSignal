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
		emitter.signal2.connect(slot2, Once);
		assertTrue(emitter.signal2.isConnected(slot2));
		
		emitter.action2(2);
		assertFalse(emitter.signal2.isConnected(slot2));
	}
		
	public function testSlot0()
	{
		emitter.signal0.connect(slot0_1, Once);
		assertTrue(emitter.signal0.numSlots == 1);
		
		emitter.signal0.connect(slot0_1);
		assertTrue(emitter.signal0.numSlots == 1);
		
		emitter.signal0.connect(slot0_2, Once);
		assertTrue(emitter.signal0.numSlots == 2);
		
		emitter.signal0.connect(slot0_3); 
		assertTrue(emitter.signal0.numSlots == 3);
		
		emitter.action0();
		assertTrue(emitter.signal0.numSlots == 1);
		
		emitter.signal0.disconnect(slot0_1);
		assertTrue(emitter.signal0.numSlots == 0);
	}
	
	public function testSlot1()
	{
		var list = new List<String>();
		
		emitter.signal1.connect(slot1_unmatched.bind(_, "no problem"), Once);
		emitter.signal1.connect(function(name) list.add("1"), Once);
		emitter.signal1.connect(slot1_0, 1, AtBack);
		emitter.signal1.connect(slot1_1, 1, AtFront);
		emitter.signal1.connect(function(name) list.add("2"), Once); // never called
		
		emitter.action1();
		
		assertEquals(list.join(","), "1");
		assertEquals(emitter.signal1.numSlots, 0);
	}
	
	public function testSlot0r()
	{
		emitter.signal0r.connect(slot0r1, Once);
		emitter.signal0r.connect(slot0r2, Once);
		emitter.signal0r.resultsProcessor = processResults; 
		
		var result = emitter.action0r();
		assertEquals(result, 3);
	}
	
	function processResults(arr:Array<Int>):Int
	{
		var result = 0;
		for (i in arr)
			result += i;
		return result;
	}
	
	function slot0_1() : Void
	{
		trace("hello1");
	}
	
	function slot0r1() : Int
	{
		return 1;
	}
	
	function slot0r2() : Int
	{
		return 2;
	}
	
	function slot0_2() : Void
	{
		trace("hello2");
	}
	
	function slot0_3() : Void
	{
		emitter.signal0.disconnect(slot0_3);
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