package hxsignal.macro;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

using haxe.macro.Tools;

/**
 * ...
 * @author German Allemand
 */
class SignalMacro {
  #if macro
  public static function build(): Type {
    var type = Context.getLocalType();
    switch (type) {
      case TInst(_.get() => {pack: ["hxsignal"], name: "Signal"}, params):
        switch (params) {
          case [TFun(args, ret)]:
            var newType = getSignalType(args, ret);
            return newType;

          case []:
            return TPath({pack: ["hxsignal", "macro"], name: "SignalInfer"}).toType();

          case [TMono(t)]:
            trace(t);
            throw new Error("Signal: Cannot infer the Signal type, use Signal.createSignal() instead.", Context.currentPos());

          default:
        }

      default:
    }

    return type;
  }

  static function getSignalType(args: Array<{name: String, opt: Bool, t: Type}>, ret: Type): Type {
    var argCount = args.length;
    if (argCount > 3) {
      Context.error("Signal function error: Too many arguments", Context.currentPos());
    }
    var className = "Signal" + argCount;
    var params = [for (a in args) TPType(a.t.toComplexType())];

    switch (ret) {
      case TAbstract(_.get() => {pack: [], name: "Void"}, []):

      case _:
        className = "R" + className;
        params.push(TPType(ret.toComplexType()));
    }

    return TPath({pack: ["hxsignal", "impl"], name: className, params: params}).toType();
  }
  #end
}
