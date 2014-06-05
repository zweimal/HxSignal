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

/**
 * ...
 * @author German Allemand
 */
class ResponderSignal<SlotType, R> extends SignalBase<SlotType>
{
	public var resultsProcessor:Array<R>->R;
	
	macro static function doEmitWithResult(exprs : Array<Expr>) : Expr
	{
		return macro
		{ 
			var result;
			var all = [];
			function delegate(con)
			{
				result = con.slot($a{exprs});
				all.push(result);
			}
			loop(delegate);
			
			if (resultsProcessor != null)
				result = resultsProcessor(all);
			
			return result;
		}
	}
}