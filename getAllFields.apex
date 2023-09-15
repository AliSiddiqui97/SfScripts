//Schema.SObjectType targetType = Schema.getGlobalDescribe().get('case');
List<String> allFields = new List<String>();
Map<String , Schema.SObjectType> globalCall = new Map<String , Schema.SObjectType>();
globalCall = Schema.getGlobalDescribe();
for(String objectName: globalCall.keyset()){
    Schema.SObjectType targetType = globalCall.get(objectName);
    Map<String, Schema.SObjectField> fieldMap = targetType.getDescribe().fields.getMap();
    for (Schema.SObjectField field : fieldMap.values()) {
        System.debug(field.getDescribe().getName());
        allFields.add(objectName+','+field.getDescribe().getlabel()+','+field.getDescribe().getName());
    } 
}
String csvColumnHeader = 'Object Name, Field Name, Api Name\n';
String csvFile = csvColumnHeader + String.join(allFields,'\n');
 
 Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            Messaging.EmailFileAttachment attach1 = new Messaging.EmailFileAttachment();
            blob b;
            if(Test.isRunningTest()) { 
                b = blob.valueOf('Unit.Test');
            } else {
                b = Blob.valueOf(csvFile);
            }                        
 
            attach1.setFileName('csvFile.csv');
            attach1.setBody(b);
            message.setFileAttachments(new Messaging.EmailFileAttachment[]{attach1});
            String[] toAddresses = new String[] {'ali.siddiqui@mediamonks.com'}; 
            message.setToAddresses(toAddresses); 
            message.setSubject('how-to-create-or-generate-a-csv-file-in-apex-salesforce-techdicer'); 
            message.setHtmlBody('This email is for testing purpose of Create csv files');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });
 


