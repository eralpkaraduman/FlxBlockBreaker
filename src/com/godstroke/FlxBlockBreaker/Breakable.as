package com.godstroke.FlxBlockBreaker
{
	import flash.geom.Point;
	
	import org.flixel.*;

	public class Breakable extends FlxSprite
	{
		private var $color:Number;
		private var _lives:Number;
		private var _LevelManager:LevelManager;
		private var _index:Number;
		
		public function Breakable(index:int,lives:Number,color:Number,levelManager:LevelManager)
		{
			super();
			createGraphic(30,10,color);
			
			_LevelManager = levelManager;
			_lives = lives;
			_index = index;
		}
		
		public function get index():int{
			return _index;
		}
		
		public function get center():Point{
			return new Point(this.x+this.width/2,this.y+this.height/2);
		}
		
		public function hit():void{
			_lives--;
			if(_lives<=0){
				// random break sound.
				if(Math.round(Math.random()*1)==0){
					//FlxG.play(snd_break_1);
				}else{
					//FlxG.play(snd_break_2);
				}
				// make dead to ensure that collisions occur with this
				_LevelManager.killBlock(this);
				dead = true; 
				visible = false;
			}
			
			// BONUS GAIN AKA. ATTRIBUTES
			if(Math.round(Math.random()*10)==0){
				if(!PlayState(FlxG.state).justDroppedAttribute){
					// drop
					dropAttribute();
				}
				PlayState(FlxG.state).justDroppedAttribute = true;
			}else{
				PlayState(FlxG.state).justDroppedAttribute = false;
			}
		}
		
		private function dropAttribute():void{
			var att:Attribute = new Attribute(x,y)
			PlayState(FlxG.state).addDrop(att);
			FlxG.state.add(att);
		}
		
	}
}