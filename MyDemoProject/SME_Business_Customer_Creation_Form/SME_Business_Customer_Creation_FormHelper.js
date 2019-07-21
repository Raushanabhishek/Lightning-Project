({
    getIndustryPicklist: function(component, event) {
        var action = component.get("c.getPickListValue");
        action.setParams({
            Object_Api_Name : component.get("v.objectName"),
            field_Api_Name  : component.get("v.industryType")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var industryMap = [];
                for(var key in result){
                    industryMap.push({key: key, value: result[key]});
                }
                component.set("v.industryMap", industryMap);
            }
        });
        $A.enqueueAction(action);
    },
    getConstitutionPicklist: function(component, event) {
        var action = component.get("c.getPickListValue");
        action.setParams({
            Object_Api_Name : component.get("v.objectName"),
            field_Api_Name  : component.get("v.constitutionValue")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var industryMap = [];
                for(var key in result){
                    industryMap.push({key: key, value: result[key]});
                }
                component.set("v.constitutionMap", industryMap);
            }
        });
        $A.enqueueAction(action);
    },
    saveAccount: function(component, event){
        debugger;
        var validData = component.find('abc').reduce(function (validSoFar, inputCmp) {
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
       if(validData){
        var params = event.getParam('arguments');
        var callback;
        console.log(params);
        if (params) {
            callback = params.callback;
        }
        var action = component.get("c.createOrUpdateAccount");
        action.setParams({ accObj : component.get("v.acc") });
        
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                callback(response.getReturnValue());
                /* var cmpEvent =  component.getEvent("SME_Business_CmpEvent_Next");
                    cmpEvent.setParams({"accBusinessPrevObj" : response.getReturnValue()}); 
                    cmpEvent.fire();  */  
            }else if (state === "INCOMPLETE") {
                // do something
            } else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
       // optionally set storable, abortable, background flag here
        // A client-side action could cause multiple events, 
        // which could trigger other events and 
        // other server-side action calls.
        // $A.enqueueAction adds the server-side action to the queue.
        $A.enqueueAction(action);
    }
    }
})