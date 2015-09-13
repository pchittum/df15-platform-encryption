({
	doInit : function(component, event, helper) {
        component.isInit = true;
		helper.refreshSecrets(component, event, true);
//        window.setTimeout(
//            $A.getCallback(function(){
//                component.isInit = false;
//            }),1000
//        );
	},
    rotateSecret : function(component, event, helper){
        console.log('in rotate secret handler');
        //call function to create new tenant secret
        helper.createNewSecret(component, event);
    }
})