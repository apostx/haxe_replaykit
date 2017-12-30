package apostx.replaykit;

import haxe.Timer;
import haxe.Unserializer;

class Playback 
{
	private var _performer:IPlaybackPerformer;
	private var _snapshotList:Array<Snapshot>;
	
	public function new(performer:IPlaybackPerformer, recording:String)
	{
		_performer = performer;
		var unserializer:Unserializer = new Unserializer(recording);
		_snapshotList = unserializer.unserialize();
	}
	
	public function showSnapshot(elapsedTime:Float):Void
	{
		for (i in 1..._snapshotList.length)
		{
			var to:Snapshot =  _snapshotList[i];
			var toTimestamp:Float = to.timestamp;
			
			if (elapsedTime < toTimestamp)
			{
				var from:Snapshot = _snapshotList[i - 1];
				var percent:Float = Math.max((elapsedTime - from.timestamp) / (to.timestamp - from.timestamp), 0);
				
				var fromUnserializer:Unserializer = new Unserializer(from.data);
				var toUnserializer:Unserializer = new Unserializer(to.data);
				
				_performer.unserializeWithTransition(fromUnserializer, toUnserializer, percent);
				
				return;
			}
		}
	}
	
	public function dispose():Void
	{
		_snapshotList.splice(0, _snapshotList.length);
		_snapshotList = null;
		_performer = null;
	}
}