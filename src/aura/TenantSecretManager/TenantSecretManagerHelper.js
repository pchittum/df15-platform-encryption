({
    registerCallbacks : function (component, event){
        //these will be callback functions. will init with closures later.
        //have to do currentSecretCallback later because of dependence on 
        //chaining the child callback
        component.currentSecretCallback;  
        component.archivedSecretCallback;
    },
    createNewSecret : function (component, event) {
        console.log('in helper createNewSecret');
        
        var rotateSecrets = component.get('c.rotateKey');
        
        rotateSecrets.setCallback(this, function(response){
            if (component.isValid()){
                if (response.getState() === 'SUCCESS'){
                    if (!response.getReturnValue().Id){
                        console.log('the new secret was not generated');
                    } 
                    this.refreshSecrets(component);
                } else {
                    //register error that there was an error
                    console.log('error in server request');
                }
            } else {
                //register error that component is out of scope
                console.log('component out of scope');
            }
        });
        
        $A.enqueueAction(rotateSecrets);
        
    },
    refreshSecrets : function(component, event, isInit) {

/*
 * This function demonstrates parent/child requests where child is only enqueued and 
 * invoked once parent has actually responded. 
 * 
 * was going to test event for init state but got back undefined for event name and only
 * param was the component itself, so passing in init Boolean param when calling from onInit
 * in other instances, will not do init so we don't repeat the test for encryption active every rerender
 */
        //controller action fetchLastNTenantSecrets has two params, we invoke twice, so 
        //below we add invoking to retrieve the current active tenant secret
        var activeParams = {
            limitNum : 1,
            status : 'ACTIVE'
        }
        
        //retrieve up to N number of archived secrets
        var archivedParams = {
            limitNum : component.get('v.numArchiveHistory'),
            status : 'ARCHIVED'
        }
        
        //get action instances
        var fetchActiveSecret = component.get('c.fetchLastNTenantSecrets');
        var fetchArchivedSecrets = component.get('c.fetchLastNTenantSecrets');
        
        //abortable: on moving away from this component we can tell framework to 
        //not process any responses still in flight
        fetchActiveSecret.setAbortable();
        fetchArchivedSecrets.setAbortable();
        
        //set the params we setup above
        //could have passed in the objects as object literal here, but added separate 
        //init step for demo purposes
        fetchActiveSecret.setParams(activeParams);
        fetchArchivedSecrets.setParams(archivedParams);
        
        component.currentSecretCallback = this.getCurrentSecretCallback(component, event, fetchArchivedSecrets);
        
        //set parent callback
        fetchActiveSecret.setCallback(this, component.currentSecretCallback);
        
        //one way to create a callback function is to create that 
        //function inside your function. helps with debugging but not reusable. 
        var childCallbackFunc = function(response){

            if (component.isValid()){

                if(response.getState()==='SUCCESS'){
                    
                    component.set('v.archivedSecrets', response.getReturnValue());
					
                }
            } 
            //TODO: explore other options for where to do this 
            component.isInit = false;
        };
        
        //set child callback
        //fetchArchivedSecrets.setCallback(this, this.willNotWorkAsACallback);
        fetchArchivedSecrets.setCallback(this, childCallbackFunc);
        
        //only enqueue the parent here. 
        //child is enqueued in parent callback. If callback is not success (or is aborted)
        //we won't ever send the child XHR
		$A.enqueueAction(fetchActiveSecret);        
	},
    getCurrentSecretCallback : function (component, event, childAction){
        return function(response){
            if (component.isValid()){
                if (response.getState()==='SUCCESS'){
                    var currentSecret = response.getReturnValue()[0]; 
                    
                    if (component.isInit && currentSecret){
                        console.log('executing init if block')
                        component.set('v.encryptionActive',true);
                    }
                    
                    component.set('v.activeSecret',currentSecret);
                    component.set('v.archivedSecrets',[]);
                    
                    $A.enqueueAction(childAction);

                }
            } else {
                
            }            
        };
    },
    getArchivedSecretsCallback : function (component, event) {
      return function(response){

            if (component.isValid()){

                if(response.getState()==='SUCCESS'){
                    
                    component.set('v.archivedSecrets', response.getReturnValue());
					
                }
            } 
            //TODO: this is a bad place to put this. should push an "endInit" event
            //onto the event stack instead. 
            //component.isInit = false;
        };  
    },
    willNotWorkAsACallback : function (response){
        if (component.isValid()){
            
            if(response.getState()==='SUCCESS'){
                
                component.set('v.archivedSecrets', response.getReturnValue());
                
            }
        }  
        //the problem is that component is out of scope. To reuse callback
    	//functionality, you need to create a closure around component.
    	//this means passing component to a function that returns a function
	}
        
})