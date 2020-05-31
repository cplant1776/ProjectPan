public with sharing class InventoryShuffleScheduler {

    private final Integer MIN_TIME_VARIANCE = 20;
    private final Integer MAX_TIME_VARIANCE = 80;

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

        this.scheduleShuffles();
    }

    /*
    *   Run to schedule all stores to update their inventory at varying frequencies
    */
    public void scheduleShuffles() {
        List<Account> stores = [SELECT Name, Id FROM Account WHERE Name LIKE '%Store%'];
        for(Account store : stores)
        {
            Decimal quanityVariance = Utils.getRandomDecimal(minQuantityVariance, maxQuantityVariance);
            Decimal productVariance = Utils.getRandomDecimal(maxProductVariance, maxProductVariance);
            Integer minutesBetweenShuffle = Utils.getRandomInteger(MIN_TIME_VARIANCE, MAX_TIME_VARIANCE);
            String cronStr = '0 0/' + minutesBetweenShuffle + ' * 1/1 * ? *'; // Easy cron creation: http://www.cronmaker.com/


            InventoryShuffler shuffler = new InventoryShuffler(store, quanityVariance, productVariance);
            String jobName = 'Shuffle Inventory - ' + store.Name;
            System.schedule(jobName, cronStr, shuffler);
        }

    }

    /*
    * Removes all scheduled inventory shuffles
    */ 
    public static void clearInventoryShuffle()
    {
        // TODO: delete all scheduled jobs starting w/ 'Shuffle Inventory - '
    }
}
