package com.KjeMar.LocationExtension
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.StatusEvent;
	import flash.events.TimerEvent;
	import flash.external.ExtensionContext;
	import flash.utils.Timer;
	
	public class SuperPosition extends EventDispatcher
	{
		private var context:ExtensionContext; // Extension context
		private var locationArray:Array; // Array for holding variables of a location object
		private var currentLocation:Location; // The current location
		private var lastBeaconInput:String; // Helper to prevent false positives from beacons
		private var locationController:LocationController; // Location controller instance
		private var timer:Timer; // Timer for comparing locations
		private var savedLocation:Boolean; // Is current location a saved location?

		/**
		 * The class constructor
		 * 
		 * Creates extension context for native code
		 * Loads the saved locations from file 
		 * Creates and starts a timer for comparing current location to saved locations
		 */
		public function SuperPosition(target:IEventDispatcher=null)
		{
			super(target);
			locationController = new LocationController();
			if(!context)
				context = ExtensionContext.createExtensionContext("com.KjeMar.LocationExtension", null);
			if(context){
				context.addEventListener(StatusEvent.STATUS,statusHandle);
			}
			loadLocations();
			timer = new Timer(20000, 0);
			timer.addEventListener(TimerEvent.TIMER, checkCurrentLocation);
			timer.start();
		}
		
		/**
		 * Eventlistener for timer
		 * Checks if the current location is a saved location
		 * 
		 * @param event The calling event
		 */
		private function checkCurrentLocation(event:Event):void{
			if(currentLocation != null) {
				
				if(locationController.compareLocations(currentLocation)) {
					savedLocation = true;
				}else {
					savedLocation = false;
				}
				var testEvent:Event = new Event("testEvent");
				this.dispatchEvent(testEvent);
			}
		}
		
		/**
		 * Returns the savedLocation boolean
		 * 
		 * @return Boolean indicating if the location is a saved location
		 */
		public function getSavedLocation():Boolean{
			return savedLocation;
		}
		
		/**
		 * Loads locations from file through location controller
		 */
		private function loadLocations():void {
			locationController.loadXmlData();
		}	
		
		/**
		 * Listens for status events from native code
		 * Dispatches a location event 
		 * 
		 * @param event Status event from native code
		 * 
		 * @see dispatchEvent
		 */
		public function statusHandle(event:StatusEvent):void{
			trace(event);
			checkEvent(event);
			
			var locationEvent:Event = new Event("locationChanged");
			this.dispatchEvent(locationEvent);
		}
		
		/**
		 * Sends a call to native code to start gps listening
		 */
		public function startGPSListening():void{
			if(context){
				context.call("ffiStartGPSListening", null);
			}
		}
		
		/**
		 * Returns the current location as an array
		 * 
		 * @return Array with string variables describing current location
		 */
		public function getLocation():Array{
			locationArray = currentLocation.getInput();
			return locationArray;
		}
		
		/**
		 * Sends a call to native code to start ranging beacons
		 */
		public function rangeBeacons():void{
			if(context){
				context.call("ffiStartBeaconListening", null);
			}
		}
		
		/*
		public function checkBeacons():void{
			if(context){
				context.call("ffiCheckBeacons", null);
			}
		}
		*/
		
		/**
		 * Sends a call to native code to stop ranging beacons
		 */
		public function stopRangeBeacons():void{
			if(context){
				context.call("ffiStopBeaconListening", null);
			}
		}
		
		/**
		 * Sends a call to native code to start WiFi listening
		 */
		public function startWifiListening():void{
			if(context){
				context.call("ffiStartWifiListening", null);
			}
		}
		
		/**
		 * Sends a call to native code to stop WiFi listening
		 */
		public function stopWifiListening():void{
			if(context){
				context.call("ffiStopWifiListening", null);
			}
		}
		
		/**
		 * Sends a call to native code to stop gps listening
		 */
		public function stopGPSListening():void{
			if(context){
				context.call("ffiStopGPSListening", null);
			}
		}
		
		/**
		 * Handles the status event from native code
		 * Checks the type and calls the corresponding method
		 * 
		 * @param event Status event from native code
		 */
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
		
		/**
		 * Adds variable data to the current location
		 * 
		 * @param event Status event from native code
		 */
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
		
		/**
		 * Adds variable data to the current location, special case for WiFi input
		 * 
		 * @param event Status event from native code
		 */
		public function addWifiData(event:StatusEvent):void{
			if(currentLocation == null){
				currentLocation = new Location(event.code, event.level);
			}
			else{
				currentLocation.newInput(event.code, event.level);
			}
		}
		
		/*
		public function getLocationFromFileSystem():void{
			if(locationController == null){
				locationController = new LocationController();
			}
			currentLocation = locationController.loadLocationFromFile();
			var locationEvent:Event = new Event("locationChanged");
			this.dispatchEvent(locationEvent);
		}
		*/
		
		/**
		 * Saves current location to file system
		 */
		public function saveCurrentLocationToFileSystem():void{
			if(locationController == null){
				locationController = new LocationController();
			}
			locationController.saveLocationToFile(currentLocation);
		}
	}
}


