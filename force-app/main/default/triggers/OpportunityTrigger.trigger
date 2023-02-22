trigger OpportunityTrigger on Opportunity (before insert, after insert, 
                                            before update, after update, 
                                            before delete, after delete, 
                                            after undelete) {

    OpportunityTriggerHandler handler = new OpportunityTriggerHandler();
    handler.run();

    if (Trigger.isBefore){
        if (Trigger.isInsert){
        }
        else if (Trigger.isUpdate){
        }
        else if (Trigger.isDelete){
        }
    }

    
    if (Trigger.isAfter){
        if (Trigger.isInsert){
            
        }else if (Trigger.isUpdate){
            
        } 
        else if (Trigger.isDelete){
            
        }
        else if (Trigger.isUndelete){
            
        }
    }
}