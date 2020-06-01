// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

List<Store_Product__c> prods = [SELECT Id, Is_External_Product__c FROM Store_Product__c];
for(Store_Product__c prod : prods)
{
    prod.Is_External_Product__c = True;
}
update prods;