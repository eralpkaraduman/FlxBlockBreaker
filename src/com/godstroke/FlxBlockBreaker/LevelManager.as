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
		"0000000000000-"+
		"0000000000000-"+
		"0333333333330-"+
		"0333333333330-"+
		"0222222222220-"+
		"0222222222220-"+
		"0111111111110-"+
		"0111111111110";
		
		private var level1:String = 
		"0000000000000-"+
		"0001000001000-"+
		"0000200020000-"+
		"0003333333000-"+
		"0011011101100-"+
		"0333333333330-"+
		"0202222222020-"+
		"0303000003030-"+
		"0000100010000-"+
		"0000000000000-"+
		"0000000000000";
		
		private var level2:String = 
		"0000000000000-"+
		"0000003000000-"+
		"0000223110000-"+
		"0002233311000-"+
		"0022333331100-"+
		"0022333331100-"+
		"0022333331100-"+
		"0030303030300-"+
		"0000002000000-"+
		"0000002000000-"+
		"0000002000000-"+
		"0000101000000-"+
		"0000111000000-"+
		"0000010000000";
		
		private var level3:String = 
		"0101010101000-"+
		"0020202020200-"+
		"0303030303030-"+
		"0020202020200-"+
		"0101010101010-"+
		"0020202020200-"+
		"0303030303020-"+
		"0020202020200-"+
		"0303030303030-"+
		"0020202020200-"+
		"0101010101010-"+
		"0020202020200";
		
		private var hiLevel:String = 
		"0000000000000-"+
		"0020000000100-"+
		"0030000000200-"+
		"0020000030300-"+
		"0030000000100-"+
		"0010100120300-"+
		"0023030030100-"+
		"0020010010200-"+
		"0030020030000-"+
		"0010010020300";
		
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
			//levelArray.push(hiLevel);
			levelArray.push(level0);
			levelArray.push(level1);
			levelArray.push(level2);
			levelArray.push(level3);
			
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