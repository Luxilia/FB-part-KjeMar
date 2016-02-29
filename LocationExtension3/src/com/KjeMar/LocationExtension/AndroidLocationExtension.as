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
			}
			
		}
		
		// listener function
		public function statusHandle(event:StatusEvent):void{
			trace(event);
			var eventCode:String = event.code; // GPS
			var location:String = event.level; // lat, lng
			locationArray = location.split(",");
			var inputArray:Array = new Array();
			if(eventCode != "WiFi"){
				for each(var input:String in locationArray){
					inputArray.push(input);
				}
				currentLocation = new Location(eventCode, inputArray[0], inputArray[1]);
			}
			else{
				currentLocation = new Location(eventCode, event.level);
			}
			
			var locationEvent:Event = new Event("GPS");
			this.dispatchEvent(locationEvent);
			
		}
		
		public function getLocation():Array{
			locationArray = currentLocation.getInput();
			return locationArray;
		}
		
		public function rangeBeacons():void{
			if(context){
				context.call("ffiStartBeaconListening", null);
			}
		}
		
		public function checkBeacons():void{
			if(context){
				context.call("ffiCheckBeacons", null);
			}
		}
		
		public function stopRangeBeacons():void{
			if(context){
				
				context.call("ffiStopBeaconListening", null);
			}
		}
		
		public function startWifiListening():void{
			if(context){
				context.call("ffiStartWifiListening", null);
			}
		}
	}
}


