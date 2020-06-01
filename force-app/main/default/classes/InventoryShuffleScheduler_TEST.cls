@isTest
public with sharing class InventoryShuffleScheduler_TEST {

    private static Integer NUM_OF_STOCKED_PRODUCTS = 20;
    private static Integer NUM_OF_STORES = 4;
    private static Integer NUM_OF_STORE_PRODS = 100;

    @TestSetup
    static void makeData(){
        TestDataFactory.createStockedProducts(NUM_OF_STOCKED_PRODUCTS);
        TestDataFactory.createStores(NUM_OF_STORES);
        TestDataFactory.createStoreProducts(NUM_OF_STORE_PRODS);
    }
    
    @isTest
    static void doesScheduleShufflesScheduleAllStores()
    {
        // InventoryShuffleScheduler shuffler = new InventoryShuffleScheduler(0.1, 0.2, 0.3, 0.4);
        // Test.startTest();
        // shuffler.scheduleShuffles();
        
        // Test.stopTest();
    }
}