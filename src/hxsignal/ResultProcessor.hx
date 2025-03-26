package hxsignal;

interface ResultProcessor<R> {
  function beforeStart(): Void;
  function afterSlotCalled(value: R): Void;
  function getFinalResult(): R;
}

class NoOpResultProcessor implements ResultProcessor<Any> {
  public function new() {}

  public function beforeStart() {}

  public function afterSlotCalled(result: Any) {}

  public function getFinalResult(): Any {
    return null;
  }
}
