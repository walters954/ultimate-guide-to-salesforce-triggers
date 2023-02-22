public with sharing class OpportunityTriggerHelper {

    public static Boolean hasRun = false; 

    public static void assignAccountToOpportunity(Map<Id,Opportunity> oppNewMap) {
        List<Account> accts = [SELECT Id FROM Account];
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
        for (Opportunity opp : oppNewMap.values()){
            if (opp.AccountId == null){
                Opportunity oppToUpdate = new Opportunity(Id = opp.Id); //create temp opportunity
                oppToUpdate.AccountId = accts[Integer.valueOf(Math.random() * accts.size())].Id; //assign random account
                oppMap.put(opp.Id, oppToUpdate);
            }
        }
        update oppMap.values();
    }

    public static void notifyOwnersOpportunityDeleted(List<Opportunity> opps) {
        Set<Id> userIdsFromOpp = new Set<Id>();
        for (Opportunity oppNew : opps){
            if (oppNew.AccountId != null) {
                userIdsFromOpp.add(oppNew.OwnerId);
            }
        }

        Map<Id,User> userFromOpp = new Map<Id,User>([SELECT Id, Email FROM User WHERE Id IN :userIdsFromOpp]);
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        for (Opportunity opp : opps){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {userFromOpp.get(opp.Id).Email}; // SOQL in for loop - bulkify
            mail.setToAddresses(toAddresses);
            mail.setSubject('Opportunity Deleted : ' + opp.Name);
            mail.setPlainTextBody('Your Opportunity: ' + opp.Name +' has been deleted.');
            mails.add(mail);
        }        
        Messaging.sendEmail(mails);
    }

    public static Decimal costPerEmployee(Opportunity opp, Account acc){
        Decimal costPerEmployee = 0;
        if (opp.Amount != null && acc.NumberOfEmployees != null){
            costPerEmployee = opp.Amount / acc.NumberOfEmployees;
        }
        System.debug('Cost per employee: ' + costPerEmployee);
        return costPerEmployee;
    }

}