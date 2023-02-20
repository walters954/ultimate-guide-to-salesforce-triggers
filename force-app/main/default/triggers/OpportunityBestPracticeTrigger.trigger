trigger OpportunityBestPracticeTrigger on Opportunity (before update) {

    for (Opportunity oppNew : Trigger.new){
        System.debug('New Opp: ' + oppNew.Id + ' Amount ' + oppNew.Amount);
        for (Opportunity oppOld : Trigger.old){
            System.debug('old Opp: ' + oppOld.Id + ' Amount ' + oppOld.Amount);
            if (oppNew.Amount != oppOld.Amount && oppNew.Id == oppOld.Id){
                System.debug('Found matching old and new opps');
                Account accountFromOpp = [SELECT Id, NumberOfEmployees  FROM Account WHERE Id = :oppNew.AccountId];
                oppNew.Cost_Per_Employee__c = costPerEmployee(oppNew, accountFromOpp);
            }
        }
    }

    public static Decimal costPerEmployee(Opportunity opp, Account acc){
        Decimal costPerEmployee = 0;
        if (opp.Amount != null && acc.NumberOfEmployees != null){
            costPerEmployee = opp.Amount / acc.NumberOfEmployees;
        }
        System.debug('Cost per employee: ' + costPerEmployee);
        return costPerEmployee;
    }
}


