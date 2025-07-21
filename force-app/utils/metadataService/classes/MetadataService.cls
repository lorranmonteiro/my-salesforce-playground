@SuppressWarnings('PMD')
public class MetadataService {

    public static String SOAP_M_URI = 'http://soap.sforce.com/2006/04/metadata';

    public virtual class Metadata {
        public String fullName;
    }

    public class NamedCredential extends Metadata {
        public String label;
        public String endpoint;
        public String principalType;
        public String protocol;
    }

    public class SaveResult {
        public MetadataService.Error[] errors;
        public String fullName;
        public Boolean success;
    }

    public class Error {
        public String message;
        public String statusCode;
    }

    public class updateMetadata_element {
        public MetadataService.Metadata[] metadata;
    }

    public class updateMetadataResponse_element {
        public MetadataService.SaveResult[] result;
    }

    public class SessionHeader_element {
        public String sessionId;
    }

    public class MetadataPort {
        public MetadataService.SessionHeader_element SessionHeader;
        public String endpoint_x = URL.getOrgDomainUrl().toExternalForm() + '/services/Soap/m/64.0';

        public MetadataService.SaveResult[] updateMetadata(MetadataService.Metadata[] metadata) {

            MetadataService.updateMetadata_element request_x = new MetadataService.updateMetadata_element();
            request_x.metadata = metadata;

            MetadataService.updateMetadataResponse_element response_x;
            Map<String, MetadataService.updateMetadataResponse_element> response_map_x = new Map<String, MetadataService.updateMetadataResponse_element>();
            response_map_x.put('response_x', response_x);
            
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              SOAP_M_URI,
              'updateMetadata',
              SOAP_M_URI,
              'updateMetadataResponse',
              'MetadataService.updateMetadataResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
    }
}
