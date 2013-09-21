"use strict"
_.mixin(_.string.exports());


if(window.location.pathname !== window.location.pathname.toLowerCase()){
	window.location.pathname = window.location.pathname.toLowerCase();
}


var urlPath = window.location.pathname.toLowerCase().split('/')
	, urlLangSlug = urlPath[1] || 'en'
	, urlWorldSlug = urlPath[2];


var Anet
	, langs
	, lang
	, worlds
	, world
	, matches
	, match
	//, matchDetails
	, guilds;
	
var prevMatchDetails, prevIncomes;
var $content, $quickNav, $indicator = $('#indicator')
var $log, $maps, $scoreBoards, $objectives





 $(function () {
 	"use strict";
	
	gaqRankTracker();
	
	$content = $('#content')
		, $quickNav = $('#quickNav')
		, $indicator = $('#indicator')
	
	$log
		, $maps
		, $scoreBoards = { overall: {}, maps: {}}
		, $objectives = {}
	
	
	
	
	if(!urlWorldSlug){
		var listeners = {
			onInit: worldOptions_onInit
			, onWorldData: worldOptions_onWorldData
			, onMatchesData: worldOptions_onMatchesData
		};
	}
	else{
		var listeners = {
			onInit: onInit
			, onMatchData: onMatchData
			, onGuildData: onGuildData
			, onOwnerChange: onOwnerChange
			, onClaimerChange: onClaimerChange
		};
		var $log;
	}
	
	
	Anet = new AnetAPI(urlLangSlug, urlWorldSlug, listeners);
	
	
	
	writeQuickLang();
	writeQuickWorlds();
	writeAttrib();
	
	
	
	
	/*
	 * 
	 * 	User Interaction
	 * 
	 */
	
	$content.on('click tabClick', '#logTabs a', function(){
		var $that = $(this);
		$that
			.closest('li')
				.addClass('active')
				.siblings()
					.removeClass('active');
		
		toggleTabTo($that.data('target'));
		highlightMap($that.data('target'));
		
		var gaData = {
		  'hitType': 'event',			// Required.
		  'eventCategory': 'Tabs',		// Required.
		  'eventAction': 'Changed Tab',	// Required.
		  'eventLabel': $that.data('target')
		};
		//console.log('Post To GA:', gaData);
		ga('send', gaData);
		
	});
	
	$content.on('click', '.serverName', function(){
		var $that = $(this);
		var target =$that.data('target');
		
		$('#logTabs a').each(function(){
			if($(this).data('target') === target){
				$(this).trigger('tabClick');
			}
		});
	});
	
	
	$('#audioToggle').on('click', function(e){
		e.preventDefault();
		var $that = $(this);
		
		$that.data('enabled', !$that.data('enabled'));
		
		playNotification();
		
		if($that.data('enabled')){
			$that.hide().html('<i class="icon-volume-up"></i>').fadeIn();
		}
		else{
			$that.hide().html('<span class="icon-stack"><i class="icon-ban-circle icon-stack-base text-error"></i><i class="icon-volume-up"></i></span>').fadeIn();
		}
		
		
		
		var gaData = {
		  'hitType': 'event',				// Required.
		  'eventCategory': 'Audio',			// Required.
		  'eventAction': 'Toggle State',	// Required.
		  'eventLabel': ($that.data('enabled')) ? 'Enabled' : 'Disabled'
		};
		ga('send', gaData);
	});
	
	
	$content.on('mouseenter mouseleave', '#log li', function(e){
		var $that = $(this)
			, id = $that.data('id')
			, $objLi = $objectives[id];
			
		$objLi.toggleClass('highlight');
	});
	
	
	
	var windowHasFocus = 1;
	$(window)
		.on('focus', function(){
			if(!windowHasFocus){
				windowHasFocus = 1;			
				console.log('window focus');
				
				var gaData = {
				  'hitType': 'event',			// Required.
				  'eventCategory': 'App',		// Required.
				  'eventAction': 'Focus',		// Required.
				  'eventLabel': 'Gained'
				};
				ga('send', gaData);
			}
		})
		.on('blur', function(){
			if(windowHasFocus){
				windowHasFocus = 0;
				var gaData = {
				  'hitType': 'event',			// Required.
				  'eventCategory': 'App',		// Required.
				  'eventAction': 'Focus',		// Required.
				  'eventLabel': 'Lost'
				};
				ga('send', gaData);
			}
		});
	
	
});




	
	
	
	

/*
 * 
 * Common Views
 * 
 */


var writeQuickLang = function (){
	var html = renderExternal('quickLang', {langs: Anet.getLangs()});
	$quickNav.append(html);
};

var writeQuickWorlds = function(){
	$quickNav.find('li:hidden').show();
};

var writeAttrib = function(){
	var html = renderExternal('attrib');
	$('.container').append(html);
};




/*
 * 
 * WorldOptions Events
 * 
 */

function worldOptions_onInit(){
	console.log("** worldOptions_onInit()");
	$indicator.stop().fadeOut();
	writeWorldOptionsBase();
	
	
	var gaData = {
		'hitType': 'event',					// Required.
		'eventCategory': 'App',				// Required.
		'eventAction': 'Data Initialized',	// Required.
		'nonInteraction': true
	};
	ga('send', gaData);
}

function worldOptions_onWorldData(){
	console.log("** worldOptions_onWorldData()");
	
	
	var worlds = { 'US': {}, 'EU': {}};
	
	_.each(worlds, function(o, region){
		_.each(Anet.getLangs(), function(lang, i){
			worlds[region][lang.name] = _.filter(Anet.getWorlds(), function(world){return world.region === region && world.lang === lang.label})
		});
	});
	
	
	var html = renderExternal('worldOptions-worlds', {
		worlds: worlds
		, currentLang: urlLangSlug
	});
	
	$('#worldLists').hide().html(html).slideDown();
}

function worldOptions_onMatchesData(){
	console.log("** worldOptions_onMatchesData()");
	
	var allMatches = Anet.getMatches();
	var matches = {
		us: _.filter(allMatches, function(world){return world.id.substring(0,1) == 1})
		, eu: _.filter(allMatches, function(world){return world.id.substring(0,1) == 2})
	};
	
	var html = renderExternal('worldOptions-matches', {
		matches: matches
		, currentLang: urlLangSlug
	});
	
	$('#matchLists').hide().html(html).slideDown();
}



/*
 * 
 * WorldOptions Views
 * 
 */

function writeWorldOptionsBase(){
	if(!$('#worldLists').length){
		var html = renderExternal('worldOptions', {});
		$content.html(html);
	}
}




/*
 * 
 * Match Details Events
 * 
 */


function onInit(){
	console.log('** onInit()');
	
	var gaData = {
		'hitType': 'event',					// Required.
		'eventCategory': 'App',				// Required.
		'eventAction': 'Data Initialized',	// Required.
		'nonInteraction': true
	};
	ga('send', gaData);
}

function onMatchData(){
	//console.log('** onMatchData()');
	
	var matchDetails = Anet.getMatchDetails()
		, match = Anet.getMatch();
	
	$indicator.stop().fadeOut();
	
	
	if(!$maps){
		writeInitialDetails(matchDetails);
		updateTimers();
		writeTitle(matchDetails);
		
		$maps = $('#maps');
		$log = $('#log');
		cacheScoreBoards(matchDetails);
	}
	else{
		updateMatchScores(matchDetails);
	}
	
	updateMatchIncomes(matchDetails);
	
	
	// deep copy to break copy by reference
	prevMatchDetails = {};
	prevMatchDetails = JSON.parse(JSON.stringify(matchDetails)); 
	
	setTimeout(function(){
		$indicator
			.stop()
			.fadeIn('fast', function(){
				Anet.refresh()
			});
	}, randRange(2000,5000));
}


function onGuildData(){
	console.log('** onGuildData()');
	var guilds = Anet.getGuilds();
	
	$('.guild:has(i)').each(function(i){
		var $that = $(this);
		var guildId = $that.data('guildid');
		
		if(guilds[guildId]){
			$that
				.fadeOut('fast', function(){
					$that
						.html('<abbr title="' + guilds[guildId].name + '">[' + guilds[guildId].tag + ']</abbr>')
						.fadeIn('fast');
				})
		}
		
	});
}



function onOwnerChange(mapName, curObj, oldObj){
	var logHtml = renderExternal('log-newOwner', {timeStamp: dateFormat(new Date(), 'isoTime'), mapName: mapName, curObj: curObj, oldObj: oldObj});
	var playAudio = (curObj.generic == 'Ruin') ? false : true;
	writeToLog(logHtml, playAudio);
	
	var $li = $objectives[curObj.id];
	var oldSprite = 'sprite-' + oldObj.owner.color + '-' + oldObj.type;
	var curSprite = 'sprite-' + curObj.owner.color + '-' + curObj.type;
	
	removeGuildFromObjective(curObj.id);
	
	$li
		.removeClass(oldObj.owner.color)
		.addClass(curObj.owner.color)
		.find('.sprite2small')
			.removeClass(oldSprite)
			.addClass(curSprite)
		.end();
		
	if(curObj.guildId){
		appendGuildToObjective(curObj);
	}
	
	//console.log('New Owner: ', curObj.mapKey, curObj.generic, curObj, 'playAudio', playAudio);
}



function onClaimerChange(mapName, curObj, oldObj){
	var $li = $objectives[curObj.id];
	
	if(curObj.guildId){
		var logHtml = renderExternal('log-newClaimer', {timeStamp: dateFormat(new Date(), 'isoTime'), mapName: mapName, curObj: curObj});
		writeToLog(logHtml, true);
		appendGuildToObjective(curObj);
		
		var guild = Anet.getGuild(curObj.guildId);
		var guildName = (guild) ? guild.name : curObj.guildId;
		
		
		//console.log('New Claimer: ', mapName, curObj.name);
		onGuildData();
	}
	else{
		removeGuildFromObjective(curObj.id);
		//console.log('Remove Claimer: ', mapName, curObj.name);
	}
		
}




/*
 * 
 * Match Details Views
 * 
 */

function writeTitle(){
	var match = Anet.getMatch();
	
	$('title').text(match.redWorld.name+ ' vs ' + match.blueWorld.name+ ' vs ' + match.greenWorld.name);
	
	$('#worldTitle')
		.html(
			'<li><a class="team red" href="' + match.redWorld.href + '">' + match.redWorld.name + '</a></li>'
			+ '<li><a class="team blue" href="' + match.blueWorld.href + '">' + match.blueWorld.name + '</a></li>'
			+ '<li><a class="team green" href="' + match.greenWorld.href + '">' + match.greenWorld.name + '</a></li>'
		)
		.find('li:contains(' + Anet.getWorld().name + ')')
			.addClass('active')
		.end();
}


function writeInitialDetails(matchDetails){	
	console.log('writeInitialDetails()', matchDetails);
	
	var match = Anet.getMatch();
		
	var $matchDetails = $(renderExternal('matchDetails'));
	var overallScores = renderExternal('matchDetails-overallScores', {matchDetails: matchDetails, match: match});
	var logHtml = renderExternal('log', {mapTypes: matchDetails.mapTypes});
	
	_.each(matchDetails.mapTypes, function(mapType, i){
		var $map = $matchDetails.find('#breakdown-' + mapType.key);
		var map = matchDetails.maps[mapType.key];
		
		var mapHtml = renderExternal('matchDetails-map', {
			mapType: mapType
			, map: map
		});
		
		var mapScoreHtml = renderExternal('matchDetails-MapScore', {
			mapType: mapType
			, map: map
			, match: match
		});
		
		var $mapObjectivesHtml = $(renderExternal('matchDetails-objectives', {
			mapType: mapType
			, map: map
			, objectivesMap: objGroups[mapType.key]
		}));
		
		
		$map
			.append(mapHtml)
			.find('.scores')
				.append(mapScoreHtml)
			.end()
			.find('.objectives')
				.append($mapObjectivesHtml)
			.end();
			
		
		$map.find('.objective')
			.each(function(i){
				var $that = $(this);
				var id = $that.data('id');
				var obj = Anet.getObjectiveBy('id', id);
				
				// cache element to $objectives object for fast lookup
				$objectives[id] = $that;
				
				if(obj){
					var objColor = (obj.owner && obj.owner.color) ? obj.owner.color : 'base';
					var spriteClass = 'sprite-' + objColor + '-' + obj.type;
						
					$that
						.addClass(objColor)
						.find('.objName')
							.attr('title', obj.name)
							.html(obj.name)
						.end()
						.find('.sprite2small')
							.attr('title', obj.name)
							.addClass(spriteClass)
						.end()
						.find('.recapTimer')
							.html('?:??')
							.addClass('unknown')
						.end();
							
					if(obj.guildId){
						$that.find('.guild')
							.replaceWith('<sup class="guild" data-guildid="' + obj.guildId + '"><i class="icon-spinner icon-spin"></i></sup>')
					}
					else{
						$that.find('.guild')
							.remove();
					}
				}
			})
		.end()
	});
	
	//console.log(overallScores)
	
	$matchDetails
		.find('.hide')
			.hide()
		.end()
		.appendTo($content);
		
	$('#logContainer').append(logHtml);
	$('#scoreOverall').append(overallScores);
}



function cacheScoreBoards(matchDetails){
	var colors = Anet.getColors();
	var mapTypes = matchDetails.mapTypes;
	
	_.each(colors, function(color, i){
		$scoreBoards.overall[color] = $('#' + color + 'ScoreBoard');
		
		_.each(mapTypes, function(mapType, i){
			$scoreBoards.maps[mapType.key] = $scoreBoards.maps[mapType.key] || {};
			$scoreBoards.maps[mapType.key][color] = $('#mapScoreBoard-' + color + '-' + mapType.key); //mapScoreBoard-green-<%= mapType.key %>
		});
	});
}	

function updateMatchScores(matchDetails){
	//console.log('updateMatchScores: ', matchDetails, matchDetails.score);
	
	
	var colors = Anet.getColors();
	var mapTypes = matchDetails.mapTypes;
	
	_.each(colors, function(color, i){
		
		// update overall scores
		if(matchDetails.score[color] !== prevMatchDetails.score[color] ){
			var $scoreBoard = $scoreBoards.overall[color];
			var score = matchDetails.score[color];
			
			updateScoreHtml($scoreBoard, score, '.score');
			//console.log('update overall score: ', color, score);
		}
		
		// update match scores
		_.each(mapTypes, function(mapType, i){
			if(matchDetails.maps[mapType.key].score[color] !== prevMatchDetails.maps[mapType.key].score[color] ){
				var $scoreBoard = $scoreBoards.maps[mapType.key][color];
				var score = matchDetails.maps[mapType.key].score[color];
				
				updateScoreHtml($scoreBoard, score, '.score');
				//console.log('update map score: ', mapType.key, color, score);
			}
		});
	})
}



function updateMatchIncomes(matchDetails){
	var incomes = calculateIncomes(matchDetails);
	var colors = Anet.getColors();
	var mapTypes = matchDetails.mapTypes;
	
	_.each(colors, function(color, i){
		
		if(!prevIncomes || incomes.overall[color] !== prevIncomes.overall[color]){
			var $scoreBoard = $scoreBoards.overall[color];
			var income = incomes.overall[color];
			
			updateScoreHtml($scoreBoard, income, '.income');
			//console.log('update overall income: ', color, income);
			
		}
		_.each(mapTypes, function(mapType, i){
			
			if(!prevIncomes || incomes.maps[mapType.key][color] !== prevIncomes.maps[mapType.key][color]){
				var $scoreBoard = $scoreBoards.maps[mapType.key][color];
				var income = incomes.maps[mapType.key][color];
				
				updateScoreHtml($scoreBoard, income, '.income');
				//console.log('update map income: ', mapType.key, color, income);
			}
		});
	});
	
	prevIncomes = JSON.parse(JSON.stringify(incomes)); // deep copy to break copy by reference
}


function calculateIncomes(matchDetails){
	var objectives = Anet.getObjectives();
	var colors = Anet.getColors();
	var mapTypes = matchDetails.mapTypes;
	var incomes = { overall: {}, maps: {}};
	
	_.each(colors, function(color, i){
		incomes.overall[color] = 0;
		
		_.each(mapTypes, function(mapType, i){
			incomes.maps[mapType.key] = incomes.maps[mapType.key] || {};
			incomes.maps[mapType.key][color] = 0;
		});
	});
	
	_.each(objectives, function(obj, i){
		var objColor = (obj.owner && obj.owner.color) ? obj.owner.color : 'base';
		if(objColor != 'base'){
			incomes.overall[objColor] += obj.points;
			incomes.maps[obj.mapKey][objColor] += obj.points;
		}
	});
	
	
	return incomes;
}


function updateScoreHtml($scoreBoard, score, selector){
	$scoreBoard
		.find(selector)
		.fadeOut('fast', function(){
			$(this).html(_.numberFormat(score)).fadeIn('slow');
		})
}



function appendGuildToObjective(curObj){
	var guild = Anet.getGuild(curObj.guildId);
	
	var $guildHtml = $('<sup class="guild" data-guildid="' + curObj.guildId + '"></sup>');
	
	if(guild) {
		$guildHtml.append('<abbr title="' + guild.name + '">[' + guild.tag + ']</abbr></sup>');
	}
	else{
		$guildHtml.append('<i class="icon-spinner icon-spin"></i></sup>');
	}
	
	removeGuildFromObjective(curObj.id);
	$objectives[curObj.id].append($guildHtml);
	
};



function removeGuildFromObjective(objId){
	var $guild = $objectives[objId].find('.guild')
	
	if($guild.length){
		$guild.remove();
	}
}




	
	
	
/*
 * 
 * recap timers
 * 
 */	

// first invoked by writeInitialDetails
var fullStateKnown = false;
var updateTimers = function updateTimers(){
	var objectives = Anet.getObjectives()
		, initTime = Anet.getInitTime()
		, now = new Date()
		, buffDuration = 5 * 60 * 1000;
		
	_.each(objectives, function(o, index){
		var $li = $objectives[o.id]
			, $timer = $li.find('.recapTimer')
			, timerVisible = $timer.is(':visible')
		
		if(o.generic == 'Ruin'){
			if(timerVisible){
				$timer.hide();
			}
		}
		else if(o.lastCaptured !== initTime){
			var expires = new Date();
			expires.setTime(o.lastCaptured.getTime() + buffDuration);
			
			var timeRemaining = expires.getTime() - now.getTime();
			
			if(timeRemaining <= 0 && timerVisible){
				$timer.fadeOut();
			}
			else if (timeRemaining > 0 && !timerVisible){
				$timer.fadeIn();
			}
			
			$timer.filter('.unknown').removeClass('unknown');
			
			if(timeRemaining > 0){
				var timerText = minuteFormat(timeRemaining);
				//console.log(timerText);
				$timer.text(timerText);
			}
			
			//console.log(o.lastCaptured.getTime(), expires.getTime(), now.getTime(), expires.getTime() > now.getTime(), timeRemaining, timerVisible);
		}
	});
	
		
	// when to hide 'unknown state' indicators
	if(!fullStateKnown){
		var elapsed = (now.getTime() - initTime.getTime());
		if(elapsed > buffDuration){
			fullStateKnown = true;
			$('#warmupWarning').slideUp();
			$('.recapTimer.unknown')
				.fadeOut('fast', function(){
					$(this).removeClass('unknown')
				})
		}
		else{
			var timeRemaining = buffDuration - (elapsed);
			var timerText = minuteFormat(timeRemaining);
			$('.recapTimer.unknown').html(timerText);
		}
	}
	
	setTimeout(updateTimers, 1*1000);
};


	
	
	
/*
 * 
 * log functionality
 * 
 */	

function writeToLog(logHtml, playAudio){
	var logSize = $log.find('li').length;
	var mapToShow = getLogMapToShow();
	
	var $li = $(logHtml)
		.hide()
		.prependTo($log);

	if(mapToShow === 'all' || $li.filter('.' + mapToShow).length){
		$li.slideDown('slow');
		
		if(playAudio){
			playNotification();
		}
		
	}
			
	zebraStripeVisibleLog();
};


function zebraStripeVisibleLog(){
	$log.find('li')
		.removeClass('alt')
		.filter(':visible:even')
			.addClass('alt');
}

function getLogMapToShow(){
	return $('#logTabs li.active a').data('target') || 'all';
}


function toggleTabTo(mapKey){
	console.log('toggleTabTo() ', mapKey);
	
	if(mapKey == 'all'){
		$log.find('li').show();
	}
	else{
		$log
			.find('li:not(.' + mapKey + ')')
				.hide()
			.end()
			.find('li.' + mapKey)
				.show()
			.end();
	}
	
	zebraStripeVisibleLog();
}



function highlightMap(mapKey){
	var $map = $('#breakdown-' + mapKey);
	$('.breakdown').removeClass('active');
	$map.addClass('active');
}



function playNotification(){
	if($('#audioToggle').data('enabled')){
		$('#audioNotification').get(0).play();
	}
}





var objGroups = {
	'Center': {
		'Castle':{
			alert: 'well'
			, objectives: [
				9			//sm
			]
		}
		, 'Red Corner':{
			alert: 'error'
			, objectives: [
				1			//overlook
				, 20		//veloka
				, 17		//mendons
				, 18		//anz
				, 19		//ogre
				, 5			//pang
				, 6			//speldan
			]
		}
		, 'Blue Corner':{
			alert: 'info'
			, objectives: [
				2			//valley
				, 22		//bravost
				, 15		//langor
				, 16		//quentin
				, 21		//durios
				, 8 		//umber
				, 7			//dane
			]
		}
		, 'Green Corner':{
			alert: 'success'
			, objectives: [
				3			//lowlands
				, 13		//jerrifer
				, 11		//aldons
				, 14		//klovan
				, 12		//wildcreek
				, 4 		//golanta
				, 10		//rogues
			]
		}
	}
	
	, 'RedHome': {
		'North':{
			alert: 'error'
			, objectives: [
				37			//keep
				, 33		//bay
				, 32		//hills
				, 38		//longview
				, 40		//cliffside
				, 39 		//godsword
				, 52		//hopes
				, 51		//astral
			]
		}
		,'Ruins':{
			alert: 'warning'
			, objectives: [
				62			//temple
				, 63		//hollow
				, 64		//estate
				, 65		//orchard
				, 66 		//ascent
			]
		}
		,'South':{
			alert: 'well'
			, objectives: [
				35			//briar
				, 36		//lake
				, 34		//lodge
				, 53		//vale
				, 50 		//water
			]
		}
	}
	
	, 'BlueHome': {
		'North':{
			alert: 'info'
			, objectives: [
				23			//keep
				, 27		//bay
				, 31		//hills
				, 30		//woodhaven
				, 28		//dawns
				, 29 		//spirit
				, 58		//gods
				, 60		//star
			]
		}
		,'Ruins':{
			alert: 'warning'
			, objectives: [
				71			//temple
				, 70		//hollow
				, 69		//estate
				, 68		//orchard
				, 67 		//ascent
			]
		}
		,'South':{
			alert: 'well'
			, objectives: [
				25			//briar
				, 26		//lake
				, 24		//champ
				, 59		//vale
				, 61 		//water
			]
		}
	}
	
	, 'GreenHome': {
		'North':{
			alert: 'success'
			, objectives: [
				46			//keep
				, 44		//bay
				, 41		//hills
				, 47		//sunny
				, 57		//crag
				, 56 		//titan
				, 48		//faith
				, 54		//fog
			]
		}
		,'Ruins':{
			alert: 'warning'
			, objectives: [
				76			//temple
				, 75		//hollow
				, 74		//estate
				, 73		//orchard
				, 72 		//ascent
			]
		}
		,'South':{
			alert: 'well'
			, objectives: [
				45			//briar
				, 42		//lake
				, 43		//lodge
				, 49		//vale
				, 55 		//water
			]
		}
	}
};





function getLink(langSlug,worldSlug){
	langSlug = langSlug || urlLangSlug;
	worldSlug = worldSlug || urlWorldSlug;
	
	var link = ['']; // lead with a slash after join('/')
	if(langSlug && langSlug != ''){
		link.push(langSlug);
	}
	if(worldSlug && worldSlug != ''){
		link.push(worldSlug);
	}
	return link.join('/');
}