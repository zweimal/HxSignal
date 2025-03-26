package hxsignal.macro;

import haxe.PosInfos;
#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
#end

abstract SignalInfer(Null<Dynamic>) {
  #if macro
  static var validSignals = ~/Signal[0-9]$/;
  #end

  macro public static function createSignal() {
    return inferSignal(Context.currentPos());
  }

  macro public static function signal() {
    return inferSignal(Context.currentPos());
  }

  #if macro
  static function inferSignal(pos: Position): Null<Expr> {
    var type = Context.getExpectedType();
    // trace("expected type: " + type);
    if (type != null) {
      switch (type) {
        case TAbstract(_.get() => {pack: ["hxsignal", "impl"], name: name}, _) if (name.indexOf("Signal") != -1):
          return getExpr(type, pos);

        case TInst(_.get() => {pack: ["hxsignal", "impl"], name: name}, _) if (name.indexOf("Signal") != -1):
          throw new Error("Signal: " + name + " is an abstract class.", pos);

        case TInst(_.get() => {pack: ["hxsignal"], name: "Signal"}, _):
          return getExpr(type, pos);
        case TMono(_):
          throw new Error("Signal: Missing Signal type.", pos);
        default:
          throw new Error("Signal: Cannot create anything but a Signal.", pos);
      }
    }
    return macro null;
  }

  static function getExpr(type: Type, pos: Position): Expr {
    var complex = Context.toComplexType(type);
    return switch (complex) {
      case TPath(p):
        {expr: ENew(p, []), pos: pos};
      default:
        macro null;
    }
  }
  #end
}
