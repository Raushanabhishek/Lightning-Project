/*
 	Created By ET Marlabs 15-07-2019
*/
public class M68c_Dashboard {
    public static List<M68_Balance_Sheet_Analysis__c> getM68cDetails(String appId){
        if(appId !=null){
            Application__c app = [Select Id,Name,Customer__c from Application__c where Id =:appId];
            List<M68_Balance_Sheet_Analysis__c> listOfM68c = [SELECT id,Name,Fiscal_Year__c,Financial_type__c,Total_Outside_Liabilities__c,Total_Liabilities__c,
                                                              Data_Source__c,Total_Assets__c,Total_Current_Liabilities__c,Total_Current_Assets__c,Total_Term_Liabilities__c,
                                                              Total_Fixed_Assets__c,Total_Net_Worth__c,Total_Non_Current_Assets__c,Total_Intangible_Assets__c,TOL_TNW_Ratio__c,
                                                              TOL_TNW_Ratio_QE__c,Current_Ratio__c,Net_Profit_Margin__c,Debtors_Velocity_days__c,Creditors_Velocity_days__c,
                                                              Tangible_Net_Worth__c,Net_Working_Capital__c,Cash_profit__c,Stock_Turnover_Ratio__c,Account__c from M68_Balance_Sheet_Analysis__c where Account__c =: app.Customer__c];
            if(listOfM68c !=null && listOfM68c.size() > 0){
                return listOfM68c;
            }
            
        }
      return null;  
    }
}