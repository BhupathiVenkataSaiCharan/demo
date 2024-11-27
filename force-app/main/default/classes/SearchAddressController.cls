    public class SearchAddressController {
        
        @AuraEnabled(cacheable=true)
        public static List<Map<String,String>> fetchAddress(String query){
            
            String apiKey = 'ak_test';
            String url = 'https://api.ideal-postcodes.co.uk/v1/autocomplete/addresses';

            Http http = new Http();
            HttpRequest req = new HttpRequest();

            String endPoint = url + '?api_key=' + apiKey + '&query=' + EncodingUtil.urlEncode(query, 'UTF-8') + '&context=IND'; 
            System.debug('Endpoint :::>>>' +endPoint);
            req.setEndpoint(endPoint);
            req.setMethod('GET');

            try{
                HttpResponse res = http.send(req);
    
                if(res.getStatusCode() == 200){
                    Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                    List<Object> suggestions = (List<Object>)jsonResponse.get('suggestions');
    
                    List<Map<String, String>> formattedSuggestions = new List<Map<String, String>>();
                    for (Object suggestion : suggestions) {
                        Map<String, Object> suggestionMap = (Map<String, Object>) suggestion;
                        formattedSuggestions.add(new Map<String, String>{
                            'id' => (String) suggestionMap.get('postcode'),
                            'address' => (String) suggestionMap.get('address')
                        });
                    }
                    
                    return formattedSuggestions;
                }else{
                    System.debug('Error: Status Code ' + res.getStatusCode() + ', Body: ' + res.getBody());
                    throw new AuraHandledException('Error fetching address suggestions');
                }
            }
            catch (Exception ex) {
                System.debug('Callout Exception: ' + ex.getMessage());
                throw new AuraHandledException('Callout failed: ' + ex.getMessage());
            }
        }
    }