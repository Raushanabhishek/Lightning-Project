({
	myAction : function(component, event, helper) {
        alert(component.get("v.recordId"));
         helper.getAccountDetails(component, event, helper);
		
	}
})