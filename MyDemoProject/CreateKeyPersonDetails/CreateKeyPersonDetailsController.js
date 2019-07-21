({
	doInit : function(component, event, helper) {
        helper.getPartyTypePickList(component, event); 
        helper.getGenderPickList(component, event);
        helper.getMaritalStatusPickList(component, event);
		//helper.getParties(component, event);
	},
    addNewParties : function(component, event, helper) {
        // If we pass error checking, do some real work
        var keyPersionDetails = component.get("v.PartiesList");
        keyPersionDetails.push({
            'sObject' : 'Account',
            'LastName':'',
            'FirstName':'',
            'Birthdate': '',
            'Email':'',
            'Mobile':'',
            'Aadhar_Number__c':'',
            'Pan_Number__c':'',
            'Gender__c':'',
            'FatherName__c':'',
            'Marital_Status__c':'',
            'Education_Qualification__c':'',
            'MailingStreet':'',
            'MailingCity':'',
            'MailingState':'',
            'MailingCountry':'',
            'MailingPostalCode':'',
            'OtherStreet':'',
            'OtherCity':'',
            'OtherState':'',
            'OtherCountry': '',
            'OtherPostalCode':'',
            'Party_Type__c':''
        });
        component.set("v.isShow", false);
        component.set("v.PartiesList", keyPersionDetails);
    },
    insertORUpdateParties : function(component, event, helper){
    	helper.getParties(component, event);    
    }
})