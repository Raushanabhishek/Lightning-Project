({
	doInit : function(component, event, helper) {
		helper.getIndustryPicklist(component, event);
        helper.getConstitutionPicklist(component, event);
	},
    saveAccountDetails : function(component, event, helper) {
    	helper.saveAccount(component, event);    
    }
})