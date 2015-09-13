({
	afterRender: function(component, helper) {
		this.superAfterRender();
//		helper.refreshSecrets(component);
		
        // if tracking the init lifecycle, this will set the flag to false after the 
        // first rendering of the component	
	}
})