({
	getM68C : function(component, event) {
        debugger;
         var action = component.get("c.getM68cDetails");
        action.setParams({
            appId :  component.get("v.appId")   
        });
        action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                    var result = response.getReturnValue();
                    if(result !==null){
                    	component.set("v.m68cList",result);    
                    }else{
                        alert('Opps !! Something went wrong');
                    }
                }
                else if (state === "INCOMPLETE") {
                    // do something
                }
                    else if (state === "ERROR") {
                        var errors = response.getError();
                        alert(errors);
                    }    
            });
            $A.enqueueAction(action);
	}
})