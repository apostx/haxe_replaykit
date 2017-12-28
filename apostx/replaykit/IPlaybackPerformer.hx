package apostx.replaykit;

import haxe.Unserializer;

interface IPlaybackPerformer 
{
	public function unserializeWithTransition(from:Unserializer, to:Unserializer, percent:Float):Void;
}