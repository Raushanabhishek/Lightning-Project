({
    getOwnershipPicklist: function(component, event) {
        var action = component.get("c.getPickListValue");
        action.setParams({
            Object_Api_Name : 'Collateral__c',
            field_Api_Name  : component.get("v.ownershipType")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var ownershipMap = [];
                for(var key in result){
                    ownershipMap.push({key: key, value: result[key]});
                }
                component.set("v.ownershipTypeMap", ownershipMap);
            }
        });
        $A.enqueueAction(action);
    },
    getPurposeOfLoanPicklist: function(component, event) {
        var action = component.get("c.getPickListValue");
        action.setParams({
            Object_Api_Name : 'Facility__c',
            field_Api_Name  : 'Purpose_of_Loan__c'
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var purposeMap = [];
                for(var key in result){
                    purposeMap.push({key: key, value: result[key]});
                }
                component.set("v.purposeOfLoanMap", purposeMap);
            }
        });
        $A.enqueueAction(action);
    },
    getTypeOfLoanPicklist: function(component, event) {
        var action = component.get("c.getPickListValue");
        action.setParams({
            Object_Api_Name : 'Facility__c',
            field_Api_Name  : 'NTB_Facility_Category__c'
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var purposeMap = [];
                for(var key in result){
                    purposeMap.push({key: key, value: result[key]});
                }
                component.set("v.typeOfLoanMap", purposeMap);
            }
        });
        $A.enqueueAction(action);
    },
    upsertFacilityAndCollateral : function(component, event) {
        var validData = component.find('abc').reduce(function (validSoFar, inputCmp) {
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        if(validData){
            var params = event.getParam('arguments');
            var callback;
            if (params) {
                callback = params.callback;
            }
            var action = component.get("c.createCollateralDetails");
            action.setParams({
                appObj		 : component.get("v.app"),
                listOfFacility   : component.get("v.listOfFacility"),
                listOfCollateral : component.get("v.listOfCollateral")
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                    callback(response.getReturnValue());
                }
                else if (state === "INCOMPLETE") {
                    // do something
                }
                    else if (state === "ERROR") {
                        var errors = response.getError();
                        if (errors) {
                            
                        } else {
                            console.log("Unknown error");
                        }
                    }    
            });
            $A.enqueueAction(action);
        }    
    },
    getNoOfAppDocRec: function(component, event) {
        var action = component.get("c.getAppDocdetails");
        action.setParams({
            App : component.get("v.app")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.listAppDocCat",result);
            }
        });
        $A.enqueueAction(action);
    }
})