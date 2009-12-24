package
{
	import com.godstroke.FlxBlockBreaker.MenuState;
	
	import org.flixel.*;
	
	[SWF(width="480",height="480", frameRate="60", backgroundColor="#1B1B1B")]
	[Frame(factoryClass="Preloader")]

	public class FlxBlockBreaker extends FlxGame
	{
		public function FlxBlockBreaker()
		{
			super(480,480,MenuState,1);
			showLogo = false;
			useDefaultHotKeys = true;
		}
	}
}
