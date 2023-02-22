public with sharing class OpportunityTriggerHandler extends TriggerHandler{

    private List<Opportunity> newOppList;
    private Map<Id,Opportunity> newOppMap;
    private List<Opportunity> oldOppList;
    private Map<Id,Opportunity> oldOppMap;

    public static Boolean hasRun = false;

    public OpportunityTriggerHandler() {
        System.debug('Hello World!');
        System.debug('OpportunityTrigger:::' + Trigger.operationType);
        this.newOppList = (List<Opportunity>)Trigger.new;
        this.newOppMap = (Map<Id,Opportunity>)Trigger.newMap;
        this.oldOppList = (List<Opportunity>)Trigger.old;
        this.oldOppMap = (Map<Id,Opportunity>)Trigger.oldMap;
        Boolean stopTrigger = Trigger_Setting__mdt.getInstance('OpportunityBestPracticeTrigger')?.Disable_Trigger__c;
        
        if (stopTrigger == true || hasRun == true){        
            TriggerHandler.bypass('OpportunityTriggerHandler');
        }

        hasRun = true;

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
            Set<Id> accountIdsFromOpp = new Set<Id>();
            for (Opportunity oppNew : this.newOppList){
                if (oppNew.AccountId != null) {
                    accountIdsFromOpp.add(oppNew.AccountId);
                }
            }

            Map<Id,Account> accountMap = new Map<Id,Account>([SELECT Id, NumberOfEmployees  FROM Account WHERE Id IN :accountIdsFromOpp]);

            for (Opportunity opp : this.newOppList){
                System.debug('New Opp Stage ' + opp.StageName);
                Opportunity oldOpp = this.oldOppMap.get(opp.Id);
                if (opp.StageName != oldOpp.StageName){
                    opp.Description += '\n Stage Change:' + opp.StageName + ':' + DateTime.now().format();
                }
                if (opp.Amount != oldOpp.Amount){
                    System.debug('Found matching old and new opps');
                    Account accountFromOpp = accountMap.get(opp.AccountId);
                    opp.Cost_Per_Employee__c = OpportunityTriggerHelper.costPerEmployee(opp, accountFromOpp);
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
        List<Product2> products = [SELECT Id FROM Product2];
        for (Opportunity opp : this.newOppList){
            System.debug('OpportunityTrigger After Insert');
            oppLineItems.add(new OpportunityLineItem(
                OpportunityId = opp.Id,
                Quantity = 1,
                UnitPrice = 100,
                Product2Id = products[Integer.valueOf(Math.random() * products.size())].Id)); //hard coding id
                
        }
        insert oppLineItems; 
    }

    public override void afterUpdate(){
        System.debug('OpportunityTrigger After Update');
        List<Opportunity> oppsToUpdate = new List<Opportunity>();
        for (Opportunity opp : this.newOppList){
            if (opp.Big_Deal__c){
                oppsToUpdate.add(new Opportunity(Id = opp.Id, TrackingNumber__c = 'PRIORITY'));
            }
        }

        update oppsToUpdate;
        StarWarsCallout.makeGetCalloutFuture();
    }
    public override void afterDelete(){
        OpportunityTriggerHelper.notifyOwnersOpportunityDeleted(this.oldOppList);
    }
    public override void afterUndelete(){
        OpportunityTriggerHelper.assignAccountToOpportunity(this.newOppMap);
    }
    
}