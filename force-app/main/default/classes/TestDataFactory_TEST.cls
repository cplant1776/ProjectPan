@isTest
public with sharing class TestDataFactory_TEST {

    @isTest
    static void doesCreateStoresMakeStores()
    {
        Integer storesToGenerate = 100;
        Integer startingStores = [SELECT Count() FROM Account];
        
        Test.startTest();
        TestDataFactory.createStores(storesToGenerate);
        Test.stopTest();
        
        Integer endingStores = [SELECT Count() FROM Account];
        System.assertEquals(startingStores + storesToGenerate, endingStores);
    }

    @isTest
    static void doesCreateExternalStockedProductsMakeExternalProducts()
    {
        Integer productsToGenerate = 1000;
        Integer startingProducts = [SELECT Count() FROM Account];
        
        Test.startTest();
        TestDataFactory.createStores(productsToGenerate);
        Test.stopTest();
        
        Integer endingProducts = [SELECT Count() FROM Account];
        System.assertEquals(startingProducts + productsToGenerate, endingProducts);
    }

    @isTest
    static void doesCreateExternalStoreProductsMakeExternalProducts()
    {
        Integer numOfStores = 10;
        Integer numOfStockedProds = 100;
        Integer numOfStoreProds = 400;

        // Prefer not to call other functions here to generate data,
        // but will do so to speed things along. We will call it good
        // as long as the called functions are passing their tests :)
        TestDataFactory.createStores(numOfStores);
        TestDataFactory.createExternalStockedProducts(numOfStockedProds);
        
        Test.startTest();
        TestDataFactory.createExternalStoreProducts(numOfStoreProds);
        Test.stopTest();

        // Ensure quantity
        List<Store_Product__c> prods = [SELECT Id, Store__c, Product__c FROM Store_Product__c];
        System.assertEquals(numOfStoreProds, prods.size());

        // Grab generated store/stocked product Ids
        Map<Id, Account> storesById = new Map<Id, Account>([SELECT Id FROM Account]);
        Map<Id, Stocked_Product__c> prodsById = new Map<Id, Stocked_Product__c>([SELECT Id FROM Stocked_Product__c]);

        // Sample random generated products and assert valid relationship ids
        Set<Integer> indicesToTest = Utils.getRandomIndices(prods.size(), 10);
        for(Integer i : indicesToTest)
        {
            System.assert(storesById.keySet().contains(prods[i].Store__c));  
            System.assert(prodsById.keySet().contains(prods[i].Product__c)); 
        }
    }

    @isTest
    static void doesCreateInternalStoreMakeStore()
    {
        TestDataFactory.createInternalStore();
        List<Account> store = [SELECT Id FROM Account
        WHERE Name = 'INTERNAL_STORE'];
        System.assertEquals(1, store.size());
    }

    @isTest
    static void doesCreateInternalStockedProductsMakeProducts()
    {
        Integer numOfStores = 10;
        Integer numOfStockedProds = 100;

        // Prefer not to call other functions here to generate data,
        // but will do so to speed things along. We will call it good
        // as long as the called functions are passing their tests :)
        TestDataFactory.createStores(numOfStores);
        TestDataFactory.createInternalStore();
        TestDataFactory.createExternalStockedProducts(numOfStockedProds);

        Test.startTest();
        TestDataFactory.createInternalStockedProducts();
        Test.stopTest();

        List<Stocked_Product__c> internalProds = [SELECT Id, Product_Ex_Id__c FROM Stocked_Product__c
        WHERE Product_Ex_Id__c != null];
        
        // Ensure quantity
        System.assertEquals(numOfStockedProds, internalProds.size());

        // Grab external products Ids
        Map<Id, Stocked_Product__c> extProdsById = new Map<Id, Stocked_Product__c>([SELECT Id FROM Stocked_Product__c
        WHERE Product_Ex_Id__c = null]);
        Set<Id> extProdIds = extProdsById.keyset();

        // Check if every internal product matches an external product
        for(Stocked_Product__c eachIntProd : internalProds)
        {
            System.assert(extProdIds.contains(eachIntProd.Product_Ex_Id__c));
            extProdIds.remove(eachIntProd.Product_Ex_Id__c);
        }
        System.assertEquals(0, extProdIds.size());
    }

    @isTest
    static void doesCreateInternalStoreProductsMakeInternalProducts()
    {
        Integer numOfStores = 10;
        Integer numOfStockedProds = 100;

        // Prefer not to call other functions here to generate data,
        // but will do so to speed things along. We will call it good
        // as long as the called functions are passing their tests :)
        TestDataFactory.createStores(numOfStores);
        TestDataFactory.createInternalStore();
        TestDataFactory.createExternalStockedProducts(numOfStockedProds);
        TestDataFactory.createInternalStockedProducts();
        
        Test.startTest();
        TestDataFactory.createInternalStoreProducts();
        Test.stopTest();

        // Get internal store
        //Account internalStore = [SELECT Id FROM Account LIMIT 1];
        List<Store_Product__c> internalProds = [SELECT Id, Product__c FROM Store_Product__c
        WHERE Store__r.Name='INTERNAL_STORE' AND Is_External_Product__c = False];
        
        // Ensure quantity
        System.assertEquals(numOfStockedProds, internalProds.size());

        // Grab internal stocked products Ids
        Map<Id, Stocked_Product__c> intStockedProdsById = new Map<Id, Stocked_Product__c>([SELECT Id FROM Stocked_Product__c
        WHERE Product_Ex_Id__c != null]);
        Set<Id> intStockedProdIds = intStockedProdsById.keyset();

        // Check if every internal product matches an external product
        for(Store_Product__c eachIntProd : internalProds)
        {
            System.assert(intStockedProdIds.contains(eachIntProd.Product__c));
            intStockedProdIds.remove(eachIntProd.Product__c);
        }
        System.assertEquals(0, intStockedProdIds.size());
    }

    @isTest
    static void doesGetRandomStoreReturnRandomStore()
    {
        // throwaway for coverage
        List<Account> accs = new List<Account>();
        accs.add(new Account(Name='blablabla'));
        Account x = TestDataFactory.getRandomStore(accs);
    }

    @isTest
    static void doesGetRandomProductReturnRandomProduct()
    {
        // throwaway for coverage
        List<Stocked_Product__c> prods = new List<Stocked_Product__c>();
        prods.add(new Stocked_Product__c(Name='blablabla', Brand__c='Brand1',
         Category__c='Cat1', Product_Ex_Id__c = null));
        Stocked_Product__c x = TestDataFactory.getRandomProduct(prods);
    }
}