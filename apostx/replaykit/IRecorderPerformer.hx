package apostx.replaykit;

import haxe.Serializer;

interface IRecorderPerformer 
{
	public function serialize(s:Serializer):Void;
}