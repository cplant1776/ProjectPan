// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

List<Account> accsToDelete = [SELECT Name, Id FROM Account WHERE (NOT Name LIKE '%Store%')];
for(Account acc : accsToDelete)
{
    System.debug(acc.Name);
}
System.Database.Delete(accsToDelete);