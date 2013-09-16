<cfscript>
	
	paths = arrayNew(1);

	/*
	This points to the jar we want to load.
	Could also load a directory of .class files
	*/
	paths[1] = expandPath("/lib/java/gson-2.2.4.jar");
	writeDump(paths);

	//create the loader
	loader = createObject("component", "lib.cfc.javaloader.JavaLoader").init(paths);

	//at this stage we only have access to the class, but we don't have an instance
	gson = loader.create("com.google.gson.JsonParser").init();

	/*
	Create the instance, just like me would in createObject("java", "HelloWorld").init()
	This also could have been done in one line - loader.create("HelloWorld").init();
	*/
	writeDump(gson);
	//abort;
	
	/*
	jsonParser = jf.createJsonParser("https://api.guildwars2.com/v1/wvw/matches.json");
	
	//writeDump(jf);
	writeDump(jsonParser);
	writeDump(jsonParser.getTextLength());
	
	jsonParser.close();
	abort;
	*/
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	function getJson(
		required array apiUrls
	){
		local.urlList = listQualify(arrayToList(arguments.apiUrls), '"');
		local.yqlUrl = "http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20json%20where%20url%20in%20(#local.urlList#)&format=json&callback=";
		
		local.httpSvc = new http(
			url = local.yqlUrl
		);
		local.result = local.httpSvc.send().getPrefix();
		
		local.jsonString = local.result.fileContent.toString('UTF-8');
		//local.json = deserializeJson(local.jsonString);
		
		
		
		json = gson.parse(local.jsonString);
		writeDump(json);
		writeDump(json.toString());
		writeOutput('<hr>');
		writeDump(json.get('query').get('results').get('json').get('wvw_matches'));
		matches = json.get('query').get('results').get('json').get('wvw_matches');
		numMatches = matches.size();
		for(i=0; i < numMatches; i++){
			writeOutput(matches.get(i).get('wvw_match_id').toString() & '<br>');
			writeOutput(matches.get(i).toString());
			writeOutput('<hr>');
		}
		abort;
		
		return local.json.query.results.json;
	}
	
	local.matchesJson = getJson(['https://api.guildwars2.com/v1/wvw/matches.json']).wvw_matches;
	//writeDump(matches);
	
	/*
	worlds = getJson([
		'https://api.guildwars2.com/v1/world_names.json?lang=en'
		, 'https://api.guildwars2.com/v1/world_names.json?lang=de'
		, 'https://api.guildwars2.com/v1/world_names.json?lang=fr'
		, 'https://api.guildwars2.com/v1/world_names.json?lang=es'
	]);
	writeDump(worlds);
	*/
	
	local.matchDetailUrls = [];
	//local.matches = {};
	for(match IN local.matchesJson){
		//local.matches[match.wvw_match_id] = match;
		arrayAppend(local.matchDetailUrls, "https://api.guildwars2.com/v1/wvw/match_details.json?match_id=#match.wvw_match_id#");
	}
	writeDump(local.matches);
	
	local.matchDetailsJson = getJson(local.matchDetailUrls);
	writeDump(local.matchDetailsJson);
	
	for(matchDetails IN local.matchDetailsJson){
		writeDump(matchDetails);
	}
	
	
	
</cfscript>