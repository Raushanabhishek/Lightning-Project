({
    fetchFacilities : function(component, event) {
        var action = component.get("c.getFacilitiesDetails");
        action.setParams({
            appId : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state ==='SUCCESS'){
                var result = response.getReturnValue();
                if(result !==null){
                    component.set("v.app",result['Application']);
                    component.set("v.listoffacilities", result['Facility']);
                }else{
                    alert('Something went wrong.');
                }
            }else if(state ==='INCOMPLETE'){
                alert('Your request is underproccessing.')    
            }else if(state ==='ERROR'){
                alert('Something went wrong.')    
            }
        });
        
        $A.enqueueAction(action);
    },
    saveRecommendationHelper : function (component, event){
        debugger;
        var validData = component.find('abc').reduce(function (validSoFar, inputCmp) {
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        if(validData){
            var action = component.get("c.saveRecommendation");
            var facilityList = component.get("v.listoffacilities");
            /*var facilityChild = [];
        for(var faciObj in facilityList){
            for(var faciChild in faciObj.Facilities__r){
            	facilityChild.push(faciChild);        
            }
        }*/
            var allChildfacility = [];
            for(var i=0;i<facilityList.length;i++){
                if(facilityList[i].Facilities__r.length >0){
                    
                    for(var j=0;j<facilityList[i].Facilities__r.length;j++){
                        allChildfacility.push(facilityList[i].Facilities__r[j]); 
                    }
                }
            }
            console.log(allChildfacility);
            component.set('v.allChildfacilityToBeSaved',allChildfacility);
            action.setParams({
                listOfParent : component.get("v.listoffacilities"),
                facilityList : component.get('v.allChildfacilityToBeSaved')
                
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state ==='SUCCESS'){
                    var result = response.getReturnValue();
                    if(result !=null){
                        if(result =='INSUFFICIENT'){
                            component.set('v.isModalOpen',true);
                        }else{
                        	window.location.reload();    
                        }
                    }
                }else if(state ==='INCOMPLETE'){
                    alert('Your request is underproccessing.')    
                }else if(state ==='ERROR'){
                    alert('Something went wrong.')    
                }
            });
            
            $A.enqueueAction(action);    
        }
    }
})