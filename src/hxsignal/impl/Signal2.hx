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

import hxsignal.impl.Slot;

/**
  Signal that calls slots with two arguements.
  @author German Allemand
**/
@:forward
abstract Signal2<T1, T2>(SignalObj<T1 -> T2 -> Void>) to SignalObj<T1 -> T2 -> Void> {
  public function new() {
    this = new SignalObj<T1 -> T2 -> Void>(Slot2.call);
  }

  /**
    Calls the slots with two arguments.
  **/
  public inline function emit(a1: T1, a2: T2): Void {
    this.emit(a1, a2);
  }
}
