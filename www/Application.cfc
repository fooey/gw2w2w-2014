<cfcomponent output="false">

	<!--- Application.cfc configuration --->
	<cfscript>
		this.name = "GW2-WvWvW";
		this.ApplicationTimeout = createTimeSpan(1,0,0,0);

		this.setClientCookies = "false";
		this.ScriptProtect = "no";
		this.sessionmanagement = "no";
		this.clientmanagement= "no";


		/* define custom coldfusion mappings. Keys are mapping names, values are full paths */
		local.thisPath = getDirectoryFromPath(getCurrentTemplatePath());
		local.thisParentPath = listDeleteAt(local.thisPath, listLen(local.thisPath, "/\"), "/\");
		this.mappings = {
			"/appRoot" = local.thisParentPath
			,"/siteRoot" = local.thisPath
			,"/cfc" = local.thisParentPath & "/cfc"
			,"/www" = local.thisParentPath & "/www"
			,"/static" = local.thisParentPath & "/www/static"
		};

		/* define a list of custom tag paths. */
		//this.customtagpaths = "";
	</cfscript>
	 



	
	<!--- Application.cfc framework --->
	<cfscript>		
		public boolean function onApplicationStart(){			
			application.startTime = now();
			
			initGlobalSettings();
			initComponents();
	
			return true;
		}
		
		
		
		public void function onRequestStart(required string thePage){
			param name="url.lang" default="";  
			param name="url.world" default=""; 
			
			if(structKeyExists(url, "reset")){
				applicationStop();
				location('/');
			}
		}


		/*
		function onError(any exception, string eventName){
			param name="request.executionStartTime"  default="#getTickCount()#";
			application.util.cfscript.setting(requestTimeout = ((getTickCount() - request.executionStartTime) / 1000) + 10);
			application.cfc.errors.throw(type = 500, dump = arguments);
			abort;
		}
		*/
		
		
		/*
		function onMissingTemplate(targetPage){
			application.cfc.errors.throw(type = 404, notifyAdmin = true);
			abort;
		}
		*/
		
		
		//function onRequestEnd(thePage){}
		//function onSessionStart(){}
		//function onSessionEnd(sessionScope,appScope){}
		//function onApplicationEnd(appScope){}
	</cfscript>
	 




	<cfscript>
		private void function initGlobalSettings(){
			application.host.machineName = CreateObject("java", "java.net.InetAddress").getLocalHost().getHostName();
			application.host.addr = CreateObject("java", "java.net.InetAddress").getLocalHost().getHostAddress();
			application.isDev = (application.host.machineName EQ "DEV" OR application.host.machineName EQ "Jason-PC");
			application.isProd = (NOT application.isDev);
		}
		
		
		
		private void function initComponents(){
			application.util.cfscript = new lib.cfc.cfscript();
			application.util.fileSystem = new lib.cfc.fileSystem();
			application.util.date = new lib.cfc.date();
			
			application.cfc.static = new cfc.static(
				localPath = expandPath('/siteRoot/assets/merged/')
				, publicPath = '/assets/merged'
			);
		}
	</cfscript>

</cfcomponent>