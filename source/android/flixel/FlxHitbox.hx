package android.flixel;

import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxSpriteGroup;
import flixel.ui.FlxButton;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxGradient;

class FlxHitbox extends FlxSpriteGroup {
	public var hitbox:FlxSpriteGroup;
	public var array:Array<FlxButton> = [];

	/*red: 0xffFF0000
	green: 0xff00FF00
	cyan: 0xff00EDFF
	pink: 0xffE390E6
	white: 0xffFFFFFF
	yellow: 0xffFFFF00
	blue: 0xff0000FF
	purple: 0xffBB00FF
	darkRed: 0xffFF0000*/

	var hitboxColor:Map<Int, Array<Int>> = [
		1 => [
			0xffFFFFFF
		],
		2 => [
			0xffE390E6,
			0xffFF0000
		],
		3 => [
			0xffE390E6,
			0xffFFFFFF,
			0xffFF0000
		],
		4 => [
			0xffE390E6,
			0xff00EDFF,
			0xff00FF00,
			0xffFF0000
		],
		5 => [
			0xffE390E6,
			0xff00EDFF,
			0xffFFFFFF,
			0xff00FF00,
			0xffFF0000
		],
		6 => [
			0xffE390E6,
			0xff00FF00,
			0xffFF0000,
			0xffFFFF00,
			0xff00EDFF,
			0xff0000FF
		],
		7 => [
			0xffE390E6,
			0xff00FF00,
			0xffFF0000,
			0xffFFFFFF,
			0xffFFFF00,
			0xff00EDFF,
			0xff0000FF
		],
		8 => [
			0xffE390E6,
			0xff00EDFF,
			0xff00FF00,
			0xffFF0000,
			0xffFFFF00,
			0xffBB00FF,
			0xffFF0000,
			0xff0000FF
		],
		9 => [
			0xffE390E6,
			0xff00EDFF,
			0xff00FF00,
			0xffFF0000,
			0xffFFFFFF,
			0xffFFFF00,
			0xffBB00FF,
			0xffFF0000,
			0xff0000FF
		],
		10 => []
	];
	public function new(type:Int = 3) {
		super();
		hitbox = new FlxSpriteGroup();
		hitbox.scrollFactor.set();
		
		var keyCount:Int = type + 1;
		var hitboxWidth:Float = (FlxG.width / keyCount);
		for (i in 0 ... keyCount) {
			hitbox.add(createhitbox(hitboxWidth * i, 0, hitboxWidth, FlxG.height, hitboxColor[keyCount][i]));
			array[i] = hitbox.members[i];
		}
	}

	public function createhitbox(x:Float = 0, y:Float = 0, width:Float, height:Float, color:Int) {
		var gradient:FlxGradient = FlxGradient.createGradientFlxSprite(width, height, [0x00000000, color]);
		gradient.setPosition(x, y);
		gradient.alpha = 0;
		add(gradient);
	
		var button:FlxButton = new FlxButton(x, y);
		button.setGraphicSize(width, height);
		button.alpha = 0;
		button.updateHitbox();
	
		button.onOut.callback = function() gradient.alpha = 0;
		button.onUp.callback = function() gradient.alpha = 0;
		button.onDown.callback = function() gradient.alpha = 0.5;
		
		return button;
	}

	override public function destroy():Void
	{
		super.destroy();
		for (hbox in hitbox.members) {
			hbox = null;
		}
	}
}