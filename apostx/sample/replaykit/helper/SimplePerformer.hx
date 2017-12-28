package apostx.sample.replaykit.helper;

import apostx.replaykit.IPlaybackPerformer;
import apostx.replaykit.IRecorderPerformer;
import haxe.Serializer;
import haxe.Unserializer;

class SimplePerformer implements IRecorderPerformer implements IPlaybackPerformer
{
	public var x:Int;
	
	public function new() {}
	
	public function serialize(s:Serializer):Void 
	{
		s.serialize(x);
	}
	
	public function unserializeWithTransition(from:Unserializer, to:Unserializer, percent:Float):Void 
	{
		var fromX:Int = from.unserialize();
		var toX:Int = to.unserialize();
		
		x = fromX + Math.floor((toX - fromX) * percent) ;
	}
}