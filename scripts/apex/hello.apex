Opportunity opp = [SELECT Id, Amount FROM Opportunity LIMIT 1];
opp.Description = 'Trying callout';
update opp;