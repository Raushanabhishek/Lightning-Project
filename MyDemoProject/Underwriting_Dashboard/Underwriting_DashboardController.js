({
	doInit : function(component, event, helper) {
		helper.fetchFacilities(component, event);	
	},
    submitRecommendation : function(component, event, helper) {
    	helper.saveRecommendationHelper(component, event);
        //helper.fetchFacilities(component, event);
    },
    closeModel: function(component, event, helper) {
        component.set("v.isModalOpen", false);
    },
    submitApp: function(component, event, helper) {
        component.set("v.isModalOpen", false);
        window.location.reload();
    }
})