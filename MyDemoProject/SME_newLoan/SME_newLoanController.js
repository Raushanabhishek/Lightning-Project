({
	myAction : function(component, event, helper) {
        //debugger;
		var action = component.get("c.getRecords");
        action.setParams({
            accId: component.get("v.recordId")
        });
        action.setCallback(this, function(data) {
           // component.set("v.Applications", data.getReturnValue());
            var accountAndAppInfo = data.getReturnValue();
            if(accountAndAppInfo.accRecord != null && accountAndAppInfo.accRecord != undefined ){
                component.set('v.custDetails',accountAndAppInfo.accRecord); 
            }
            if(accountAndAppInfo.appList != null && accountAndAppInfo.appList != undefined ){
                component.set('v.Applications',accountAndAppInfo.appList);
                console.log("result", JSON.stringify(v.Applications));
                alert('accountAndAppInfo.appList');
            }
        });
        $A.enqueueAction(action);
	},
    
    loadNew : function(component, event, helper){
        var newloan =$A.get()
}
})