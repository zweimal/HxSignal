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

/**
 * ...
 * @author German Allemand
 */
 #if !haxe3 abstract #end
class ResponderSignal<SlotType:Function, R> extends SignalBase<SlotType> {
  public var resultsProcessor: Array<R> -> R;

  function doEmitWithResult(slotCaller: Slot<SlotType> -> R): R {
    var result = null;
    var all = [];

    this.doEmit(function (slot) return all.push(slotCaller(slot)));

    if (resultsProcessor != null)
      result = resultsProcessor(all);

    return result;
  }
}
