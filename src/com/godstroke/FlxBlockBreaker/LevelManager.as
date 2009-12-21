package com.godstroke.FlxBlockBreaker
{
	import flash.geom.Point;
	
	public class LevelManager
	{
		private var _level:Number = -1;
		private var _position:Point;
		private var _blockArray:Array;
		private var activeBlockCount:Number;
		
		private var _game:PlayState;
		private var level0:String = 
		"00000000000-"+
		"00000000000-"+
		"03333333330-"+
		"03333333330-"+
		"02222222220-"+
		"02222222220-"+
		"01111111110-"+
		"01111111110";
		
		private var level1:String = 
		"00100000100-"+
		"00020002000-"+
		"00333333300-"+
		"01101110110-"+
		"33333333333-"+
		"20222222202-"+
		"30300000303-"+
		"00010001000-"+
		"00000000000-"+
		"00000000000";
		
		private var level2:String = 
		"00000300000-"+
		"00022311000-"+
		"00223331100-"+
		"02233333110-"+
		"02233333110-"+
		"02233333110-"+
		"03030303030-"+
		"00000200000-"+
		"00000200000-"+
		"00000200000-"+
		"00010100000-"+
		"00011100000-"+
		"00001000000";
		
		private var level3:String = 
		"1010101010-"+
		"0202020202-"+
		"3030303030-"+
		"0202020202-"+
		"1010101010-"+
		"0202020202-"+
		"3030303030-"+
		"0202020202-"+
		"3030303030-"+
		"0202020202-"+
		"1010101010-"+
		"0202020202";
		
		private var hiLevel:String = 
		"0000000000-"+
		"0200000001-"+
		"0300000002-"+
		"0200000303-"+
		"0300000001-"+
		"0101001203-"+
		"0230300301-"+
		"0200100102-"+
		"0300200300-"+
		"0100100203";
		
		private var testLevel:String = 
		"0000000000-"+
		"0000000000-"+
		"0000000000-"+
		"0000000000-"+
		"0000000000-"+
		"0000000000-"+
		"0000000000-"+
		"0001000000-"+
		"0000000000-"+
		"0000000000";
		
		
		
		private var levelArray:Array;
		
		public function LevelManager(game:PlayState,position:Point)
		{
			levelArray = new Array();
			//levelArray.add(testLevel);
			
			//levelArray.push(hiLevel);
			levelArray.push(level0);
			levelArray.push(level1);
			levelArray.push(level2);
			levelArray.push(level2);
			
			_game = game;
			_position = position;
			_blockArray = new Array();
			
		}
		
		public function makeNextLevel():void{
			_level++;
			if(_level>=levelArray.length){
				//_game.gameFinished();
				//return;
				_level = 0;
			}
			_blockArray = buildLevel(levelArray[_level]);
			activeBlockCount =_blockArray.length
		}
		
		public function killBlock(block:Breakable):void{
			activeBlockCount--;
			if(activeBlockCount<=0)_game.levelClear();
		}
		
		public function get level():Number{
			return _level+1;
		}
		
		public function get array():Array{
			return _blockArray;
		}
		
		
		protected function buildLevel(str:String):Array{
			var _array:Array = new Array();
			var layerDelimiter:String = "-";
			var rows:Array = str.split(layerDelimiter);
			var yindex:Number = 0;
			var xindex:Number = 0;
			var margin:Number = 5;
			
			var block_index:Number = 0;
			for each(var row:String in rows){
				var blocks:Array = row.split("");
				for each(var blockCode:String in blocks){
					//--
					var breakable:*;
					switch(blockCode){
						case "3": breakable=new Breakable(block_index,1,0xFFDD3739,this); break;
						case "2": breakable=new Breakable(block_index,1,0xFFF3CB14,this); break;
						case "1": breakable=new Breakable(block_index,1,0xFF64899B,this); break;
						default : breakable=null; break;
					}
					if(breakable){
						breakable.x = _position.x + xindex*(breakable.width+margin);
						breakable.y = _position.y + yindex*(breakable.height+margin);
						_game.add(breakable);
						_array.push(breakable);
					}
					xindex++;
					block_index++;
				}
				xindex = 0;
				yindex++;
			}
			
			return _array;
		}

	}
}