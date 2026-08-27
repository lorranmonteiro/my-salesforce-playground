@SuppressWarnings('PMD')
global with sharing class PrepareMySandbox implements SandboxPostCopy {

    global PrepareMySandbox() {
        //Implementations of SandboxPostCopy must have a no-arg constructor.
        //This constructor is used during the sandbox copy process.
    }

    global void runApexClass(SandboxContext context) {
        updateNamedCredentials();
    }

    private void updateNamedCredentials() {
        List<MetadataService.Metadata> metadatas = new List<MetadataService.Metadata>();

        for (NamedCredential namedCredential : [SELECT Endpoint, MasterLabel, DeveloperName FROM NamedCredential]) {

            // Only works with legacy Named Credentials
            if (namedCredential.Endpoint == null) { continue; }

            MetadataService.NamedCredential credential = new MetadataService.NamedCredential();
            credential.fullName = namedCredential.DeveloperName;
            credential.label = namedCredential.MasterLabel;
            credential.endpoint = namedCredential.Endpoint + '.invalid';
            credential.principalType = 'NamedUser';
            credential.protocol = 'NoAuthentication';

            metadatas.add(credential);
        }

        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();

        if (!metadatas.isEmpty() && !Test.isRunningTest()) { service.updateMetadata(metadatas); }
    }
}
