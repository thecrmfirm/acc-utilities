public class CRMF_Utilities {

    public void printFullDebug(String fullDebugLog) {
        for (Integer i = 0; i <= fullDebugLog.length(); i=i+300) {
            Integer endPosition = (i+300 > (fullDebugLog.length()) ? fullDebugLog.length() : i+300);
            System.debug(fullDebugLog.subString(i,endPosition));
        }
    }

    public static String getSFInstanceUrl() {
        return URL.getSalesforceBaseUrl().toExternalForm();
    }

    public Boolean checkIfRecordIdBelongsToSpecificObjectType(String recordId, String objectApiName) {
        Boolean result = false;
        if (String.isNotBlank(recordId) && String.isNotBlank(objectApiName)) {
            Id id = (Id) recordId;

            if (id.getSObjectType().getDescribe().getName() == objectApiName) {
                result = true;
            }
        }

        return result;
    }

    public String getObjectNameById(Id objectId) {
        return objectId.getSObjectType().getDescribe().getName();
    }

    public String[] getAllParentOfAnObject(String objectName) {
        Map<String, Schema.SObjectType> completeSchema = Schema.getGlobalDescribe();
        Schema.SObjectType requiredObject = completeSchema.get(objectName);
        String[] childObjectName = new List<String>();
        Schema.DescribeSObjectResult result = requiredObject.getDescribe();
        for (Schema.ChildRelationship cr : result.getChildRelationships()) {
            childObjectName.add(cr.getChildSObject().getDescribe().getName());
        }
        return childObjectName;
    }

    public void displaySchemaForSpecifiedObjects(List<String> objectsNames) {
        Schema.DescribeSObjectResult[] objectType = Schema.DescribeSObjects(objectsNames);
        for (Schema.DescribeSObjectResult singleSchema : objectType) {
            system.debug(singleSchema);
        }
    }

    public void displaySchemaForSpecifiedObject(String objectName) {
        displaySchemaForSpecifiedObjects(new String[]{objectName});
    }

    public void displayFieldNamesForSpecifiedObject(String objectName) {
        Schema.DescribeSObjectResult[] objectType = Schema.DescribeSObjects(new String[] {objectName});
        Schema.DescribeSObjectResult obj = objectType[0];
        Map<String, Schema.SObjectField> fieldMap = obj.fields.getMap();

        for (Schema.SObjectField fieldToken : fieldMap.values()) {
            Schema.DescribeFieldResult f = fieldToken.getDescribe();
            system.debug(f.getName());
        }
    }

    public static String getObjectTypeByRecordId(String recordId) {
        String result = '';
        if (String.isNotBlank(recordId)) {
            result = ((Id)recordId).getSObjectType().getDescribe().getName();
        }
        return result;
    }

    public static Schema.DescribeSObjectResult getSObjectDescribe(String objectName) {
        return Schema.getGlobalDescribe().get(objectName).getDescribe();
    }

    public static Id getRecordTypeIdByDevName(String objectName, String rtName) {
        Schema.DescribeSObjectResult obj = getSObjectDescribe(objectName);
        return obj.getRecordTypeInfosByName().get(rtName).getRecordTypeId();
    }

    public static String getRecordTypeLabelNameById(String objectName, String rtId) {
        Schema.DescribeSObjectResult obj = getSObjectDescribe(objectName);
        return obj.getRecordTypeInfosById().get(rtId).getName();
    }

    public static String getRecordTypeDevNameById(String objectName, String rtId) {
        Schema.DescribeSObjectResult obj = getSObjectDescribe(objectName);
        return obj.getRecordTypeInfosById().get(rtId).getDeveloperName();
    }

    public static Boolean isFieldAccessible(String objectName, String fieldName) {
        Schema.DescribeSObjectResult obj = getSObjectDescribe(objectName);
        return obj.fields.getMap().get(fieldName).getDescribe().isAccessible();
    }

    public static Boolean isFieldUpdateable(String objectName, String fieldName) {
        Schema.DescribeSObjectResult obj = getSObjectDescribe(objectName);
        return obj.fields.getMap().get(fieldName).getDescribe().isUpdateable();
    }

    public static Boolean isFieldCreateable(String objectName, String fieldName) {
        Schema.DescribeSObjectResult obj = getSObjectDescribe(objectName);
        return obj.fields.getMap().get(fieldName).getDescribe().isCreateable();
    }

    public static Boolean isObjectAccessible(String objectName) {
        Schema.DescribeSObjectResult obj = getSObjectDescribe(objectName);
        return obj.isAccessible();
    }

    public static Boolean isObjectCreateable(String objectName) {
        Schema.DescribeSObjectResult obj = getSObjectDescribe(objectName);
        return obj.isCreateable();
    }

    public static Boolean isObjectDeletable(String objectName) {
        Schema.DescribeSObjectResult obj = getSObjectDescribe(objectName);
        return obj.isDeletable();
    }

    public static Boolean isObjectUpdateable(String objectName) {
        Schema.DescribeSObjectResult obj = getSObjectDescribe(objectName);
        return obj.isUpdateable();
    }
    /**
     * REST callouts
     */
    public static HttpRequest preparePostRequest() {
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setTimeout(120000);
        return request;
    }

    public static HttpRequest prepareGetRequest() {
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setTimeout(120000);
        return request;
    }

    public static HttpRequest prepareDeleteRequest() {
        HttpRequest request = new HttpRequest();
        request.setMethod('DELETE');
        request.setTimeout(120000);
        return request;
    }

    public static HttpRequest setNamedCredential(HttpRequest request, String namedCredential) {
        if (String.isNotBlank(namedCredential)) {
            request.setEndpoint('callout: ' + namedCredential);
        }
        return request;
    }

    public static HttpRequest setEndpoint(HttpRequest request, String endPoint) {
        if (String.isNotBlank(endPoint)) {
            request.setEndpoint(endPoint);
        }
        return request;
    }

    public static HttpRequest setBody(HttpRequest request, String body) {
        if (String.isNotBlank(body)) {
            request.setBody(body);
        }
        return request;
    }

    public static HttpRequest setHeaders(HttpRequest request, Map<String, String> headers) {
        if (headers != null && headers.size() > 0) {
            for (String index : headers.keySet()) {
                request.setHeader(index, headers.get(index));
            }
        }
        return request;
    }

    public static HttpRequest preparePostRequestWithNamedCredentials(String namedCredential, String requestBody, Map<String, String> requestHeaders) {
        HttpRequest request = preparePostRequest();
        request = setNamedCredential(request, namedCredential);
        request = setBody(request, requestBody);
        request = setHeaders(request, requestHeaders);
        return request;
    }

    public static HttpRequest preparePostRequestWithAuthBearer(String authToken, String requestBody, Map<String, String> requestHeaders) {
        HttpRequest request = preparePostRequest();
        request = setHeaders(request, new Map<String, String>{'Authorization' => 'Bearer ' + authToken});
        request = setBody(request, requestBody);
        request = setHeaders(request, requestHeaders);
        return request;
    }

    public static HttpRequest preparePostRequestWithEndpoint(String endPoint, String requestBody, Map<String, String> requestHeaders) {
        HttpRequest request = preparePostRequest();
        request = setEndpoint(request, endPoint);
        request = setBody(request, requestBody);
        request = setHeaders(request, requestHeaders);
        return request;
    }

    public static HttpRequest prepareGetRequestWithEndpointAndAuth(String endPoint, String authToken, String requestBody, Map<String, String> requestHeaders) {
        HttpRequest request = prepareGetRequest();
        request = setHeaders(request, new Map<String, String>{'Authorization' => 'Bearer ' + authToken});
        request = setEndpoint(request, endPoint);
        request = setBody(request, requestBody);
        request = setHeaders(request, requestHeaders);
        return request;
    }

    public static HttpRequest prepareGetRequestWithNamedCredentials(String namedCredential, String requestBody, Map<String, String> requestHeaders) {
        HttpRequest request = prepareGetRequest();
        request = setNamedCredential(request, namedCredential);
        request = setBody(request, requestBody);
        request = setHeaders(request, requestHeaders);
        return request;
    }

    public static HttpRequest prepareGetRequestWithEndpointWithoutAuth(String endPoint, String requestBody, Map<String, String> requestHeaders) {
        HttpRequest request = prepareGetRequest();
        request = setEndpoint(request, endPoint);
        request = setHeaders(request, requestHeaders);
        return request;
    }

    public static HttpRequest prepareDeleteRequestWithNamedCredentials(String namedCredential, String requestBody, Map<String, String> requestHeaders) {
        HttpRequest request = prepareDeleteRequest();
        request = setNamedCredential(request, namedCredential);
        request = setHeaders(request, requestHeaders);
        return request;
    }

    public static HttpResponse makeCalloutToSFRestApi(String restAPIUrl) {
        String sfdcURL = CRMF_Utilities.getSFInstanceUrl();
        String fullAPIUrl = sfdcURL + restAPIUrl;
        String response = ''        ;
        Http http = new Http();

        HttpRequest httpRequest = CRMF_Utilities.prepareGetRequestWithEndpointAndAuth(fullAPIUrl, UserInfo.getSessionID(), null, null);
        HttpResponse httpResponse = http.send(httpRequest);

        return httpResponse;
    }

    public static HttpResponse getPicklistValuesForSpecifiedFieldAndRecordType(String objectName, String fieldName, String recordTypeId, String restAPIUrl, Integer version) {
        String apiUrl = '/services/data/v ' + version + '.0/ui-api/object-info/' + objectName + '/picklist-values/' + recordTypeId + '/' + fieldName;
        return CRMF_Utilities.makeCalloutToSFRestApi(apiUrl);
    }

    /*
    Jordan's method for dependent picklist values retrieval - START
    */
    public static ConfigurationFieldDependency getDependentPicklistValues(Schema.DescribeFieldResult depend) {
        Schema.sObjectField controlToken = depend.getController();
        if (controlToken == null) {
            return null;
        }
        Schema.DescribeFieldResult control = controlToken.getDescribe();
        List<Schema.PicklistEntry> controlEntries = (control.getType() == Schema.DisplayType.Boolean ? null : control.getPicklistValues());
        String base64map = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
        ConfigurationFieldDependency controlFieldDependency = new ConfigurationFieldDependency();
        controlFieldDependency.control_field_name = control.getName();
        controlFieldDependency.control_field_label = control.getLabel();
        controlFieldDependency.values_map = new Map<string,List<FileViewerSelectOption>>();

        for (Schema.PicklistEntry entry : depend.getPicklistValues()) {
            if (entry.isActive()) {
                Map<String,Object> mmm = (Map<String,Object>)JSON.deserializeUntyped(JSON.serialize(entry));
                List<String> base64chars = String.valueOf (((Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(entry))).get('validFor')).split('');
                for (Integer index = 0; index < (controlEntries != null ? controlEntries.size() : 2); index++) {
                    String controlValue = null;
                    if (controlEntries == null) {
                        controlValue = (index == 1) ? 'true' : 'false';
                    } else {
                        if (controlEntries[index].isActive()) {
                            controlValue = controlEntries[index].getLabel();
                        } else {
                            controlValue = null;
                        }
                    }
                    Integer bitIndex = index / 6, bitShift = 5 - Math.mod(index, 6);
                    if (controlValue == null || (base64map.indexOf(base64chars[bitIndex]) & (1 << bitShift)) == 0) {
                        continue;
                    }
                    if (!controlFieldDependency.values_map.containsKey(controlValue)) {
                        controlFieldDependency.values_map.put(controlValue, new List<FileViewerSelectOption>());
                    }
                    controlFieldDependency.values_map.get(controlValue).add(new FileViewerSelectOption().withLabel(entry.getLabel()).withValue(entry.getValue()));
                }
            }
        }
        return controlFieldDependency;
    }

    public with sharing class ConfigurationFieldDependency {
        public string control_field_name {get;set;}
        public string control_field_label {get;set;}
        public Map<string,List<FileViewerSelectOption>> values_map {get;set;}
    }

    public class FileViewerSelectOption implements Comparable {
        public string label {get;set;}
        public string value {get;set;}

        public FileViewerSelectOption() {
        }

        public FileViewerSelectOption withLabel(string label) {
            this.label = label;
            return this;
        }

        public FileViewerSelectOption withValue(string value) {
            this.value = value;
            return this;
        }

        public Integer compareTo (Object compareTo) {
            FileViewerSelectOption thatWrapper = (FileViewerSelectOption)compareTo;
            FileViewerSelectOption thisWrapper = this;
            if (thisWrapper.label == thatWrapper.label) {
                return 0;
            }
            if (thisWrapper.label > thatWrapper.label) {
                return 1;
            } else {
                return -1;
            }
        }
    }
    /*
    Jordan's method for dependent picklist values retrieval - END
    */
    List<sObject> querryBuilder(String objectName, String fieldsList, String whereConditions) {
        String query = 'SELECT ' + fieldsList + ' FROM ' + objectName + ' WHERE ' + whereConditions;
        return Database.query(query);
    }
}