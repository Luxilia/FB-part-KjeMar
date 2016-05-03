package com.KjeMar.LocationExtension
{
	public class Location
	{
		public var type:String; // The location type
		public var latitude:String; // Latitude for gps location
		public var longitude:String; // Longitude for gps location
		public var major:String; // Major value for beacon location
		public var minor:String; // Minor value for beacon location 
		public var wifiSSID:String; // SSID string for WiFi location
		public var name:String; // Name of location
		
		/**
		 * Constructor for location object
		 * 
		 * @param inputType The location type
		 * @param input1 First input for location (latitude, major, wifiSSID)
		 * @param input2 Second input for location (longitude, minor)
		 */
		public function Location(inputType:String, input1:String = null, input2:String = null)
		{
			type = inputType;
			switch(type){
				case "GPS":
					latitude = input1;
					longitude = input2;
					break;
				case "Beacon":
					major = input1;
					minor = input2;
					break;
				case "WiFi":
					wifiSSID = input1;
			}
		}
		
		/**
		 * Sets the name of the location
		 * 
		 * @param inputName Name of the location
		 */
		public function setName(inputName:String):void {
			name = inputName;
		}
		
		/**
		 * Gets current location as Array
		 * 
		 * @return An array representing current location
		 */
		public function getInput():Array{
			var inputArray:Array = new Array();
			inputArray.push(type);
			switch(type){
				case "GPS":
					inputArray.push(latitude);
					inputArray.push(longitude);
					break;
				case "Beacon":
					inputArray.push(major);
					inputArray.push(minor);
					break;
				case "WiFi":
					inputArray.push(wifiSSID);
					break;
				default:
					inputArray.push("There is currently no registered location");
					break;
			}
			return inputArray;
		}
		
		/**
		 * Updates the location object with input from native code
		 * Prioritizes input type to keep the strongest type on top
		 * 
		 * @param inputType Type of the new input
		 * @param input1 First parameter of new input (latitude, major, wifiSSID)
		 * @param input2 Second parameter of new input (longitude, minor)
		 */
		public function newInput(inputType:String, input1:String = null, input2:String = null):void{
			switch(inputType){
				case "GPS":
					if(this.type != "Beacon" && this.type != "WiFi"){
						this.type = inputType;
					}
					this.latitude = input1;
					this.longitude = input2;
					break;
				case "Beacon":
					this.type = inputType;
					this.major = input1;
					this.minor = input2;
					break;
				case "WiFi":
					if(this.type != "Beacon"){
						this.type = inputType;
					}
					this.wifiSSID = input1;
					break;
			}
		}
		
		/**
		 * Removes beacon input from location object
		 * Updates location type to next highest priority, existing type 
		 */
		public function exitBeacon():void{
			if(type == "Beacon"){
				if(wifiSSID != null){
					type = "WiFi";
				}
				else if(latitude != null && longitude != null){
					type = "GPS";
				}
				else{
					type = null;
				}
			}
			minor = null;
			major = null;
		}
		
		/**
		 * Removes WiFi input from location object
		 * Updates location type to GPS if exist
		 */
		public function exitWifi():void{
			if(type == "WiFi"){
				if(latitude != null && longitude != null){
					type = "GPS";
				}
				else{
					type = null;
				}
			}
			wifiSSID = null;
		}
	}
}