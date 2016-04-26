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
		private var locationController:LocationController;
		
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
			
			var locationEvent:Event = new Event("locationChanged");
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
		
		public function stopWifiListening():void{
			if(context){
				context.call("ffiStopWifiListening", null);
				
			}
		}
		
		public function stopGPSListening():void{
			if(context){
				context.call("ffiStopGPSListening", null);
				
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
		
		public function getLocationFromFileSystem():void{
			if(locationController == null){
				locationController = new LocationController();
			}
			currentLocation = locationController.loadLocationFromFile();
			var locationEvent:Event = new Event("locationChanged");
			this.dispatchEvent(locationEvent);
		}
		
		public function saveCurrentLocationToFileSystem():void{
			if(locationController == null){
				locationController = new LocationController();
			}
			locationController.saveLocationToFile(currentLocation);
		}
	}
}


