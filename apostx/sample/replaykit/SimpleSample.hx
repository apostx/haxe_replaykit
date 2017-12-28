package apostx.sample.replaykit;

import apostx.replaykit.Playback;
import apostx.replaykit.Recorder;
import haxe.Timer;
import apostx.sample.replaykit.helper.SimplePerformer;

class SimpleSample 
{
	static function main() 
	{	
		var performer:SimplePerformer = new SimplePerformer();
		var recorder:Recorder = new Recorder(performer);
		
		performer.x = 10;
		recorder.takeSnapshot();
		
		trace(recorder.toString());
		
		var timer:Timer = new Timer(1000);
		timer.run = function()
		{
			timer.stop();
			
			performer.x = 20;
			recorder.takeSnapshot();
			
			var playback:Playback = new Playback(performer, recorder.toString());
			playback.showSnapshot(500);
			
			trace(performer.x);
		};
	}
}