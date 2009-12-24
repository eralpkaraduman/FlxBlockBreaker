package com.godstroke.FlxBlockBreaker
{
	import flash.geom.Point;
	
	import org.flixel.*;

	public class CannonBall extends FlxSprite
	{
		protected var docked:Boolean = false;
		protected var _vessel:Vessel;
		private var defaultAcceleration:int = 15;
		private var current_magnus_force:Number = 0; // force caused by the rotation on contact with the vessel
		private var vessel_friction:Number = 0.02; // used for calculating magnus force
		private var angle_delta:Number = 0;
		private var max_angle_delta:Number = 25;
		
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
			if(Contact is Vessel){
				hitVessel(Contact as Vessel);
				return true;
			}
			// else
			velocity.y = -Math.abs(velocity.y);
			direction.y = -Math.abs(direction.y);
			
			hitBreakableCase(Contact);
			
			return true;
		}
		
		private function hitVessel(vessel:Vessel):void{
			var touchDeltaPointX:Number = (vessel.x - x + vessel.width/2 - width/2);
			var p:Number = touchDeltaPointX/(vessel.width/2);
			if(p>1)p=1; if(p<-1)p=-1;
			
			//var magnusForce:Number =(vessel_friction*vessel.velocity.x);
			var magnusForce:Number = calculateMagnusForce(vessel);
			//trace("p "+p);
			//trace("magnus "+magnusForce);
			
			//if( (p>0 && magnusForce<0 ) || (p<0 && magnusForce>0 ) )trace("p "+p+" mag "+magnusForce)
			//if(magnusForce!=0)trace("mag "+magnusForce)
			
			
			p += -magnusForce;
			
			
			direction.y = -Math.abs(direction.y);
			velocity.y = -Math.abs(velocity.y);

			direction.x = -p;
			velocity.x = Math.abs(velocity.x)*direction.x;
			
			hitBreakableCase(vessel);
		}
		
		// *
		
		public function release():void{
			docked =false;
			direction.y = -1; // TODO: ekranın üst yarısındaysa aşağı, alt yarısındaysa yukarı doğru release olsun
			
			direction.x = calculateMagnusForce(_vessel);
			velocity.x = Math.abs(velocity.x)*direction.x;
			
			// TODO: x directionu random olabilir
			//trace("release");
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
				velocity.y += direction.y*defaultAcceleration;
				velocity.x += direction.x*defaultAcceleration;
				/*
				angle_delta += (current_magnus_force/1000);
				trace(angle_delta);
				if(Math.abs(angle_delta)>Math.abs(max_angle_delta))angle_delta= (angle_delta<0 ? -max_angle_delta : +max_angle_delta );
				trace("ü "+angle_delta);
				//angle+=angle_delta;
				*/
				angle += current_magnus_force;
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
					//direction.x = -0.01;
				}
				else if(direction.x == 0 && x> FlxG.width/2){
					//direction.x = 0.01;
				} 
			}
		}
		
		public function calculateMagnusForce(vessel:Vessel):Number{
			var magnusForce:Number =(vessel_friction*vessel.velocity.x);
			current_magnus_force = magnusForce;
			return magnusForce;
		}
		
	}
}