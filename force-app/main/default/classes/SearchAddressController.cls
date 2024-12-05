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
                System.debug('Response :::>>>' + res);
                System.debug('Response :::>>>' + res.getStatusCode());
                System.debug('Response :::>>>' + res.getBody());
    
                if(res.getStatusCode() == 200){
                    Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                    System.debug('jsonResponse ::: '+jsonResponse);
                    Map<String, Object> result = (Map<String, Object>) jsonResponse.get('result');
                    System.debug('result ::: '+result);
                    List<Object> hits = (List<Object>) result.get('hits');
                    System.debug('hits ::: '+hits);
                    // System.debug('result'+result);

                    // List<Object> suggestions = (List<Object>)jsonResponse.get('suggestion');
                    // System.debug('suggestions'+suggestions);
    
                    List<Map<String, String>> formattedSuggestions = new List<Map<String, String>>();
                    for (Object hit : hits) {
                        Map<String, Object> hitMap = (Map<String, Object>) hit;
                        System.debug('hitMap: '+hitMap);
                        formattedSuggestions.add(new Map<String, String>{
                            'id' => (String) hitMap.get('id'),
                            'address' => (String)  hitMap.get('suggestion')
                        });
                    }
                    System.debug('formattedSuggestions: '+formattedSuggestions);
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