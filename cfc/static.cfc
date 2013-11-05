component 
output="false"
accessors="true"
{
	property name="localPath";
	property name="publicPath";
	
	property name="resourceCacheTime";
	
	public function init(
		required localPath
		, required publicPath
	){
		setLocalPath(arguments.localPath);
		setPublicPath(arguments.publicPath);
		
		setResourceCacheTime(createTimeSpan(0,0,0,5));
		
		if(NOT directoryExists(getLocalPath())){
			directoryCreate(getLocalPath());
		}
		else{
			deleteStaleFiles();
		}
		
	}
	
	
	/*
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
	*/	
	
	
	
	public function getMergedLink(required resourceType, required filePrefix, required array absPaths) output=false {
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
		
		local.fileName = "#arguments.filePrefix#.#local.modHash#.#arguments.resourceType#";
		local.filePath = getLocalPath() & "\#local.fileName#";
		
		
		if(NOT fileExists(local.filePath) OR structKeyExists(url, "recompileCss")){
			
			local.crlf = chr(13) & chr(10);
			local.crlf2 = local.crlf & local.crlf;
			
			local.cssMerged = ["/* Created #now()# */#local.crlf2#"];
			
			for(local.path in local.paths){
				arrayAppend(local.cssMerged, "#local.crlf2#/* #local.crlf#*#local.crlf#*#local.crlf#*#local.crlf#* mergefile :: #getFileFromPath(local.path)# #local.crlf#*#local.crlf#*#local.crlf#*#local.crlf#*/#local.crlf2#");
				arrayAppend(local.cssMerged, fileRead(local.path));
			}
			
			fileWrite(local.filePath, arrayTolist(local.cssMerged, local.crlf));
		}
		
		local.urlPath = getPublicPath() & "/#local.fileName#";
		
		return local.urlPath;
	}
	
	
	
	private function deleteStaleFiles() {
		local.maxAge = 5 * 24 * 60;
		local.now = now();
		local.qryFiles = directoryList(getLocalPath(), false, "query", "", "dateLastModified");
		
		for(local.r = 1; local.r LTE local.qryFiles.recordCount; local.r++){
			local.lastMod = local.qryFiles.dateLastModified[local.r];
			local.age = dateDiff("n", local.lastMod, local.now);
			local.isStale = (local.age GT local.maxAge);
			
			if(local.isStale){
				local.filePath = local.qryFiles.directory[local.r] & "\" & local.qryFiles.name[local.r];
				fileDelete(local.filePath);
			}
			else{
				break;
			}
		}
		
		return;
	}

}