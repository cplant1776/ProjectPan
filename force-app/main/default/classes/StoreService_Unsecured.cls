@RestResource(urlmapping='/unsecured/store/*')
global class StoreService_Unsecured {
    
	// Base URL = https://projectpan-developer-edition.na172.force.com/public/services/apexrest
	private static Integer BASE_URL_PARTS = 5;
    private static Integer PATH_URL_PARTS = 2;
    
    @HttpGet
    global static void SyncInventory()
    {
        RestRequest request = RestContext.request;
        
        // Check for {id}
        // Example: [BASE URL]/unsecured/store/{id}
        String storeId = getPathPart(request.requestURI, 1);
        System.debug('storeId??  ' + storeId);
    }
    
    /*
     * Returns specified part of the given url's path, ignoring controller's base url
     * Ex:
     * String url = https://projectpan-developer-edition.na172.force.com/public/services/apexrest/one/two/three;
     * String part = getPathPart(url, 2);
     * System.debug(part); => "two"
     */
    private static String getPathPart(String url, Integer part)
    {
        return url.split('/')[BASE_URL_PARTS + PATH_URL_PARTS + part];
    }
}

// Returning JSON
//         RestContext.response.addHeader('Content-Type', 'application/json');
//        RestContext.response.responseBody = Blob.valueOf('{ "s" : "Hello", "i" : 1234 }');