<cfscript>
	param name="request.jsAppend" default="#[]#";
	
	
	local.jsPaths = [
		'/assets/js/custom.js'
		//, '/assets/js/bootstrap.min.js'
		//, '/assets/js/store+json2.min.js'
	];
	local.jsPaths.addAll(request.jsAppend);
	
	local.jsLink = application.cfc.static.getMergedLink(
		resourceType = "js",
		relPaths = local.jsPaths
	);
</cfscript>

<cfoutput>	
	<footer id="footer" class="footer" itemscope itemtype="http://schema.org/WPFooter">
		<div class="row-fluid"><div class="span24">
			
			<div class="row-fluid">
				<div class="span16">
					<!---<p class="btn-group">
						<!---<a class="btn btn-small" href="/sitemap"><i class="icon-list"></i> Sitemap</a>--->
						<a target="_blank" class="btn" href="/legal/termsandconditions"><i class="icon-info-sign"></i> Terms and Conditions of Use</a>
						<a target="_blank" class="btn" href="/legal/privacypolicy"><i class="icon-info-sign"></i> Privacy Policy</a>
						<!---<a target="_blank" class="btn btn-small" href="/legal/ContentGuidelines.cfm"><i class="icon-info-sign"></i> Content Policies and Guidelines</a>--->
					</p>--->
					<p id="copy">
						GW2-Events.com
						&copy;2013<cfif year(now()) NEQ "2013">-#year(now())#</cfif>
					</p>
				</div>
				<div class="span8">
					<div id="anet-attribution">
						<p>Data by ArenaNet</p>
					</div>
				</div>
			</div><!--- row --->
				
		</div></div><!--- row --->
	</footer>
	
</div> <!-- /container -->
	
	<!--[if lt IE 9]>
    	<script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
	<![endif]-->
	<!--[if gte IE 9]><!-->
		<script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/2.0.1/jquery.min.js"></script>
	<!--<![endif]-->
	<!---<script src="//ajax.googleapis.com/ajax/libs/angularjs/1.0.7/angular.min.js"></script>--->
	
	<!---http://underscorejs.org/ --->
	<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/underscore.js/1.4.4/underscore-min.js"></script>
	
	<!---https://github.com/epeli/underscore.string --->
	<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/underscore.string/2.3.0/underscore.string.min.js"></script>
	<script>
		window.urlData  ={
			lang: <cfoutput>'#url.lang#'</cfoutput>
			, world: <cfoutput>'#url.world#'</cfoutput>
			, map: <cfoutput>'#url.map#'</cfoutput>
		}
		</script>
	<script src="http://cdnjs.cloudflare.com/ajax/libs/xregexp/2.0.0/xregexp-all-min.js"></script>
	<script src="#local.jsLink#"></script>
	
</cfoutput>
</body>
</html>
