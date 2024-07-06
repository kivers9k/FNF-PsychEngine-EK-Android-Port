package android.flixel;

import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxSpriteGroup;
import flixel.ui.FlxButton;
import flixel.FlxSprite;
import flixel.util.FlxGradient;

class FlxHitbox extends FlxSpriteGroup {
	public var hitbox:FlxSpriteGroup;
	public var array:Array<FlxButton> = [];

	var colors:Array<Int> = {
		red: 0xffFF0000,
		green: 0xff00FF00,
		cyan: 0xff00EDFF,
		pink: 0xffE390E6,
		white: 0xffFFFFFF,
		yellow: 0xffFFFF00,
		blue: 0xff0000FF,
		purple: 0xffBB00FF,
		darkRed: 0xffFF0000
	};
	var hitboxColor:Map<Int, Array<Int>> = [
		1 => [colors.white],
		2 => [colors.pink, colors.red],
		3 => [colors.pink, colors.white, colors.red],
		4 => [colors.pink, colors.cyan, colors.green , colors.red],
		5 => [colors.pink, colors.cyan, colors.white, colors.green , colors.red],
		6 => [colors.pink, colors.green, colors.red, colors.yellow, colors.cyan, colors.blue],
		7 => [colors.pink, colors.green, colors.red, colors.white, colors.yellow, colors.cyan, colors.blue],
		8 => [colors.pink, colors.cyan, colors.green , colors.red, colors.yellow, colors.purple, colors.red, colors.blue],
		9 => [colors.pink, colors.cyan, colors.green , colors.red, colors.white, colors.yellow, colors.purple, colors.red, colors.blue],
		10 => []
	];
	public function new(mania:Int = 3) {
		super();
		hitbox = new FlxSpriteGroup();
		hitbox.scrollFactor.set();
		
		var keyCount:Int = mania + 1;
		var hitboxWidth:Float = (FlxG.width / keyCount);
		for (i in 0 ... keyCount) {
			hitbox.add(createhitbox(hitboxWidth * i, 0, hitboxWidth, FlxG.height, hitboxColor[keyCount][i]));
			array[i].push(hitbox.members[i]);
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