public with sharing class EncryptedFieldAuditHelper {

    public static void auditEncryptedFields(){

        Map<String,Encrypted_Field__c> existingFieldMap = new Map<String,Encrypted_Field__c>();

        existingFieldMap = getExistingEncryptedFields();

        List<Encrypted_Field__c> fieldAuditList = new List<Encrypted_Field__c>();
        
        // Do a global describe and walk through each sobejct
        Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
    
        for(Schema.SObjectType objType : globalDescribe.values()) { 
            
            // Describe each object and walk through each field
            Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
            for (Schema.SObjectField f : objDescribe.fields.getMap().values()) {
                Schema.DescribeFieldResult field = f.getDescribe();

                //form key identifier string
                String objFieldKeyStr = objDescribe.getName() + field.getName(); 
        
                // Find all encrypted items
                if(field.isEncrypted()){ 
                    //if no change to Encryption flag, remove before upsert
                    if (existingFieldMap.containsKey(objFieldKeyStr) && existingFieldMap.get(objFieldKeyStr).Is_Encrypted__c == true){
                        existingFieldMap.remove(objFieldKeyStr);

                    //could be a bit more surgical here, but this works for now. 
                    //reapply describe information, this will ensure that fields that were
                    //encrypted, where encryption has been turned off and back on will be updated
                    } else {
                        Encrypted_Field__c fieldAudit = new Encrypted_Field__c();
                        fieldAudit.Name = field.getName();
                        fieldAudit.Object_Name__c = objDescribe.getName();
                        fieldAudit.Type__c = field.getType().name();
                        fieldAudit.Is_Encrypted__c = field.isEncrypted();
                        fieldAudit.Is_Custom__c = field.isCustom();
                        fieldAudit.ObjectFieldKey__c = objFieldKeyStr;

                        existingFieldMap.put(objFieldKeyStr, fieldAudit);

                    }

                //not encrypted, but we find the key means we've found a field where encryption
                //previously was enabled but is now disablied. update the audit.   
                } else if (existingFieldMap.containsKey(objFieldKeyStr)){
                    existingFieldMap.get(objFieldKeyStr).Is_Encrypted__c = false;
                }
            }
    
        }
        //upsert using the ExternalId of ObjectFieldKey__c
        System.debug('Total Encrypted Fields found: ' + fieldAuditList.size());
        upsert existingFieldMap.values() Encrypted_Field__c.fields.ObjectFieldKey__c;


    }

    public static Map<String,Encrypted_Field__c> getExistingEncryptedFields(){
        Map<String,Encrypted_Field__c> mapOfFields = new Map<String,Encrypted_Field__c>();

        for (Encrypted_Field__c e : [SELECT Id, Name, ObjectFieldKey__c, Is_Encrypted__c from Encrypted_Field__c]){
            mapOfFields.put(e.ObjectFieldKey__c, e);
        }

        return mapOfFields;

    }

    @AuraEnabled
    public static List<SetupAuditTrail> getEncryptionAudits(){
        List<SetupAuditTrail> filteredAuditRecords = new List<SetupAuditTrail>();

        Pattern ptn = Pattern.compile('.*[E,e]ncryption.*');

        for (List<SetupAuditTrail> batch : [SELECT Action, Id, Section, CreatedDate, CreatedBy.Name, Display, DelegateUser FROM SetupAuditTrail ORDER BY CreatedDate DESC]){
            for (SetupAuditTrail item : batch) {
                
                Matcher matchSection = ptn.matcher(item.Section != null ? item.Section : '');
                Matcher matchDisplay = ptn.matcher(item.Display != null ? item.Display : '');
                
                if (matchSection.matches() || matchDisplay.matches()){
                    filteredAuditRecords.add(item);
                }
            }
            System.debug(Limits.getHeapSize());
            System.debug(Limits.getLimitHeapSize());
        }

        return filteredAuditRecords;

    }

}