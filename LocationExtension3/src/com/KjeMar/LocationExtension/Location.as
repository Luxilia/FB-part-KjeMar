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
				default:
					inputArray.push("There is currently no registered location");
					break;
			}
			return inputArray;
					
		}
		
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
					this.beaconUpper = input1;
					this.beaconLower = input2;
					break;
				case "WiFi":
					if(this.type != "Beacon"){
						this.type = inputType;
						
					}
					this.wifiSSID = input1;
					break;
					
			}
		}
		
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
			beaconLower = null;
			beaconUpper = null;
		}
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