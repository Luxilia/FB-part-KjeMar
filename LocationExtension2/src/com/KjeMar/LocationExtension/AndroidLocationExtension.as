package com.KjeMar.LocationExtension
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	
	public class AndroidLocationExtension extends EventDispatcher
	{
		private var context:ExtensionContext;
		private var locationArray:Array;
		private var currentLocation:Location;
		
		public function AndroidLocationExtension(target:IEventDispatcher=null)
		{
			super(target);
			if(!context)
				context = ExtensionContext.createExtensionContext("com.KjeMar.LocationExtension", null);
			if(context){
				context.addEventListener(StatusEvent.STATUS,statusHandle);
				context.call("ffiStartListening", null);
			}
			
		}
		
		// listener function
		public function statusHandle(event:StatusEvent):void{
			trace(event);
			var eventCode:String = event.code; // GPS
			var location:String = event.level; // lat, lng
			locationArray = location.split(",");
			var inputArray:Array = new Array();
			for each(var input:String in locationArray){
				inputArray.push(int(input));
			}
			currentLocation = new Location(eventCode, inputArray[0], inputArray[1]);
			var locationEvent:Event = new Event("GPS");
			this.dispatchEvent(locationEvent);
			
		}
		
		public function getLocation():Array{
			locationArray = currentLocation.getInput();
			return locationArray;
		}
	}
}


