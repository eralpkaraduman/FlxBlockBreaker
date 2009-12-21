package com.godstroke.FlxBlockBreaker
{
	import flash.geom.Point;
	
	import org.flixel.*;

	public class CannonBall extends FlxSprite
	{
		protected var docked:Boolean = false;
		protected var _vessel:Vessel;
		private var defaultAcceleration:int = 20;
		
		private var direction:Point;
		
		public function CannonBall(vessel:Vessel,X:int=0, Y:int=0)
		{
			super(X, Y);
			_vessel = vessel;
			maxVelocity.x = 180;
			maxVelocity.y = 180;
			direction =new Point(0,0); // 0 adds no acceleration
		}
		
		public function dock():void{
			docked =true;
		}
		
		public function get isDocked():Boolean{
			return docked;
		}
		
		// COLLISION
		
		override public function hitCeiling(Contact:FlxCore=null):Boolean {
			velocity.y = Math.abs(velocity.y);
			direction.y = Math.abs(direction.y);
			
			hitBreakableCase(Contact);
			
			return true; 
		}
		
		override public function hitWall(Contact:FlxCore=null):Boolean {
			velocity.x = -velocity.x;
			direction.x = -direction.x;
			
			hitBreakableCase(Contact);
			
			return true;
		}
		
		override public function hitFloor(Contact:FlxCore=null):Boolean {
			// case hit vessel
			var touchDeltaPointX:Number = (Contact.x - x + Contact.width/2 - width/2);
			var p:Number = touchDeltaPointX/(Contact.width/2);
			if(p>1)p=1; if(p<-1)p=-1;
			
			direction.y = -Math.abs(direction.y*Math.abs(p));
			velocity.y = -Math.abs(velocity.y);
			
			velocity.x = Math.abs(direction.y)*-p;
			direction.x = -p;
			// -
			hitBreakableCase(Contact);
			
			return true; 
		}
		
		// *
		
		public function release():void{
			docked =false;
			direction.y = -1; // TODO: ekranın üst yarısındaysa aşağı, alt yarısındaysa yukarı doğru release olsun
			// TODO: x directionu random olabilir
			trace("release");
		}
		
		override public function update():void{
			if(y>FlxG.height || y<0 || x>FlxG.width || x<0){
				die();
			}
			
			if(docked){
				velocity.x = 0;
				velocity.y = 0;
				x = _vessel.x + _vessel.width/2 - width/2 ;
				y = _vessel.y -height;
			}else if(!docked){
				//velocity.x += defaultAcceleration;
				velocity.y += direction.y*defaultAcceleration;
				velocity.x += direction.x*defaultAcceleration;
				angle+=(direction.x*20);
			}
			super.update();
		}
		
		public function die():void{
			dead = true; // kill the ball if it has fallen off
			visible =false;
			// explode
			
			// playsatate checks if all cannonballs are alive
		}
		
		public function hitBreakableCase(Contact:FlxCore=null):void{
			if(Contact is Breakable){
				Breakable(Contact).hit();
				 if(direction.x == 0 && x<= FlxG.width/2){
					direction.x = -0.01;
				}
				else if(direction.x == 0 && x> FlxG.width/2){
					direction.x = 0.01;
				} 
			}
		}
		
	}
}