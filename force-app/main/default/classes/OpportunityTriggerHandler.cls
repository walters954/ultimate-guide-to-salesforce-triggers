public with sharing class OpportunityTriggerHandler extends TriggerHandler{

    private List<Opportunity> newOppList;
    private Map<Id,Opportunity> newOppMap;

    public OpportunityTriggerHandler() {
        System.debug('Hello World!');
        System.debug('OpportunityTrigger:::' + Trigger.operationType);
        this.newOppList = (List<Opportunity>)Trigger.new;
        this.newOppMap = (Map<Id,Opportunity>)Trigger.newMap;

        this.setMaxLoopCount(2);
    }


    public override void beforeInsert(){
        System.debug('OpportunityTrigger Before Insert');
        TriggerHandler.bypass('AccountTriggerHandler');
        for (Opportunity opp : this.newOppList){
            if (opp.Amount == null){
                opp.Amount = 1000;
            } else if (opp.Amount < 1000){
                opp.addError('You need to have an amount greater than 1000');
            }
        }

        TriggerHandler.clearBypass('AccountTriggerHandler');
    }
    
}