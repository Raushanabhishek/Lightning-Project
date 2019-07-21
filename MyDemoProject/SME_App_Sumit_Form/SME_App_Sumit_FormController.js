({
    closeModel: function(component, event, helper) {
        component.set("v.isModalOpen", false);
    },
    submitApp : function(component, event, helper) {
        //submitApplication
        var action = component.get("c.submitApplication");
        action.setParams({
            appObj : component.get("v.appObj"),
            listOfFacilities : component.get("v.listOfFacility")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                var result = response.getReturnValue();
                component.set("v.appNuber",result.Name);
                component.set("v.resultSaved", true);
                //location.reload();
            }else if(state === 'INCOMPLETE'){
                
            }else if(state === 'ERROR'){
                
            }
        });
        $A.enqueueAction(action);
    }
})