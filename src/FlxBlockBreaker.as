package
{
	import com.godstroke.FlxBlockBreaker.MenuState;
	
	import org.flixel.*;
	
	[SWF(width="247",height="240", frameRate="32", backgroundColor="#1B1B1B")]
	[Frame(factoryClass="Preloader")]

	public class FlxBlockBreaker extends FlxGame
	{
		public function FlxBlockBreaker()
		{
			super(247,240,MenuState,1);
			showLogo = false;
			useDefaultHotKeys = true;
		}
	}
}
