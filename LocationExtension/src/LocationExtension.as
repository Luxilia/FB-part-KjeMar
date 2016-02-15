package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.text.TextField;
	import flash.events.Event;
	
	public class LocationExtension extends Sprite
	{
		public function LocationExtension()
		{
			super();
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			var txt:TextField = new TextField();
			txt.text = "Test 1, 2, 1, 2";
			stage.addChild(txt);
			this.addEventListener("GPS", onGetInfo);
		}
		
		protected function onGetInfo(evt:Event):void {
			var info:String = "";
			
			
		}
	}

}