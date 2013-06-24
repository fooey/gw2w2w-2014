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
<html lang="en" ng-app="ngGw2">
<head>
	<meta charset="utf-8">
	<title itemprop="name">GW2W2W</title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link href="<cfoutput>#local.cssLink#</cfoutput>" rel="stylesheet">
	
    	
    <script src="http://cdnjs.cloudflare.com/ajax/libs/xregexp/2.0.0/xregexp-all-min.js"></script>
	<script src="http://ajax.googleapis.com/ajax/libs/angularjs/1.0.7/angular.min.js"></script>
    <script src="http://ajax.googleapis.com/ajax/libs/angularjs/1.0.7/angular-resource.min.js"></script>
    <script src="/assets/js/app.js"></script>
    <script src="/assets/js/anet.js"></script>
	
    <!---<script src="http://ajax.googleapis.com/ajax/libs/jquery/2.0.1/jquery.min.js"></script>--->
    <!---<script src="http://cdnjs.cloudflare.com/ajax/libs/underscore.js/1.4.4/underscore-min.js"></script>--->
	
    <!---<script src="/assets/js/bootstrap.min.js"></script>--->
    <!---<script src="/assets/js/store-json2.min.js"></script>--->
</head>

<body ng-controller="MainCntl">



<div class="navbar navbar-static-top">
	<div class="navbar-inner">
		<a class="brand" href="/">GW2W2W</a>
		<ul class="nav pull-right" ng-controller="LangCtrl">
			<li ng-repeat="lang in langs">
				<a href="{{lang.href}}" title="{{lang.description}}">{{lang.text}}</a>
			</li>
		</ul>
		<ul class="nav">
		</ul>
	</div>
</div>
	
<div class="container">
	<div class="row-fluid">
		<div class="span24">
			<div ng-view></div>
			
			
			<hr />			
			<pre>$location.path() = {{$location.path()}}</pre>
			<pre>$route.current.templateUrl = {{$route.current.templateUrl}}</pre>
			<pre>$route.current.params = {{$route.current.params}}</pre>
			<pre>$route.current.scope.name = {{$route.current.scope.name}}</pre>
			<pre>$routeParams = {{$routeParams}}</pre>
			
		</div>
	</div>
</div> <!-- /container -->

</body>
</html>
