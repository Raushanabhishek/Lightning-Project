({
    closeModel: function(component, event, helper) {
        component.set("v.isModalOpen", false);
    },
    rerenderThePage : function(component, event, helper) {
        debugger;
        if(component.get("v.nameOfComp") == 'SME_Business_Customer_Creation_Form'){
            //call aura method of first comp
            var abc = component.find("cusDetailCmp");
            //abc.customerDetailsMethod();
            abc.customerDetailsMethod(function(result) {
                console.log("result: " + JSON.stringify(result));
                
                if(result !== undefined && result !== null){
                    component.set("v.accObj",result['Account']);
                    component.set("v.app",result['Application']);
                    component.set("v.isModalOpen", false);
                    component.set("v.nameOfComp",'CreateKeyPersonDetails');
                    component.set("v.isPrevEnable", true);
                }else{
                    component.set("v.isModalOpen", true);
                }
            });
            
        }else if(component.get("v.nameOfComp") == 'CreateKeyPersonDetails'){
            var abc = component.find("keyPartiesCmp");
            abc.keyPartiesDetailsMethod(function(result) {
            	 if(result !== undefined && result !== null){
                    component.set("v.listOfParties",result['Party']); 
                    component.set("v.listOfAccPerson",result['PartyAccount']);
                    component.set("v.isModalOpen", false);
                    component.set("v.nameOfComp",'FinancialDetails');    
                }else{
                    component.set("v.isModalOpen", true);
                }    
            });
        }else if(component.get("v.nameOfComp") == 'FinancialDetails'){
            var abc = component.find("financialCmp");
            abc.financialDetailsMethod(function(result){
                if(result !==null && result !== undefined){
                	component.set("v.listOfFacility",result['Facility']);
                    component.set("v.listOfCollateral",result['Collateral']);
                    component.set("v.nameOfComp",'SME_App_Sumit_Form');
                    component.set("v.isNextEnable", false);
                }
            });
        }else if(component.get("v.nameOfComp") == 'SME_App_Sumit_Form'){
            
        }
    },
    setAttributeAccountNext : function(component, event, helper){
        var accObj = event.getParam("accBusinessPrevObj");
        component.set("v.accObj",accObj);    
    },
    prevRerenderPage : function(component, event, helper){
        if(component.get("v.nameOfComp") == 'FinancialDetails'){
        	component.set("v.nameOfComp",'CreateKeyPersonDetails');
            component.set("v.isPrevButton",true);
        }else if(component.get("v.nameOfComp") == 'CreateKeyPersonDetails'){
            component.set("v.nameOfComp",'SME_Business_Customer_Creation_Form');
            component.set("v.isPrevButton",true);
        }else if(component.get("v.nameOfComp") == 'SME_Business_Customer_Creation_Form'){
            component.set("v.nameOfComp",'SME_Business_Customer_Creation_Form');
            component.set("v.isPrevEnable", false);
        }else if(component.get("v.nameOfComp") == 'SME_App_Sumit_Form'){
            component.set("v.isNextEnable", true);
            component.set("v.nameOfComp",'FinancialDetails');
            component.set("v.isPrevButton",false);
        }   
    }
})