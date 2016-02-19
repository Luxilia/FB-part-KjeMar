package com.KjeMar.LocationExtension
{
	public class Location
	{
		
		public var type:String;
		public var latitude:int;
		public var longitude:int;
		public var beaconUpper:int;
		public var beaconLower:int;
		
		
		public function Location(inputType:String, input1:int, input2:int)
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
			}
			return inputArray;
					
		}
	}
}