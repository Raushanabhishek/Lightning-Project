public class ApplicationDetails {
    @AuraEnabled
    public Static List<Application__c> getApplicationDetails(Id applicationId){
        List<Application__c> app = [Select Id,Name,Application_Stage__c,Branch_Name__c,CreatedById,Applicant_Name__c, RecordType.Name,Sub_Stage__c,Customer__r.Name,Customer__c,Customer__r.Branch_Code__c,Type__c
                                    From Application__c Where Id =:applicationId];
        return app;
    }
   @AuraEnabled
    public Static List<Party__C> getPartyDetails(Id applicationId){
        List<Party__C> party = [Select Id,Name,Customer__c,Date_of_Birth__c,CIBIL_Scores__c,Active__c,Party_Account__c,genesis_Party_Type__c,Party_Account__r.Name,Customer__r.Name
                                    From Party__C Where Application__c =: applicationId ];
        return party;
    }
    
    @AuraEnabled
    public Static List<Facility__c> getFacilityDetails(Id applicationId){
        List<Facility__c> facility = [Select Id,Name,Account_Number__c,Final_Authority_Name__c,Recommended_Limit__c,Requested_Amount__c,Purpose_of_Loan__c,NTB_Facility_Category__c
                                    From Facility__c Where Application__c =: applicationId ];
        return facility;
    }
    @AuraEnabled
    public Static List<Application_Collateral__c> getCollateralDetails(Id applicationId){
        List<Application_Collateral__c> collateral = [Select Id,Name,Facility__r.Name,Security_Type__c,Collateral__r.Name,Facility__c
                                    From Application_Collateral__c Where Application__c =: applicationId ];
        return collateral;
    }
    @AuraEnabled
    public Static List<Task> getTaskDetails(Id applicationId){
        
        List<Task> tsk = [Select Subject,Status,Type,ActivityDate
                                    From Task Where whatId =: applicationId ];
        return tsk;
    }
    @AuraEnabled
    public static List<M68_Balance_Sheet_Analysis__c> getM68cDetails(String appId){
        if(appId !=null){
            Application__c app = [Select Id,Name,Customer__c from Application__c where Id =:appId];
            List<M68_Balance_Sheet_Analysis__c> listOfM68c = [SELECT id,Name,Fiscal_Year__c,Financial_type__c,Total_Outside_Liabilities__c,Total_Liabilities__c,
                                                              Data_Source__c,Total_Assets__c,Total_Current_Liabilities__c,Total_Current_Assets__c,Total_Term_Liabilities__c,
                                                              Total_Fixed_Assets__c,Total_Net_Worth__c,Total_Non_Current_Assets__c,Total_Intangible_Assets__c,TOL_TNW_Ratio__c,
                                                              TOL_TNW_Ratio_QE__c,Current_Ratio__c,Net_Profit_Margin__c,Debtors_Velocity_days__c,Creditors_Velocity_days__c,
                                                              Tangible_Net_Worth__c,Net_Working_Capital__c,Cash_profit__c,Stock_Turnover_Ratio__c,Account__c,Account__r.Name from M68_Balance_Sheet_Analysis__c where Account__c =: app.Customer__c];
            if(listOfM68c !=null && listOfM68c.size() > 0){
                return listOfM68c;
            }
            
        }
      return null;  
    }
}