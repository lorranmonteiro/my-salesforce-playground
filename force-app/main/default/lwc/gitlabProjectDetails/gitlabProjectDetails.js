import { LightningElement, wire } from 'lwc';
import { publish, MessageContext } from 'lightning/messageService';
import ACCOUNT_CHANNEL from '@salesforce/messageChannel/GitlabProjectAccountDetails__c';
import getProjectDetails from '@salesforce/apex/GitLabProjectInfo.getProjectDetails';

const ACCOUNT_NUMBER = '88274515';

export default class GitLabProjectInfo extends LightningElement {

    projectDetails;
    errorMessage;

    @wire(MessageContext) messageContext;

    @wire(getProjectDetails)
    wiredProjectDetails({ error, data }) {
        if (data) {
            this.projectDetails = data;
            this.errorMessage = undefined;

            publish(this.messageContext, ACCOUNT_CHANNEL, {
                accountNumber: ACCOUNT_NUMBER,
                accountSite: this.projectDetails.web_url || '',
            });
        } else if (error) {
            this.errorMessage = `Failed to fetch project details: ${error.body?.message || error.message}`;
            this.projectDetails = undefined;
        }
    }
}