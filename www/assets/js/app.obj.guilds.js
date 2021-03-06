var objGuilds = function(){
	"use strict"
	
	var self = this;
	var $guildsList;
	
	
	
	
	/*
	 * PUBLIC
	 */
	self.init = function($obj){
		console.log('** objGuilds.init()');
		$guildsList = $obj;
		
		return self;
	};
	
	
	
	self.update = function(guilds){
		updateGuildsList(guilds);
		renderGuildEmblems(guilds);
		updateGuildInfo(guilds);
	};



	self.initGuild = function (guildId){
		if($guildsList){
			var guildSelector = 'tr.guild-' + guildId;
			var $guild = $guildsList.find(guildSelector);
			
			
			if($guild.length === 0){
				var emblemId = 'emblem' + guildId;
				
				$guild = $('<tr/>', {
						'class': 'guild-' + guildId
						, 'id': 'guild-' + guildId
					})
					.data('guildid', guildId).hide();
				
				var $guildEmblem = $('<td/>').append(
					$('<div/>', {id: emblemId, 'class': 'guildEmblem pending', html: '<h1><i class="icon-spinner icon-spin"></i>'})
				);
				var $guildInfo = $('<td class="guildInfo"><h2 class="guildName pending"><i class="icon-spinner icon-spin"></i></h2><ul class="history unstyled"></ul></td>');
				
				$guild
					.append($guildEmblem)
					.append($guildInfo)
					.prependTo($guildsList)
					.slideDown()
			}
			return true;
		}
		else{
			return false;
		}
	};


	self.getGuildListing = function (guildId){
		if(self.initGuild(guildId)){
			var guildSelector = 'tr.guild-' + guildId;
			var $guild = $guildsList.find(guildSelector);
			return $guild;
		}
	};
	
	
	
	self.appendObjectiveToGuildHistory = function (curObj){
		if($guildsList){
			var guildId = curObj.guildId;
			var $guild = $guildsList.find('tr.guild-' + guildId);
			var $guildHistory = $guild.find('.history');
			
			
			var sprite = 'sprite-' + curObj.owner.color + '-' + curObj.type;
			
			var $li = $('<li/>', {
					html: (
						'<span class="sprite2small ' + sprite + '"></span>'
						+  '<span class="historyTime">' + dateFormat(new Date(), 'isoTime') + '</span>'
						+  '<span class="historyMap">' + curObj.mapKey + '</span>'
						+  '<span class="historyName">' + curObj.name + '</span>'
					)
					, 'class': 'objective team ' + curObj.owner.color
				})
				
			
			$guild
				.hide()
				.detach()
				.find('.history')
					.prepend($li)
				.end()
				.prependTo($guildsList)
				.slideDown();
		}
	};
	
	
	

	/*
	 * PRIVATE
	 */
	
	var renderGuildEmblems = function (guilds){
		async.forEach(
			$guildsList.find('.guildEmblem.pending'),
			function(guildObj, nextGuild){
				var $guild = $(guildObj);
				var guildId = $guild.closest('tr').data('guildid');
				var guild = guilds[guildId];
				
				if(guild){
					var $emblem = $('#emblem' + guildId);
					$emblem.empty();

					if(guild.emblem){
						$emblem.append($('<img>', {
							'src': "http://guilds.gw2w2w.com/" + guildId + '.svg',
							'width': 160,
							'height': 160,
						}));
					}
				}
				nextGuild();
			},
			_.noop
		);
	};



	var updateGuildInfo = function (guilds){
		async.forEach(
			$guildsList.find('.guildName.pending'),
			function(guildObj, nextGuild){
				var $guild = $(guildObj);
				var guildId = $guild.closest('tr').data('guildid');
				var guild = guilds[guildId];
				
				if(guild){
					$guild
						.html('<h1>[' + guild.tag + '] ' + guild.name + '</h1>')
						.removeClass('pending');
				}

				nextGuild();
			},
			_.noop
		);

	};


	var updateGuildsList = function (guilds){
		return;
		
		var $guilds = $('#guildsList');
		
		_.each(Object.keys(guilds), function(guildId, index){
			var guildSelector = 'tr.guild-' + guildId;
			var objectiveClaimsSelector = 'abbr.guild-' + guildId;
			
			var $guild = getGuildListing(guildId);
			var $claims = $(objectiveClaimsSelector);
			
			var claimIds = [];
			$claims.closest('li').each(function( index ) {
				var objectiveId = $(this).data('id');
				claimIds.push(objectiveId);
			});
			
			claimIds = _.uniq(claimIds);
			
			$guild.find('.guildsList').empty();
			_.each(claimIds, function(objectiveId, index) {
				
				var obj = Anet.getObjectiveBy('id', objectiveId);
				
				var objectiveName = (
					(obj.mapKey != 'Center')
						? (' ' + obj.mapKey + ' - ')
						: (' ')
					)
					+  obj.name;
				
				var $sprite = $('<span class="sprite2small sprite-' + obj.owner.color + '-' + obj.type + '"></span> ');
				var $name = $('<span/>', {text: objectiveName, 'class': 'objName'});
				
				var $li = $('<li>')
					.append($sprite)
					.append($name);
				
				
				
				$guild.find('ul').append($li);
				
			});
			
			
		});
	};
	
	
	
	return self;
};