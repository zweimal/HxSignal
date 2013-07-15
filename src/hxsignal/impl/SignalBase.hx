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

#if macro
import haxe.macro.Expr;
#end

import hxsignal.impl.SlotMap;
import hxsignal.ds.LinkedList;
import hxsignal.Signal;

using Lambda;

/**
 * ...
 * @author German Allemand
 */
class SignalBase<SlotType> implements ISignal<SlotType>
{
	var types : Array<Dynamic>;
	var resultType : Dynamic;
	var emitting : Bool;
	
	/**
	 * The current number of slots connected to the signal.
	 */
	public var numSlots(get, null) : Int;
	
	function get_numSlots() return slots.length;
	
	var slots : SlotMap<SlotType>;
	
	public function new(?types : Array<Dynamic>, ?resultType : Dynamic) 
	{
		this.types = if (types!=null) types else [];
		this.resultType = resultType;
		
		slots = new SlotMap();
	}

	public var emit : SlotType;
	
	public function connect(slot : SlotType, ?once : Bool = false, ?groupId : Int = null, ?at : ConnectPosition = null) : Void
	{
		if (!updateConnection(slot, once))
		{
			var conn = new Connection(this, slot, once);
			
			slots.insert(conn, groupId, at);
		}
	}
	
	function updateConnection(slot : SlotType, once : Bool, ?groupId : Int, ?at : ConnectPosition) : Bool
	{
		var con = slots.get(slot);
		
		if (con == null)
			return false;
		
		if ((groupId != null && con.groupId != groupId) || at != null)
		{
			slots.disconnect(slot);
			return false;
		}
		
		con.once = once;
		con.connected = true;
		
		return true;
	}
	
	public function isConnected(slot : SlotType) : Bool
	{
		return slots.has(slot);
	}
	
	macro static function doEmit(exprs : Array<Expr>) : Expr
	{
		return macro { 
			emitting = true;
			for (g in slots.groups) 
			{
				for (con in g) 
				{
					if (con.connected && !con.blocked)
					{
						con.slot($a{exprs});
						
						if (!con.connected || con.once)
							slots.disconnect(con.slot);
					}
				}
			}
			emitting = false;
		}
	}
	
	public function block(slot : SlotType, flag : Bool) : Void
	{
		var con = slots.get(slot);
		if (con == null)
			return;
			
		con.blocked = flag;
	}
	
	public function isBlocked(slot : SlotType) : Bool
	{
		var con = slots.get(slot);
		if (con == null)
			return false;
			
		return con.blocked;
	}
	
	public function disconnect(slot : SlotType) : Bool
	{
		return slots.disconnect(slot);
	}
	
	public function disconnectAll() : Void
	{
		if (emitting)
			slots.disconnectAll();
		else
			slots.clear();
	}
	
	public function disconnectGroup(id : Int) : Bool
	{
		return slots.disconnectGroup(id);
	}
}
