HxSignal: Simple Haxe Signal
========

My motivation was to create a simple API for callback functions, I thought that Haxe must have a signals and slots toolkit generic, type safe, flexible and efficient. There are already fantastic signal toolkits for Haxe, but I wanted to give to signal this touch or tweak I think were missing. I like the implementation of msignal, so my first try was to give it my touch but soon I realized it will be different taking C++ Boost and Qt signals as base.

Basic usage
-----------
<pre>
  // initialisation
  var voidSignal  = new Signal&lt;Void -> Void>();
  var eventSignal = new Signal&lt;AnyObject -> String -> Void>();
  var signal1     = new Signal&lt;Int -> Void>();
  
  // connecting, adding or binding slot
  voidSignal.connect(function() {});
  
  // connecting once (disconnected the first time it is called)
  eventSignal.connect(function(origin, type) {}, Once);
  
  // disconnecting slot
  function slot1(num : Int) : Void { }
  
  signal1.disconnect(slot1);
  
  // emitting
  voidSignal.emit();
  eventSignal.emit(this, "clicked");
  signal1.emit(123);
</pre>

Advanced usage
--------------
<pre>
// connecting n times (disconnected the nth time it is called)
eventSignal.connect(function(origin, type) {}, Times(n));

// Add slots to groups
signal1.connect(slot1, 1); // slot1 added to group 1
signal1.connect(slot1bis, 2); // slot added to group 2

// disconnect all slots in group 1
signal1.disconnectGroup(1);

// priority
signal1.connect(slot1, 1, AtBack);
signal1.connect(slot1bis, 1, AtFront); // slot1bis is called first then slot1
</pre>

Responding a signal
-------------------
<pre>
  // slot that adds 1 to emitted value
  function add1(value : Int) : Int {
    return value + 1;
  }

  // slot that add 2 to emitted value
  function add2(value : Int) : Int {
    return value + 2;
  }
  
  var signalWithResponse = new Signal&lt;Int->Int>();
  signalWithResponse.connect(add1);
  signalWithResponse.connect(add2);
  
  var result = signalWithResponse.emit(3); // result == 5
</pre>
Why is result 5? Because signal always return the last result as default behavior, in this case add2(3) has returned 3 + 2 = 5

Handling the signal responses
-----------------------------
Let's add a results processor...
<pre>
  // responses == [add1(x), add2(x)] where x is the emitted integer
  signalWithResponse.resultsProcessor = function (responses:Array&lt;Int>) {
    var result = 0;
    for (i in responses)
       result += i;
    return result;
  }
  
  var processedResult = signalWithResponse.emit(3); // result == 9
</pre>
This time emit function returns the processed value and it is 9 because resultsProcessor has added the responses of call add1(3) and add2(3) (4 and 5 respectively). 


Also
----
- disconnectAll() // disconects all the slots
- block(slot, true)     // block slot (not called) until block(slot, false) is called
- isBlock(slot)
- numSlots  	  // amount of slot connected
- and more features are coming
