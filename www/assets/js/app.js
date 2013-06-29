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
	, objectives
	, matchDetails
	, guilds;
	
var prevMatchDetails, prevIncomes;








 $(function () {
 	"use strict";
	
	var $content = $('#content')
		, $quickNav = $('#quickNav')
		, $indicator = $('#indicator')
	
	var $log
		, $maps
		, $scoreBoards = { overall: {}, maps: {}};
	
	
	
	
	if(urlWorldSlug){
		var listeners = {
			onInit: onInit
			, onMatchData: onMatchData
			, onGuildData: onGuildData
		};
		var $log;
	}
	else{
		var listeners = {
			onInit: worldOptions_onInit
			, onWorldData: worldOptions_onWorldData
			, onMatchesData: worldOptions_onMatchesData
		};
	}
	
	
	Anet = new AnetAPI(urlLangSlug, urlWorldSlug, listeners);
	
	
	
	
	/*
	 * 
	 * Common Views
	 * 
	 */
	
	
	var writeQuickLang = (function writeQuickLang(){
		var html = renderExternal('quickLang', {langs: Anet.getLangs()});
		$quickNav.append(html);
	})();
	
	var writeQuickWorlds = (function writeQuickWorlds(){
		$quickNav.find('li:hidden').show();
	})();
	
	
	
	/*
	 * 
	 * WorldOptions Views
	 * 
	 */
	
	function worldOptions_onInit(){
		console.log("** worldOptions_onInit()");
		$indicator.stop().fadeOut();
		writeWorldOptionsBase();
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
	
	function writeWorldOptionsBase(){
		if(!$('#worldLists').length){
			var html = renderExternal('worldOptions', {});
			$content.html(html);
		}
	}
	
	
	
	
	/*
	 * 
	 * Match Details Views
	 * 
	 */
	
	
	function onInit(){
		console.log('** onInit()');
	}
	
	function onMatchData(){
		//console.log('** onMatchData()');
		
		var matchDetails = Anet.getMatchDetails()
			, match = Anet.getMatch();
		
		$indicator.stop().fadeOut();
		
		//console.log(matchDetails);
		
		if(!$maps){
			writeInitialDetails(matchDetails);
			$maps = $('#maps');
			
			writeTitle(matchDetails);
			cacheScoreBoards(matchDetails);
			updateMatchIncomes(matchDetails);
			
		}
		else{
			updateMatchDetails(matchDetails);
		}		
		
		
		// deep copy to break copy by reference
		prevMatchDetails = JSON.parse(JSON.stringify(matchDetails)); 
		
		
		// refresh the data in 1-3 seconds
		var randomRefresh = Math.floor((Math.random() * 2 + 1) * 1000); 
		
		setTimeout(function(){
			$indicator
				.stop()
				.fadeIn('fast', function(){
					Anet.refresh()
				});
		}, randomRefresh);
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
	
	function updateMatchDetails(matchDetails){
		//console.log('updateMatchDetails: ', prevMatchDetails, matchDetails);
		
		updateMatchObjectives(matchDetails);
		updateMatchScores(matchDetails);
		updateMatchIncomes(matchDetails);
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
			incomes.overall[objColor] += obj.points;
			incomes.maps[obj.mapKey][objColor] += obj.points;
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
	
	
	function updateMatchObjectives(matchDetails){
		
		// look for changed objective owners and guild claimers
		_.each(prevMatchDetails.mapTypes, function(mapType, ixMapType){
			var map = prevMatchDetails.maps[mapType.key];
			
			_.each(map.objectives, function(obj, ixObj){
				var curObj = matchDetails.maps[mapType.key].objectives[ixObj];
				var oldObj = obj;				
				
				if(oldObj.owner){
					if(oldObj.owner.name !== curObj.owner.name){
						newObjectiveOwner(mapType.label, curObj, oldObj);
					}
					else if(oldObj.guildId !== curObj.guildId && curObj.guildId){
						newObjectiveClaimer(mapType.label, curObj);
					}
				}
			});
		});
	}
	
	
	function newObjectiveOwner(mapName, curObj, oldObj){
		var logHtml = renderExternal('log-newOwner', {timeStamp: dateFormat(new Date(), 'isoTime'), mapName: mapName, curObj: curObj, oldObj: oldObj});
		writeToLog(logHtml);
		
		var $li = $('#obj-' + curObj.id);
		var oldSprite = 'sprite-' + oldObj.owner.color + '-' + oldObj.type;
		var curSprite = 'sprite-' + curObj.owner.color + '-' + curObj.type;
		
		/*
		var cssFrom =  	{backgroundColor: '#ffffcc'};
		var cssTo = 	{backgroundColor: 'inherit'};
			.animate(cssTo, 2*60*1000)
		*/
		
		$li
			.removeClass(oldObj.owner.color)
			.addClass(curObj.owner.color)
			.find('.guild')
				.remove()
			.end()
			.find('.spriteSmall')
				.removeClass(oldSprite)
				.addClass(curSprite)
			.end();
			
		if(curObj.guildId){
			appendGuildToObjective(curObj);
		}
		
		startReCapTimer(curObj);
		
		
		
		var gaData = {
		  'hitType': 'event',			// Required.
		  'eventCategory': curObj.name,	// Required.
		  'eventAction': 'New Owner',	// Required.
		  'eventLabel': curObj.owner.name,
		  'nonInteraction': 1
		};
		//console.log('Post To GA:', gaData);
		ga('send', gaData);
		
		console.log('New Owner: ', mapName, curObj.mapKey, curObj.owner.name, oldObj.owner.name);
		
			
	};
	
	function newObjectiveClaimer(mapName, curObj){
		if(curObj.guildId){
			var logHtml = renderExternal('log-newClaimer', {timeStamp: dateFormat(new Date(), 'isoTime'), mapName: mapName, curObj: curObj});
			writeToLog(logHtml);
			appendGuildToObjective(curObj);
			
			var guild = Anet.getGuild(curObj.guildId);
			var guildName = (guild) ? guild.name : curObj.guildId;
			
			var gaData = {
			  'hitType': 'event',			// Required.
			  'eventCategory': curObj.name,	// Required.
			  'eventAction': 'New Claimer',	// Required.
			  'nonInteraction': 1
			};
			ga('send', gaData);
			
			
			console.log('New Claimer: ', mapName, curObj.name);
			
			onGuildData();
			//console.log('Post To GA:', gaData);
		}
			
	};
	
	function appendGuildToObjective(curObj){
		var guild = Anet.getGuild(curObj.guildId);
		var $li = $('#obj-' + curObj.id);
		
		var guildHtml;
		
		if(guild) {
			guildHtml = '<sup class="guild" data-guildid="' + curObj.guildId + '"><abbr title="' + guild.name + '">[' + guild.tag + ']</abbr></sup>';
		}
		else{
			guildHtml = '<sup class="guild" data-guildid="' + curObj.guildId + '"><i class="icon-spinner icon-spin"></i></sup>';
		}
		
		$li
			.find('.guild')
				.remove()
			.end()
			.append(guildHtml);
		
	};
	
	
	
	
	
	
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
					
					var objColor = (obj.owner && obj.owner.color) ? obj.owner.color : 'base';
					var spriteClass = 'sprite-' + objColor + '-' + obj.type;
						
					$that
						.addClass(objColor)
						.find('.objName')
							.attr('title', obj.name)
							.html(obj.name)
						.end()
						.find('.spriteSmall')
							.attr('title', obj.name)
							.addClass(spriteClass);
							
					if(obj.guildId){
						$that.find('.guild')
							.replaceWith('<sup class="guild" data-guildid="' + obj.guildId + '"><i class="icon-spinner icon-spin"></i></sup>')
					}
					else{
						$that.find('.guild').remove();
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
			
		$log = $('#log');
	}
	
	
	function writeToLog(logHtml){
		var logSize = $log.find('li').length;
		var mapToShow = getLogMapToShow();		
		
		
		var $li = $(logHtml)
			.hide()
			.prependTo($log);
	
		if(mapToShow === 'all' || $li.filter('.' + mapToShow).length){
			$li.slideDown('slow');
			playNotification();
			
		}
				
		zebraStripeVisibleLog();
	};
	
	
	function zebraStripeVisibleLog(){
		$log.find('li')
			.removeClass('alt')
			.filter(':visible:even')
				.addClass('alt');
	}
	
	
	function startReCapTimer(curObj){
		var $obj = $('#obj-' + curObj.id);
		var $recapTimer = $obj.find('.recapTimer').fadeIn();
			
		var now = new Date();
		var expires = new Date();
		
		expires.setTime(now.getTime() + (5 * 60 * 1000));
		
		console.log('ReCap Timer Started: ', curObj.name, 'Expires: ', expires);
		
		timerCountdown($recapTimer, expires);
	};
	
	
	function timerCountdown($recapTimer, expiration){
		var now = new Date();
		var remaining = expiration.getTime() - now.getTime();
		
		//console.log(now, expiration, remaining, minuteFormat(remaining));
		
		if(remaining > 0){
			$recapTimer.text(minuteFormat(remaining));
			setTimeout(function(){timerCountdown($recapTimer, expiration)}, 1000);
		}
		else{
			$recapTimer.fadeOut();
		}			
	}
	
	
	$content.on('click', '#logTabs a', function(){
		var $that = $(this);
		$that
			.closest('li')
				.addClass('active')
				.siblings()
					.removeClass('active');
		
		toggleTabTo($that.data('target'));
	});
	
	
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
	
	function playNotification(){
		if($('#audioToggle').data('enabled')){
			$('#audioNotification').get(0).play();
		}
	}
	
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
	})
	
	
	
	
});



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
				, 18		//anz
				, 19		//ogre
				, 17		//mendons
				, 20		//veloka
				, 5			//pang
				, 6			//speldan
			]
		}
		, 'Blue Corner':{
			alert: 'info'
			, objectives: [
				2			//valley
				, 16		//quentin
				, 21		//durios
				, 22		//bravost
				, 15		//langor
				, 8 		//umber
				, 7			//dane
			]
		}
		, 'Green Corner':{
			alert: 'success'
			, objectives: [
				3			//lowlands
				, 12		//wildcreek
				, 14		//klovan
				, 13		//jerrifer
				, 11		//aldons
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