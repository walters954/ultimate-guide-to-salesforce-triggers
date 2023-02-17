List<Opportunity> oppList = new List<Opportunity>();
Opportunity opp1 = new Opportunity(
    Name = 'Opportunity Opp3',
    StageName = 'Prospecting',
    CloseDate = System.today(),
    Amount = 10000,
    Pricebook2Id = '01s4x000005pjqTAAQ');

Opportunity opp2 = new Opportunity(
    Name = 'Opportunity Opp4',
    StageName = 'Prospecting',
    CloseDate = System.today(),
    Amount = null,
    Pricebook2Id = '01s4x000005pjqTAAQ');

oppList.add(opp1);
oppList.add(opp2);
insert oppList;