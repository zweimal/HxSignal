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
import hxsignal.impl.SlotMap;
import hxsignal.Signal;

using Lambda;

/**
 * ...
 * @author German Allemand
 */
#if !haxe3 abstract #end
class SignalBase<SlotType:Function> {
  var emitting: Bool;

  /**
   * The current number of slots connected to the signal.
   */
  public var numSlots(get, null): Int;

  function get_numSlots()
    return slots.length;

  var slots: SlotMap<SlotType>;

  public function new() {
    slots = new SlotMap();
  }

  public function connect(slot: SlotType, ?times: ConnectionTimes, ?groupId: Int = null, ?at: ConnectPosition = null): Void {
    if (times == null) {
      times = Forever;
    }
    if (!updateConnection(slot, times)) {
      var conn = new Connection(this, slot, times);

      slots.insert(conn, groupId, at);
    }
  }

  function updateConnection(slot: SlotType, times: ConnectionTimes, ?groupId: Int, ?at: ConnectPosition): Bool {
    var con = slots.get(slot);

    if (con == null)
      return false;

    if ((groupId != null && con.groupId != groupId) || at != null) {
      slots.disconnect(slot);
      return false;
    }

    con.times = times;
    con.calledTimes = 0;
    con.connected = true;

    return true;
  }

  public function isConnected(slot: SlotType): Bool {
    return slots.has(slot);
  }

  inline function doEmit(slotCaller: Slot<SlotType> -> Void): Void {
    emitting = true;
    for (group in slots.groups) {
      for (con in group) {
        if (con.connected && !con.blocked) {
          con.calledTimes++;
          slotCaller(con.slot);

          if (!con.connected)
            slots.disconnect(con.slot);

          if (con.times == Once)
            con.times = Times(1);

          switch (con.times) {
            case Times(t):
              if (t <= con.calledTimes)
                slots.disconnect(con.slot);

            case _:
          }
        }
      }
    }
    emitting = false;
  }

  public function block(slot: SlotType, flag: Bool): Void {
    var con = slots.get(slot);
    if (con == null)
      return;

    con.blocked = flag;
  }

  public function isBlocked(slot: SlotType): Bool {
    var con = slots.get(slot);
    if (con == null)
      return false;

    return con.blocked;
  }

  public function disconnect(slot: SlotType): Bool {
    return slots.disconnect(slot);
  }

  public function disconnectAll(): Void {
    if (emitting)
      slots.disconnectAll();
    else
      slots.clear();
  }

  public function disconnectGroup(id: Int): Bool {
    return slots.disconnectGroup(id);
  }
}
