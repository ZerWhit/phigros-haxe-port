package;

import flixel.FlxGame;
import openfl.display.FPS;
import openfl.display.Sprite;
import states.TrackPlayState;

class Main extends Sprite
{
	public static var fpsObj = new FPS(0, 0, 0xFFFFFF);
	public function new()
	{
		super();
		Assets.preloadAssets(["note/splashes", 'note/tap', 'note/tap_hl', 'note/drag', 'note/drag_hl', 'note/hold_head', 'note/hold2_hl_0', 'note/flick', 'note/flick_hl']);
		addChild(new FlxGame(0, 0, TrackPlayState, 1, 480, 480, true, false));
		addChild(fpsObj);
	}
}
