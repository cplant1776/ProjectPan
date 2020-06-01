// ==== Seed some data to play with ==== //

// Create Stocked Products
List<Stocked_Product__c> prods = new List<Stocked_Product__c>();
prods.add(new Stocked_Product__c(Name='Product1', Category__c='Category1', Brand__c='Brand1', Product_Ex_Id__c='a'));
prods.add(new Stocked_Product__c(Name='Product2', Category__c='Category1', Brand__c='Brand1', Product_Ex_Id__c='b'));
prods.add(new Stocked_Product__c(Name='Product3', Category__c='Category1', Brand__c='Brand2', Product_Ex_Id__c='c'));
prods.add(new Stocked_Product__c(Name='Product4', Category__c='Category2', Brand__c='Brand2', Product_Ex_Id__c='d'));
prods.add(new Stocked_Product__c(Name='Product5', Category__c='Category2', Brand__c='Brand3', Product_Ex_Id__c='e'));
prods.add(new Stocked_Product__c(Name='Product6', Category__c='Category3', Brand__c='Brand1', Product_Ex_Id__c='f'));
prods.add(new Stocked_Product__c(Name='Product7', Category__c='Category4', Brand__c='Brand1', Product_Ex_Id__c='g'));
prods.add(new Stocked_Product__c(Name='Product8', Category__c='Category4', Brand__c='Brand2', Product_Ex_Id__c='h'));
MyScripts.PrintList(prods);
insert prods;

// Create Stores
List<Account> stores = new List<Account>();
stores.add(new Account(Name='Store1'));
stores.add(new Account(Name='Store2'));
MyScripts.PrintList(stores);
insert stores;

// Stock products in stores
List<Store_Product__c> storeProducts = new List<Store_Product__c>();
storeProducts.add(new Store_Product__c(Name='Stock1', Quantity__c=1,
                                        Store__c=stores[0].id, Product__c=prods[0].id));
storeProducts.add(new Store_Product__c(Name='Stock2', Quantity__c=2,
                                        Store__c=stores[0].id, Product__c=prods[1].id));
storeProducts.add(new Store_Product__c(Name='Stock3', Quantity__c=3,
                                        Store__c=stores[0].id, Product__c=prods[2].id));
storeProducts.add(new Store_Product__c(Name='Stock4', Quantity__c=4,
                                        Store__c=stores[0].id, Product__c=prods[3].id));
storeProducts.add(new Store_Product__c(Name='Stock5', Quantity__c=5,
                                        Store__c=stores[0].id, Product__c=prods[4].id));
storeProducts.add(new Store_Product__c(Name='Stock6', Quantity__c=6,
                                        Store__c=stores[0].id, Product__c=prods[6].id));
storeProducts.add(new Store_Product__c(Name='Stock7', Quantity__c=7,
                                        Store__c=stores[0].id, Product__c=prods[7].id));
storeProducts.add(new Store_Product__c(Name='Stock8', Quantity__c=8,
                                        Store__c=stores[1].id, Product__c=prods[5].id));
storeProducts.add(new Store_Product__c(Name='Stock9', Quantity__c=9,
                                        Store__c=stores[1].id, Product__c=prods[6].id));
storeProducts.add(new Store_Product__c(Name='Stock10', Quantity__c=10,
                                        Store__c=stores[1].id, Product__c=prods[7].id));
storeProducts.add(new Store_Product__c(Name='Stock11', Quantity__c=11,
                                        Store__c=stores[1].id, Product__c=prods[1].id));
storeProducts.add(new Store_Product__c(Name='Stock12', Quantity__c=12,
                                        Store__c=stores[1].id, Product__c=prods[3].id));
storeProducts.add(new Store_Product__c(Name='Stock13', Quantity__c=13,
                                        Store__c=stores[1].id, Product__c=prods[0].id));
MyScripts.PrintList(storeProducts);
insert storeProducts;


// ==== DELETE PLAY DATA ==== //

// Data to delete
List<Store_Product__c> storeProducts = [SELECT Id FROM Store_Product__c];
List<Account> stores = [SELECT Id FROM Account WHERE Name LIKE '%Store%'];
List<Stocked_Product__c> prods = [SELECT Id FROM Stocked_Product__c];

// Delete 'em
delete storeProducts;
delete stores;
delete prods;