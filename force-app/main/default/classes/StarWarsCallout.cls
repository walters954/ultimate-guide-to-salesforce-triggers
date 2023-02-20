public with sharing class StarWarsCallout {
    public static String makeGetCallout() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://swapi.dev/api/people/1');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        // If the request is successful, parse the JSON response.
        if(response.getStatusCode() == 200) {
            return response.getBody();
        }
        return '';
    }

    @future (callout = true)
    public static void makeGetCalloutFuture() {
        makeGetCallout();
    }
}