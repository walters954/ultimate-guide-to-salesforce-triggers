trigger OpportunityBestPracticeTrigger on Opportunity (before update) {

    Set<Id> accountIdsFromOpp = new Set<Id>();
    for (Opportunity oppNew : Trigger.new){
        if (oppNew.AccountId != null) {
            accountIdsFromOpp.add(oppNew.AccountId);
        }
    }
    Map<Id,Account> accountMap = new Map<Id,Account>([SELECT Id, NumberOfEmployees  FROM Account WHERE Id IN :accountIdsFromOpp]);

    for (Opportunity oppNew : Trigger.new){
        System.debug('New Opp: ' + oppNew.Id + ' Amount ' + oppNew.Amount);
        Opportunity oppOld = Trigger.oldMap.get(oppNew.Id);
        System.debug('old Opp: ' + oppOld.Id + ' Amount ' + oppOld.Amount);
        if (oppNew.Amount != oppOld.Amount){
            System.debug('Found matching old and new opps');
            Account accountFromOpp = accountMap.get(oppNew.AccountId);
            oppNew.Cost_Per_Employee__c = costPerEmployee(oppNew, accountFromOpp);
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


