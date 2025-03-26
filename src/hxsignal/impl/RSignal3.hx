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
  Signal that calls slots with three arguements.
  @author German Allemand
**/
@:forward
abstract RSignal3<T1, T2, T3, R>(RSignalObj<T1 -> T2 -> T3 -> R, R>) to RSignalObj<T1 -> T2 -> T3 -> R, R> {
  public function new() {
    this = new RSignalObj<T1 -> T2 -> T3 -> R, R>(Slot3.call);
  }

  public inline function emit(a1: T1, a2: T2, a3: T3): R {
    return this.emit(a1, a2, a3);
  }
}
