trigger OpportunityBestPracticeTrigger on Opportunity (after update) {

    for (Opportunity oppNew : Trigger.new){
        System.debug('New Opp: ' + oppNew.Name);
        for (Opportunity oppOld : Trigger.old){
            System.debug('Old Opp: ' + oppOld.Name);
            if (oppNew.Amount != oppOld.Amount && oppNew.Id == oppOld.Id) { //if amount has changed and check if same opportunity
                Account accountFromOpp = [SELECT Id, NumberOfEmployees FROM Account WHERE Id = :oppNew.AccountId];
                oppNew.Cost_Per_Employee__c = costPerEmployee(oppNew,accountFromOpp);
            }
        }
    }

    public static Decimal costPerEmployee(Opportunity opp, Account acc){
        Decimal pricePerEmployee = 0;
        if (opp.Amount != null && acc.NumberOfEmployees != null){
            pricePerEmployee = opp.Amount / acc.NumberOfEmployees;
        }
        return pricePerEmployee;
    }
}


