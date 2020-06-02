@RestResource(urlmapping='/myservice')
global class InventorySyncService {
	
    @HttpGet
    // Example: https://projectpan-developer-edition.na172.force.com/public/services/apexrest/myservice?name=Josh
    global static String getHelloName()
    {
        String name = RestContext.request.params.get('name');
        return 'Hello ' + name;
    }
}