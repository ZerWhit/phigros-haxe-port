package;

import data.Song;
import data.state.PlayState;
import flixel.FlxGame;
import lime.app.Application;
import openfl.display.Sprite;

using StringTools;

class Main extends Sprite
{
	public static var current_FPS:Int = 60;
	public static var curSong:String = "Another-Me";

	public function new()
	{
		super();
		PlayState.SONG = Song.loadJson(curSong);
		addChild(new FlxGame(0, 0, data.state.PlayState));
		addChild(new data.state.substate.FPS(3, 3, 0xFFFFFF));
	}
}
