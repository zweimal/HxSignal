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

import haxe.Rest;
import haxe.Constraints.Function;

/**
 * ...
 * @author German Allemand
 */
@:callable
@:generic
abstract Slot<T:Function>(T) from T to T {}

class Slot0 {
  public static function call<R>(slot: Slot<Void -> R>, args: Rest<Any>): R {
    return slot();
  }
}

class Slot1 {
  public static function call<T1, R>(slot: Slot<T1 -> R>, args: Rest<Any>): R {
    return slot(args[0]);
  }
}

class Slot2 {
  public static function call<T1, T2, R>(slot: Slot<T1 -> T2 -> R>, args: Rest<Any>): R {
    return slot(args[0], args[1]);
  }
}

class Slot3 {
  public static function call<T1, T2, T3, R>(slot: Slot<T1 -> T2 -> T3 -> R>, args: Rest<Any>): R {
    return slot(args[0], args[1], args[2]);
  }
}
