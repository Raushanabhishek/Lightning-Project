({
    loadPrimary : function(component, event, helper) {
        
        
        helper.getAccountDetails(component, event, helper);
        helper.getPartyDetails(component, event, helper);
        helper.getAppDetails(component, event, helper);
        
        helper.coborrowerlist(component, event, helper);
        helper.getdoc(component,event,helper);
        
        
    },
    
    newPopup : function(component, event, helper){
        
        
        var cmpTarget = component.find('Modalbox1');
        var cmpBack = component.find('Modalbackdrop');
        
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open');
        
        
        
    },
    /*  saveModal : function(component, event, helper){

        var action = component.get("v.fetchAcc");
   
        action.setParams({
                 applicationid:component.get("v.recordId")
                   
            });
        action.setCallback(this, function(response) {
            var state = response.getState();          
            if (state === "SUCCESS") {
                 var allValues = response.getReturnValue();
                   component.set('v.accForm', allValues);
                $A.get('e.force:refreshView').fire();
                var cmpTarget = component.find('Modalbox1');
                var cmpBack = component.find('Modalbackdrop');
                $A.util.removeClass(cmpBack,'slds-backdrop--open');
                $A.util.removeClass(cmpTarget, 'slds-fade-in-open');
                
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } 
                else {
                    console.log(response.getReturnValue());
                }
            }
        });
        $A.enqueueAction(action);
    },*/
    
    closeNewModal : function(component, event, helper){
        var cmpTarget = component.find('Modalbox1');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open');
    },
    
    
    handleSectionToggle: function (cmp, event) {
        var openSections = event.getParam('openSections');
        
        if (openSections.length === 0) {
            cmp.set('v.activeSectionsMessage', "All sections are closed");
        } else {
            cmp.set('v.activeSectionsMessage', "Open sections: " + openSections.join(', '));
        }
    },
    handleSelect: function (cmp, event, helper) {
        //return name of selected tree item
        var selectedName = event.getParam('name');
        alert("Selected Name: " + selectedName);
    },
    
    
    /*  edit : function(component, event, helper) {
        var editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
            "recordId": component.get("v.recordId")
        });
        editRecordEvent.fire();
    },*/
    
    editAccount : function(component, event, helper) {
        //var idx = event.target.id;
        component.set('v.showmodal',false);
        console.log('hiding current page');
        var current = component.get('v.showModal1');
        component.set('v.showModal1', true); 
        
        
        
        
        //alert(idx);  
        
    } 
})