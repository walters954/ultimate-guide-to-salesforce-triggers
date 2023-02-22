public with sharing class OpportunityTriggerHelper {

    public static Boolean hasRun = false; 

    public static void assignAccountToOpportunity(Map<Id,Opportunity> oppNewMap) {
        List<Account> accts = [SELECT Id FROM Account];
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
        for (Opportunity opp : oppNewMap.values()){
            if (opp.AccountId == null){
                Opportunity oppToUpdate = new Opportunity(Id = opp.Id); //create temp opportunity
                oppToUpdate.AccountId = accts[0].Id; //assign random account
                oppMap.put(opp.Id, oppToUpdate);
            }
        }
        update oppMap.values();
    }

    public static void notifyOwnersOpportunityDeleted(List<Opportunity> opps) {
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        for (Opportunity opp : opps){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {[SELECT Id, Email FROM User WHERE Id = :opp.OwnerId].Email}; // SOQL in for loop - bulkify
            mail.setToAddresses(toAddresses);
            mail.setSubject('Opportunity Deleted : ' + opp.Name);
            mail.setPlainTextBody('Your Opportunity: ' + opp.Name +' has been deleted.');
            mails.add(mail);
        }        
        Messaging.sendEmail(mails);
    }

}