String permissionSetname ='D_Administrator_Permissions';
String Query = 'select id, SobjectType, Field, PermissionsEdit, PermissionsRead from FieldPermissions  where parent.name =\''+permissionSetname+'\'';
List<FieldPermissions> fieldPermissionList = Database.query(query);
Map<String,List<string>> mapOfFields = new Map<String,List<string>>();
Map<String,FieldPermissions> mapOfFieldpermission = new Map<String,FieldPermissions>();
for(FieldPermissions fp : fieldPermissionList){
    List<String> listOfFields = mapOfFields.containsKey(fp.SobjectType) ? mapOfFields.get(fp.SobjectType) : new List<String>();
    listOfFields.add(fp.Field);
    mapOfFields.put(fp.SobjectType, listOfFields);
    mapOfFieldpermission.put(fp.Field, fp);
}

List<String> allFields = new List<String>();
Map<String , Schema.SObjectType> globalCall = new Map<String , Schema.SObjectType>();
globalCall = Schema.getGlobalDescribe();
for(String objectName: globalCall.keyset()){
    Schema.SObjectType targetType = globalCall.get(objectName);
    Map<String, Schema.SObjectField> fieldMap = targetType.getDescribe().fields.getMap();
    for (Schema.SObjectField field : fieldMap.values()) {
        String fieldName= field.getDescribe().getlabel();
        String ApiName=field.getDescribe().getName() ;
        
        System.debug(field.getDescribe().getName());
        if( mapOfFields.containsKey(objectName) &&  mapOfFields.get(objectName).contains(objectName+'.'+ApiName ) ){
            allFields.add(objectName+','+fieldName+','+ApiName+','+mapOfFieldpermission.get(objectName+'.'+ApiName).PermissionsEdit+','+mapOfFieldpermission.get(objectName+'.'+ApiName).PermissionsRead);
        }
        else{
            allFields.add(objectName+','+fieldName+','+ApiName+','+'False'+','+'False');
        }
    } 
}
String csvColumnHeader = 'Object Name, Field Name, Api Name,PermissionsEdit ,PermissionsRead\n';
String csvFile = csvColumnHeader + String.join(allFields,'\n');
 
 Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            Messaging.EmailFileAttachment attach1 = new Messaging.EmailFileAttachment();
            blob b;
            if(Test.isRunningTest()) { 
                b = blob.valueOf('Unit.Test');
            } else {
                b = Blob.valueOf(csvFile);
            }                        
 
            attach1.setFileName(permissionSetname+'.csv');
            attach1.setBody(b);
            message.setFileAttachments(new Messaging.EmailFileAttachment[]{attach1});
            String[] toAddresses = new String[] {'ali.siddiqui@mediamonks.com'}; 
            message.setToAddresses(toAddresses); 
            message.setSubject(permissionSetname); 
            message.setHtmlBody('This email is for testing purpose of Create csv files');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });
 


