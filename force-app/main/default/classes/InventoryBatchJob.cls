global class InventoryBatchJob implements Database.Batchable<SObject>, Schedulable {

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(
            'SELECT Id, Stock_Quantity__c FROM Inventory__c WHERE Stock_Quantity__c < 10'
        );
    }

    global void execute(Database.BatchableContext BC, List<SObject> records) {
        List<Inventory__c> inventoryList = new List<Inventory__c>();

        for (SObject record : records) {
            Inventory__c inv = (Inventory__c) record;

            inv.Stock_Quantity__c =
                (inv.Stock_Quantity__c == null ? 0 : inv.Stock_Quantity__c) + 50;

            inventoryList.add(inv);
        }

        if (!inventoryList.isEmpty()) {
            update inventoryList;
        }
    }

    global void finish(Database.BatchableContext BC) {
        System.debug('Inventory Restocking Completed');
    }

    global void execute(SchedulableContext SC) {
        InventoryBatchJob job = new InventoryBatchJob();
        Database.executeBatch(job, 200);
    }
}