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

/**
	Signal that calls slots with one arguement.
	@author German Allemand
**/
class Signal1<T1> extends SignalBase<T1 -> Void>
{
	public function new(?types : Array<Dynamic>, ?resultType : Dynamic)
	{
		super(types, resultType);
		this.emit = emit1;
	}

	/**
		Calls the slots with one arguement.
	**/
	function emit1(p1 : T1)
	{
		SignalBase.doEmit(p1);
	}
}
