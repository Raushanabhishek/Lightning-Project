({
    getPartyTypePickList : function(component, event){
        var action = component.get("c.getPickListValue");
        action.setParams({
            Object_Api_Name : 'Account',
            field_Api_Name  : 'Party_Type__c'
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var ownershipMap = [];
                for(var key in result){
                    ownershipMap.push({key: key, value: result[key]});
                }
                component.set("v.partyTypeMap", ownershipMap);
            }
        });
        $A.enqueueAction(action);
    },
    getGenderPickList : function(component, event){
        var action = component.get("c.getPickListValue");
        action.setParams({
            Object_Api_Name : 'Account',
            field_Api_Name  : 'Gender__c'
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var ownershipMap = [];
                for(var key in result){
                    ownershipMap.push({key: key, value: result[key]});
                }
                component.set("v.partyGenderMap", ownershipMap);
            }
        });
        $A.enqueueAction(action);
    },
    getMaritalStatusPickList : function(component, event){
        var action = component.get("c.getPickListValue");
        action.setParams({
            Object_Api_Name : 'Account',
            field_Api_Name  : 'Marital_Status__c'
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var ownershipMap = [];
                for(var key in result){
                    ownershipMap.push({key: key, value: result[key]});
                }
                component.set("v.partyMaritalMap", ownershipMap);
            }
        });
        $A.enqueueAction(action);
    },
    getParties : function(component, event) {
        var validData = component.find('keypartyrequred').reduce(function (validSoFar, inputCmp) {
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        // If we pass error checking, do some real work
        if(validData){
            debugger;
            var params = event.getParam('arguments');
            var callback;
            if (params) {
                callback = params.callback;
            }
            var action = component.get("c.createORUpdateParties");
            action.setParams({
                listOfPersonAccount   : component.get("v.PartiesList"),
                businnesAccObj 		  : component.get("v.businessAccount"),
                appObj		 	      : component.get("v.app")
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
    }
})