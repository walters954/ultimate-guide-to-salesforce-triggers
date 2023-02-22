trigger OpportunityBestPracticeTrigger on Opportunity (before update, after update) {
    if (Trigger.isBefore){
        //bulkification
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

    }
    if (Trigger.isAfter){
        //recursion
        Boolean stopTrigger = Trigger_Setting__mdt.getInstance('OpportunityBestPracticeTrigger')?.Disable_Trigger__c;
        Boolean stopTriggerHelper = OpportunityTriggerHelper.hasRun; //boolean
        List<Opportunity> oppsToUpdate = new List<Opportunity>();
        if (stopTrigger == false && stopTriggerHelper == false){        
            OpportunityTriggerHelper.hasRun = true;
            for (Opportunity opp : Trigger.new){
                if (opp.Big_Deal__c){
                    oppsToUpdate.add(new Opportunity(Id = opp.Id, TrackingNumber__c = 'PRIORITY'));
                }
            }
        }
        //callotus
        StarWarsCallout.makeGetCalloutFuture();
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