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
		private var lastBeaconInput:String;
		
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
			checkEvent(event);
			/*var eventCode:String = event.code; // GPS
			var location:String = event.level; // lat, lng
			locationArray = location.split(",");
			var inputArray:Array = new Array();
			if(eventCode != "WiFi"){
				for each(var input:String in locationArray){
					inputArray.push(input);
				}
				if(currentLocation == null){
					currentLocation = new Location(eventCode, inputArray[0], inputArray[1]);
				}
				else{
					currentLocation.newInput(eventCode, inputArray[0], inputArray[1]);
				}
			}
			else{
				if(currentLocation == null){
					currentLocation = new Location(eventCode, event.level);
				}
				else{
					currentLocation.newInput(eventCode, event.level);
				}
			}*/
			
			var locationEvent:Event = new Event("GPS");
			this.dispatchEvent(locationEvent);
			
		}
		public function startGPSListening():void{
			if(context){
				context.call("ffiStartGPSListening", null);
			}
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
		
		public function checkEvent(event:StatusEvent):void{
			
			switch(event.code){
				case "GPS":
					addLocationData(event);
					break;
				case "WiFi":
					addWifiData(event);
					break;
				case "Beacon":
					if(lastBeaconInput == null){
						lastBeaconInput = event.level;
					}
					else if(lastBeaconInput == event.level){
						lastBeaconInput = null;
						addLocationData(event);
					}
					else{
						lastBeaconInput = event.level;
					}
					break;
				case "Beacon Exit":
					currentLocation.exitBeacon();
					break;
				case "Wifi Exit":
					currentLocation.exitWifi();
			}
		}
		
		public function addLocationData(event:StatusEvent):void{
			var inputArray:Array = new Array();
			var location:String = event.level; 
			locationArray = location.split(",");
			for each(var input:String in locationArray){
				inputArray.push(input);
			}
			if(currentLocation == null){
				currentLocation = new Location(event.code, inputArray[0], inputArray[1]);
			}
			else{
				currentLocation.newInput(event.code, inputArray[0], inputArray[1]);
			}
		}
		
		public function addWifiData(event:StatusEvent):void{
			if(currentLocation == null){
				currentLocation = new Location(event.code, event.level);
			}
			else{
				currentLocation.newInput(event.code, event.level);
			}
		}
	}
}


