@IsTest
@SuppressWarnings('PMD')
private class PrepareMySandboxTest {

    @IsTest
    static void testMySandboxPrep() {
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        String orgId = UserInfo.getOrganizationId();

        Test.testSandboxPostCopyScript(
            new PrepareMySandbox(),
            orgId,
            orgId,
            UserInfo.getOrganizationName(),
            true
        );
    }

    private class WebServiceMockImpl implements WebServiceMock  {

		public void doInvoke(
			Object stub, Object request, Map<String, Object> response,
			String endpoint, String soapAction, String requestName,
			String responseNS, String responseName, String responseType) {

            response.put('response_x', new MetadataService.updateMetadataResponse_element());
		}
	}
}
