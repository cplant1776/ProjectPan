public with sharing class InventoryShuffleScheduler {

    // Constants
    private final Integer MIN_TIME_VARIANCE = 20;
    private final Integer MAX_TIME_VARIANCE = 80;

    // Member variables
    private final Decimal minQuantityVariance;
    private final Decimal maxQuantityVariance;
    private final Decimal minProductVariance;
    private final Decimal maxProductVariance;

    /*
    *   Initializes all stores to periodically "update" their inventories
    *   INPUT PARAMS:
    *   minQtyVar - minimum % of total quantity that a product's quantity will increase or decrease on each shuffle
    *   maxQtyVar - maximum % of total quantity that a product's quantity will increase or decrease on each shuffle
    *   minProdVar - minimum % of store's products that will change quantity on each shuffle
    *   maxProdVar - maximum % of store's products that will change quantity on each shuffle
    */
    public InventoryShuffleScheduler(Decimal minQtyVar, Decimal maxQtyVar, Decimal minProdVar, Decimal maxProdVar)
    {
        this.minQuantityVariance = minQtyVar;
        this.maxQuantityVariance = maxQtyVar;
        this.minProductVariance = minProdVar;
        this.maxProductVariance = maxprodVar;
        System.debug('InventoryShuffleScheduler initialized.');
    }

    /*
    *   Schedules all stores to update their inventory at varying times
    */
    public void scheduleShuffles() {
        List<Account> stores = [SELECT Name, Id FROM Account WHERE Name LIKE '%Store%'];
        
        for(Account store : stores)
        {
            System.debug('Initial scheduling for ' + store.Name + '. . .');
            
            // Generate random parameter values
            Decimal quantityVariance = Utils.getRandomDecimal(minQuantityVariance, maxQuantityVariance);
            Decimal productVariance = Utils.getRandomDecimal(minProductVariance, maxProductVariance);
            Integer minutesBetweenShuffle = Utils.getRandomInteger(MIN_TIME_VARIANCE, MAX_TIME_VARIANCE);

			// Debug printouts            
            System.debug('qtyVar: ' + quantityVariance);
            System.debug('productVariance: ' + productVariance);
            System.debug('minutesBetweenShuffle: ' + minutesBetweenShuffle);

            // Schedule store shuffle
            Datetime sysTime = System.now();
            String cronID = System.scheduleBatch(new InventoryShuffler(store.Id, quantityVariance, productVariance),
            'Shuffle Inventory -' + store.Id + ' - ' + sysTime, minutesBetweenShuffle);

            System.debug('Scheduled job with Id: ' + cronId);
        }

    }

    /*
    * Removes all scheduled inventory shuffles
    */ 
    public static void clearInventoryShuffle()
    {
        List<CronTrigger> cronTriggers = [SELECT Id FROM CronTrigger 
                                          WHERE CronJobDetail.Name LIKE '%Shuffle Inventory%'];
            for(CronTrigger job : cronTriggers)
            {
                System.abortJob(job.Id);
            }
    }
}