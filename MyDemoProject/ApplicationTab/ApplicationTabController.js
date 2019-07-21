({
	doInit : function(component, event, helper) {
		var AppId = component.get("v.recordId");
        //To get application details
        var getappdetails = component.get("c.getApplicationDetails");
        getappdetails.setParams({
            "applicationId": AppId
        });
        getappdetails.setCallback(this, function(result){
            var state = result.getState();
            if (state === "SUCCESS") {
                component.set("v.appdetails", result.getReturnValue());
                console.log(result.getReturnValue());
            } 
        })
        $A.enqueueAction(getappdetails);  
        
        //To get parties
        var getPartydetails = component.get("c.getPartyDetails");
        getPartydetails.setParams({
            "applicationId": AppId
        });
        getPartydetails.setCallback(this, function(result){
            var state = result.getState();
            if (state === "SUCCESS") {
                component.set("v.partydetails", result.getReturnValue());
                
                console.log(result.getReturnValue());
            } 
        })
        $A.enqueueAction(getPartydetails);  
        
        //to get Facilities
        var getFacilitydetail = component.get("c.getFacilityDetails");
        getFacilitydetail.setParams({
            "applicationId": AppId
        });
        getFacilitydetail.setCallback(this, function(result){
            var state = result.getState();
            if (state === "SUCCESS") {
                component.set("v.facilitydetails", result.getReturnValue());
                console.log(result.getReturnValue());
            } 
        })
        $A.enqueueAction(getFacilitydetail);  
        
        //To get Application Collateral details
        var getAppCollateraldetails = component.get("c.getCollateralDetails");
        getAppCollateraldetails.setParams({
            "applicationId": AppId
        });
        getAppCollateraldetails.setCallback(this, function(result){
            var state = result.getState();
            if (state === "SUCCESS") {
                component.set("v.Collateraldetails", result.getReturnValue());
                console.log(result.getReturnValue());
            } 
        })
        $A.enqueueAction(getAppCollateraldetails);  
	},
    
    
    handleSectionToggle: function (cmp, event) {
        var openSections = event.getParam('openSections');

        if (openSections.length === 0) {
            cmp.set('v.activeSectionsMessage', "All sections are closed");
        } else {
            cmp.set('v.activeSectionsMessage', "Open sections: " + openSections.join(', '));
        }
    }
})