({
    doInit : function(component, event, helper){
    	helper.getOwnershipPicklist(component, event);
        helper.getPurposeOfLoanPicklist(component, event);
        helper.getTypeOfLoanPicklist(component, event);
        helper.getNoOfAppDocRec(component, event);
    },
    saveFinancialDetails : function(component, event, helper) {
		helper.upsertFacilityAndCollateral(component, event);	
	},
    addNewCollateralDetail : function(component, event, helper) {
        var collateralList = component.get("v.listOfCollateral");
        collateralList.push({
            'sObject' : 'Collateral__c',
            'Name'	: '',
            'Nature_of_Property__c' : '',
            'Collateral_value__c' : '',
            'Area_Square_Feet__c' : '',
            'Survey_Number__c' : '',
            'Khata_Number__c' : '',
            'Collateral_Address__c' : '',
            'Owner_Name__c' : '',
            'Owner_Pan_Number__c' : '',
            'Owner_Aadhar_Number__c' : '',
            'Ownership_Type__c' : ''

        });
        component.set("v.listOfCollateral", collateralList);
    },
    addNewFacilityDetail : function(component, event, helper) {
        var facilityList = component.get("v.listOfFacility");
        facilityList.push({
            'sObject' : 'Facility__c',
            'Requested_Amount__c': '',
            'Purpose_of_Loan__c': '',
            'NTB_Facility_Category__c': ''
        });
        component.set("v.listOfFacility", facilityList);
    },
    addNewDocumentsDetail : function(component, event, helper) {
        var DocumentList = component.get("v.listOfDocuments");
        DocumentList.push({
            'sObject' : 'AppDocCatAttachmentJunction__c',
            'AttachmentId__c': '',
            'Document_Name__c': ''
        });
        component.set("v.listOfDocuments", DocumentList);
    },
    
    handleUploadFinished: function (cmp, event) {
        // This will contain the List of File uploaded data and status
        //var uploadedFiles = event.getParam("files");
       var uploadedFiles = event.getParam("files");
        alert("Files uploaded : " + uploadedFiles.length);
    }

})