<cfprocessingdirective pageencoding = "utf-8">
<cfscript>
	function slugify(str){
		var from  = listToArray("ą,à,á,ä,â,ã,å,æ,ă,ć,ę,è,é,ë,ê,ì,í,ï,î,ł,ń,ò,ó,ö,ô,õ,ø,ś,ș,ț,ù,ú,ü,û,ñ,ç,ż,ź,ß");
		var to    = listToArray("a,a,a,a,a,a,a,a,a,c,e,e,e,e,e,i,i,i,i,l,n,o,o,o,o,o,o,s,s,t,u,u,u,u,n,c,z,z,ss");
		
		var rStr = lCase(arguments.str);
		
		for(var i = 1; i LTE arrayLen(from); i++){
			var char = from[i];
			
			if(rStr CONTAINS from[i]){
				rStr = replace(rStr, from[i], to[i], "ALL");
			}
		}
		
		return dasherize(rStr);
    }
    
    function dasherize(str){
		var rStr = arguments.str;
		rStr = REReplace(rStr, "[^a-z]", " ", "ALL");
		rStr = REReplace(trim(rStr), " +", "-", "ALL");
		return rStr;
    }
    
    
    function getWorldsData(lang){
    	var cacheKey = "#CGI.SERVER_NAME#::getWorldsData(#arguments.lang#)";
    	var worldsData = cacheGet(cacheKey);
    	
    	if(isNull(worldsData)){
			var apiWorlds = "https://api.guildwars2.com/v1/world_names.json?lang=#arguments.lang#";
			
			var requestContent = new http(
					url=apiWorlds
					, method="GET"
					, timeout=2
				)
				.send()
				.getPrefix();
							
			if(requestContent.statusCode EQ "200 OK"){
				worldsData = deserializeJson(requestContent.fileContent.toString("UTF-8"));
				cachePut(cacheKey, worldsData, createTimeSpan(0,0,1,0));
			}
			else{
				throw("Connection failure");
			}
		}
		
		return worldsData;
    }
    
    
    
    function getPageTitle(urlLang, urlWorld){
    	if(arguments.urlWorld NEQ ""){
			try{
				var worlds = getWorldsData(arguments.urlLang);
			
				for(var world IN worlds){
					var nameSlug = slugify(world.name);
					
					if(nameSlug EQ arguments.urlWorld){
						return "#world.name# WvW Objective Timers";
					}
				}
			}
			catch(any expt){}
		}
		return "Guild Wars 2 WvW Objective Timers"; 
    }
	
</cfscript>