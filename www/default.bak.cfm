<cfscript>
	
	request.model = new models.common();
	request.model.setMeta(title = "", description = "");
	
	
	local.metaTitle = ["GW2 WvWvW"];
	local.metaDescription = "GuildWars2 WvWvW";
	
	
	request.model.getMeta().setTitle(arrayToList(local.metaTitle, " | "));
	request.model.getMeta().setDescription(local.metaDescription);

	include "/views/layout/template-open.cfm";
</cfscript>






			
			


<div class="row-fluid">
	<div class="span6">
		<ul class="nav nav-list small" id="WorldList">
			<li class="nav-header">Worlds</li>
			<li></li>
		</ul>
	</div>
	<!---<div class="span6">
		<ul class="nav nav-list small" id="MatchList">
			<li class="nav-header">Matches</li>
			<li></li>
		</ul>
	</div>--->
	<div class="span18" id="main">
		<div class="row-fluid">
			<ul class="scoresList unstyled" id="scoreList"></ul>
		</div>
		
		<hr>
		
		<div id="mapScores">
			<div class="row-fluid">
				<div class="span6"><ul class="unstyled scoresList" id="mapScoreEB"><li class="nav-header">Mid</li></ul></div>
				<div class="span6"><ul class="unstyled scoresList" id="mapScoreRed"><li class="nav-header">Red</li</ul></div>
				<div class="span6"><ul class="unstyled scoresList" id="mapScoreBlue"><li class="nav-header">Blue</li</ul></div>
				<div class="span6"><ul class="unstyled scoresList" id="mapScoreGreen"><li class="nav-header">Green</li</ul></div>
			</div>
		</div>
		
		<hr>
		
		<div id="objectives">
			<ul id="objListEB"><li class="nav-header">Mid</li></ul>
			<ul id="objListRed"><li class="nav-header">Red</li></ul>
			<ul id="objListBlue"><li class="nav-header">Blue</li></ul>
			<ul id="objListGreen"><li class="nav-header">Green</li></ul>
		</div>




		
		<hr>
		<hr>

<cfdump var="#url#">












<cfif request.isDev OR CGI.REMOTE_ADDR EQ "127.0.0.1" OR CGI.REMOTE_ADDR CONTAINS "192.168.11.">
	<cfoutput>
	<div class="well" id="dev-options">
		<div class="row-fluid">
			<cfset thisCanonical = "/" />
			
			<div class="span8">
				<dl>
					<dt>startTime: <dd>#application.startTime#
				</dl>
			</div>
			<div class="span8">
				<ul class="nav nav-list">
					<li class="nav-header"><i class="icon-cog"></i> dev flags</li>
					<li><a href="#application.util.net.urlAppendParam("/", "reInit", NOT request.reInit)#">reInit::#request.reInit#</a></li>
					<li><a href="#application.util.net.urlAppendParam("/", "isDev", NOT request.isDev)#">isDev::#request.isDev#</a></li>
					<li><a href="#application.util.net.urlAppendParam("/", "showAds", NOT request.showAds)#">showAds::#request.showAds#</a></li>
					<li><a href="/?recompileCss">recompileCss</a></li>
				</ul>
			</div>
			<div class="span8">
				<ul class="nav nav-list">
					<li class="nav-header"><i class="icon-cog"></i> dev resets</li>
					<!---<li><a href="#application.util.net.urlAppendParam(thisCanonical, "reset", "all")#">reset all</a></li>--->
					<li><a href="#application.util.net.urlAppendParam("/", "reset", "app")#">reset app</a></li>
					<li><a href="#application.util.net.urlAppendParam("/", "reset", "client")#">reset client</a></li>
					<li><a href="#application.util.net.urlAppendParam("/", "reset", "components")#">reset components</a></li>
					<li><a href="#application.util.net.urlAppendParam("/", "reset", "memCache")#">reset mem/queries</a></li>
				</ul>
			</div>
		</div>
	</div>
	</cfoutput>
</cfif>
	
<cfscript>
	include "/views/layout/template-close.cfm";
</cfscript>