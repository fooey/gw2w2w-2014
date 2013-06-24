component 
output="false"
{
	
	public function init(){
		variables.cssMergedFolder = expandPath('/siteRoot/assets/merged/');
		if(NOT directoryExists(variables.cssMergedFolder)){
			directoryCreate(variables.cssMergedFolder);
		}
		
		
		variables.yuiCompressorCSS = createObject('java', 'com.yahoo.platform.yui.compressor.CssCompressor');
		//variables.yuiCompressorJS = createObject('java', 'com.yahoo.platform.yui.compressor.JavaScriptCompressor');
		//variables.ErrorReporter = createObject('java', 'org.mozilla.javascript.ErrorReporter');
	}
	


	private function getResourceCacheTime(){
		if(request.isDev){
			return createTimeSpan(0,0,0,1);
		}
		else{
			return application.cache.time.min;
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
	
	
	
	public function getMergedLink(required resourceType, required array relPaths) output=true {
		local.lastMod = getFileInfo(getCurrentTemplatePath()).Lastmodified;
		
		local.paths = [];
		for(local.relPath in arguments.relPaths){
			arrayAppend(local.paths,  expandPath('/siteRoot/#local.relPath#'));
		}
			
		for(local.path in local.paths){
			local.mod = getFileInfo(local.path).Lastmodified;
			local.lastMod = application.util.date.dateMax(local.mod, local.lastMod);
		}
		
		local.modHash = lcase(hash(local.lastMod));
		
		local.fileName = "#local.modHash#.#arguments.resourceType#";
		local.filePath = variables.cssMergedFolder & "\#local.fileName#";
		
		local.fileNameMin = "#local.modHash#.min.#arguments.resourceType#";
		local.filePathMin = variables.cssMergedFolder & "\#local.fileNameMin#";
		
		
		if(NOT fileExists(local.filePath) OR structKeyExists(url, "recompileCss")){
			
			local.crlf = chr(13) & chr(10);
			local.crlf2 = local.crlf & local.crlf;
			
			local.cssMerged = ["/* Created #now()# */#local.crlf2#"];
			
			for(local.path in local.paths){
				arrayAppend(local.cssMerged, "/*! #local.crlf#*#local.crlf#* mergefile :: #getFileFromPath(local.path)# #local.crlf#*#local.crlf#*/#local.crlf2#");
				arrayAppend(local.cssMerged, fileRead(local.path));
			}
			
			fileWrite(local.filePath, arrayTolist(local.cssMerged, local.crlf));
			
			if(arguments.resourceType EQ "CSS"){
				compressResource(
					input = local.filePath
					, resourceType = arguments.resourceType
					, toPath = local.filePathMin
				);
			}
		}
		
		if(arguments.resourceType EQ "CSS"){
			local.urlPath = "/assets/merged/#local.fileNameMin#";
		}
		else{
			local.urlPath = "/assets/merged/#local.fileName#";
		}
		
		return local.urlPath;
	}
	
	
	
	public string function compressResource(input, resourceType, toPath){
		if(fileExists(arguments.input)){
			arguments.input = fileRead(arguments.input);
		}
		
		local.inputString = createObject('java','java.io.StringReader').init(arguments.input);
		local.outputString = createObject('java','java.io.StringWriter').init();
		
			if(arguments.resourceType EQ "css"){
				variables.yuiCompressorCSS
					.init(local.inputString)
					.compress(local.outputString, javaCast('int', -1));
			}
			/*else if(arguments.resourceType EQ "js"){
				
				arguments.linebreak = -1;
				arguments.munge = false;
				arguments.verbose = false;
				arguments.preserveAllSemiColons = false;
				arguments.disableOptimizations = false;
				arguments.disableOptimizations = false;
				arguments.charset = 'UTF-8';
				
				variables.yuiCompressorJS
						.init(
							local.inputString
							, createObject('java', 'org.mozilla.javascript.ErrorReporter')
						)
						.compress(
							local.outputString
							,javaCast('int',arguments.linebreak)
							,javaCast('boolean',arguments.munge)
							,javaCast('boolean',arguments.verbose)
							,javaCast('boolean',arguments.preserveAllSemiColons)
							,javaCast('boolean',arguments.disableOptimizations)
						);
			}*/
			else{
				throw("Not supported");
			}
			
			local.compressed = local.outputString.toString();
			
		local.outputString.close();
		local.inputString.close();
		
		if(structKeyExists(arguments, "toPath")){
			fileWrite(arguments.toPath, local.compressed);
			return true;
		}
		else{
			return local.compressed;
		}
	}

}