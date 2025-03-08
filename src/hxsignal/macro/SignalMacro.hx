package hxsignal.macro;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.PosInfos;

using haxe.macro.Tools;

/**
 * ...
 *  @author German Allemand
 */
class SignalMacro {
  public static function build(): Type {
    var type = Context.getLocalType();
    switch (type) {
      case TInst(_.get() => {pack: ["hxsignal"], name: "Signal"}, params):
        switch (params[0]) {
          case TFun(args, ret):
            var newType = getSignalType(args, ret);
            return newType;

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
        className = "Responder" + className;
        params.push(TPType(ret.toComplexType()));
    }

    return TPath({pack: ["hxsignal", "impl"], name: className, params: params}).toType();
  }
}
