package;

/**
 * ...
 * @author German Allemand
 */
class Receiver {
  public var slot0Calls: List<Int>;
  public var slot1Calls: List<String>;
  public var slot2Calls: List<Int>;

  public function new() {}

  public function reset(): Void {
    slot0Calls = new List();
    slot1Calls = new List();
    slot2Calls = new List();
  }
}
