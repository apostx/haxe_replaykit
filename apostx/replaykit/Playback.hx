package apostx.replaykit;

import haxe.Timer;
import haxe.Unserializer;

class Playback 
{
	private var _timer:Timer;
	private var _performer:IPlaybackPerformer;
	private var _snapshotList:Array<Snapshot>;
	private var _startTime:Float;
	
	public function new(performer:IPlaybackPerformer, recording:String)
	{
		_performer = performer;
		var unserializer:Unserializer = new Unserializer(recording);
		_snapshotList = unserializer.unserialize();
		trace(_snapshotList);
	}
	
	public function play(delay_ms:Int):Void
	{
		_startTime = Date.now().getTime();
		_timer = new Timer(delay_ms);
		_timer.run = refreshSnapshot;
		refreshSnapshot();
	}
	
	public function stop():Void
	{
		_timer.stop();
		_timer.run = null;
		_timer = null;
	}
	
	private function refreshSnapshot():Void 
	{
		showSnapshot(Date.now().getTime() - _startTime);
	}
	
	public function showSnapshot(time:Float):Void
	{
		var zeroTimestamp:Float = _snapshotList[0].timestamp;
		
		for (i in 1..._snapshotList.length)
		{
			var to:Snapshot =  _snapshotList[i];
			var toTimestamp:Float = to.timestamp - zeroTimestamp;
			
			if (time < toTimestamp)
			{
				var from:Snapshot = _snapshotList[i - 1];
				var fromTimestamp:Float = from.timestamp - zeroTimestamp;
				var percent:Float = (time - fromTimestamp) / (toTimestamp - fromTimestamp);
				
				var fromUnserializer:Unserializer = new Unserializer(from.data);
				var toUnserializer:Unserializer = new Unserializer(to.data);
				
				_performer.unserializeWithTransition(fromUnserializer, toUnserializer, percent);
				
				return;
			}
		}
	}
	
	private function length():Float
	{
		return _snapshotList[_snapshotList.length - 1].timestamp - _snapshotList[0].timestamp;
	}
}