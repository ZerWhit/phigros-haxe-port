package states.sub;

import flixel.text.FlxText;
import flixel.addons.ui.FlxUIState;

import flixel.FlxG;
class ClassGUI extends FlxUIState {
    public var font0:String = "assets/assets/fonts/Source Han Sans & Saira Hybrid-Regular - Hot.ttf";
    public var combo:FlxText;
    public var score:FlxText;
    public var comboFollow:FlxText;
    public var trackDisplayName:FlxText;
    public var level:FlxText;
    public var comboCount:Int;
    public var numOfNotes:Int;
    public var hitNum:Int;
    public var scoreCount:Int;

    public function new() {
        super();
        combo = new FlxText(0, 6, FlxG.camera.width, "114514", 40);
        comboFollow = new FlxText(0, combo.y + combo.height - 14, FlxG.camera.width, "combo", 18);
        score = new FlxText(-14, 12, FlxG.camera.width, "1919810", 28);
        trackDisplayName = new FlxText(10, 10, FlxG.camera.width, "| trackDisplayName", 20);
        level = new FlxText(-14, 10, FlxG.camera.width, "trackLevelName", 20);
        combo.alignment = CENTER;
        comboFollow.alignment = CENTER;
        score.alignment = RIGHT;
        level.alignment = RIGHT;
        score.font = combo.font = comboFollow.font = trackDisplayName.font = level.font = font0;
        level.y = trackDisplayName.y = FlxG.camera.height - trackDisplayName.height - 10;
        add(combo);
        add(comboFollow);
        add(score);
        add(trackDisplayName);
        add(level);
    }

    public override function update(elapsed:Float) {
        combo.text = Std.string(comboCount);
        if (comboCount >= 3) {
            combo.visible = true;
            comboFollow.visible = true;
        }
        else {
            combo.visible = false;
            comboFollow.visible = false;
        }

        trackDisplayName.text = "| " + getTrackDisplayName(TrackPlayState.instance.trackName);
        level.text = "| " + getLevelDisplayName(TrackPlayState.instance.trackName);

        scoreCount = Std.int((hitNum / numOfNotes) * 1000000.0);
        var formattedNumber:String = formatWithLeadingZeroes(scoreCount, 7);
        score.text = formattedNumber;
    }

    static function formatWithLeadingZeroes(number:Int, desiredWidth:Int):String {
        var numberString:String = '' + number;
        while (numberString.length < desiredWidth) {
            numberString = '0' + numberString;
        }
        return numberString;
    }

    public function getTrackDisplayName(name:String) {
        switch (name) {
            case 'fengyu':
                return "风屿";
            case 'retribution':
                return "Retribution ~ Cycle of Redemption ~";
        }
        return "???";
    }

    public function getLevelDisplayName(name:String) {
        switch (name) {
            case 'fengyu':
                return "IN Lv.13";
            case 'retribution':
                return "SP Lv.???";
        }
        return "Unknown Lv.???";
    }
}
