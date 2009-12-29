package com.godstroke.FlxBlockBreaker
{
	import org.flixel.*;
	

	public class Attribute extends FlxSprite
	{
		public var type:AttributeType;
		public var attributeArray:Array;
		private var title_txt:FlxText;
		public function Attribute(X:int=0, Y:int=0)
		{
			super(X, Y);
			
			attributeArray=[
				//new AttributeType(3/8,10,true,"+length","attribute_vessel_wide",0),
				//new AttributeType(2/8,11,false,"-length","attribute_vessel_narrow",0),
				//new AttributeType(2/8,20,true,"+life","bonus_life",0),
				new AttributeType(8/8,20,false,"frost","add_frost",0)
			];
			
			choose();
			var bad_color:Number = 0x55ff0000;
			var good_color:Number = 0x5500ff00;
			createGraphic(30,10,type.good?good_color:bad_color);
			
			title_txt = new FlxText(-500,-500,200);
			title_txt.text = type.name;
			title_txt.alignment ="center";
			FlxG.state.add(title_txt);
			
		}
		
		private function choose():void{

			var sumOfProbs:Number = 0;
			var rand:Number = Math.random();
			selectionLoop : for each(var a:AttributeType in attributeArray){
				sumOfProbs+=a.chance;
				if(rand<=sumOfProbs){
					type = a; // selected
					break selectionLoop;
				}
			}
			if(sumOfProbs!=1)trace("WARNING sum of drop chances is not 1 !  leaks: "+(sumOfProbs-1));
		}
		
		override public function update():void{
			if(dead){
				title_txt.velocity.y = -20;
				title_txt.alpha-=0.04;
			}else{
				velocity.y = 80;
				title_txt.x = x-title_txt.width/2+width/2;
				title_txt.y = y-13;
			}
			
			super.update();
		}
		
		public function expire():void{
			//title_txt.destroy();
			dead =true;
			visible =false;
			velocity.y = 0;
			//title_txt.flicker();
			//destroy();
		}
		
	}
}