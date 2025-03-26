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
import haxe.Rest;
import hxsignal.ResultProcessor;

typedef RSlotCaller<T:Function, R> = Slot<T> -> Rest<Any> -> R;

/**
 * ...
 * @author German Allemand
 */
class RSignalObj<SlotType:Function, R> extends SignalObj<SlotType> {
  static final noopProcessor = new NoOpResultProcessor();

  public var resultsProcessor: ResultProcessor<R> = cast noopProcessor;

  var actualSlotCaller: RSlotCaller<SlotType, R>;

  public function new(slotCaller: RSlotCaller<SlotType, R>) {
    super(this.forwardCall);
    this.actualSlotCaller = slotCaller;
  }

  function forwardCall(slot: Slot<SlotType>, ...args) {
    this.resultsProcessor.afterSlotCalled(this.actualSlotCaller(slot, ...args));
  }

  override public function emit(...args): R {
    this.resultsProcessor.beforeStart();
    super.emit(...args);
    return this.resultsProcessor.getFinalResult();
  }
}
