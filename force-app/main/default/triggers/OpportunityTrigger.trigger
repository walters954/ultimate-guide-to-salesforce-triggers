trigger OpportunityTrigger on Opportunity (before insert, after insert, before update, after update, before delete, after delete) {
    System.debug('OpportunityTrigger:::' + Trigger.operationType);

    if (Trigger.isBefore){
        if (Trigger.isInsert){
            System.debug('OpportunityTrigger Before Insert');
            for (Opportunity opp : Trigger.new){
                if (opp.Amount == null){
                    opp.Amount = 1000;
                } else if (opp.Amount < 1000){
                    opp.addError('You need to have an amount greater than 1000');
                }
            }
        }
        else if (Trigger.isUpdate){
            System.debug('OpportunityTrigger Before Update');
            System.debug(Trigger.old);
            for (Opportunity opp : Trigger.new){
                System.debug('New Opp Stage ' + opp.StageName);
                for (Opportunity oldOpp : Trigger.old){
                    System.debug('oldOpp Opp Stage ' + oldOpp.StageName);
                    if (opp.StageName != oldOpp.StageName && opp.Id == oldOpp.Id){
                        opp.Description += '\n Stage Change:' + opp.StageName + ':' + DateTime.now().format();
                    }
                }
                
            }
        }
        else if (Trigger.isDelete){
            for (Opportunity oldOpp : Trigger.old){
                if (oldOpp.IsClosed){
                    oldOpp.addError('Cannot delete closed won opportunity');
                }
            }
        }
    }

    List<OpportunityLineItem> oppLineItems = new List<OpportunityLineItem>();
    if (Trigger.isAfter){
        if (Trigger.isInsert){
            for (Opportunity opp : Trigger.new){
                System.debug('OpportunityTrigger After Insert');
                // opp.Name = opp.Name + 'after';
                oppLineItems.add(new OpportunityLineItem(
                    OpportunityId = opp.Id,
                    Quantity = 1,
                    UnitPrice = 100,
                    Product2Id = '01t4x0000020maiAAA'));
                
            }
                
        }else if (Trigger.isUpdate){
            System.debug('OpportunityTrigger After Update');
        } 
        else if (Trigger.isDelete){
            notifyOwnersOpportunityDeleted(Trigger.old);
        }

        insert oppLineItems; 
    }

    private static void assignAccountToOpportunity(List<Opportunity> opps) {
        for (Opportunity opp : opps){
            if (opp.AccountId == null){
                opp.AccountId = accts[0].Id; //assign random account
            }
        }
        update opps;
    }

    private static void notifyOwnersOpportunityDeleted(List<Opportunity> opps) {
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