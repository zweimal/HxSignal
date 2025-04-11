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
import hxsignal.impl.SlotMap;
import hxsignal.Signal;

/**
 * ...
 * @author German Allemand
 */
class SignalObj<SlotType:Function> {
  var emitting: Bool;

  /**
   * The current number of slots connected to the signal.
   */
  public var numSlots(get, null): Int;

  function get_numSlots()
    return slots.length;

  var slots: SlotMap<SlotType>;

  public function new() {
    this.slots = new SlotMap();
  }

  public function connect(slot: SlotType, ?times: ConnectionTimes, ?groupId: Int = null, ?at: ConnectPosition = null): Void {
    if (times == null) {
      times = Forever;
    }
    if (!updateConnection(slot, times)) {
      var conn = new Connection(this, slot, times);

      this.slots.insert(conn, groupId, at);
    }
  }

  function updateConnection(slot: SlotType, times: ConnectionTimes, ?groupId: Int, ?at: ConnectPosition): Bool {
    var con = this.slots.get(slot);

    if (con == null)
      return false;

    if ((groupId != null && con.groupId != groupId) || at != null) {
      this.slots.disconnect(slot);
      return false;
    }

    con.times = times;
    con.calledTimes = 0;
    con.connected = true;

    return true;
  }

  public function isConnected(slot: SlotType): Bool {
    return this.slots.has(slot);
  }

  #if (js || python || hl || hxsignal_dynamic)
  public function emit(args: Rest<Any>): Any {
    this.doEmit(function(slot) {
      #if haxe4 inline #end Reflect.callMethod(null, slot, args);
    });
    return null;
  }
  #end

  inline function doEmit(slotCaller: SlotType -> Void): Void {
    this.emitting = true;
    for (group in slots.groups) {
      for (con in group) {
        if (con.connected && !con.blocked) {
          con.calledTimes++;
          slotCaller(con.slot);

          if (!con.connected)
            this.slots.disconnect(con.slot);

          if (con.times == Once)
            con.times = Times(1);

          switch (con.times) {
            case Times(t):
              if (t <= con.calledTimes)
                this.slots.disconnect(con.slot);

            case _:
          }
        }
      }
    }
    this.emitting = false;
  }

  public function block(slot: SlotType, flag: Bool): Void {
    var con = this.slots.get(slot);
    if (con == null)
      return;

    con.blocked = flag;
  }

  public function isBlocked(slot: SlotType): Bool {
    var con = this.slots.get(slot);
    if (con == null)
      return false;

    return con.blocked;
  }

  public function disconnect(slot: SlotType): Bool {
    return this.slots.disconnect(slot);
  }

  public function disconnectAll(): Void {
    if (emitting)
      this.slots.disconnectAll();
    else
      this.slots.clear();
  }

  public function disconnectGroup(id: Int): Bool {
    return this.slots.disconnectGroup(id);
  }
}
