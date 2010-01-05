package com.godstroke.FlxBlockBreaker
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;

	public class Vessel extends FlxSprite
	{
		private var baseWidth:int =40; // minimum width, this can be multiplied by bonuses
		public var widthLevel:int = 2; // max 3
		
		private var base_friction_level:Number =1;
		private var max_friction_level:Number =32;
		public var frictionLevel:Number = base_friction_level; // hard 30
		private var defaultAcceleration:int = 20;
		private var lives:Number = 3;
		private var base_color:uint = 0xff3a5c39;
		
		public function Vessel(X:int=0, Y:int=0)
		{
			super(X, Y);
			createGraphic(baseWidth*widthLevel,5,base_color);
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
			
			adjust_friction(-0.01);
			// if friction is positive, over time it should go back to normal
			
			
			super.update();
			checkBounds();
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
			createGraphic(baseWidth*widthLevel,5,0xff3a5c39);
			x-=(delta*baseWidth)/2; // centerize;
		}
		
		public function adjust_friction(by:Number=0):void{
			frictionLevel+=by;
			if(frictionLevel<base_friction_level)frictionLevel=base_friction_level;
			if(frictionLevel>max_friction_level)frictionLevel=max_friction_level;
			//trace((base_friction_level/frictionLevel));
			
			
			//trace( String(base_color).substr( String(base_color).indexOf("x")+1 ) );
			
			//this.color=((base_friction_level/frictionLevel)*base_color);
		}
		
	}
}