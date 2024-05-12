package;

import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import openfl.display.BitmapData;
import sys.FileSystem;

class Assets
{
	public static var assets:Map<String, FlxGraphic> = new Map<String, FlxGraphic>();
	inline static public function chart(name:String)
		return 'assets/charts/${name}/insane.json';

	inline static public function music(name:String)
	    return "assets/tracks/" + name + "/music.wav";

	inline static public function sound(name:String)
	    return "assets/sounds/" + name + ".wav";

	inline static public function image(key:String, ?textureCompression:Bool = false)
	{
		var returnAsset:FlxGraphic = getGraphic(key, textureCompression);
		return returnAsset;
	}

	public static function preloadAssets(keys:Array<String>)
	{
		for (i in keys) {
			if (!assets.exists(i)){
				assets.set(i, image(i));
			}
			else {
				trace("Already has asset.");
			}
		}
	}

	public static function getGraphic(key:String, ?textureCompression:Bool = false, ?debug:Bool = false)
	{
		if (assets.exists(key))
		{
			return assets.get(key);
		}
		else
		{
			var path = getPath('assets/$key.png');
			if (FileSystem.exists(path))
			{
				var newGraphic:FlxGraphic;
				var bitmap = BitmapData.fromFile(path);
				if (textureCompression)
				{
					var texture = FlxG.stage.context3D.createTexture(bitmap.width, bitmap.height, BGRA, true, 0);
					texture.uploadFromBitmapData(bitmap);
					bitmap.dispose();
					bitmap.disposeImage();
					bitmap = null;
					if (debug)
						trace('MainPhi texture $key, bitmap is $bitmap');
					newGraphic = FlxGraphic.fromBitmapData(BitmapData.fromTexture(texture), false, key, false);
				}
				else
				{
					newGraphic = FlxGraphic.fromBitmapData(bitmap, false, key, false);
					if (debug)
						trace('MainPhi bitmap $key, not textured');
				}
				return newGraphic;
			}
		}
		if (debug)
			trace('oh no ' + key + ' is returning null NOOOO');
		return null;
	}

	inline static public function getPath(name:String)
	    return 'assets/$name';
}
