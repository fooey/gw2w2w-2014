<cfscript>
	param name="request.cssAppend" default="#[]#";
	
	
	local.cssPaths = [
		'/assets/css/bootstrap.css'
		,'/assets/css/font-awesome.css'
		,'/assets/css/custom.css'
	];
	local.cssPaths.addAll(request.cssAppend);
	
	local.cssLink = application.cfc.static.getMergedLink(
		resourceType = "css",
		relPaths = local.cssPaths
	);
	application.util.cfscript.content(reset=true, type="text/html; charset=utf-8");
</cfscript><!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<title itemprop="name">GW2W2W</title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link href="https://d1h9a8s8eodvjz.cloudfront.net/fonts/menomonia/08-02-12/menomonia.css" rel="stylesheet">
	<link href="https://d1h9a8s8eodvjz.cloudfront.net/fonts/menomonia/08-02-12/menomonia-italic.css" rel="stylesheet">
	<link href="<cfoutput>#local.cssLink#</cfoutput>" rel="stylesheet">
	
	<script>
		(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
		(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
		m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
		})(window,document,'script','//www.google-analytics.com/analytics.js','ga');
		
		ga('create', 'UA-51384-37', 'gw2w2w.com');
		ga('send', 'pageview');
	</script>
</head>

<body >



<div class="navbar navbar-static-top">
	<div class="navbar-inner">
		<a class="brand" href="/"><img src="/assets/img/logo-96x36.png" width="96" height="36"/></a>
		<ul class="nav" id="worldTitle"></ul>
		<ul class="nav pull-right" id="quickNav">
			<li id="indicator"><i class="icon-spinner icon-spin muted hide"></i></li>
			<li class="divider-vertical hide"></li>
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



<cfscript>
	param name="request.jsAppend" default="#[]#";
	
	
	local.jsPaths = [
		'/assets/js/app.js'
		, '/assets/js/lib.js'
		, '/assets/js/anet.js'
		//, '/assets/js/bootstrap.min.js'
		//, '/assets/js/store+json2.min.js'
	];
	local.jsPaths.addAll(request.jsAppend);
	
	local.jsLink = application.cfc.static.getMergedLink(
		resourceType = "js",
		relPaths = local.jsPaths
	);
</cfscript>
	
	<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.0.2/jquery.min.js"></script>
	<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/jquery-color/2.1.2/jquery.color.min.js"></script>
	<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/underscore.js/1.4.4/underscore-min.js"></script>
	<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/underscore.string/2.3.0/underscore.string.min.js"></script>
	<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/xregexp/2.0.0/xregexp-all-min.js"></script>
	<script type="text/javascript" src="<cfoutput>#local.jsLink#</cfoutput>"></script>

</body>
</html>
