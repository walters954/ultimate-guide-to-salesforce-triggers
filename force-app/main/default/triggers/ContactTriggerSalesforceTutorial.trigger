// https://www.salesforcetutorial.com/salesforce-apex-trigger-examples/
// 1. Populate contact description when user creates contact - Done
// 2. Populate contact description with modified user name when user updates contact. - Done

trigger ContactTriggerSalesforceTutorial on Contact (before insert, before update) {

    if (Trigger.isInsert){
        for (Contact cont : Trigger.new){
            cont.Description = 'This is in the ContactTriggerSalesforceTutorial';
        }
    } else if (Trigger.isUpdate){
        for (Contact cont : Trigger.new){
            cont.Description = 'I changed this contact ' + UserInfo.getUserName();
        }
    }
    
}