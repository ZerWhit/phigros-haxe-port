package;

@:build(flixel.system.FlxAssets.buildFileReferences("assets", true))
class AssetPaths
{
	public static function imagePath(name:String)
	{
		return "assets/images/" + name + ".png";
	}

	public static function musicPath(name:String)
	{
		return "assets/music/" + name + ".wav";
	}

	inline static public function json(song:String)
		return 'assets/data/${song.toLowerCase()}/${song.toLowerCase()}-CHART_IN.json';
}
