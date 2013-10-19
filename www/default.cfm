<cfscript>
	/*
	param name="request.cssAppend" default="#[]#";
	param name="request.jsAppend" default="#[]#";
	
	
	local.cssPaths = [
		expandPath('/siteroot')
		, expandPath('/siteroot')
		, expandPath('/siteroot')
		, expandPath('/siteroot')
	];
	local.cssPaths.addAll(request.cssAppend);
	
	local.cssLink = application.cfc.static.getMergedLink(
		resourceType = "css",
		absPaths = local.cssPaths
	);
	
		
		
	local.jsPaths = [
		expandPath('/siteroot/assets/js/anet.js')
		, expandPath('/siteroot/assets/js/lib.js')
		, expandPath('/siteroot/assets/js/app.js')
		//, expandPath('/siteroot/assets/plugins/jquery.pnotify.min.js')
		//, expandPath('/siteroot/assets/plugins/gw2emblem-defs.js')
		//, expandPath('/siteroot/assets/plugins/gw2emblem.js')
		//, '/assets/js/bootstrap.min.js'
		//, '/assets/js/store+json2.min.js'
	];
	local.jsPaths.addAll(request.jsAppend);
	
	local.jsLink = application.cfc.static.getMergedLink(
		resourceType = "js",
		absPaths = local.jsPaths
	);
	
	*/
	application.util.cfscript.content(reset=true, type="text/html; charset=utf-8");
</cfscript><!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<title itemprop="name">GW2W2W</title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	
	<link href="https://d1h9a8s8eodvjz.cloudfront.net/fonts/menomonia/08-02-12/menomonia.css" rel="stylesheet">
	<link href="https://d1h9a8s8eodvjz.cloudfront.net/fonts/menomonia/08-02-12/menomonia-italic.css" rel="stylesheet">
	
	<link href="/assets/css/bootstrap.min.css" rel="stylesheet">
	<link href="//netdna.bootstrapcdn.com/font-awesome/3.2.1/css/font-awesome.min.css" rel="stylesheet">
	<link href="/assets/plugins/jquery.pnotify.default.css" rel="stylesheet">
	<link href="/assets/css/custom.css" rel="stylesheet">
	
	<script>
		(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
		(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
		m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
		})(window,document,'script','//www.google-analytics.com/analytics.js','ga');
		
		ga('create', 'UA-51384-37', 'gw2w2w.com');
		ga('send', 'pageview');
	</script>
	
	<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.0.2/jquery.min.js"></script>
	<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/jquery-color/2.1.2/jquery.color.min.js"></script>
	<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/2.3.2/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/underscore.js/1.4.4/underscore-min.js"></script>
	<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/underscore.string/2.3.0/underscore.string.min.js"></script>
	<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/xregexp/2.0.0/xregexp-all-min.js"></script>
	<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/raphael/2.1.0/raphael-min.js"></script>
	
	<script type="text/javascript" src="/assets/plugins/jquery.pnotify.min.js"></script>
	<script type="text/javascript" src="/assets/plugins/gw2emblem-defs.js"></script>
	<script type="text/javascript" src="/assets/plugins/gw2emblem.js"></script>
	<script type="text/javascript" src="/assets/js/lib.js"></script>
	<script type="text/javascript" src="/assets/js/anet.js"></script>
	<script type="text/javascript" src="/assets/js/app.js"></script>
</head>

<body >



<div class="navbar navbar-static-top">
	<div class="navbar-inner">
		<a class="brand" href="/"><img src="/assets/img/logo-96x36.png" width="96" height="36"/></a>
		<ul class="nav" id="worldTitle"></ul>
		<ul class="nav pull-right" id="quickNav">
			<li id="indicator" class="navbarIcon muted"><i class="icon-spinner icon-spin hide"></i></li>
			<li class="divider-vertical"></li>
			<li id="audioToggle" class="navbarIcon muted" data-enabled="true"><i class="icon-volume-up"></i></li>
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

</body>
</html>
