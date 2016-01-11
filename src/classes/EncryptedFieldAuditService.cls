public class EncryptedFieldAuditService {
    
    @AuraEnabled
    public static List<Encrypted_Field__c> getEncryptedFields(){
        List<Encrypted_Field__c> fieldList = new List<Encrypted_Field__c>();
        
        fieldList = [SELECT Id, Name, CreatedDate, Object_Name__c, Is_Encrypted__c, Type__c, Is_Custom__c, ObjectFieldKey__c FROM Encrypted_Field__c ORDER BY ObjectFieldKey__c];
        
        return fieldList;
    }

}