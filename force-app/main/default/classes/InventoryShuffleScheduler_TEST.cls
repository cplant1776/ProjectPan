@isTest
public with sharing class InventoryShuffleScheduler_TEST {

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
    static void doesScheduleShufflesScheduleAllStores()
    {
        List<CronJobDetail> jobs = [SELECT Id, Name, JobType FROM CronJobDetail];
        System.assertEquals(0, jobs.size());

        InventoryShuffleScheduler shuffler = new InventoryShuffleScheduler(0.1, 0.2, 0.3, 0.4);

        Test.startTest();
        shuffler.scheduleShuffles();

        jobs = [SELECT Id, Name, JobType FROM CronJobDetail];
        System.assertEquals(NUM_OF_STORES, jobs.size());
        Test.stopTest();
    }

    @isTest
    static void doesClearInventoryShuffleRemoveAllShuffleJobs()
    {
        InventoryShuffleScheduler shuffler = new InventoryShuffleScheduler(0.1, 0.2, 0.3, 0.4);
        Test.startTest();
        shuffler.scheduleShuffles();

        // Ensure jobs were scheduled
        List<CronJobDetail> jobs = [SELECT Id, Name, JobType FROM CronJobDetail];
        System.assertEquals(NUM_OF_STORES, jobs.size());

        InventoryShuffleScheduler.clearInventoryShuffle();

        // Ensure jobs were cleared
        jobs = [SELECT Id, Name, JobType FROM CronJobDetail];
        System.assertEquals(0, jobs.size());
        Test.stopTest();
    }
}