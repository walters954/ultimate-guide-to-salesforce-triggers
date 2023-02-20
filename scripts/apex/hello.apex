List<Opportunity> opps = [SELECT Id FROM Opportunity WHERE AccountId != null];
for (Opportunity opp : opps){
    opp.Amount = Integer.valueOf(Math.random() * 100000);
}

update opps;