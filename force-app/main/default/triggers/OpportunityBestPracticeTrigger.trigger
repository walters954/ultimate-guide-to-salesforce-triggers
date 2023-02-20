trigger OpportunityBestPracticeTrigger on Opportunity (after update) {

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
    

    update oppsToUpdate;
}