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

/**
  Signal that calls slots with no arguments.
  @author German Allemand
**/
@:forward
abstract Signal0(SignalObj<Void -> Void>) to SignalObj<Void -> Void> {
  public inline function new() {
    this = new SignalObj<Void -> Void>();
  }

  /**
    Calls the slots with no arguments.
  **/
  #if (js || python || hl || hxsignal_dynamic)
  public inline function emit(): Void {
    this.emit(
      #if haxe4
      #else
      []
      #end
    );
  }
  #else
  @:access(hxsignal.impl.SignalObj)
  public function emit(): Void {
    this.doEmit(function(slot) {
      slot();
    });
  }
  #end
}
