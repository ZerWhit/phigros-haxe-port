package objects;

import flixel.FlxSprite;
import flixel.util.FlxColor;

import flixel.FlxG;
class Splashes extends FlxSprite
{
	public function new(x:Float, y:Float, color:FlxColor = 0xFFFFFF)
	{
		super();

		this.x = x;
		this.y = y;

		this.color = color;

		loadGraphic(Assets.image("note/splashes"), true, 248, 248);
		animation.add("splashes", [
			0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29
		], 60, false);
		animation.play("splashes");
		setGraphicSize(Std.int(width * 0.75));
		centerOffsets();
		offset.x = -372;
		offset.y = 124;
	}
}
