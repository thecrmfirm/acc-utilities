public class CRMF_Utilities {

    public void printFullDebug(String fullDebugLog) {
        for (Integer i = 0; i <= fullDebugLog.length(); i=i+300) {
            Integer endPosition = (i+300 > (fullDebugLog.length()) ? fullDebugLog.length() : i+300);
            System.debug(fullDebugLog.subString(i,endPosition));
        }
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
}