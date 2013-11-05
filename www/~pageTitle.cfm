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
			var apiWorlds = "https://api.guildwars2.com/v1/world_names.json?lang=#url.lang#";
			
			var requestContent = new http(
					url=apiWorlds
					, method="GET"
					, timeout=2
				)
				.send()
				.getPrefix()
				.fileContent.toString("UTF-8");
				
			worldsData = deserializeJson(requestContent);
			
			cachePut(cacheKey, worldsData, createTimeSpan(0,0,1,0));
		}
		
		return worldsData;
    }
    
    
    
    function getPageTitle(){
		try{
			worlds = getWorldsData(url.lang);
		
			for(world IN worlds){
				world['slug'] = slugify(world.name);
				
				if(world['slug'] EQ url.world){
					return "#world.name# WvW Objective Timers";
				}
			}
		}
		catch(any expt){}
		
		//else
		return "Guild Wars 2 WvW Objective Timers";  
    	
    }
	
</cfscript>