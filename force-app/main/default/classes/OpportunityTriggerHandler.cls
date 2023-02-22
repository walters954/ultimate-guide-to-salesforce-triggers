public with sharing class OpportunityTriggerHandler extends TriggerHandler{

    private List<Opportunity> newOppList;
    private Map<Id,Opportunity> newOppMap;
    private List<Opportunity> oldOppList;
    private Map<Id,Opportunity> oldOppMap;

    public OpportunityTriggerHandler() {
        System.debug('Hello World!');
        System.debug('OpportunityTrigger:::' + Trigger.operationType);
        this.newOppList = (List<Opportunity>)Trigger.new;
        this.newOppMap = (Map<Id,Opportunity>)Trigger.newMap;
        this.oldOppList = (List<Opportunity>)Trigger.old;
        this.oldOppMap = (Map<Id,Opportunity>)Trigger.oldMap;
        this.setMaxLoopCount(1);
    }


    public override void beforeInsert(){
        System.debug('OpportunityTrigger Before Insert');
        for (Opportunity opp : this.newOppList){
            if (opp.Amount == null){
                opp.Amount = 1000;
            } else if (opp.Amount < 1000){
                opp.addError('You need to have an amount greater than 1000');
            }
        }
    }

    public override void beforeUpdate(){
            System.debug('OpportunityTrigger Before Update');
            System.debug(this.oldOppList);
            for (Opportunity opp : this.newOppList){
                System.debug('New Opp Stage ' + opp.StageName);
                for (Opportunity oldOpp : this.oldOppList){
                    System.debug('oldOpp Opp Stage ' + oldOpp.StageName);
                    if (opp.StageName != oldOpp.StageName && opp.Id == oldOpp.Id){
                        opp.Description += '\n Stage Change:' + opp.StageName + ':' + DateTime.now().format();
                    }
                }
        }
    }

    public override void beforeDelete(){
        for (Opportunity oldOpp : this.oldOppList){
                if (oldOpp.IsClosed){
                    oldOpp.addError('Cannot delete closed won opportunity');
                }
            }
    }

    public override void afterInsert(){
        List<OpportunityLineItem> oppLineItems = new List<OpportunityLineItem>();
        for (Opportunity opp : this.newOppList){
            System.debug('OpportunityTrigger After Insert');
            oppLineItems.add(new OpportunityLineItem(
                OpportunityId = opp.Id,
                Quantity = 1,
                UnitPrice = 100,
                Product2Id = '01t4x0000020maiAAA')); //hard coding id
                
        }
        insert oppLineItems; 
    }

    public override void afterUpdate(){
        System.debug('OpportunityTrigger After Update');
    }
    public override void afterDelete(){
        OpportunityTriggerHelper.notifyOwnersOpportunityDeleted(this.oldOppList);
    }
    public override void afterUndelete(){
        OpportunityTriggerHelper.assignAccountToOpportunity(this.newOppMap);
    }
    
}