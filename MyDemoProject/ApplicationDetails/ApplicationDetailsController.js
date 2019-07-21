({
	doInit : function(component, event, helper) {
        var applicationid = component.get("v.recordId");
		var getTaskDetail = component.get("c.getTaskDetails");
        getTaskDetail.setParams({
            "applicationId": applicationid
        });
        getTaskDetail.setCallback(this, function(result){
            var state = result.getState();
            if (state === "SUCCESS") {
                component.set("v.TaskDetails", result.getReturnValue());
                console.log(result.getReturnValue());
            } 
        })
        $A.enqueueAction(getTaskDetail);  
	}
})