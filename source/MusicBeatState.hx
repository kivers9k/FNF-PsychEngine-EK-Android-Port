package;

import openfl.geom.Rectangle;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.text.FlxText;
import Conductor.BPMChangeEvent;
import flixel.FlxG;
import flixel.addons.ui.FlxUIState;
import flixel.math.FlxRect;
import flixel.util.FlxTimer;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import flixel.FlxState;
import flixel.FlxCamera;
import flixel.FlxBasic;
#if mobile
import flixel.input.actions.FlxActionInput;
import android.flixel.FlxHitbox;
import android.flixel.FlxVirtualPad;
#end

class MusicBeatState extends FlxUIState
{
	private var curSection:Int = 0;
	private var stepsToDo:Int = 0;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;

	private var curDecStep:Float = 0;
	private var curDecBeat:Float = 0;
	private var controls(get, never):Controls;

	public static var camBeat:FlxCamera;

	inline function get_controls():Controls
	return PlayerSettings.player1.controls;

	#if mobile
	var _virtualpad:FlxVirtualPad;
	var _hitbox:FlxHitbox;
	var trackedinputsUI:Array<FlxActionInput> = [];
	var trackedinputsNOTES:Array<FlxActionInput> = [];
	#end

	#if mobile
	public function addVirtualPad(?DPad:FlxDPadMode, ?Action:FlxActionMode) {
        _virtualpad = new FlxVirtualPad(DPad, Action, 0.75, ClientPrefs.globalAntialiasing);
		add(_virtualpad);
		controls.setVirtualPadUI(_virtualpad, DPad, Action);
		trackedinputsUI = controls.trackedinputsUI;
		controls.trackedinputsUI = [];
	}
	#end

    #if mobile
    public function addVirtualPadCamera() {
		var virtualpadcam = new flixel.FlxCamera();
		virtualpadcam.bgColor.alpha = 0;
		FlxG.cameras.add(virtualpadcam, false);
		_virtualpad.cameras = [virtualpadcam];
    }
    #end

	#if mobile
	public function removeVirtualPad() {
		controls.removeFlxInput(trackedinputsUI);
		remove(_virtualpad);
	}
	#end

    #if mobile
	public function addHitbox(mania:Int) {
		var curhitbox:HitboxType = FOUR;

		switch (mania){
			case 0:
				curhitbox = ONE;
			case 1:
				curhitbox = TWO;
			case 2:
				curhitbox = THREE;
			case 3:
				curhitbox = FOUR;
			case 4:
				curhitbox = FIVE;
			case 5:
				curhitbox = SIX;
			case 6:
				curhitbox = SEVEN;
			case 7:
				curhitbox = EIGHT;
			case 8:
				curhitbox = NINE;
			case 9:
				curhitbox = TEN;
			case 10:
				curhitbox = ELEVEN;
			case 11:
				curhitbox = TWELVE;
			case 12:
				curhitbox = THIRTEEN;
			case 13:
				curhitbox = FOURTEEN;
			case 14:
				curhitbox= FIFTEEN;
			case 15:
				curhitbox = SIXTEEN;
			case 16:
				curhitbox= SEVENTEEN;
			case 17:
				curhitbox = EIGHTEEN;
			default:
				curhitbox = FOUR;
		}
		_hitbox = new FlxHitbox(curhitbox);

		var hitboxcam = new flixel.FlxCamera();
		hitboxcam.bgColor.alpha = 0;
		FlxG.cameras.add(hitboxcam, false);
		_hitbox.cameras = [hitboxcam];

		_hitbox.visible = false;
		add(_hitbox);
	}
    #end

	override function destroy() {
		#if mobile
		controls.removeFlxInput(trackedinputsUI);
		controls.removeFlxInput(trackedinputsNOTES);
		#end

		super.destroy();
	}

	override function create() {
		camBeat = FlxG.camera;
		var skip:Bool = FlxTransitionableState.skipNextTransOut;
		super.create();

		if(!skip) {
			openSubState(new CustomFadeTransition(0.7, true));
		}
		FlxTransitionableState.skipNextTransOut = false;
	}

	override function update(elapsed:Float)
	{
		//everyStep();
		var oldStep:Int = curStep;

		updateCurStep();
		updateBeat();

		if (oldStep != curStep)
		{
			if(curStep > 0)
				stepHit();

			if(PlayState.SONG != null)
			{
				if (oldStep < curStep)
					updateSection();
				else
					rollbackSection();
			}
		}

		if(FlxG.save.data != null) FlxG.save.data.fullscreen = FlxG.fullscreen;

		super.update(elapsed);
	}

	private function updateSection():Void
	{
		if(stepsToDo < 1) stepsToDo = Math.round(getBeatsOnSection() * 4);
		while(curStep >= stepsToDo)
		{
			curSection++;
			var beats:Float = getBeatsOnSection();
			stepsToDo += Math.round(beats * 4);
			sectionHit();
		}
	}

	private function rollbackSection():Void
	{
		if(curStep < 0) return;

		var lastSection:Int = curSection;
		curSection = 0;
		stepsToDo = 0;
		for (i in 0...PlayState.SONG.notes.length)
		{
			if (PlayState.SONG.notes[i] != null)
			{
				stepsToDo += Math.round(getBeatsOnSection() * 4);
				if(stepsToDo > curStep) break;
				
				curSection++;
			}
		}

		if(curSection > lastSection) sectionHit();
	}

	private function updateBeat():Void
	{
		curBeat = Math.floor(curStep / 4);
		curDecBeat = curDecStep/4;
	}

	private function updateCurStep():Void
	{
		var lastChange = Conductor.getBPMFromSeconds(Conductor.songPosition);

		var shit = ((Conductor.songPosition - ClientPrefs.noteOffset) - lastChange.songTime) / lastChange.stepCrochet;
		curDecStep = lastChange.stepTime + shit;
		curStep = lastChange.stepTime + Math.floor(shit);
	}

	public static function switchState(nextState:FlxState) {
		// Custom made Trans in
		var curState:Dynamic = FlxG.state;
		var leState:MusicBeatState = curState;
		if(!FlxTransitionableState.skipNextTransIn) {
			leState.openSubState(new CustomFadeTransition(0.6, false));
			if(nextState == FlxG.state) {
				CustomFadeTransition.finishCallback = function() {
					FlxG.resetState();
				};
				//trace('resetted');
			} else {
				CustomFadeTransition.finishCallback = function() {
					FlxG.switchState(nextState);
				};
				//trace('changed state');
			}
			return;
		}
		FlxTransitionableState.skipNextTransIn = false;
		FlxG.switchState(nextState);
	}

	public static function resetState() {
		MusicBeatState.switchState(FlxG.state);
	}

	public static function getState():MusicBeatState {
		var curState:Dynamic = FlxG.state;
		var leState:MusicBeatState = curState;
		return leState;
	}

	public function stepHit():Void
	{
		if (curStep % 4 == 0)
			beatHit();
	}

	public function beatHit():Void
	{
		//trace('Beat: ' + curBeat);
	}

	public function sectionHit():Void
	{
		//trace('Section: ' + curSection + ', Beat: ' + curBeat + ', Step: ' + curStep);
	}

	function getBeatsOnSection()
	{
		var val:Null<Float> = 4;
		if(PlayState.SONG != null && PlayState.SONG.notes[curSection] != null) val = PlayState.SONG.notes[curSection].sectionBeats;
		return val == null ? 4 : val;
	}
}
