package apostx.replaykit;

import haxe.Serializer;
import haxe.Timer;
import haxe.rtti.Rtti;

class Recorder
{
	private var _timer:Timer;
	private var _performer:IRecorderPerformer;
	private var _snapshotList:Array<Snapshot>;
	
	public function new(performer:IRecorderPerformer)
	{
		_performer = performer;
		_snapshotList = new Array<Snapshot>();
	}
	
	public function takeSnapshot():Void
	{
		var serializer:Serializer = new Serializer();
		_performer.serialize(serializer);
		
		var snapshot:Snapshot = {
			timestamp: Date.now().getTime(),
			data: serializer.toString()
		}
		
		_snapshotList.push(snapshot);
	}
	
	public function startRecording(delay_ms:Int):Void
	{
		stopRecording();
		_timer = new Timer(delay_ms);
		_timer.run = takeSnapshot;
		takeSnapshot();
	}
	
	public function stopRecording():Void
	{
		_timer.stop();
		_timer.run = null;
		_timer = null;
	}
	
	public function isRecording():Bool
	{
		return _timer != null;
	}
	
	public function toString():String
	{
		var serializer:Serializer = new Serializer();
		serializer.serialize(_snapshotList);
		return serializer.toString();
	}
}