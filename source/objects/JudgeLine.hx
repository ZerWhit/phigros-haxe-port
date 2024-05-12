package objects;

import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import json.ChartObject.JudgeLineObject;
import flixel.FlxG;
class JudgeLine extends FlxSprite
{
	public var lineId:Int = 0;
	public var lineBpm:Float = 100;
	public var lineSpeed:Float = 1.0;

	public var judgeLineDisappearEvents:Array<Dynamic>;
	public var judgeLineMoveEvents:Array<Dynamic>;
	public var judgeLineRotateEvents:Array<Dynamic>;
	public var judgeLineSpeedEvents:Array<Dynamic>;

	public function new(obj:JudgeLineObject, id:Int, bpm:Float)
	{
		super();

		lineId = id;
		lineBpm = bpm;

		judgeLineMoveEvents = obj.judgeLineMoveEvents;
		judgeLineRotateEvents = obj.judgeLineRotateEvents;
		judgeLineSpeedEvents = obj.speedEvents;
		judgeLineDisappearEvents = obj.judgeLineDisappearEvents;

		loadGraphic(Assets.image('judge_line'));
		centerOffsets();
		offset.y = 1.5;
		centerOrigin();
		screenCenter();

		if (id == 0) {
			scale.x = 0;
			FlxTween.tween(this, {"scale.x": 1}, 1, {ease: FlxEase.cubeOut});
		}
	}

	public function moveXHelper(x:Float) {
		return FlxG.camera.width * x - frameWidth / 2;
	}

	public function moveYHelper(y:Float) {
		return FlxG.camera.height * (1.0 - y) - frameHeight / 2;
	}
}
