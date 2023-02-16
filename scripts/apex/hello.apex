// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

Opportunity opp = new Opportunity(
    Name = 'Anon Opp with Amount Preset',
    StageName = 'Prospecting',
    CloseDate = System.today(),
    Amount = 10);
insert opp;