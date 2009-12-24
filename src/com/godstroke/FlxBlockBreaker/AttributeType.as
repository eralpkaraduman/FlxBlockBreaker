package com.godstroke.FlxBlockBreaker
{
	public class AttributeType
	{
		public var good:Boolean;
		public var name:String;
		public var function_string:String;
		public var duration:Number;
		public var id:int;
		
		public function AttributeType(id:int,good:Boolean,name:String,function_string:String,duration:Number=0)
		{
			this.good = good;
			this.name = name;
			this.function_string = function_string;
			this.duration =duration;
			this.id = id;
		}

	}
}