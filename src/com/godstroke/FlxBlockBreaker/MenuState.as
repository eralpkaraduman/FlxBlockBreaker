package com.godstroke.FlxBlockBreaker
{
	import org.flixel.*
	

	public class MenuState extends FlxState
	{
		public function MenuState()
		{
			super();
			FlxG.showCursor();
		}
		
		override public function update():void{
			FlxG.switchState(PlayState);
		}
		
		
	}
}