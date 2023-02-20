trigger OpportunityBestPracticeTrigger on Opportunity (after update) {

    StarWarsCallout.makeGetCallout();
}


