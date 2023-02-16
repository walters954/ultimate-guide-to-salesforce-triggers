trigger OpportunityTrigger on Opportunity (before insert) {
    System.debug('OpportunityTrigger ::: ' + Trigger.operationType);
    System.debug(Trigger.new);
    Opportunity opp = Trigger.new[0];
    if (opp.Amount == null){
        opp.Amount = 1000;
    } else if (opp.Amount < 1000){
        opp.addError('You need to have an amount greater than 1000');
    }
    
}