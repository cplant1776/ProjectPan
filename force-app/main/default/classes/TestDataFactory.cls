@isTest
public class TestDataFactory {
    
    private static final Integer MAX_NUM_BRANDS = 7;
    private static final Integer MAX_NUM_CATEGORIES = 4;
    private static final Integer MAX_QUANTITY = 100;
    
    public static void createStores(Integer numOfStores)
    {
        List<Account> stores = new List<Account>();
        for(Integer i=1; i <= numOfStores; i++)
        {
            stores.add(new Account(Name='Store' + i));
        }
        System.Database.insert(stores);
    }
    
    public static void createExternalStockedProducts(Integer numOfProds)
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
    
    public static void createExternalStoreProducts(Integer numOfProds)
    {
        List<Store_Product__c> storeProducts = new List<Store_Product__c>();
        List<Account> stores = [SELECT Id FROM Account];
        List<Stocked_Product__c> stockedProds = [SELECT Id FROM Stocked_Product__c 
                                                 WHERE Product_Ex_Id__c = null];
        
        for(Integer i=0; i < numOfProds; i++)
        {
            storeProducts.add(new Store_Product__c(Name = 'Stock' + i,
                                                   Quantity__c = Utils.getRandomInteger(MAX_QUANTITY),
                                                   Store__c = getRandomStore(stores).id,
                                                   Product__c = getRandomProduct(stockedProds).id,
                                                   Is_External_Product__c = True));
        }
        
        System.Database.insert(storeProducts);
    }
    
    public static void createInternalStore()
    {
        Account internalStore = new Account(Name = 'INTERNAL_STORE');
        insert internalStore;
    }
    
    public static void createInternalStockedProducts()
    {
        List<Stocked_Product__c> externalProds = [SELECT Name, Category__c, Brand__c 
                                                  FROM Stocked_Product__c 
                                                  WHERE Product_Ex_Id__c = null];
        List<Stocked_Product__c> internalProds = new List<Stocked_Product__c>();
        
        for(Stocked_Product__c eachExProd : externalProds)
        {
            internalProds.add(new Stocked_Product__c(Name = eachExProd.Name,
                                                     Category__c = eachExProd.Category__c,
                                                     Brand__c = eachExProd.Brand__c,
                                                     Product_Ex_Id__c = eachExProd.Id
                                                    ));
        }
        
        System.Database.insert(internalProds);
    }
    
    public static void createInternalStoreProducts()
    {
        List<Store_Product__c> storeProducts = new List<Store_Product__c>();
        Account internalStore = [SELECT Id FROM Account WHERE Name='INTERNAL_STORE' LIMIT 1];
        List<Stocked_Product__c> internalStockedProds = [SELECT Id FROM Stocked_Product__c
                                                         WHERE Product_Ex_Id__c != null];
        
        for(Integer i=0; i < internalStockedProds.size(); i++)
        {
            storeProducts.add(new Store_Product__c(Name = 'Stock' + i,
                                                   Quantity__c = Utils.getRandomInteger(MAX_QUANTITY),
                                                   Store__c = internalStore.id,
                                                   Product__c = internalStockedProds[i].id,
                                                   Is_External_Product__c = False));
        }
        
        System.debug(storeProducts.size());
        
        System.Database.insert(storeProducts);
    } 
    
    @testVisible
    private static Account getRandomStore(List<Account> stores)
    {
        return stores.size() == 1 ? stores[0] : stores[Utils.getRandomInteger(stores.size() - 1)];
    }
    
    @testVisible
    private static Stocked_Product__c getRandomProduct(List<Stocked_Product__c> prods)
    {
        return prods.size() == 1 ? prods[0] : prods[Utils.getRandomInteger(prods.size() - 1)];
    }
    
}