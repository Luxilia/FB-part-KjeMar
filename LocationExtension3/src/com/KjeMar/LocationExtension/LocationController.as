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
		
		public function LocationController()
		{
			fileStream = new FileStream();
		}
		
		
		public function saveLocationToFile(location:Location):void{
			locationFile = File.applicationStorageDirectory.resolvePath("test.xml");
			locationToSave = location;
			
			if(!locationFile.exists) {
				var locArray:Array = locationToSave.getInput();
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
				locationFile.addEventListener(Event.COMPLETE, onFileLoaded);
				locationFile.load();
			}
		}
		
		public function onFileLoaded(event:Event):void {
			xmlData = XML(locationFile.data);
			var locationExists:Boolean = false;
			var locArray:Array = locationToSave.getInput();
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
			else if(locationArray[0] == "nullWiFi"){
				loadedLocation = new Location(locationArray[0], locationArray[1]);
			}
			return loadedLocation;
		}
	}
}