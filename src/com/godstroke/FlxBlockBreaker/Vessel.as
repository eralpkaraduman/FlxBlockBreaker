package com.godstroke.FlxBlockBreaker
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;

	public class Vessel extends FlxSprite
	{
		private var baseWidth:int =60; // minimum width, this can be multiplied by bonuses
		public var widthLevel:int = 2; // max 3
		
		public var frictionLevel:int = 2; // hard 30
		private var defaultAcceleration:int = 20;
		private var lives:Number = 3;
		
		public function Vessel(X:int=0, Y:int=0)
		{
			super(X, Y);
			createGraphic(baseWidth*widthLevel,10,0xff3a5c39);
			maxVelocity.x = 450;
		}
		
		public function loseLife(amount:int=1):void{
			lives-=amount;
			if(lives<=0){
				die();
			}
		}
		
		public function get currentLives():Number{
			return lives;
		}
		
		public function gainLife(amount:int=1):void{
			lives+=amount;
		}
		
		private function die():void{
			//animate
			dead = true;
			visible =false;
		}
		
		override public function update():void{
			// MOVEMENT
			if(FlxG.keys.LEFT){
				if(velocity.x>0)velocity.x -= velocity.x/frictionLevel;
				velocity.x -= defaultAcceleration;
			}
			else if(FlxG.keys.RIGHT){
				if(velocity.x<0)velocity.x -= velocity.x/frictionLevel;
				velocity.x += defaultAcceleration;
			}else{
				velocity.x += (0 - velocity.x)/frictionLevel;
			}
			checkBounds();
			
			super.update();
		}
		
		protected function checkBounds():void{
			if(x<0){
				velocity.x = 0;
				x=0;
			}
			if(x>FlxG.width-width){
				velocity.x = 0;
				x=FlxG.width-width;
			}
		}
		
		public function changeWidthLevel(delta:Number):void{
			widthLevel+=delta;
			// limits
			if(widthLevel<1){widthLevel = 1; return;} 
			if(widthLevel>3){widthLevel = 3; return;}
			createGraphic(baseWidth*widthLevel,10,0xff3a5c39);
			x-=(delta*baseWidth)/2; // centerize;
		}
		
	}
}