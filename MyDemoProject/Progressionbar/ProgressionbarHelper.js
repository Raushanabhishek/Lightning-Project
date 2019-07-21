({
	
          getAccountDetails: function(component, event, helper){
        var action = component.get("c.getAccountDetails");
     
       
                action.setParams({
                 applicationid:component.get("v.recordId")
                   
            });
        action.setCallback(this, function(response){
            if(response.getState()==="SUCCESS" )
            {
                component.set("v.accountdetails", JSON.parse(JSON.stringify(response.getReturnValue())));
                console.log(component.get("v.accountdetails"));
            }
            
    });
        $A.enqueueAction(action);
    },
		
	
})