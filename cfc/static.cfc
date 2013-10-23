component 
output="false"
accessors="true"
{
	property name="ResourceCacheTime";
	
	public function init(
		required localPath
		, required publicPath
	){
		variables.localPath = arguments.localPath;
		variables.publicPath = arguments.publicPath;
		variables.resourceCacheTime = createTimeSpan(0,0,0,5);
		
		if(NOT directoryExists(variables.localPath)){
			directoryCreate(variables.localPath);
		}
	}
	
	
	
	public function getLink(string relPath, appendModHash = true) {
		if(arguments.appendModHash){
			local.sysPath = expandPath('/siteRoot/#arguments.relPath#');
			local.lastModHash = application.util.fileSystem.lastModifiedHash(local.sysPath, getResourceCacheTime());
			local.urlPath = listInsertAt(arguments.relPath, listLen(arguments.relPath, "."), local.lastModHash, ".");
		}
		else{
			local.urlPath = arguments.relPath;
		}
		
		return local.urlPath;
	}	
	
	
	
	public function getMergedLink(required resourceType, required array absPaths) output=true {
		local.lastMod = getFileInfo(getCurrentTemplatePath()).Lastmodified;
		
		local.paths = [];
		for(local.path in arguments.absPaths){
			arrayAppend(local.paths,  local.path);
		}
			
		for(local.path in local.paths){
			local.mod = getFileInfo(local.path).Lastmodified;
			local.lastMod = application.util.date.dateMax(local.mod, local.lastMod);
		}
		
		local.modHash = lcase(hash(local.lastMod));
		
		local.fileName = "#local.modHash#.#arguments.resourceType#";
		local.filePath = variables.localPath & "\#local.fileName#";
		
		
		if(NOT fileExists(local.filePath) OR structKeyExists(url, "recompileCss")){
			
			local.crlf = chr(13) & chr(10);
			local.crlf2 = local.crlf & local.crlf;
			
			local.cssMerged = ["/* Created #now()# */#local.crlf2#"];
			
			for(local.path in local.paths){
				arrayAppend(local.cssMerged, "/*! #local.crlf#*#local.crlf#* mergefile :: #getFileFromPath(local.path)# #local.crlf#*#local.crlf#*/#local.crlf2#");
				arrayAppend(local.cssMerged, fileRead(local.path));
			}
			
			fileWrite(local.filePath, arrayTolist(local.cssMerged, local.crlf));
		}
		
		local.urlPath = variables.publicPath & "/#local.fileName#";
		
		return local.urlPath;
	}

}