/*
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
 *
 * This file is part of HxSignal
 *
 * Copyright (C) 2013 German Allemand
 *
 * HxSignal is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 3 of the License, or (at your option) any later version.
 *
 * HxSignal is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; If not, see <http://www.gnu.org/licenses/>.
 */

package hxsignal.impl;

import haxe.Constraints.Function;
import hxsignal.impl.Rest;
import hxsignal.ResultProcessor;

/**
 * ...
 * @author German Allemand
 */
class RSignalObj<SlotType:Function, R> extends SignalObj<SlotType> {
  #if haxe4 
  static final
  #else 
  static var 
  #end 
  noopProcessor = new NoOpResultProcessor();

  public var resultsProcessor: ResultProcessor<R> = cast noopProcessor;

  public function new() {
    super();
  }

  #if (js || python || hl || hxsignal_dynamic)
  override public function emit(args: Rest<Any>): #if haxe4 R #else Any #end {
    this.resultsProcessor.beforeStart();
    this.doEmit(
      function(slot) {
        return this.resultsProcessor.afterSlotCalled(#if haxe4 inline #end Reflect.callMethod(null, slot, args));
      }
    );
    return this.resultsProcessor.getFinalResult();
  }
  #end
}
