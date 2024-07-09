package android.flixel;

import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxGradient;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxSpriteGroup;
import flixel.ui.FlxButton;
import flixel.FlxSprite;
import flixel.FlxG;

class FlxHitbox extends FlxSpriteGroup {
	public var hitbox:FlxSpriteGroup;
	public var array:Array<FlxButton> = [];

	var hitboxColor:Map<Int, Array<Int>> = [
		1 => [0xffFFFFFF],
		2 => [0xffE390E6, 0xffFF0000],
		3 => [0xffE390E6, 0xffFFFFFF, 0xffFF0000],
		4 => [0xffE390E6, 0xff00EDFF, 0xff00FF00, 0xffFF0000],
		5 => [0xffE390E6, 0xff00EDFF, 0xffFFFFFF, 0xff00FF00, 0xffFF0000],
		6 => [0xffE390E6, 0xff00FF00, 0xffFF0000, 0xffFFFF00, 0xff00EDFF, 0xff0000FF],
		7 => [0xffE390E6, 0xff00FF00, 0xffFF0000, 0xffFFFFFF, 0xffFFFF00, 0xff00EDFF, 0xff0000FF],
		8 => [0xffE390E6, 0xff00EDFF, 0xff00FF00, 0xffFF0000, 0xffFFFF00, 0xffBB00FF, 0xffFF0000, 0xff0000FF],
		9 => [0xffE390E6, 0xff00EDFF, 0xff00FF00, 0xffFF0000, 0xffFFFFFF, 0xffFFFF00, 0xffBB00FF, 0xffFF0000, 0xff0000FF],
	   10 => [0xffE390E6, 0xff00EDFF, 0xff00FF00, 0xffFF0000, 0xffFFFFFF, 0xffFFFFFF, 0xffFFFF00, 0xffBB00FF, 0xffFF0000, 0xff0000FF],
	   11 => [0xffE390E6, 0xff00EDFF, 0xff00FF00, 0xffFF0000, 0xffE390E6, 0xffFFFFFF, 0xffFF0000, 0xffFFFF00, 0xffBB00FF, 0xffFF0000, 0xff0000FF],
	   12 => [0xffE390E6, 0xff00EDFF, 0xff00FF00, 0xffFF0000, 0xffE390E6, 0xff00EDFF, 0xff00FF00, 0xffFF0000, 0xffFFFF00, 0xffBB00FF, 0xffFF0000, 0xff0000FF],
	   13 => [0xffE390E6, 0xff00EDFF, 0xff00FF00, 0xffFF0000, 0xffE390E6, 0xff00EDFF, 0xffFFFFFF, 0xff00FF00, 0xffFF0000, 0xffFFFF00, 0xffBB00FF, 0xffFF0000, 0xff0000FF],
	   14 => [0xffE390E6, 0xff00EDFF, 0xff00FF00, 0xffFF0000, 0xffE390E6, 0xff00EDFF, 0xffFFFFFF, 0xffFFFFFF, 0xff00FF00, 0xffFF0000, 0xffFFFF00, 0xffBB00FF, 0xffFF0000, 0xff0000FF],
	   15 => [0xffE390E6, 0xff00EDFF, 0xff00FF00, 0xffFF0000, 0xffE390E6, 0xff00EDFF, 0xffFFFFFF, 0xffFFFFFF, 0xffFFFFFF, 0xff00FF00, 0xffFF0000, 0xffFFFF00, 0xffBB00FF, 0xffFF0000, 0xff0000FF],
	   16 => [0xffE390E6, 0xff00EDFF, 0xff00FF00, 0xffFF0000, 0xffE390E6, 0xff00EDFF, 0xff00FF00, 0xffFF0000, 0xffFFFF00, 0xffBB00FF, 0xffFF0000, 0xff0000FF, 0xffFFFF00, 0xffBB00FF, 0xffFF0000, 0xff0000FF],
	   17 => [0xffE390E6, 0xff00EDFF, 0xff00FF00, 0xffFF0000, 0xffE390E6, 0xff00EDFF, 0xff00FF00, 0xffFF0000, 0xFFFFFFFF, 0xffFFFF00, 0xffBB00FF, 0xffFF0000, 0xff0000FF, 0xffFFFF00, 0xffBB00FF, 0xffFF0000, 0xff0000FF],
	   18 => [0xffE390E6, 0xff00EDFF, 0xff00FF00, 0xffFF0000, 0xffFFFFFF, 0xffFFFF00, 0xffBB00FF, 0xffFF0000, 0xff0000FF, 0xffE390E6, 0xff00EDFF, 0xff00FF00, 0xffFF0000, 0xffFFFFFF, 0xffFFFF00, 0xffBB00FF, 0xffFF0000, 0xff0000FF]
	];

	public function new(type:Int = 3) {
		super();
		hitbox = new FlxSpriteGroup();
		hitbox.scrollFactor.set();
		
		var keyCount:Int = type + 1;
		var hitboxWidth:Int = Math.floor(FlxG.width / keyCount);
		for (i in 0 ... keyCount) {
			hitbox.add(add(array[i] = createhitbox(hitboxWidth * i, 0, hitboxWidth, FlxG.height, hitboxColor[keyCount][i])));
		}
	}

	public function createhitbox(x:Float = 0, y:Float = 0, width:Int, height:Int, color:Int) {
		var button:FlxButton = new FlxButton(x, y);
		button.setGraphicSize(width, height);
		button.scrollFactor.set();
		button.alpha = 0;
		button.updateHitbox();

		var gradient:FlxSprite = FlxGradient.createGradientFlxSprite(width, height, [0x00000000, color]);
		gradient.setPosition(x, y);
		gradient.scrollFactor.set();
		gradient.alpha = 0;
		add(gradient);

		button.onOut.callback = function() gradient.alpha = 0;
		button.onUp.callback = function() gradient.alpha = 0;
		button.onDown.callback = function() gradient.alpha = 0.5;
		
		return button;
	}

	override public function destroy():Void {
		super.destroy();
		for (hbox in array) {
			hbox = null;
		}
	}
}