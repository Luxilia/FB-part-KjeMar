package com.KjeMar.LocationExtension
{
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	public class LocationController
	{
		
		private var fileStream:FileStream;
		private var xmlData:XML;
		private var locationFile:File;
		private var locationToSave:Location;
		private var gpsLocations:Array;
		private var wiFiLocations:Array;
		private var beaconsLocations:Array;
		
		public function LocationController()
		{
			fileStream = new FileStream();
		}
		
		public function loadXmlData():void{
			locationFile = File.applicationStorageDirectory.resolvePath("test.xml");
			if(locationFile.exists) {
				locationFile.addEventListener(Event.COMPLETE, onFileLoaded);
				locationFile.load();
			}
		}
		
		public function compareLocations(currentLocation:Location):Boolean{
			switch(currentLocation.type) {
				case "GPS":
					for each(var locationToCompare:Location in gpsLocations) {
						if(compareLatLng(currentLocation, locationToCompare) < 50) {
							return true;
						}
					}
					break;
				case "WiFi":
					for each(var locationToCompare:Location in gpsLocations) {
						if(currentLocation.wifiSSID == locationToCompare.wifiSSID) {
							return true;
						}
					}
					break;
				case "Beacon":
					for each(var locationToCompare:Location in gpsLocations) {
						if(currentLocation.beaconLower == locationToCompare.beaconLower && 
								currentLocation.beaconUpper == locationToCompare.beaconUpper) {
							return true;
						}
					}					
					break;
			}
			return false;
		}
		
		public function compareLatLng(location1:Location, location2:Location):Number{
			var latitude1:Number = Number(location1.latitude);
			var latitude2:Number = Number(location2.latitude);
			var longitude1:Number = Number(location1.longitude);
			var longitude2:Number = Number(location2.longitude);
			var R:Number = 6378.137; // Radius of earth in KM
			var dLat:Number = (latitude2 - latitude1) * Math.PI / 180;
			var dLng:Number = (longitude2 - longitude1) * Math.PI / 180;
			var a:Number = Math.sin(dLat/2) * Math.sin(dLat/2) +
				Math.cos(latitude1  * Math.PI / 180)  * Math.cos(latitude2  * Math.PI / 180) * 
				Math.sin(dLng/2) * Math.sin(dLng/2);
			var c:Number = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
			var d:Number = R * c;
			return d * 1000; // meters
		}
		
		public function getLocationsFromXml():void{
			gpsLocations = new Array();
			wiFiLocations = new Array();
			beaconsLocations = new Array();
			var type:String;
			for each (var locationObject:XML in xmlData.Location.LocationObject) {
				type = locationObject.Type;
				switch (type) {
					case "GPS":
						gpsLocations.push(new Location(locationObject.Type, locationObject.Input1, locationObject.Input2));
						//locationObject.parent().@name
						break;
					case "WiFi":
						wiFiLocations.push(new Location(locationObject.Type, locationObject.Input1, null));
						break;
					case "Beacon":
						beaconsLocations.push(new Location(locationObject.Type, locationObject.Input1, locationObject.Input2));
						break;
				}
			}
		}
		
		public function saveLocationToFile(inputLocation:Location):void{
			locationFile = File.applicationStorageDirectory.resolvePath("test.xml");
			locationToSave = inputLocation;
			
			var locArray:Array = locationToSave.getInput();
			if(!locationFile.exists) {
				if(locArray.length == 2) {
					xmlData = 
						<Locations>
							<Location name="test">
								<LocationObject>
									<Type>{locArray[0]}</Type>
									<Input1>{locArray[1]}</Input1>
								</LocationObject>
							</Location>
						</Locations>;
				} else if(locArray.length == 3) {
					xmlData = 
						<Locations>
							<Location name="test">
								<LocationObject>
									<Type>{locArray[0]}</Type>
									<Input1>{locArray[1]}</Input1>
									<Input2>{locArray[2]}</Input2>
								</LocationObject>
							</Location>
						</Locations>;
				}
				fileStream.open(locationFile,FileMode.WRITE);
				fileStream.writeUTFBytes(xmlData);
				fileStream.close();
				
			}else {
				var locationExists:Boolean = false;
				for each (var location:XML in xmlData.Location) {
					if(locationToSave.name == location.@name) {
						
						locationExists = true;
						if(locArray.length == 2) {
							xmlData.Location.(@name == locationToSave.name).appendChild(<LocationObject>
								<Type>{locArray[0]}</Type>
								<Input1>{locArray[1]}</Input1>
								</LocationObject>);
						} else if(locArray.length == 3) {
							xmlData.Location.(@name == locationToSave.name).appendChild(<LocationObject>
								<Type>{locArray[0]}</Type>
								<Input1>{locArray[1]}</Input1>
								<Input2>{locArray[2]}</Input2>
								</LocationObject>);
						}
					}	
				}
				if(!locationExists) {
					if(locArray.length == 2) {
						xmlData.appendChild(<Location><LocationObject>
							<Type>{locArray[0]}</Type>
							<Input1>{locArray[1]}</Input1>
							</LocationObject></Location>);
					} else if(locArray.length == 3) {
						xmlData.appendChild(<Location><LocationObject>
							<Type>{locArray[0]}</Type>
							<Input1>{locArray[1]}</Input1>
							<Input2>{locArray[2]}</Input2>
							</LocationObject></Location>);
					}
				}
				fileStream.open(locationFile,FileMode.WRITE);
				fileStream.writeUTFBytes(xmlData);
				fileStream.close();
			}
		}
		
		public function onFileLoaded(event:Event):void {
			xmlData = XML(locationFile.data);
			getLocationsFromXml();
			
		}
		
		public function loadLocationFromFile():Location{
			var locationFile:File = File.applicationStorageDirectory.resolvePath("test.xml");
			fileStream.open(locationFile,FileMode.READ);
			var locationString:String = fileStream.readMultiByte(locationFile.size,File.systemCharset);
			fileStream.close();
			var locationArray:Array = locationString.split(",");
			var loadedLocation:Location;
			if(locationArray[0] == "GPS" || locationArray[0] == "Beacon"){
				loadedLocation = new Location(locationArray[0], locationArray[1], locationArray[2]);
			}
			else if(locationArray[0] == "WiFi"){
				loadedLocation = new Location(locationArray[0], locationArray[1]);
			}
			return loadedLocation;
		}
	}
}