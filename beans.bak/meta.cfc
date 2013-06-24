component output="false" accessors="true"
{
	property name="title";
	property name="description";
	property name="canonical";
	
	property name="breadCrumb" type="beans.meta.breadcrumb";
	
	  
	public function init(
		title = ""
		, description = ""
		, canonical = ""
	){
		
		setTitle(arguments.title);
		setDescription(arguments.description);
		setCanonical(arguments.canonical);

		setBreadCrumb(new beans.meta.breadcrumb());
		
		return this;
	}
	
	
	public function setTitle(title){
		variables.title = cleanWhiteSpace(arguments.title);
	}
	
	
	public function setDescription(description){
		variables.description = cleanWhiteSpace(arguments.description);
	}
	
	
	
	private function cleanWhiteSpace(str){
		local.str = trim(arguments.str);
		local.str = reReplace(local.str, " {2,}", " ", "ALL");
		return local.str;
	}
	

}