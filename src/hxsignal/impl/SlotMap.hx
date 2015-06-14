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

import haxe.ds.ObjectMap;
import hxsignal.ds.ExtendedIterator;
import hxsignal.ds.LinkedList;
import hxsignal.ds.TreeMap;
import hxsignal.Signal;

/**
 * ...
 * @author German Allemand
 */
class SlotMap<SlotType>
{
	public var length(get, never) : Int;

	public var groups(default, null) : TreeMap<Int, ConnectionList<SlotType>>;
	#if cpp
	var slots = new TreeMap<Slot<SlotType>, Connection<SlotType>>();
	#else
	var slots = new ObjectMap<Dynamic, Connection<SlotType>>();
	#end

	public function new()
	{
		clear();
	}

	public function clear() : Void
	{
		groups = new TreeMap();
		groups.set(0, new LinkedList());
	}

	public function insert(con : Connection<SlotType>, ?groupId : Int, ?at : ConnectPosition) : Void
	{
		if (at == null)
			at = AtBack;

		slots.set(con.slot, con);

		var group : ConnectionList<SlotType>;
		if (groupId == null)
		{
			switch (at)
			{
				case AtFront:
					groupId = groups.firstKey();
					group = groups.firstValue();

				default:
					groupId = groups.lastKey();
					group = groups.lastValue();
			}
		}
		else
		{
			group = groups.get(groupId);
			if (group == null)
			{
				group = new LinkedList();
				groups.set(groupId, group);
			}
		}

		con.groupId = groupId;

		switch (at)
		{
			case AtFront: group.push(con);

			default: group.add(con);
		}
	}

	public function get(slot : Slot<SlotType>) : Connection<SlotType>
	{
		return slots.get(slot);
	}

	public function has(slot : Slot<SlotType>) : Bool
	{
		return slots.get(slot) != null;
	}

	public function disconnect(slot : Slot<SlotType>) : Bool
	{
		var con = slots.get(slot);
		if (con == null)
			return false;

		slots.remove(slot);
		con.connected = false;

		return true;
	}

	public function disconnectGroup(groupId : Int) : Bool
	{
		var group = groups.get(groupId);
		if (group == null)
			return false;

		groups.remove(groupId);

		for (con in group)
		{
			slots.remove(con.slot);
			con.connected = false;
		}

		return true;
	}

	public function disconnectAll() : Void
	{
		for (g in groups.keys())
			disconnectGroup(g);
	}

	function get_length() : Int
	{
		return Lambda.count(slots);
	}
}

typedef ConnectionList<SlotType> = LinkedList<Connection<SlotType>>;

