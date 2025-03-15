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
import hxsignal.ds.TreeMap;
import hxsignal.Signal;

/**
 * ...
 * @author German Allemand
 */
class SlotMap<SlotType:Function> {
  public var length(get, never): Int;

  public var groups(default, null): TreeMap<Int, ConnectionList<SlotType>>;

  public function new() {
    clear();
  }

  public function clear(): Void {
    groups = new TreeMap();
    groups.set(0, new List());
  }

  public function insert(con: Connection<SlotType>, ?groupId: Int, ?at: ConnectPosition): Void {
    if (at == null)
      at = AtBack;

    var group: ConnectionList<SlotType>;
    if (groupId == null) {
      switch (at) {
        case AtFront:
          groupId = groups.firstKey();
          group = groups.firstValue();

        default:
          groupId = groups.lastKey();
          group = groups.lastValue();
      }
    } else {
      group = groups.get(groupId);
      if (group == null) {
        group = new List();
        groups.set(groupId, group);
      }
    }

    con.groupId = groupId;

    switch (at) {
      case AtFront:
        group.push(con);

      default:
        group.add(con);
    }
  }

  public function get(slot: Slot<SlotType>): Null<Connection<SlotType>> {
    for (group in groups) {
      for (conn in group) {
        if (equalSlots(conn.slot, slot)) {
          return conn;
        }
      }
    }
    return null;
  }

  public function has(slot: Slot<SlotType>): Bool {
    return this.get(slot) != null;
  }

  public function disconnect(slot: Slot<SlotType>): Bool {
    var removed = false;
    for (key in groups.keys()) {
      var value = groups.get(key);
      var list = value.filter(function(conn) {
        if (!equalSlots(conn.slot, slot)) {
          return true;
        }

        conn.connected = false;
        removed = true;
        return false;
      });
      groups.set(key, list);
    }

    return removed;
  }

  public function disconnectGroup(groupId: Int): Bool {
    var group = groups.get(groupId);
    if (group == null) {
      return false;
    }

    groups.remove(groupId);

    for (con in group) {
      con.connected = false;
    }

    return true;
  }

  public function disconnectAll(): Void {
    for (g in groups.keys())
      disconnectGroup(g);
  }

  function get_length(): Int {
    var count = 0;
    for (group in groups) {
      count += group.length;
    }
    return count;
  }

  inline function equalSlots<SlotType>(aSlot: SlotType, bSlot: SlotType): Bool {
    return Reflect.compareMethods(aSlot, bSlot);
  }
}

typedef ConnectionList<SlotType:Function> = List<Connection<SlotType>>;
