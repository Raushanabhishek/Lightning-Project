({
	getAccountInfo : function(component, event, helper) {
        
        var action = component.get("c.getAccountDetails");
       action.setCallback(this, function(response){
            if(response.getState()==="SUCCESS" && component.isValid()){
                component.set("v.accountdetails",response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }, 
    getAccountDetails: function(component, event, helper){
        var action = component.get("c.getAccountDetails");
     
       
                action.setParams({
                 applicationid:component.get("v.recordId")
                   
            });
        action.setCallback(this, function(response){
            if(response.getState()==="SUCCESS" )
            {
                component.set("v.accountdetails", JSON.parse(JSON.stringify(response.getReturnValue())));
                console.log(component.get("v.accountdetails"));
            }
            
    });
        $A.enqueueAction(action);
    },
          getPartyDetails     : function(component, event, helper){
        var action = component.get("c.getPartyDetails");
                action.setParams({
                 applicationid:component.get("v.recordId")
            });
            action.setCallback(this, function(response1){
                if(response.getState()==="SUCCESS" && component.isValid()){
                    component.set("v.partydetails",response.getReturnValue());
                }
            });
            $A.enqueueAction(action);
    },            
        getAppDetails  : function(component, event, helper){
            
        var action = component.get("c.getAppDetails");
             action.setParams({
                 applicationid:component.get("v.recordId")
            });
            action.setCallback(this, function(response){
                debugger;
                if(response.getState()==="SUCCESS" && component.isValid()){
                    component.set("v.appdetails",response.getReturnValue());
                }
            });
            $A.enqueueAction(action); 
        },
   
    
  
    coborrowerlist :function(component,event,helper) {
        
 var action = component.get("c.getCoborrowerDetails");
        action.setParams({
                 applicationid:component.get("v.recordId")
            });
 action.setCallback(this, function(response){
       if(response.getState()==="SUCCESS" ){
                    console.log(response);
                    component.set("v.coBorrower",response.getReturnValue());
                }
            });
            $A.enqueueAction(action);
    },
    getdoc:function(component,event,helper) {
        debugger;
        console.log('INNNN');
        var action = component.get("c.getDocumentDetails");
        action.setParams({
            applicationid:component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            console.log('STATE'+response.getState());
            if(response.getState()==="SUCCESS" ){
                var treeData= response.getReturnValue();
                console.log('treeData INNN ::::'+JSON.stringify(treeData));
               component.set("v.items",treeData);
            }
        });
        $A.enqueueAction(action);
    } ,
    
    
       
    
    
    
})