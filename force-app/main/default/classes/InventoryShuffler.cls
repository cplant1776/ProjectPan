global class InventoryShuffler implements Schedulable{

    private final Account store;
    private final Decimal quantityVariance;
    private final Decimal productVariance;

    public InventoryShuffler(Account store, Decimal quantityVariance, Decimal productVariance)
    {
        this.store = store;
        this.quantityVariance = quantityVariance;
        this.productVariance = productVariance;
    }

    global void execute(SchedulableContext sc)
    {
        // TODO: Adjust inventory
    }
}