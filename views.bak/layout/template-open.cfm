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
<html lang="en" itemscope itemtype="http://schema.org/WebPage">
<cfoutput>
<head>
	<meta charset="utf-8">
	<title itemprop="name">#request.model.getMeta().getTitle()#</title>
	<meta name="description" itemprop="description" content="#request.model.getMeta().getDescription()#">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta itemprop="isFamilyFriendly" content="true" />
	<meta itemprop="inLanguage" content="en-us" />

	
	<!--- FIXME --->
	<!---<link rel="publisher" href="https://plus.google.com/u/0/b/102962327644029116086/" />--->
		
	<link href='http://fonts.googleapis.com/css?family=Open+Sans:300italic,400italic,600italic,700italic,800italic,400,300,600,700,800|Oswald:400,300,700|Droid+Sans+Mon' rel='stylesheet' type='text/css'>
	<link href="#local.cssLink#" rel="stylesheet">
	
	<!--[if lt IE 9]><script src="/assets/js/html5shiv.js"></script><![endif]-->
	<!--[if IE 7]><link rel="stylesheet" href="/assets/css/font-awesome-ie7.min.css"><![endif]-->
	
	
	<!---FIXME --->
	<!---<script>
		(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
		(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
		m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
		})(window,document,'script','//www.google-analytics.com/analytics.js','ga');
		
		ga('create', 'UA-51384-36', 'gw2-events.com');
		ga('send', 'pageview');
	</script>--->
</head>

<body>



<div class="container">
	
	<div class="page-header" id="masthead" itemscope itemtype="http://schema.org/WPHeader">
		<div class="row-fluid">
			<div class="span16">
				<a id="brand" href="/"><img src="#application.cfc.static.getLink('/assets/img/gw2-dragon-48.png')#" width="48" height="48" /> GW2 TP</a>
			</div>
			<div class="span8">
			</div>
		</div>
	</div>
	
	<div class="row-fluid">
		<div class="span20">
			#request.model.getMeta().getBreadcrumb().getHtml()#
		</div>
		<cfif structKeyExists(url, "map") AND len(url.map)>
			<div class="span1">
				<input type="text" id="refreshTime" value="15" class="span24 small input-mini" />
			</div>
			<div class="span3">
				<div id="progressToRefresh" class="progress active">
					<div class="bar" style="width: 1%;"></div>
				</div>
			</div>
		</cfif>
	</div>

</cfoutput>

	
	