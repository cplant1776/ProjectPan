global with sharing class InventoryShuffler implements Database.Batchable<SObject>, Database.Stateful {

    // Constants
    private final Integer MIN_TIME_VARIANCE = 20;
    private final Integer MAX_TIME_VARIANCE = 80;

    // Class members
    private Account store;
    private Decimal quantityVariance;
    private Decimal productVariance;
    private Integer prodsToChange = 0;
    private Integer prodsChanged = 0;
    
    public InventoryShuffler(Account store, Decimal quantityVariance, Decimal productVariance)
    {
        this.store = store;
        this.quantityVariance = quantityVariance;
        this.productVariance = productVariance;
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {

        // Calculate total # of products whose quantity we will change
        //Integer totalProds = [SELECT COUNT() FROM Store_Product__c WHERE Store__c = :this.store.Id
        //                                                           AND Is_External_Product__c = True];
                                                                   
        this.prodsToChange = (this.store.Total_Product__c * this.productVariance).intValue();
        
        //System.debug('Total Products to update: ' + this.store.TotalProduct__c);
        Id storeId = this.store.Id;
        String query = 'SELECT Id, Quantity__c ' +
           'FROM Store_Product__c ' +
           'WHERE Store__c = :storeId ' +
           'AND Is_External_Product__c = True';
        
        // Pull out records to operate on
       return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<Store_Product__c> scope){
        // Declarations
        List<Store_Product__c> updatedProds = new List<Store_Product__c>();
        
        for(Store_Product__c product : scope)
        {
            if(prodsChanged <= prodsToChange)
            {
                // Either increases or decreases quantity by Quantity__c*quantityVariance
                product.Quantity__c = product.Quantity__c + (product.Quantity__c * this.quantityVariance * Utils.getRandomSign());
                prodsChanged++;
                updatedProds.add(product);
            }
            else { // enough products already changed; don't change any more
                break;
            }
        }

        update updatedProds;
    }    

    global void finish(Database.BatchableContext bc){
        AsyncApexJob thisJob = [SELECT Status FROM AsyncApexJob
                                WHERE id = :bc.getJobId()];

        // Schedule another run
        if(thisJob.Status == 'Completed')
        {
            Integer minutesBetweenShuffle = Utils.getRandomInteger(MIN_TIME_VARIANCE, MAX_TIME_VARIANCE);
            Datetime sysTime = System.now().addSeconds(Utils.getRandomInteger(10));
            System.scheduleBatch(new InventoryShuffler(this.store, this.quantityVariance, this.productVariance),
            'Shuffle Inventory -' + this.store.Id + ' - ' + sysTime, minutesBetweenShuffle);
        }
        
    }    
}