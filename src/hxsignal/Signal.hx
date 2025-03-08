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

package hxsignal;

/**
 * ...
 * @author German Allemand
 */
#if !macro @:genericBuild(hxsignal.macro.SignalMacro.build()) #end
class Signal<SlotType> {
  public function new() {};

  /**
    Connects an slot to the signal.

    @param slot A function matching the signature of SlotType
    @param once Removes slot automatically after it is called
  **/
  public function connect(slot: SlotType, ?times: ConnectionTimes, ?groupId: Int = null, ?at: ConnectPosition = null): Void {}

  public function isConnected(slot: SlotType): Bool
    return false;

  public function block(slot: SlotType, flag: Bool): Void {}

  public function isBlocked(slot: SlotType): Bool
    return false;

  public function disconnect(slot: SlotType): Bool
    return false;

  public function disconnectAll() {};

  public function disconnectGroup(id: Int): Bool
    return false;

  /**
    The current number of slots connected to the signal.
  **/
  public var numSlots(default, never): Int;
}

enum ConnectionTimes {
  Once;
  Times(t: Int);
  Forever;
}

enum ConnectPosition {
  AtBack;
  AtFront;
}
