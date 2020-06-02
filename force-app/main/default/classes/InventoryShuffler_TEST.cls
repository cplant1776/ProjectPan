@isTest
public with sharing class InventoryShuffler_TEST {
    
    private static Integer NUM_OF_STOCKED_PRODUCTS = 20;
    private static Integer NUM_OF_STORES = 4;
    private static Integer NUM_OF_STORE_PRODS = 100;
    
    @TestSetup
    static void makeData(){
        TestDataFactory.createStockedProducts(NUM_OF_STOCKED_PRODUCTS);
        TestDataFactory.createStores(NUM_OF_STORES);
        TestDataFactory.createExternalStoreProducts(NUM_OF_STORE_PRODS);
    }
    
    @isTest
    static void doesInventoryShufflerRescheduleItself()
    {
        Account randomStore = [SELECT Id, Name, Total_Product__c FROM Account LIMIT 1];
        
        Test.startTest();
        InventoryShuffler shuffler = new InventoryShuffler(randomStore, 0.2, 0.3);
        String cronId = Database.executeBatch(shuffler);
        
        // Ensure no jobs were scheduled to begin with
        List<CronTrigger> jobs = [SELECT Id, TimesTriggered, NextFireTime
                                FROM CronTrigger];
        System.assertEquals(0, jobs.size());
        
        Test.stopTest();
        
        //Ensure job was scheduled after finishing
        jobs = [SELECT Id, TimesTriggered, NextFireTime
              FROM CronTrigger];
        System.assertEquals(1, jobs.size());
    }
    
    @isTest
    static void doesInventoryShufflerAdjustProductQuantity()
    {
        Account randomStore = [SELECT Id, Name, Total_Product__c FROM Account LIMIT 1];
        Map<Id, Store_Product__c> oldStoreProdsById = new Map<Id, Store_Product__c>([SELECT Id, Quantity__c, Store__c FROM Store_Product__c
                                                                                     WHERE Store__c = :randomStore.Id
                                                                                     AND Is_External_Product__c = True]);
        
        Test.startTest();
        InventoryShuffler shuffler = new InventoryShuffler(randomStore, 0.2, 0.3);
        String batchId = Database.executeBatch(shuffler);
        Test.stopTest();
        
        // Compare old and new quantities looking for differences
        Boolean foundChangedQuantity = false;
        Map<Id, Store_Product__c> updatedStoreProdsById = new Map<Id, Store_Product__c>([SELECT Id, Quantity__c, Store__c FROM Store_Product__c
                                                                                         WHERE Store__c = :randomStore.Id
                                                                                         AND Is_External_Product__c = True]);
        for(Id prodId : updatedStoreProdsById.keySet())
        {
            if(oldStoreProdsById.get(prodId).Quantity__c != updatedStoreProdsById.get(prodId).Quantity__c)
            {
                foundChangedQuantity = true;
            }
        }
        
        System.assert(foundChangedQuantity);
    }
}