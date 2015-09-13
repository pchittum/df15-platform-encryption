global class EncryptedFieldAuditScanner implements Schedulable {
    global void execute(SchedulableContext sc) {

        EncryptedFieldAuditHelper.auditEncryptedFields();

    }
}