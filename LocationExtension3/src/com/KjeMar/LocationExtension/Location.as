package com.KjeMar.LocationExtension
{
	public class Location
	{
		
		public var type:String;
		public var latitude:String;
		public var longitude:String;
		public var beaconUpper:String;
		public var beaconLower:String;
		public var wifiSSID:String;
		
		
		public function Location(inputType:String, input1:String = null, input2:String = null)
		{
			type = inputType;
			switch(type){
				case "GPS":
					latitude = input1;
					longitude = input2;
					break;
				case "Beacon":
					beaconUpper = input1;
					beaconLower = input2;
					break;
				case "WiFi":
					wifiSSID = input1;
			}
			
		}
		public function getInput():Array{
			var inputArray:Array = new Array();
			switch(type){
				case "GPS":
					inputArray.push(latitude);
					inputArray.push(longitude);
					break;
				case "Beacon":
					inputArray.push(beaconUpper);
					inputArray.push(beaconLower);
					break;
				case "WiFi":
					inputArray.push(wifiSSID);
					break;
			}
			return inputArray;
					
		}
	}
}