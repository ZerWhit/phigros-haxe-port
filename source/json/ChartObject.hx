package json;

import haxe.Json;
import sys.io.File;

using StringTools;

typedef JudgeLineObject =
{
	var numOfNotes:Int;
	var numOfNotesAbove:Int;
	var numOfNotesBelow:Int;
	var bpm:Float;
	var speedEvents:Array<Dynamic>;
	var notesAbove:Array<Dynamic>;
	var notesBelow:Array<Dynamic>;
	var judgeLineDisappearEvents:Array<Dynamic>;
	var judgeLineMoveEvents:Array<Dynamic>;
	var judgeLineRotateEvents:Array<Dynamic>;
}

typedef ChartObjectTypedef =
{
	var offset:Int;
	var numOfNotes:Int;
	var judgeLineList:Array<JudgeLineObject>;
}

class ChartObject
{
	public var offset:Int;
	public var numOfNotes:Int;

	public function new(offset, numOfNotes, judgeLineList)
	{
		this.offset = offset;
		this.numOfNotes = numOfNotes;
	}

	public static function loadChart(trackName:String):ChartObjectTypedef
	{
		var trackJson = File.getContent(Assets.chart(trackName)).trim();

		return parseChart(trackJson);
	}

	public static function parseChart(trackJson:String):ChartObjectTypedef
	{
		var trackObject:ChartObjectTypedef = cast Json.parse(trackJson);
		return trackObject;
	}
}
