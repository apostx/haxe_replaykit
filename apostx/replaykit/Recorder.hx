package apostx.replaykit;

import haxe.Serializer;
import haxe.Timer;
import haxe.rtti.Rtti;

class Recorder
{
	var _recordingStartTime:Float;
	var _pauseStartTime:Float;
	var _pauseTotalTime:Float;
	var _autoRecordingDelay:Int;
	var _isPaused:Bool;
	var _isAutoRecordingEnabled:Bool;
	var _timer:Timer;
	var _performer:IRecorderPerformer;
	var _snapshotList:Array<Snapshot>;
	
	public function new(performer:IRecorderPerformer)
	{
		_snapshotList = new Array<Snapshot>();
		
		_performer = performer;
		
		_isPaused = false;
		_isAutoRecordingEnabled = false;
		_pauseTotalTime = 0;
		_recordingStartTime = Date.now().getTime();
	}
	
	public function pause():Void
	{
		if (_isPaused)
		{
			return;
		}
			
		_isPaused = true;
		_pauseStartTime = Date.now().getTime();
		
		forceDisableAutoRecording();
	}
	
	public function resume():Void
	{
		if (!_isPaused)
		{
			return;
		}
		
		_isPaused = false;
		_pauseTotalTime += Date.now().getTime() - _pauseStartTime;
		
		if (_isAutoRecordingEnabled)
		{
			forceEnableAutoRecording();
		}
	}

	public function takeSnapshot():Void
	{
		if (_isPaused)
		{
			return;
		}
		
		var serializer:Serializer = new Serializer();
		_performer.serialize(serializer);
		
		var snapshot:Snapshot = {
			timestamp: getElapsedTime(),
			data: serializer.toString()
		}
		
		_snapshotList.push(snapshot);
	}
	
	public function enableAutoRecording(delay_ms:Int):Void
	{
		_isAutoRecordingEnabled = true;
		_autoRecordingDelay = delay_ms;
		
		forceEnableAutoRecording();
	}
	
	public function forceEnableAutoRecording():Void
	{
		if (_isPaused)
		{
			return;
		}
		
		forceDisableAutoRecording();
		
		_timer = new Timer(_autoRecordingDelay);
		_timer.run = takeSnapshot;
		takeSnapshot();
	}
	
	public function disableAutoRecording():Void
	{
		_isAutoRecordingEnabled = false;
		
		forceDisableAutoRecording();
	}
	
	private function forceDisableAutoRecording():Void
	{
		if (_timer != null)
		{
			_timer.stop();
			_timer.run = null;
			_timer = null;
		}
	}
	
	public function toString():String
	{
		var serializer:Serializer = new Serializer();
		serializer.serialize(_snapshotList);
		return serializer.toString();
	}
	
	public function getElapsedTime():Float
	{
		return Date.now().getTime() -  _recordingStartTime - _pauseTotalTime;
	}
	
	public function dispose():Void
	{
		forceDisableAutoRecording();
		_snapshotList.splice(0, _snapshotList.length);
		_snapshotList = null;
		_performer = null;
	}
}