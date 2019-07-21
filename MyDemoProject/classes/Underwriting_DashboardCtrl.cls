global class Underwriting_DashboardCtrl {
    @AuraEnabled
    public static Map<String,Object> getApplicationDetails(String appId){
        return null;    
    }
    @AuraEnabled
    public static Map<String,Object> getFacilitiesDetails(String appId){
        if(appId !=null && appId !=''){
            try{
                Map<String,Object> mapOfObject = new Map<String,Object>();
                Application__c appObj = [SELECT id,Security_Coverage__c,Name,Customer__c,Customer__r.Name,Customer__r.Constitution__c,Customer__r.Industry,Customer__r.Branch_Code__c,Customer__r.Commercial_Rank__c from Application__c where Id=:appId];
                List<Facility__c> listOfFacilitiesDetails = prepareFacilityDetails(appId);
                System.debug('listOfFacilitiesDetails @@@@'+listOfFacilitiesDetails);
                System.debug('appObj @@@@'+appObj);
                mapOfObject.put('Application',appObj);
                mapOfObject.put('Facility',listOfFacilitiesDetails);
                return mapOfObject;
            }catch(Exception ex){
                System.debug('Exception ::'+ ex.getMessage() + 'Line Number ::'+ ex.getLineNumber());    
            }
        }
        return null;
    }
    public static List<Facility__c> prepareFacilityDetails(String appId){
        String query = 'select Id,Requested_Amount__c,Application__c,Tenure__c,Holiday_Period__c,App_Facility_Type__c,Recommended_Holidays__c,Frequency_Interest__c,EMI_NEMI__c,Frequency_Principal__c,Is_Referred_Back_Enabled__c,Is_Facility_App_Type_Upadte__c,Recommended_Rate__c,Recommended_Limit__c,Recommended_Tenure__c,Faciliity_Type__c,Renewal_Processing_Charge__c,Recommended_Processing_Charge__c,Name,NTB_Facility_Type__c,Is_Save_Operation_Done__c,New_Limit_Amount__c,Purpose_of_Shifting__c,Application__r.Customer__c,Lending_Product__c,Lending_Product__r.Lending_Product_Name__c,Lending_Product__r.Facility_Category__c,BRE_Rate__c,BRE_Margin_Receivables__c,BRE_Margin_Stock_Manufacturing__c,BRE_Margin_Stock_Trading__c, Existing_Limit__c,Existing_Rate__c,Type__c,Approved_Margin__c,BRE_Spread__c,Lending_Product__r.Processing_fee_renwal__c,Lending_Product__r.Schematic_Loan__c,Existing_Processing_Charge__c,BRE_Processing_Charge__c,Existing_Spread__c,Margin__c,Margin_Receivables__c,Margin_Stock_Manufacturing__c,Margin_Stock_Trading__c,Application__r.OwnerId,Application__r.Customer__r.Industry,Existing_Margin_Receivables__c,Existing_Margin_Stock_Manufacturing__c,Existing_Margin_Stock_Trading__c,MCLR_Rate__c,(Select id,BRE_Margin__c,Recommended_Holidays__c,Recommended_Tenure__c,Frequency_Interest__c,Facility__c,Renewal_Processing_Charge__c,Frequency_Principal__c,EMI_NEMI__c,Is_Referred_Back_Enabled__c,Recommended_Days__c,Deviation_Approver__c,Highest_Authority__c,Recommended_Rate__c,Recommended_Limit__c,Role__c,Higher_Authority_Order__c,Existing_Processing_Charge__c,Read_Only_User__c,Recommended_Processing_Charge__c,Margin__c,Margin_Receivables__c,Margin_Stock_Manufacturing__c,Margin_Stock_Trading__c from Facilities__r), RecordType.DeveloperName ,Application__r.RecordType.DeveloperName FROM Facility__c where Application__c=:appId AND RecordType.DeveloperName =\'Parent\'';
        List<Facility__c> facList    = Database.query(query);
        return facList;
    }
    public static Double getAuthorityHierarchy(Decimal overallExposure){
        List<Authority_Hierarchy_Level__mdt> listOfAuthHierachy = [Select id,DeveloperName,Authority_Level__c,EAE_Limit__c from Authority_Hierarchy_Level__mdt];
        Double higherAuthorityHierarchyLevel = 0;
        for(Authority_Hierarchy_Level__mdt authHierarchyObj : listOfAuthHierachy){
            if(overallExposure > 0 && overallExposure <= authHierarchyObj.EAE_Limit__c){
                higherAuthorityHierarchyLevel = authHierarchyObj.Authority_Level__c;	    
            }    
        }
        return higherAuthorityHierarchyLevel;
    }
    public static Double getProductSanctAuthority(String prodId, Decimal overallExposure, Decimal securityCoverage){
        List<Product_Sanction_Authority__c> listOfProdSanct = [Select id,Name,Product__c,Limit_Start_Range__c,Limit_End_Range__c,Security_Coverage_Start_Range__c,Security_Coverage_End_Range__c,Order__c from Product_Sanction_Authority__c where Product__c =:prodId];
        Double higherProdSanctAuth = 0;
        if(listOfProdSanct !=null && listOfProdSanct.size() > 0){
            for(Product_Sanction_Authority__c prodSancAuthObj : listOfProdSanct){
                if(prodSancAuthObj.Limit_Start_Range__c < overallExposure && prodSancAuthObj.Limit_End_Range__c >= overallExposure && prodSancAuthObj.Security_Coverage_End_Range__c >= securityCoverage && prodSancAuthObj.Limit_Start_Range__c < securityCoverage){
                    higherProdSanctAuth =   prodSancAuthObj.Order__c;   
                }
            }    
        }
        return higherProdSanctAuth;
    }
    public static Decimal calculateOverallExposure(String appId){
        Set<Id> setOfIds = new Set<Id>();
        Decimal sum =0; 		
        List<Facility__c> listOfParentFac = [Select Id,Application__c,Name,Requested_Amount__c,Lending_Product__c,(Select id,BRE_Margin__c,Lending_Product__c,Recommended_Holidays__c,Recommended_Tenure__c,Frequency_Interest__c,Facility__c,Renewal_Processing_Charge__c,Frequency_Principal__c,EMI_NEMI__c,Is_Referred_Back_Enabled__c,Recommended_Days__c,Deviation_Approver__c,Highest_Authority__c,Recommended_Rate__c,Recommended_Limit__c,Role__c,Higher_Authority_Order__c,Existing_Processing_Charge__c,Read_Only_User__c,Recommended_Processing_Charge__c,Margin__c,Margin_Receivables__c,Margin_Stock_Manufacturing__c,Margin_Stock_Trading__c from Facilities__r) from Facility__c where Application__c =:appId];
        if(listOfParentFac !=null && listOfParentFac.size() > 0){
            for(Facility__c faciPObj : listOfParentFac){
                for(Facility__c faciCObj : faciPObj.Facilities__r){
                    if(faciCObj !=null && faciCObj.Recommended_Limit__c !=null){
                        sum =+faciCObj.Recommended_Limit__c;
                    }	
                }      
            }
        }
        return sum;
    }
    @AuraEnabled
    public static String saveRecommendation(List<Facility__c> listOfParent,List<Facility__c> facilityList){ //List<Facility__c> listOfParent, List<Facility__c> listOfChildfacilities
        System.debug('facilityList @@@@'+facilityList);
        Boolean isBMRole = true;
        Boolean isHighestAuth = false;
        Map<String,Object> mapOfReturn = new Map<String,Object>();
        if(listOfParent !=null && facilityList !=null){
            try{
                UPDATE facilityList;
                for(Facility__c facObj : facilityList){
                    if(facObj.Role__c !='BR_MGR_MEDIUM'){
                        isBMRole = false;
                    }
                    if(facObj.Highest_Authority__c){
                        isHighestAuth = true;    
                    }
                    
                }
                Double higherProdSancAuth = 0;
                Double higherAuthority = 0;
                Double higherAuthCalculated = 0; 
                Decimal overallExposure = calculateOverallExposure(listOfParent[0].Application__c);
                for(Facility__c faciCObj : facilityList){
                    if(faciCObj.Recommended_Limit__c !=null && faciCObj.Recommended_Rate__c !=null){
                        SecurityCoverageCalculation.recLimitByFacId.put(faciCObj.id,new SecurityCoverageCalculation.facWrap(faciCObj.Recommended_Limit__c,faciCObj.Recommended_Rate__c));
                    }    
                }
                SecurityCoverageCalculation.Coverage_Map coverageMapObj = SecurityCoverageCalculation.calculateSecurityCoverage(listOfParent[0].Application__c);
                 Application__c appObject = new Application__c();
                 System.debug('coverageMapObj @@@'+coverageMapObj);
                if(coverageMapObj !=null){
                   	 
                     appObject.Id = listOfParent[0].Application__c;
                     appObject.Security_Coverage__c = coverageMapObj.secCoverage.setScale(2);
                    System.debug('coverageMapObj222 @@@'+coverageMapObj);
                    If(coverageMapObj.is_Sufficient !=null && coverageMapObj.is_Sufficient =='SUFFICIENT'){
                        higherAuthority = getAuthorityHierarchy(overallExposure);
                        Double higherProdAuth = 0;
                        for(Facility__c facPObjec : listOfParent){
                            //Inside for loop querying record...
                            higherProdAuth = getProductSanctAuthority(facPObjec.Lending_Product__c,overallExposure,coverageMapObj.secCoverage);
                            if(higherProdSancAuth < higherProdAuth){
                                higherProdSancAuth = higherProdAuth;
                            }
                        }
                        if(higherProdSancAuth >= higherAuthority){
                            higherAuthCalculated = higherProdSancAuth;    
                        }else if(higherAuthority > higherProdSancAuth){
                            higherAuthCalculated = higherAuthority;
                        }    
                        if(higherAuthCalculated > 1){
                            Id devRecordTypeId = Schema.SObjectType.Facility__c.getRecordTypeInfosByName().get('Child').getRecordTypeId(); 
                            List<Facility__c> listOfChildFacility = new List<Facility__c>();
                            Map<Double,String> mapOfAuthorityHierarchy = new Map<Double,String>();
                            List<Authority_Hierarchy_Level__mdt> listOfAuthHierachy = [Select id,DeveloperName,Authority_Level__c,EAE_Limit__c from Authority_Hierarchy_Level__mdt];
                            for(Authority_Hierarchy_Level__mdt authHieraObj : listOfAuthHierachy){
                                mapOfAuthorityHierarchy.put(authHieraObj.Authority_Level__c,authHieraObj.DeveloperName);
                            }
                            if(mapOfAuthorityHierarchy.containsKey(higherAuthCalculated) && higherAuthCalculated > 1 && isBMRole && !isHighestAuth){
                                for(Facility__c facPObjec : listOfParent){
                                    Facility__c facChildObj = new Facility__c();
                                    
                                    facChildObj.Lending_Product__c = facPObjec.Lending_Product__c;
                                    facChildObj.RecordTypeId = devRecordTypeId;
                                    facChildObj.Facility__c = facPObjec.id;
                                    facChildObj.Higher_Authority_Order__c = higherAuthCalculated;
                                    facChildObj.Role__c = mapOfAuthorityHierarchy.get(higherAuthCalculated);
                                    facChildObj.Highest_Authority__c= true;
                                    listOfChildFacility.add(facChildObj);	                                    
                                }
                                insert listOfChildFacility;//
                                createHigherAuthTask(listOfParent[0].Application__c,'Final authority-Recommendation','Final authority-Recommendation',mapOfAuthorityHierarchy.get(higherAuthCalculated));
                                closeExistingBMTask(listOfParent[0].Application__c,'BM-Recommendation');
                            }else if(mapOfAuthorityHierarchy.containsKey(higherAuthCalculated) && higherAuthCalculated == 1 && isBMRole && !isHighestAuth){
                                for(Facility__c faciCObj : facilityList){
                                    faciCObj.Highest_Authority__c = true;      
                                }
                                UPDATE facilityList;
                            }
                            if(isHighestAuth){
                                appObject.Application_Stage__c = 'New Loan - Final sanction offered';
                                closeExistingBMTask(listOfParent[0].Application__c,'Final authority-Recommendation');
                            }
                            LoadBalance.isTriggerRun = false;
                            UPDATE appObject;
                            System.debug('appObject@@@@'+appObject);
                            return 'SUFFICIENT'; //Security_Coverage__c
                        }
                    }else if(coverageMapObj.is_Sufficient !=null && coverageMapObj.is_Sufficient =='INSUFFICIENT'){
                        LoadBalance.isTriggerRun = false;
                        UPDATE appObject;
                        System.debug('appObject@@@@'+appObject);
                        return 'INSUFFICIENT';
                    }
                }
            }catch(Exception ex){
                System.debug('Exception ::'+ ex.getMessage() + 'Line Number ::'+ex.getLineNumber());    
            }
        }
        return null;
    }
    public static void closeExistingBMTask(string appId,String taskType) {
        
        try{
            List<Application__c> appInfo         = new List<Application__c>();
            appInfo                                        = [Select id,Name,OwnerId from Application__c where Id=:appId];
            List<Task> getExistingTaskList= new List<Task>();
            
            getExistingTaskList = [SELECT Id,OwnerId,Status,Type,WhatId FROM Task where WhatId=:appId And Type=:taskType And Status = 'Not Started'];
            
            if(! getExistingTaskList.isEmpty()){
                getExistingTaskList[0].Status = 'Completed';
            }
            if(!getExistingTaskList.isEmpty())
                update getExistingTaskList;
        }catch(Exception ex){
            System.debug('Exception'+ ex.getStackTraceString()+'LINE NUMBER '+ex.getLineNumber() + 'Message '+ ex.getMessage());
            
        }
    }
    public static void createHigherAuthTask(String appId, String taskType, String taskSubject, String role){
        try{
            
            List<User> listOfUser = [SELECT Id,Designation__c FROM User WHERE Designation__c =:role];
            Task taskObj = new Task(WhatId=appId,Subject=taskSubject,OwnerId=listOfUser[0].Id,ActivityDate=System.today()+2,Type=taskType);
            insert taskObj;
            System.debug('Task Subject ::'+taskObj);
        }catch(Exception ex){
            System.debug('Exception ::'+ex.getMessage() + 'Line Number ::'+ ex.getLineNumber());
        }
    }
    public class Coverage_Map {
        public Decimal secCoverage;
        public String is_Sufficient;
    }
}