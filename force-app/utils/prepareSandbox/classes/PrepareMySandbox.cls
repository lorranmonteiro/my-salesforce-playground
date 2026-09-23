@SuppressWarnings('PMD.AvoidGlobalModifier')
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

        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();

        if (!metadatas.isEmpty()) service.updateMetadata(metadatas);
    }
}
