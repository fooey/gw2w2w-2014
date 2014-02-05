<cfprocessingdirective pageencoding = "utf-8">
<cfscript>
	if(structKeyExists(url, "ViewSource")){
		application.util.cfscript.content(file="#getCurrentTemplatePath()#", reset=true, type="text/plain; charset=utf-8");
		abort;
	}
	
	
	jsLibraries = application.cfc.static.getMergedLink("js", "lib", [
		expandPath("/approot/www/assets/plugins/jquery.pnotify.min.js")
	]);
	jsCustom = application.cfc.static.getMergedLink("js", "app", [
		expandPath("/approot/www/assets/js/lib.js")
		
		, expandPath("/approot/www/assets/js/app.js")
		, expandPath("/approot/www/assets/js/anet.js")
		, expandPath("/approot/www/assets/js/app.model.worlds.js")
		, expandPath("/approot/www/assets/js/app.model.objectives.js")
		
		, expandPath("/approot/www/assets/js/app.obj.scoreboard.js")
		, expandPath("/approot/www/assets/js/app.obj.objectives.js")
		, expandPath("/approot/www/assets/js/app.obj.eventlog.js")
		, expandPath("/approot/www/assets/js/app.obj.guilds.js")
	]);
	
	
	cssLibraries = application.cfc.static.getMergedLink("css", "lib", [
		expandPath("/approot/www/assets/css/bootstrap.min.css")
		, expandPath("/approot/www/assets/plugins/jquery.pnotify.default.css")
	]);
	cssCustom = application.cfc.static.getMergedLink("css", "custom", [
		expandPath("/approot/www/assets/css/custom.css")
	]);
	
	include "~pageTitle.cfm";
	
	
	application.util.cfscript.content(reset=true, type="text/html; charset=utf-8");
</cfscript><!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<title><cfoutput>#getPageTitle(url.lang, url.world)#</cfoutput></title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	
	<link href="https://d1h9a8s8eodvjz.cloudfront.net/fonts/menomonia/08-02-12/menomonia.css" rel="stylesheet">
	<link href="https://d1h9a8s8eodvjz.cloudfront.net/fonts/menomonia/08-02-12/menomonia-italic.css" rel="stylesheet">
	
	<cfoutput>
		<link href="#cssLibraries#" rel="stylesheet">
		<link href="//netdna.bootstrapcdn.com/font-awesome/3.2.1/css/font-awesome.min.css" rel="stylesheet">
		<link href="#cssCustom#" rel="stylesheet">
	</cfoutput>
	
	<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.0.2/jquery.min.js"></script>
	<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/jquery-color/2.1.2/jquery.color.min.js"></script>
	<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/2.3.2/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/lodash.js/2.4.1/lodash.min.js"></script>
	<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/underscore.string/2.3.0/underscore.string.min.js"></script>
	<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/xregexp/2.0.0/xregexp-all-min.js"></script>
	<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/async/1.22/async.min.js"></script>
	<cfoutput>
		<script type="text/javascript" src="#jsLibraries#"></script>
		<script type="text/javascript" src="#jsCustom#"></script>
	</cfoutput>
	
	
	<!-- ****************** -->
	<!--                    -->
	<!--  HIRE ME Anet! xD  -->
	<!--                    -->
	<!-- ****************** -->
</head>

<body >



<div class="navbar navbar-static-top">
	<div class="navbar-inner">
		<a class="brand" href="/"><img src="/assets/img/logo-96x36.png" width="96" height="36"/></a>
		<ul class="nav" id="worldTitle"></ul>
		<ul class="nav pull-right" id="quickNav">
			<li id="indicator" class="navbarIcon muted"><i class="icon-spinner icon-spin hide"></i></li>
			<li class="divider-vertical"></li>
			<li id="audioToggle" class="navbarIcon muted" data-enabled="false"><span class="icon-stack"><i class="icon-ban-circle icon-stack-base text-error"></i><i class="icon-volume-up"></i></span></li>
			<li class="divider-vertical"></li>
			<li class="hide"><a href="<cfoutput>/#url.lang#</cfoutput>"><i class="icon-globe"></i> Select World</a></li>
			<li class="divider-vertical hide"></li>
		</ul>
	</div>
</div>
	
<div class="container">
	<div class="row-fluid">
		<div class="span24">
			<div id="content"></div>
		</div>
	</div>
</div>

	
<script>
	(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
	(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
	m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
	})(window,document,'script','//www.google-analytics.com/analytics.js','ga');
	
	ga('create', 'UA-51384-37', 'gw2w2w.com');
	ga('send', 'pageview');
</script>
</body>
</html>
