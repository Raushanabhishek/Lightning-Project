/*
Class Name : Customer360View
Purpose    : Insertion and Updation Customer details and Loan Details.	
*/
global class Customer360View {
    // for getting the picklist value Dynamically.
    @AuraEnabled
    public static Map<String, String> getPickListValue(String Object_Api_Name, String field_Api_Name){
        Map<String, String> optionMap = new Map<String, String>();
        if(Object_Api_Name !=null && Object_Api_Name !='' && field_Api_Name !=null && field_Api_Name !=''){
            try{
                Map<String,Schema.SObjectType> globaldesObj = Schema.getGlobalDescribe(); 
                Map<String, Schema.SObjectField> field_map = globaldesObj.get(Object_Api_Name.toLowerCase()).getDescribe().fields.getMap(); 
                List<Schema.PicklistEntry> picklistValues = field_map.get(field_Api_Name).getDescribe().getPickListValues();
                
                for(Schema.PicklistEntry pvObj : picklistValues) {
                    optionMap.put(pvObj.getValue(),pvObj.getLabel());
                }
                return optionMap;
            }catch(Exception ex){
                System.debug('Exception ::'+ ex.getMessage() +'Line Number ::'+ex.getLineNumber());    
            }
        }
        return optionMap;
    }
    @AuraEnabled
    public static Map<String,Object> createOrUpdateAccount(Account accObj){
        Map<String,Object> mapOfObject = new Map<String,Object>();
        Application__c app = new Application__c();
        Application_Document_Category__c parentAppDoc = new Application_Document_Category__c();
        Application_Document_Category__c PLDoc = new Application_Document_Category__c();
        Application_Document_Category__c Bankdoc = new Application_Document_Category__c();
        Application_Document_Category__c sanctionDoc  = new Application_Document_Category__c();
        Application_Document_Category__c SupportDoc   = new Application_Document_Category__c();
        List<Application_Document_Category__c> childAppDoc = new List<Application_Document_Category__c>();
        if(accObj !=null){
            try{
                system.debug('accObj'+accObj);
                List<User> listOfUser = [Select id,Name,Designation__c,Office_Code__c from User where Office_Code__c ='1857' AND Designation__c ='BR_MGR_MEDIUM'];
                if(accObj.TAN_Number__c !=null && accObj.TAN_Number__c !=''){
                    accObj.External_Id__c = accObj.Pan_Number__c +'@'+ accObj.TAN_Number__c;    
                }else{
                    accObj.External_Id__c = accObj.Pan_Number__c;
                }
                accObj.OwnerId = listOfUser[0].Id;
                CustomerRelatedDetails.isTriggerRun = false;
                upsert accObj External_Id__c;
                
                List<Application__c> listOfApp = [Select Id,Application_Stage__c,Customer__c,RecordType.DeveloperName from Application__c where Customer__c =: accObj.Id AND RecordType.DeveloperName ='SME_NEW_LOAN'];
                if(listOfApp !=null && listOfApp.size() > 0){
                    app =  listOfApp[0];      
                }else{
                    Id devRecordTypeId = Schema.SObjectType.Application__c.getRecordTypeInfosByName().get('SME NEW LOAN').getRecordTypeId(); 
                    //List<User> listOfUser = [Select id,Name,Designation__c,Office_Code__c from User where Office_Code__c ='1857'];
                    app.Customer__c = accObj.Id;
                    app.OwnerId = listOfUser[0].Id;
                    app.Application_Stage__c = 'New loans - Application created';
                    app.Sub_Stage__c = 'Application Created';//SME NEW LOAN
                    app.Type__c = 'NTB';
                    app.RecordTypeId =  devRecordTypeId;
                    
                    LoadBalance.isTriggerRun = false;
                    insert app;
                    
                    Application__c appObj = [Select id,Name from Application__c where id=:app.Id];
                    if(appObj !=null){
                        parentAppDoc.Application__c = appObj.Id;
                        //parentAppDoc.Applicant__c = app.Customer__c;
                        parentAppDoc.Name = 'SME_'+appObj.Name;
                        insert parentAppDoc;
                        
                        PLDoc.Name = 'P&L Document';
                        PLDoc.Parent_Application_Document_Category__c = parentAppDoc.Id;
                        childAppDoc.add(PLDoc);
                        
                        Bankdoc.Name = 'Bank Statement';
                        Bankdoc.Parent_Application_Document_Category__c = parentAppDoc.Id;
                        childAppDoc.add(Bankdoc);
                        
                        sanctionDoc.Name = 'Sanction Document';
                        sanctionDoc.Parent_Application_Document_Category__c = parentAppDoc.Id;
                        childAppDoc.add(sanctionDoc);
                        
                        SupportDoc.Name = 'Supporting Document';
                        SupportDoc.Parent_Application_Document_Category__c = parentAppDoc.Id;
                        childAppDoc.add(SupportDoc);
                        insert childAppDoc;    
                    }
                }
                mapOfObject.put('Account',accObj);
                mapOfObject.put('Application',app);
                return mapOfObject;
            }catch(Exception ex){
                System.debug('Exception ::'+ ex.getMessage() +'Line Number ::'+ex.getLineNumber()); 
            }
        }    
        return null;
    }
    @AuraEnabled
    public static Map<String,Object> createCollateralDetails(Application__c appObj, List<Facility__c> listOfFacility, List<Collateral__c>  listOfCollateral){
        try{
            Map<String,Object> mapOfObject = new Map<String,Object>();
            Id devRecordTypeId = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Parent').getRecordTypeId(); 
            Map<String,Lending_Product__c> mapOfProduct = new Map<String,Lending_Product__c>();
            List<Lending_Product__c> listOfLendingProduct = [select id,Lending_Product_Name__c,Existing_Rate_Commission__c,Los_Customer_Id__c,NTB_Facility_Category__c,Processing_fee_fresh__c,Existing_Margin__c from Lending_Product__c];
            if(listOfLendingProduct !=null && listOfLendingProduct.size() > 0){
                for(Lending_Product__c lendingProductObj : listOfLendingProduct){
                    if(lendingProductObj.NTB_Facility_Category__c !=null){
                        mapOfProduct.put(lendingProductObj.NTB_Facility_Category__c,lendingProductObj);
                    }
                }
            }
            for(Facility__c facObj : listOfFacility){
                facObj.Application__c = appObj.Id;
                if(facObj.NTB_Facility_Category__c !=null && mapOfProduct.containsKey(facObj.NTB_Facility_Category__c)){
                    facObj.Lending_Product__c  =  mapOfProduct.get(facObj.NTB_Facility_Category__c).id;
                    facObj.Existing_Rate__c     = mapOfProduct.get(facObj.NTB_Facility_Category__c).Existing_Rate_Commission__c;
                    facObj.Existing_Processing_Charge__c = mapOfProduct.get(facObj.NTB_Facility_Category__c).Processing_fee_fresh__c;
                    facObj.Approved_Margin__c = mapOfProduct.get(facObj.NTB_Facility_Category__c).Existing_Margin__c;
                    facObj.RecordTypeId = devRecordTypeId;
                }
            }
            upsert listOfFacility;
            
            UpdateFiledonApplicationHandler.isTrigger = false;
            upsert listOfCollateral;
            List<Application_Collateral__c> listOfAppColl = new List<Application_Collateral__c>();
            for(Collateral__c collObj	: listOfCollateral){
                Application_Collateral__c appCollObj = 	new Application_Collateral__c();
                appCollObj.Application__c = appObj.Id;
                appCollObj.Collateral__c = collObj.Id;
                //appCollObj.Facility__c = facObj.Id;
                appCollObj.External_Id__c = collObj.Id;
                listOfAppColl.add(appCollObj);
            }
            for(Facility__c facObj : listOfFacility){
                for(Application_Collateral__c appCollObj : listOfAppColl){
                    appCollObj.Facility__c = facObj.Id;
                    appCollObj.External_Id__c = appCollObj.External_Id__c + '@'+ facObj.Id;
                    if(facObj.NTB_Facility_Category__c == 'Overdraft (OD)' || facObj.NTB_Facility_Category__c == 'Secure Overdraft (SOD)'
                       || facObj.NTB_Facility_Category__c == 'Cash Credit (CC)'){
                           appCollObj.Security_Type__c = 'Primary Securities';    
                       }else if(facObj.NTB_Facility_Category__c == 'Letter of Credit (LC)' || facObj.NTB_Facility_Category__c == 'Bank Guarantee (BG)'){
                           appCollObj.Security_Type__c = 'Collateral Securities';    
                       }
                }                
            }
            upsert listOfAppColl External_Id__c;
            mapOfObject.put('Facility',listOfFacility);
            mapOfObject.put('Collateral',listOfCollateral);
            return mapOfObject;
        }catch(Exception ex){
            System.debug('Exception ::'+ ex.getMessage() +'Line Number ::'+ex.getLineNumber());    
        }
        return null;
    }
    @AuraEnabled
    public static Application__c submitApplication(Application__c appObj, List<Facility__c> listOfFacilities){
        if(appObj !=null && listOfFacilities !=null){
            try{
                //Set<Id> setOfIds = new Set<Id>();
                /*for(Facility__c facObj : listOfFacilities){
                    setOfIds.add(facObj.id);
                }*/
                Id devRecordTypeId = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Child').getRecordTypeId(); 
                /*if(setOfIds.size() > 0){
                    //List<Facility__c> listOfParentFacilities = [Select id,Lending_Product__c,Processing_fee_fresh__c,Existing_Margin__c,]
                }*/
                LoadBalance.isTriggerRun = false;
                appObj.Application_Stage__c = 'New loans - Application submitted';
                update appObj;
               	List<M68_Balance_Sheet_Analysis__c> listOfM68c = [Select Id,Name,Account__c from M68_Balance_Sheet_Analysis__c];
                if(listOfM68c !=null && listOfM68c.size() > 0){
                    for(M68_Balance_Sheet_Analysis__c m68cObj : listOfM68c) {
                        m68cObj.Account__c = appObj.Customer__c;
                    }
                    UPDATE listOfM68c;
                }
                TransUnion_Credit_Report__c transObj = [SELECT Id,Name,Account__c from TransUnion_Credit_Report__c limit 1];
                if(transObj !=null){
                    transObj.Account__c = appObj.Customer__c;
                    UPDATE transObj;
                    
                    RankVec__c	rankVecObj = [SELECT Id,Rank_Value__c,Tu_Credit_Report__c from RankVec__c where Tu_Credit_Report__c=: transObj.Id limit 1];
                    if(rankVecObj !=null && rankVecObj.Rank_Value__c !=null){
                        Account accObj = new Account(Id = appObj.Customer__c,Commercial_Rank__c = rankVecObj.Rank_Value__c);
                        UPDATE accObj;
                    }
                }
                Application__c appObjReturn = [Select Id,Name from Application__c where Id=:appObj.Id];	                
                List<Facility__c> listOfChildFacilities = new List<Facility__c>();
                for(Facility__c facObj : listOfFacilities){
                	Facility__c facChildObj = new Facility__c();
                    facChildObj.Lending_Product__c = facObj.Lending_Product__c;
                    facChildObj.RecordTypeId = devRecordTypeId;
                    facChildObj.Facility__c = facObj.id;
                    facChildObj.Higher_Authority_Order__c = 1;
                    facChildObj.Role__c = 'BR_MGR_MEDIUM';
                    listOfChildFacilities.add(facChildObj);
                }
                insert listOfChildFacilities;
                //Task create for BM.
                createBMTask(appObj.id, 'BM-Recommendation', 'BM-Recommendation');
                
                return appObjReturn;
            }catch(Exception ex){
                System.debug('Exception ::'+ ex.getMessage() + ' :: Line Number'+ ex.getLineNumber());    
            }
        }
        return null;
    }
    @AuraEnabled
    public static Map<String,Object> createORUpdateParties(List<Account> listOfPersonAccount, Account  businnesAccObj , Application__c appObj){
        if(listOfPersonAccount !=null && listOfPersonAccount.size() > 0 && businnesAccObj !=null && appObj !=null){
            try{
                Map<String,Object> mapOfObject = new Map<String,Object>();
                Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(); 
                for(Account accPobj : listOfPersonAccount){
                    accPobj.RecordTypeId = devRecordTypeId;
                }
                System.debug('listOfPersonAccount @@@'+listOfPersonAccount);
                CustomerRelatedDetails.isTriggerRun = false;
                upsert listOfPersonAccount;
                
                List<Party__c> listOfParties = new List<Party__c>();
                for(Account accPobj : listOfPersonAccount){
                    Party__c patiesObj = new Party__c();
                    patiesObj.Application__c = appObj.id;
                    patiesObj.Customer__c = businnesAccObj.id;
                    patiesObj.Party_Account__c = accPobj.id;
                    patiesObj.genesis_Party_Type__c = accPobj.Party_Type__c;
                    patiesObj.CIBIL_Scores__c = 830;
                    listOfParties.add(patiesObj);
                }
                upsert listOfParties;
                System.debug('listOfParties++++'+listOfParties);
                mapOfObject.put('PartyAccount',listOfPersonAccount);
                mapOfObject.put('Party',listOfParties);
                return mapOfObject;
            }catch(Exception ex){
                System.debug('Exception ::'+ ex.getMessage() + 'Line Number ::'+ ex.getLineNumber());
                System.debug('Exception::Stack ::'+ex.getStackTraceString());
            }
        }
        return null;    
    }
    public static void createBMTask(String appId, String taskType, String taskSubject){
        try{
            Application__c  appObj =  [Select id,OwnerId from Application__c where Id=:appId];
            Task taskObj = new Task(WhatId=appObj.Id,Subject=taskSubject,OwnerId=appObj.OwnerId,ActivityDate=System.today()+2,Type=taskType);
            insert taskObj;
            System.debug('Task Subject ::'+taskObj);
        }catch(Exception ex){
            System.debug('Exception ::'+ex.getMessage() + 'Line Number ::'+ ex.getLineNumber());
        }
    }
    @AuraEnabled
    public static List<Application_Document_Category__c> getAppDocdetails(Application__C App){
        Set<Id> parentId = new Set<Id>();
        List<Application_Document_Category__c> appdoc = [Select Id,Name,Application__c From Application_Document_Category__c where Application__c =: App.Id AND Name LIKE 'SME_%' LIMIT 1];
        System.debug('appdoc----'+appdoc);
        for(Application_Document_Category__c ids : appdoc){
            parentId.add(ids.Id);
        }
        List<Application_Document_Category__c> childDoc1 = [Select Id,Name,Parent_Application_Document_Category__c From Application_Document_Category__c where Parent_Application_Document_Category__c IN :parentId];
        return childDoc1;
        
    }
    /*public static List<M68_Balance_Sheet_Analysis__c> getAllM68cRecord(){
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(M68_Balance_Sheet_Analysis__c).getDescribe().fields.getMap();
        
        String commaSepratedFields = '';
        for(String fieldName : fieldMap.keyset()){
            if(commaSepratedFields == null || commaSepratedFields == ''){
                commaSepratedFields = fieldName;
            }else{
                commaSepratedFields = commaSepratedFields + ', ' + fieldName;
            }
        }
        
        query = 'select ' + commaSepratedFields + ' from ' + SobjectApiName + ' Where ';
        
        accList = Database.query(query);    
    }*/
}