package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import json.ChartObject;
import math.MathHelper;
import objects.JudgeLine;
import objects.Note;
import objects.Splashes;
import states.sub.ClassGUI;
import lime.app.Application;
class TrackPlayState extends FlxState
{
	public static var songPosition:Float;
	public static var instance:TrackPlayState;

	public static var unspawnNotes:Array<Note> = [];
	public static var judgeLines:FlxTypedGroup<JudgeLine>;
	public static var noteList:FlxTypedGroup<Note>;

	public var trackName:String = "fengyu";
	public var TRACKCHART:ChartObjectTypedef;
	public var displayUI:ClassGUI;

	private var trackBg:FlxSprite;
	private var judgeLineList:Array<JudgeLineObject>;
	private var splashes:FlxTypedGroup<Splashes>;

	public static var playingSong:Bool = false;

	override public function create()
	{
		instance = this;

		trackBg = new FlxSprite();
		trackBg.loadGraphic(Assets.image('illustration/blur/$trackName/illustration_blur'));
		trackBg.alpha = 0;
		add(trackBg);
		judgeLines = new FlxTypedGroup<JudgeLine>();
		add(judgeLines);
		noteList = new FlxTypedGroup<Note>();
		add(noteList);
		splashes = new FlxTypedGroup<Splashes>();
		add(splashes);

		displayUI = new ClassGUI();
		add(displayUI);

		TRACKCHART = ChartObject.loadChart(trackName);
		initChart();
		FlxTween.tween(trackBg, {alpha: 0.25}, 1, {ease: F lxEase.cubeOut});
		new FlxTimer().start(1, function(timer:FlxTimer) {
			FlxG.sound.playMusic(Assets.music(trackName), 1);
			playingSong = true;
		});
		super.create();
	}

	function initChart()
	{
		judgeLineList = TRACKCHART.judgeLineList;
		var id:Int = 0;
		for (lineObject in judgeLineList)
		{
			var obj0:JudgeLine = new JudgeLine(lineObject, id, lineObject.bpm);
			judgeLines.add(obj0);

			for(noteObject in lineObject.notesAbove) {
				var highlight:Bool = false;
				for (i in lineObject.notesAbove) {
					if (noteObject.time == i.time && noteObject != i) {
						highlight = true;
					}
				}
				var noteHead:Note = new Note(cast noteObject, obj0, highlight);
				unspawnNotes.push(noteHead);
				if (noteObject.holdTime > 0) {
					var noteEnd:Note = new Note(cast noteObject, obj0, highlight, false, true);
					var hold:Note = new Note(cast noteObject, obj0, highlight, true);
					hold.endObj = noteEnd;
					hold.headObj = noteHead;
					unspawnNotes.push(hold);
					unspawnNotes.push(noteEnd);
				}
			}
			for(noteObject in lineObject.notesBelow) {
				var highlight:Bool = false;
				for (i in lineObject.notesBelow) {
					if (noteObject.time == i.time && noteObject != i) {
						highlight = true;
					}
				}
				var noteHead:Note = new Note(cast noteObject, obj0, highlight);
				noteHead.below = true;
				unspawnNotes.push(noteHead);
				if (noteObject.holdTime > 0) {
					var noteEnd:Note = new Note(cast noteObject, obj0, highlight, false, true);
					noteEnd.below = true;
					var hold:Note = new Note(cast noteObject, obj0, highlight, true);
					hold.below = true;
					hold.endObj = noteEnd;
					hold.headObj = noteHead;
					unspawnNotes.push(hold);
					unspawnNotes.push(noteEnd);
				}
			}
			unspawnNotes.sort((a, b) -> Std.int(a.time - b.time));
			displayUI.numOfNotes = unspawnNotes.length;
			id++;
		}
	}

	override public function update(elapsed:Float)
	{
		var gameWidth:Float = Application.current.window.width;
		var gameHeight:Float = Application.current.window.height;
		var windowRatio:Float = gameWidth / gameHeight;
		var imageRatio:Float = trackBg.width / trackBg.height;
		if (windowRatio > imageRatio)
		{
			trackBg.scale.x = gameWidth / trackBg.width;
			trackBg.scale.y = trackBg.scale.x;
		}
		else
		{
			trackBg.scale.y = gameHeight / trackBg.height;
			trackBg.scale.x = trackBg.scale.y;
		}
		trackBg.screenCenter();

		if (playingSong)
			songPosition = FlxG.sound.music.time + TRACKCHART.offset;

		for (note in unspawnNotes) {
			if (note.time <= songPosition + 1500) {
				noteList.add(note);
				unspawnNotes.splice(unspawnNotes.indexOf(note), 1);
			}
		}

		noteList.forEachAlive(function (note:Note) {
			var strumX = note.positionX * 50;
			var strumY = getStrumY(note);

			var posX = strumX * MathHelper.cosRadian(note.lineObj.angle) - strumY * MathHelper.sinRadian(note.lineObj.angle);
			var posY = strumX * MathHelper.sinRadian(note.lineObj.angle) + strumY * MathHelper.cosRadian(note.lineObj.angle);

			note.x = posX + note.lineObj.x + note.lineObj.width / 2 - note.width / 2;
			note.y = posY + note.lineObj.y;
			note.angle = note.lineObj.angle + (note.below ? 180 : 0);
			note.strumY = strumY;

			if (songPosition >= note.time) {
				if (!note.shouldBeRemove)
					switch (note.type)
					{
						case 1:
							FlxG.sound.play(Assets.sound("HitSong0"), 0.7);
						case 2:
							FlxG.sound.play(Assets.sound("HitSong1"), 0.7);
						case 3:
							if (!note.holdNote && !note.endNote) {
								FlxG.sound.play(Assets.sound("HitSong0"), 0.7);
							}
						case 4:
							FlxG.sound.play(Assets.sound("HitSong2"), 0.7);
					}

				note.shouldBeRemove = true;

				var splash:Splashes = new Splashes(note.x, note.y);
				if (!note.holdNote && !note.endNote) {
					splashes.add(splash);
				}
				if (note.holdNote && note.ticksExisted % 100 == 0) {
					splashes.add(splash);
				}
			}

			note.update(elapsed);
		});

		splashes.forEachAlive(function (splash:Splashes) {
			if (splash.animation.finished) {
				splash.alive = false;
				splash.visible = false;
				splash.kill();
				splashes.remove(splash);
			}
		});

		judgeLines.forEachAlive(function (line:JudgeLine) {
			for (moveEvent in line.judgeLineMoveEvents){
				var trueStartTime = timeConversion(moveEvent.startTime, line.lineBpm);
				var trueEndTime = timeConversion(moveEvent.endTime, line.lineBpm);
				if (songPosition >= trueStartTime && songPosition <= trueEndTime) {
					var ratio = MathHelper.clamp((songPosition - trueStartTime) / (trueEndTime - trueStartTime), 0.0, 1.0);
					var interpolatedX:Float = FlxMath.lerp(moveEvent.start, moveEvent.end, ratio);
					line.x = line.moveXHelper(interpolatedX);
					var interpolatedY:Float = FlxMath.lerp(moveEvent.start2, moveEvent.end2, ratio);
					line.y = line.moveYHelper(interpolatedY);
				}
				if (songPosition > trueEndTime)
					line.judgeLineMoveEvents.splice(line.judgeLineMoveEvents.indexOf(moveEvent), 1);
			}

			for (rotateEvent in line.judgeLineRotateEvents){
				var trueStartTime = timeConversion(rotateEvent.startTime, line.lineBpm);
				var trueEndTime = timeConversion(rotateEvent.endTime, line.lineBpm);
				if (songPosition >= trueStartTime && songPosition <= trueEndTime) {
					var ratio = MathHelper.clamp((songPosition - trueStartTime) / (trueEndTime - trueStartTime), 0.0, 1.0);
					var interpolatedAngle:Float = FlxMath.lerp(rotateEvent.start, rotateEvent.end, ratio);
					line.angle = -interpolatedAngle;
				}
				if (songPosition > trueEndTime)
					line.judgeLineRotateEvents.splice(line.judgeLineRotateEvents.indexOf(rotateEvent), 1);
			}

			for (speedEvent in line.judgeLineSpeedEvents){
				var trueStartTime = timeConversion(speedEvent.startTime, line.lineBpm);
				var trueEndTime = timeConversion(speedEvent.endTime, line.lineBpm);
				if (songPosition >= trueStartTime && songPosition <= trueEndTime) {
					var ratio = MathHelper.clamp((songPosition - trueStartTime) / (trueEndTime - trueStartTime), 0.0, 1.0);
					var interpolatedSpeed:Float = speedEvent.value;
					if (line.judgeLineSpeedEvents.indexOf(speedEvent) != 0)
						interpolatedSpeed = FlxMath.lerp(line.judgeLineSpeedEvents[line.judgeLineSpeedEvents.indexOf(speedEvent) - 1].value, speedEvent.value, ratio);
					line.lineSpeed = interpolatedSpeed;
				}
				if (songPosition > trueEndTime) {
					line.judgeLineSpeedEvents.splice(line.judgeLineSpeedEvents.indexOf(speedEvent), 1);
				}
			}

			for (alphaEvent in line.judgeLineDisappearEvents){
				var trueStartTime = timeConversion(alphaEvent.startTime, line.lineBpm);
				var trueEndTime = timeConversion(alphaEvent.endTime, line.lineBpm);
				if (songPosition >= trueStartTime && songPosition <= trueEndTime) {
					var ratio = MathHelper.clamp((songPosition - trueStartTime) / (trueEndTime - trueStartTime), 0.0, 1.0);
					var interpolatedAlpha:Float = FlxMath.lerp(alphaEvent.start, alphaEvent.end, ratio);
					line.alpha = interpolatedAlpha;
				}
				if (songPosition > trueEndTime)
					line.judgeLineDisappearEvents.splice(line.judgeLineDisappearEvents.indexOf(alphaEvent), 1);
			}
		});

		super.update(elapsed);
	}

	public function getStrumY(note:Note) {
		var time:Float = note.time;
		if (note.endNote)
			time += note.holdTime;
		if (songPosition > time)
		    return 0.0;
		return (songPosition - time) * (note.below ? -note.lineObj.lineSpeed : note.lineObj.lineSpeed) * note.speed * 0.25;
	}

	public static function timeConversion(time:Float, bpm:Float):Float {
		return time / bpm * 1875.0;
	}
}
