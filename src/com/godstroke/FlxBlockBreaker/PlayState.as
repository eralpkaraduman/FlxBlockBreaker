package com.godstroke.FlxBlockBreaker
{
	import flash.geom.Point;
	
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;

	public class PlayState extends FlxState
	{
		private var leftWall:FlxSprite;
		private var rightWall:FlxSprite;
		private var topWall:FlxSprite;
		// kind of "player"
		private var vessel:Vessel;
		// we will put all active active cannonballs here
		private var canonBallArray:Array;
		private var level_manager:LevelManager;
		private var lifeMeter:FlxText;
		private var levelMeter:FlxText;
		private var gameIsStillPlayable:Boolean = true;
		// attributes a.k.a. bonuses
		public var justDroppedAttribute:Boolean = false;
		private var _attributesArray:Array = [];
		
		public function PlayState()
		{
			super();
			FlxG.showCursor();
			
			// BASIC OBJECTS
			// - walls
			var wallWidth:int = 10;
			var wallHeight:int = 400;
			var wallColor:Number = 0xff3a5c39;
			
			leftWall = new FlxSprite(0,0);
			leftWall = leftWall.createGraphic(wallWidth,wallHeight,wallColor);
			leftWall.fixed =true;
			add(leftWall);
			
			rightWall = new FlxSprite(FlxG.width - wallWidth,0);
			rightWall = rightWall.createGraphic(wallWidth,wallHeight,wallColor);
			rightWall.fixed =true;
			add(rightWall);
			
			wallHeight = wallWidth;
			wallWidth = FlxG.width - 2*wallWidth;
			
			topWall = new FlxSprite(wallHeight,0);
			topWall = topWall.createGraphic(wallWidth,wallHeight,wallColor);
			topWall.fixed =true;
			add(topWall);
			
			// - Vessel
			vessel = new Vessel(0,400);
			vessel.fixed =true;
			vessel.x = FlxG.width/2 - vessel.width/2;
			add(vessel);
			
			// - levels
			level_manager =new LevelManager(this,new Point(15,15));
			level_manager.makeNextLevel();
			
			// - Displays
			lifeMeter = new FlxText(0,450,100);
			add(lifeMeter);
			levelMeter = new FlxText(0,460,100);
			add(levelMeter);
			
			// - CannonBalls
			canonBallArray = new Array();
			continuePlaying();
		}
		
		public function addDrop(d:Attribute):void{
			_attributesArray.push(d);
		}
		
		public function expireAllDrops():void{
			for each(var a:Attribute in _attributesArray){
				a.expire();
			}
			_attributesArray =[];
		}
		
		public function addCannonBall(docked:Boolean=false,X:Number=0,Y:Number=0):CannonBall{
			var c:CannonBall =new CannonBall(vessel);
			if(docked)c.dock();
			else{
				c.x = X;
				c.y = Y;
				c.release();
			}
			canonBallArray.push(c);
			add(c);
			return c;
		}
		
		// *********************************************
		// **** ATTRIBUTE FUNCTIONS A.K.A. BONUSES  ****
		// *********************************************
		
		public function bonus_life():void{
			trace("bonus_life");
			vessel.gainLife(1);
			displayLives();
		}
		
 		public function attribute_vessel_wide():void{
			trace("WIDER");
			vessel.changeWidthLevel(+1);
		}
		
		public function attribute_vessel_narrow():void{
			trace("NARROW");
			vessel.changeWidthLevel(-1);
		}
		
		public function add_frost():void{
			trace("FROST");
			vessel.adjust_friction(+10);
		}
		// *********************************************
		
		private function attributeGain(_attr:Attribute,ves:Vessel):void{
			trace("GET "+_attr.type.name);
			this[_attr.type.function_string]();
			_attr.expire();
		}
		
		override public function update():void{
			
			// collision
			FlxG.collideArrays([topWall,leftWall,rightWall,vessel],canonBallArray);
			FlxG.collideArrays(level_manager.array,canonBallArray);
			FlxG.overlapArray(_attributesArray,vessel,attributeGain);
			
			// press space to launch any docked cannonballs, one at a time
			if(FlxG.keys.justPressed("SPACE")){
				// search for docked cannonballs
				dockedSearchLoop : for each(var c:CannonBall in canonBallArray){
					if(c.isDocked){
						c.release();
						break dockedSearchLoop;
					}
				}
			}
			
			// check if all cannonballs are alive
			var allCannonballsAreDead:Boolean =true;
			for each(var cb:CannonBall in canonBallArray){
				if(!cb.dead){ // if there's one alive, change
					allCannonballsAreDead =false;
				}
			}
			
			if(allCannonballsAreDead && gameIsStillPlayable){
				// Vessel lose life
				vessel.loseLife();
				// VesseltoCenter
				// reset cannonBallArray
				canonBallArray = [];
				
				if(vessel.dead){
					gameLost();
				}else{
					resetAttributes();
					continuePlaying();
				}
			}
			super.update();
		}
		
		public function continuePlaying():void{
			// display lives
			displayLives();
			// display level num
			displayLevelNumber();
			// give one new cannonball
			addCannonBall(true);
			// vessel to center
		}
		
		public function resetAttributes():void{
			// reset player's all attributes
		}
		
		public function gameLost():void{
			displayLives();
			// display level num
			displayLevelNumber();
			// display FAIL
			
			gameIsStillPlayable =false;
		}
		
		public function levelClear():void{
			// win sound
			trace("level clear"); // display this
			// clear all cannonballs
			for each(var cb:CannonBall in canonBallArray){cb.die()};
			canonBallArray = [];
			// give new docked cannonball
			level_manager.makeNextLevel();
			continuePlaying();
		}
		
		public function displayLives():void{
			lifeMeter.text = "Lives: "+vessel.currentLives;
		}
		
		public function displayLevelNumber():void{
			levelMeter.text = "Level: "+level_manager.level;
		}
	}
}