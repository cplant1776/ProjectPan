global with sharing class InventoryShuffler implements Database.Batchable<SObject>, Database.Stateful {

    // Constants
    private final Integer MIN_TIME_VARIANCE = 20;
    private final Integer MAX_TIME_VARIANCE = 80;

    // Class members
    private Id storeId;
    private Decimal quantityVariance;
    private Decimal productVariance;
    private Integer prodsToChange = 0;
    private Integer prodsChanged = 0;
    
    public InventoryShuffler(Id storeId, Decimal quantityVariance, Decimal productVariance)
    {
        this.storeId = storeId;
        this.quantityVariance = quantityVariance;
        this.productVariance = productVariance;
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {

        // Calculate total # of products whose quantity we will change
        Integer totalProds = [SELECT COUNT() FROM Store_Product__c WHERE Store__c = :this.storeId];
        this.prodsToChange = (totalProds * this.productVariance).intValue();
        
        System.debug('Total Products to update: ' + totalProds);
        
        // Pull out records to operate on
       return Database.getQueryLocator(
           'SELECT Id, Quantity__c ' +
           'FROM Store_Product__c ' +
           'WHERE Store__c = :storeId'
       );
    }

    global void execute(Database.BatchableContext bc, List<Store_Product__c> scope){
        for(Store_Product__c product : scope)
        {
            if(prodsChanged <= prodsToChange)
            {
                // Either increases or decreases quantity by Quantity__c*quantityVariance for product
                product.Quantity__c = product.Quantity__c + (product.Quantity__c * this.quantityVariance * Utils.getRandomSign());
                prodsChanged++;
            }
            else { // enough products already changed; don't change any more
                break;
            }
        }

        update scope;
    }    

    global void finish(Database.BatchableContext bc){
        AsyncApexJob thisJob = [SELECT Status FROM AsyncApexJob
                                WHERE id = :bc.getJobId()];

        // Schedule another run
        if(thisJob.Status == 'Completed')
        {
            Integer minutesBetweenShuffle = Utils.getRandomInteger(MIN_TIME_VARIANCE, MAX_TIME_VARIANCE);
            Datetime sysTime = System.now().addSeconds(Utils.getRandomInteger(5));
            System.scheduleBatch(new InventoryShuffler(this.storeId, this.quantityVariance, this.productVariance),
            'Shuffle Inventory -' + this.storeId + ' - ' + sysTime, minutesBetweenShuffle);
        }
        
    }    
}