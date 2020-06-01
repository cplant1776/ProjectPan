@isTest
public class TestDataFactory {
    
    private static final Integer MAX_NUM_BRANDS = 7;
    private static final Integer MAX_NUM_CATEGORIES = 4;
    private static final Integer MAX_QUANTITY = 100;
    
    public static void createStockedProducts(Integer numOfProds)
    {
        List<Stocked_Product__c> prods = new List<Stocked_Product__c>();
        for(Integer i=1; i <= numOfProds; i++)
        {
            prods.add(new Stocked_Product__c(Name = 'Product' + i,
                                             Category__c = 'Category' + Utils.getRandomInteger(1, MAX_NUM_CATEGORIES),
                                             Brand__c = 'Brand' + Utils.getrandomInteger(1, MAX_NUM_BRANDS)
                                            ));
        }
        
        System.Database.insert(prods);
    }
    
    public static void createStores(Integer numOfStores)
    {
        List<Account> stores = new List<Account>();
        for(Integer i=1; i <= numOfStores; i++)
        {
            stores.add(new Account(Name='Store' + i));
        }
        System.Database.insert(stores);
    }
    
    public static void createStoreProducts(Integer numOfProds)
    {
        List<Store_Product__c> storeProducts = new List<Store_Product__c>();
        List<Account> stores = [SELECT Id FROM Account];
        List<Stocked_Product__c> stockedProds = [SELECT Id FROM Stocked_Product__c];
        
        for(Integer i=0; i < numOfProds; i++)
        {
            storeProducts.add(new Store_Product__c(Name = 'Stock' + i,
                                                   Quantity__c = Utils.getRandomInteger(MAX_QUANTITY),
                                                   Store__c = getRandomStore(stores).id,
                                                   Product__c = getRandomProduct(stockedProds).id));
        }
        
        System.Database.insert(storeProducts);
    }
    
    
    
    private static Account getRandomStore(List<Account> stores)
    {
        return stores[Utils.getRandomInteger(stores.size() - 1)];
    }
    
    private static Stocked_Product__c getRandomProduct(List<Stocked_Product__c> prods)
    {
        return prods[Utils.getRandomInteger(prods.size() - 1)];
    }
    
}