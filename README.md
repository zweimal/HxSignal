HxSignal: Simple Haxe Signal
========

My motivation was to create a simple API for callback functions, I thought that Haxe must have a signal and slot toolkit generic, type safe, flexible and efficient. There are already fantastic signal toolkits for Haxe, but I wanted to give to signal this touch or tweak I think were missing. I like the implementation of msignal, so my first try was to give it my touch but soon I realized it will be different taking as base C++ Boost signal and the operators of C# Events and adding to the combo an abstract type, macros and operators overloading.
After some research, coding, testing and effort HxSignal was born!

Basic usage
-----------
<pre>
  // initialisation
  var voidSignal  = new Signal&lt;Void -> Void>();
  var eventSignal = new Signal&lt;AnyObject -> String -> Void>();
  var signal1     = new Signal&lt;Int -> Void>();
  
  // connecting, adding or binding slot
  voidSignal += function() {};
  
  // connecting once (disconnected the first time it is called)
  eventSignal &lt;&lt; function(origin, type) {};
  
  // disconnecting slot
  function slot1(num : Int) : Void { }
  
  signal1 -= slot1;
  
  // emitting
  voidSignal.emit();
  eventSignal.emit(this, "clicked");
  signal1.emit(123);
</pre>

Advanced usage
--------------
<pre>
// Add slots to groups
signal1.connect(slot1, 1); // slot1 added to group 1
signal1.connect(slot1bis, 2); // slot added to group 2

// disconnect all slot in a group
signal1.disconnectGroup(1);

// priority
signal1.connect(slot1, 1, AtBack);
signal1.connect(slot1bis, 1, AtFront); // slot1bis is called first then slot1
</pre>

Also
----
- disconnectAll() // disconects all the slots
- block(slot, true)     // block slot (not called) until block(slot, false) is called
- isBlock(slot)
- numSlots  	  // amount of slot connected
- and more features are coming
