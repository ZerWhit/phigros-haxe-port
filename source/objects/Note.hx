package objects;
import flixel.FlxSprite;
import states.TrackPlayState;

import math.MathHelper;
import flixel.math.FlxMath;
typedef NoteObject =
{
    var type:Int;
    var time:Float;
    var positionX:Float;
    var holdTime:Float;
    var speed:Float;
    var floorPosition:Float;
}

class Note extends FlxSprite {
    public var lineObj:JudgeLine;
    public var headObj:Note;
    public var endObj:Note;
    public var type:Int;
    public var time:Float;
    public var positionX:Float;
    public var holdTime:Float;
    public var speed:Float;
    public var floorPosition:Float;
    public var highlight:Bool;
    public var below:Bool = false;
    public var holdNote:Bool;
    public var endNote:Bool;
    public var shouldBeRemove:Bool = false;
    public var strumY:Float;
    public var ticksExisted:Int;

    public function new(noteObject:NoteObject, lineObject:JudgeLine, hl:Bool = false, hold:Bool = false, end:Bool = false) {
        super();

        lineObj = lineObject;

        type = noteObject.type;
        time = TrackPlayState.timeConversion(noteObject.time, lineObj.lineBpm);
        positionX = noteObject.positionX;
        holdTime = TrackPlayState.timeConversion(noteObject.holdTime, lineObj.lineBpm);
        speed = noteObject.speed;
        floorPosition = noteObject.floorPosition;

        highlight = hl;
        holdNote = hold;
        endNote = end;

        centerOffsets();
        switch (type)
        {
            case 1:
                if (!highlight) {
                    loadGraphic(Assets.image('note/tap'));
                    offset.y += 50.0;
                }
                else {
                    loadGraphic(Assets.image('note/tap_hl'));
                    offset.y += 100.0;
                }
            case 2:
                if (!highlight) {
                    loadGraphic(Assets.image('note/drag'));
                    offset.y += 30;
                }
                else {
                    loadGraphic(Assets.image('note/drag_hl'));
                    offset.y += 80.0;
                }
            case 3:
                if (!highlight) {
                    loadGraphic(Assets.image('note/hold_head'));
                    offset.y = 50 * 0.4 + 1.5;
                }
                else {
                    loadGraphic(Assets.image('note/hold2_hl_0'));
                    offset.y = 97 * 0.4 + 1.5;
                }

                if (holdNote) {
                    if (!highlight) {
                        loadGraphic(Assets.image('note/hold'));
                        offset.y = 1900;
                    }
                    else {
                        loadGraphic(Assets.image('note/hold2_hl_1'));
                        offset.y = 1855;
                    }
                }

                if (endNote) {
                    loadGraphic(Assets.image('note/hold_end'));
                    offset.y = 50 * 0.6 - 1.5;
                }

                if (below) {
                    flipY = true;
                }
            case 4:
                if (!highlight) {
                    loadGraphic(Assets.image('note/flick'));
                    offset.y += 100.0;
                }
                else {
                    loadGraphic(Assets.image('note/flick_hl'));
                    offset.y += 150.0;
                }
        }
        setGraphicSize(Std.int(width * 0.15));
        centerOrigin();
        if (holdNote)
            origin.set(frameWidth * 0.5, frameHeight);
    }

    public override function update(elapsed:Float){
        super.update(elapsed);

        ticksExisted++;

        if (holdNote) {
            setGraphicSize(Std.int(width * 0.15), Std.int(Math.abs(endObj.strumY - headObj.strumY)));
        }

        if (shouldBeRemove) {
            if (!holdNote && !endNote) {
                remove();
            }
            else if (TrackPlayState.songPosition >= time + holdTime) {
                remove();
            }
        }
    }

    public function remove() {
        alive = false;
        visible = false;
        kill();
        TrackPlayState.noteList.remove(this);
        if (!holdNote) {
            TrackPlayState.instance.displayUI.comboCount++;
            TrackPlayState.instance.displayUI.hitNum++;
        }
    }
}
