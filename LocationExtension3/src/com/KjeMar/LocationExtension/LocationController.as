package com.KjeMar.LocationExtension
{
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	public class LocationController
	{
		
		private var fileStream:FileStream;
		
		public function LocationController()
		{
			fileStream = new FileStream();
		}
		
		
		public function saveLocationToFile(location:Location):Boolean{
			var myFile:File = File.applicationStorageDirectory.resolvePath("test.txt");
			var locationData:Array = location.getInput();
			var locationString:String;
			for each(var dataString:String in locationData){
				locationString += dataString + ",";
			}
			fileStream.open(myFile,FileMode.APPEND);
			fileStream.writeUTFBytes(locationString);
			fileStream.close();
			return true; //Add try/catches, with return true/false
		}
		
		public function loadLocationFromFile():Location{
			var locationFile:File = File.applicationStorageDirectory.resolvePath("test.txt");
			fileStream.open(locationFile,FileMode.READ);
			var locationString:String = fileStream.readMultiByte(locationFile.size,File.systemCharset);
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