component
output="false"
accessors="false"
{
	
	public void function init(){
		variables.crumbs = [];
		appendCrumb("Home", "/");
	}
	
	public boolean function appendCrumb(text, url, title=arguments.text){
		return arrayAppend(variables.crumbs, {text = arguments.text, url = arguments.url, title = arguments.title});
	}
	
	
	public string function getHtml(){
		local.toHtml = [];
		local.totalText = 0;
		
		if (arrayLen(variables.crumbs) EQ 1){
			return "";
		}
		
		for(local.ix = 1; local.ix <= arrayLen(variables.crumbs); local.ix++){
			local.thisCrumb = variables.crumbs[local.ix];
			
			local.totalText += len(local.thisCrumb.text);
			
			local.crumbAttrib = [''];
			if(len(local.thisCrumb.url)){
				local.crumbAnchorAttrib = [
					'href="#local.thisCrumb.url#"'
					,'itemprop="breadcrumb"'
				];
			}
			else{
				local.crumbAnchorAttrib = [];
			}
			
			if(local.ix EQ 1){
				local.dividerIcon = "icon-home";	
			}
			else{
				local.dividerIcon = "icon-caret-right";
			}
			
			local.dividerHtml = ' <span class="divider #local.dividerIcon#"></span>';
			
			if(len(local.thisCrumb.title)){
				arrayAppend(local.crumbAnchorAttrib, 'title="#jsStringFormat(local.thisCrumb.title)#"');
			}
			
			if(local.ix EQ arrayLen(variables.crumbs)){
				arrayAppend(local.crumbAttrib, 'class="active"');
			}
			
			local.crumbAttribString = arrayToList(local.crumbAttrib, " ");
			local.crumbAnchorAttribString = arrayToList(local.crumbAnchorAttrib, " ");
			
			if(len(local.thisCrumb.url)){
				arrayAppend(
					local.toHtml,
					'<li #local.crumbAttribString#>#local.dividerHtml# <a #local.crumbAnchorAttribString#>#local.thisCrumb.text#</a></li>'
				);
			}
			else{
				arrayAppend(
					local.toHtml,
					'<li #local.crumbAttribString#>#local.dividerHtml# <span #local.crumbAnchorAttribString#>#local.thisCrumb.text#</span></li>'
				);
			}
		}
		
		
		local.crumbClass = "breadcrumb";
		if(local.totalText GT 140){
			local.crumbClass = listAppend(local.crumbClass, "trunc", " ");
		}
		
		return '<ul class="#local.crumbClass#">#arrayToList(local.toHtml, chr(10))#</ul>';
	}
}