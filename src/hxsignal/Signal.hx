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

import hxsignal.impl.Connection;
import hxsignal.impl.Signal0;
import hxsignal.impl.Signal1;
import hxsignal.impl.Signal2;
import hxsignal.impl.Signal3;

/**
 * ...
 * @author German Allemand
 */
@:multiType
abstract Signal<SlotType>(ISignal<SlotType>)
{
	public function new();
	
	/**
		Connects an slot to the signal.
		
		@param slot A function matching the signature of SlotType
		@param once Removes slot automatically after it is called
	**/
	public inline function connect(slot : SlotType, ?once : Bool = false, ?groupId : Int = null, ?at : ConnectPosition = null) return this.connect(slot, once, groupId, at);
	
	public inline function isConnected(slot : SlotType) return this.isConnected(slot);
	
	public inline function block(slot : SlotType, flag : Bool) this.block(slot, flag);
	
	public inline function isBlocked(slot : SlotType) return this.isBlocked(slot);
	
	public inline function disconnect(slot : SlotType) return this.disconnect(slot);
	
	public inline function disconnectAll() this.disconnectAll();
	
	public inline function disconnectGroup(id : Int) return this.disconnectGroup(id);
		
	public var emit(get, never) : SlotType;
	
	private inline function get_emit() return this.emit;
	
	/**
		The current number of slots connected to the signal.
	**/
	public var numSlots(get, never) : Int;
	
	private inline function get_numSlots() return this.numSlots;
	
	@:op(A += B) inline public static function addSlot<SlotType>(signal : Signal<SlotType>, slot : SlotType) signal.connect(slot, false, null, null);
	
	@:op(A -= B) inline public static function removeSlot<SlotType>(signal : Signal<SlotType>, slot : SlotType) signal.disconnect(slot);
	
	@:op(A << B) inline public static function addOnceSlot<SlotType>(signal : Signal<SlotType>, slot : SlotType) signal.connect(slot, true, null, null);
	
	@:to static inline function toSignal0(signal : ISignal<Void -> Void>) : Signal0 {
		return new Signal0();
	}
	
	@:to static inline function toSignal1<T1>(signal : ISignal<T1 -> Void>) : Signal1<T1> {
		return new Signal1();
	}
	
	@:to static inline function toSignal2<T1, T2>(signal : ISignal<T1 -> T2 -> Void>) : Signal2<T1, T2> {
		return new Signal2();
	}
	
	@:to static inline function toSignal3<T1, T2, T3>(signal : ISignal<T1 -> T2 -> T3 -> Void>) : Signal3<T1, T2, T3> {
		return new Signal3();
	}
}

interface ISignal<SlotType> 
{
	var emit : SlotType;
	var numSlots (get, never) : Int;
	function connect(slot : SlotType, ?once : Bool = false, ?groupId : Int = null, ?at : ConnectPosition = null) : Void;
	function isConnected(slot : SlotType) : Bool;
	function block(slot : SlotType, flag : Bool) : Void;
	function isBlocked(slot : SlotType) : Bool;
	function disconnect(slot : SlotType) : Bool;
	function disconnectAll() : Void;
	function disconnectGroup(id : Int) : Bool;
}

enum ConnectPosition 
{ 
	AtBack; 
	AtFront; 
}
