package math;

class MathHelper {
    public function new() {
    }

    public static function sinRadian(angle:Float){
        return Math.sin(angle * 3.1415927 / 180.0);
    }

    public static function cosRadian(angle:Float){
        return Math.cos(angle * 3.1415927 / 180.0);
    }

    public static function clamp(v:Float, min:Float, max:Float){
        return MathHelper.min(MathHelper.max(v, max), min);
    }

    public static function min(v:Float, min:Float){
        return v < min ? min : v;
    }

    public static function max(v:Float, max:Float){
        return v > max ? max : v;
    }

    public static function approximately(v1:Float, v2:Float, epsilon:Float = 1){
        return Math.abs(v1 - v2) < epsilon;
    }
}
