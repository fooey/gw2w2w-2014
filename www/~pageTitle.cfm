<cfprocessingdirective pageencoding = "utf-8">
<cfscript>
	function slugify(str){
		var from  = listToArray("ą,à,á,ä,â,ã,å,æ,ă,ć,ę,è,é,ë,ê,ì,í,ï,î,ł,ń,ò,ó,ö,ô,õ,ø,ś,ș,ț,ù,ú,ü,û,ñ,ç,ż,ź,ß");
		var to    = listToArray("a,a,a,a,a,a,a,a,a,c,e,e,e,e,e,i,i,i,i,l,n,o,o,o,o,o,o,s,s,t,u,u,u,u,n,c,z,z,ss");
		
		var rStr = lCase(arguments.str);
		
		//writeOutput("#rStr#<br>");
		for(var i = 1; i LTE arrayLen(from); i++){
			var char = from[i];
			
			//writeOutput(" #char#<br>");
			if(rStr CONTAINS from[i]){
				//writeDump([rStr, from[i], to[i]]);
				rStr = replace(rStr, from[i], to[i], "ALL");
			}
		}
		//writeOutput("#rStr#<br>");
		
		/*
		var regex = new RegExp(defaultToWhiteSpace(from), 'g');
		
		str = String(str).toLowerCase().replace(regex, function(c){
			var index = from.indexOf(c);
			return to.charAt(index) || '-';
		});
		
		return dasherize(str.replace(/[^\w\s-]/g, ''));
		*/
		
		return dasherize(rStr);
    }
    
    function dasherize(str){
		var rStr = arguments.str;
		rStr = REReplace(rStr, "[^a-z]", " ", "ALL");
		rStr = REReplace(trim(rStr), " +", "-", "ALL");
		//return _s.trim(str).replace(/([A-Z])/g, '-$1').replace(/[-_\s]+/g, '-').toLowerCase();
		return rStr;
    }
    
    
    function getWorldsData(lang){
    	var cacheKey = "#CGI.SERVER_NAME#::getWorldsData(#arguments.lang#)";
    	var worldsData = cacheGet(cacheKey);
    	
    	if(isNull(worldsData)){
			var apiWorlds = "https://api.guildwars2.com/v1/world_names.json?lang=#url.lang#";
			var requestContent = new http(url=apiWorlds).send().getPrefix().fileContent.toString("UTF-8");
			worldsData = deserializeJson(requestContent);
			
			//writeOutput("refreshing #apiWorlds#<hr>");
			
			cachePut(cacheKey, worldsData, createTimeSpan(0,0,1,0));
		}
		
		return worldsData;
    }
    
	
	try{
		worlds = getWorldsData(url.lang);
	
		for(world IN worlds){
			world['slug'] = slugify(world.name);
			if(world['slug'] EQ url.world){
				pageTitle = "#world.name# WvW Objective Timers";
			}
		}
		//writeDump(var = worlds);
	}
	catch(any expt){}
	
</cfscript>