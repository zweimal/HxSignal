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
package hxsignal.ds;

/**
 * ...
 * @author German Allemand
 */
class LinkedList<T> extends List<T>
{
	public function new() 
	{
		super();
	}
	
	private inline function removeNode(node : Array<Dynamic>, prev : Array<Dynamic>) : Void
	{
		if (node != null)
		{
			if( prev == null )
				h = node[1];
			else
				prev[1] = node[1];
			if( q == node )
				q = prev;
			length--;
		}
	}
	
	public function listIterator() : ExtendedIterator<T> {
		var list = this;
		var next = h;
		var curr = null;
		var prev = null;
		return cast {
			hasNext : function()
			{
				return (next != null);
			},
			next : function()
			{
				if(next == null)
					return null;
				prev = curr;
				curr = next;
				next = next[1];
				return curr[0];
			},
			remove : function()
			{
				if (curr == prev)
					return;
				list.removeNode(curr, prev);
				curr = prev;
			}
		}
	}
}
