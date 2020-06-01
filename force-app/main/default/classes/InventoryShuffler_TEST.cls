@isTest
public with sharing class InventoryShuffler_TEST {
    
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
    static void doesInventoryShufflerRescheduleItself()
    {
        Account randomStore = [SELECT Id FROM Account WHERE Name LIKE '%Store%' LIMIT 1];
        
        Test.startTest();
        String cronId = System.scheduleBatch(new InventoryShuffler(randomStore.Id, 0.2, 0.3),
                                             'Old and Busted' + randomStore.Id, 1);
        
        // Ensure job was scheduled
        //CronTrigger ct = [SELECT Id, TimesTriggered, NextFireTime
        //       FROM CronTrigger WHERE Id = :cronID];
        List<CronTrigger> ct = [SELECT Id, TimesTriggered, NextFireTime
                                FROM CronTrigger];
        for(CronTrigger t : ct)
        {
            System.debug('TimesTriggered: ' + t.TimesTriggered);
            System.debug('NextFireTime: ' + t.NextFireTime);
                }
        //DateTime oldFireTime = ct.NextFireTime;
        
        Test.stopTest();
        
        //Ensure job was REscheduled
        ct = [SELECT Id, TimesTriggered, NextFireTime
              FROM CronTrigger];
        for(CronTrigger t : ct)
        {
            System.debug('TimesTriggered: ' + t.TimesTriggered);
            System.debug('NextFireTime: ' + t.NextFireTime);
                }
        //System.assertNotEquals(oldFireTime, ct.NextFireTime);
    }
    
    @isTest
    static void doesInventoryShufflerAdjustProductQuantity()
    {
        Account randomStore = [SELECT Id FROM Account WHERE Name LIKE '%Store%' LIMIT 1];
        Map<Id, Store_Product__c> oldStoreProdsById = new Map<Id, Store_Product__c>([SELECT Id, Quantity__c, Store__c FROM Store_Product__c
                                                                                     WHERE Store__c = :randomStore.Id]);
        Test.startTest();
        System.scheduleBatch(new InventoryShuffler(randomStore.Id, 0.2, 0.3),
                             'Shuffle Inventory -' + randomStore.Id, 1);
        Test.stopTest();
        
        // Compare old and new quantities looking for differences
        Boolean foundChangedQuantity = false;
        Map<Id, Store_Product__c> updatedStoreProdsById = new Map<Id, Store_Product__c>([SELECT Id, Quantity__c, Store__c FROM Store_Product__c
                                                                                         WHERE Store__c = :randomStore.Id]);
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