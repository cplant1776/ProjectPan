@isTest
public class StoreService_Unsecured_TEST {
    
    private static String BASE_URL = 'https://projectpan-developer-edition.na172.force.com/public/services/apexrest/unsecured/store';
    
    private static Integer NUM_OF_STOCKED_PRODUCTS = 20;
    private static Integer NUM_OF_STORES = 4;
    private static Integer NUM_OF_STORE_PRODS = 100;
    
    @testSetup
    static void makeData()
    {
        TestDataFactory.createExternalStockedProducts(NUM_OF_STOCKED_PRODUCTS);
        TestDataFactory.createStores(NUM_OF_STORES);
        TestDataFactory.createExternalStoreProducts(NUM_OF_STORE_PRODS);
        TestDataFactory.createInternalStore();
        TestDataFactory.createInternalStockedProducts();
        TestDataFactory.createInternalStoreProducts();
    }
    
    @isTest
    static void tester()
    {
        RestRequest request = new RestRequest();
        request.requestURI = BASE_URL + '/THE_ID';
        request.httpMethod = 'GET';
        RestContext.request = request;
        StoreService_Unsecured.SyncInventory();
    }
    
    @isTest
    static void doesGetRequestSyncCorrectStoreInventory()
    {
        Account randomStore = [SELECT Id, Name, Total_Product__c FROM Account LIMIT 1];
        
        RestRequest request = new RestRequest();
        request.requestURI = BASE_URL + '/THE_ID';
        request.httpMethod = 'GET';
        RestContext.request = request;
        
        StoreService_Unsecured.SyncInventory();
    }
}