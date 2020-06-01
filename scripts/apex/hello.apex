// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

List<CronJobDetail> details = [SELECT Id, Name, JobType
FROM CronJobDetail
WHERE Name LIKE '%Shuffle Inventory%'];

System.debug(details);
for(CronJobDetail detail : details)
{
    System.debug(detail.Name);
}