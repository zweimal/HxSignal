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

import hxsignal.Signal;

/**
	Defines the basic properties of an slot associated with a Signal.
**/
class Connection<SlotType>
{
	/**
		The slot to be called when signal is emitted
	**/
	public var slot(default, null) : SlotType;
	
	/**
		Amount of times slot has to called before autodisconnect it
	**/
	public var times(default, default) : ConnectionTimes;
	
	public var calledTimes(default, default) : Int;
	
	/**
		Whether the slot is called on signal emition. Defaults to false.
	**/
	public var blocked : Bool;
	
	public var connected (default, default) : Bool;
	
	public var groupId (default, default) : Int;
	
	var signal : SignalBase<SlotType>;

	public function new(signal : SignalBase<SlotType>, slot : SlotType, times : ConnectionTimes) 
	{
		this.signal = signal;
		if (slot == null) throw "Slot cannot be null";
		this.slot = slot;
		this.times = times;
		this.blocked = false;
		this.connected = true;
	}
}
