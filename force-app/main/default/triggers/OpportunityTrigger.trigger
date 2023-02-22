trigger OpportunityTrigger on Opportunity (before insert, after insert, 
                                            before update, after update, 
                                            before delete, after delete, 
                                            after undelete) {

    OpportunityTriggerHandler handler = new OpportunityTriggerHandler();
    handler.run();
}