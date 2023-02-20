trigger OpportunityBestPracticeTrigger on Opportunity (after update) {

    List<Opportunity> oppsToUpdate = new List<Opportunity>();
    for (Opportunity opp : Trigger.new){
        if (opp.Big_Deal__c){
            oppsToUpdate.add(new Opportunity(Id = opp.Id, TrackingNumber__c = '123'));
        }
    }

    update oppsToUpdate;
}


