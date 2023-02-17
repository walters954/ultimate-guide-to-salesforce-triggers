trigger OpportunityTrigger on Opportunity (before insert, after insert) {
    System.debug('OpportunityTrigger:::' + Trigger.operationType);
    System.debug(Trigger.new);
    System.debug(Trigger.new.size());
    
    
    if (Trigger.isBefore){
        for (Opportunity opp : Trigger.new){
            if (opp.Amount == null){
                opp.Amount = 1000;
            } else if (opp.Amount < 1000){
                opp.addError('You need to have an amount greater than 1000');
            }
        }
    }

    List<OpportunityLineItem> oppLineItems = new List<OpportunityLineItem>();
    if (Trigger.isAfter){
        if (Trigger.isInsert){
            for (Opportunity opp : Trigger.new){
                System.debug('OpportunityTrigger After Insert');
                System.debug(opp);
                // opp.Name = opp.Name + 'after';
                oppLineItems.add(new OpportunityLineItem(
                    OpportunityId = opp.Id,
                    Quantity = 1,
                    UnitPrice = 100,
                    Product2Id = '01t4x0000020maiAAA'));
                
            }
            insert oppLineItems;            
        }
    }
}