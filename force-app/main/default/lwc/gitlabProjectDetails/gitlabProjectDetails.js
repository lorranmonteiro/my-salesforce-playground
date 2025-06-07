import { LightningElement, wire } from 'lwc';
import getProjectDetails from '@salesforce/apex/GitLabProjectInfo.getProjectDetails';

export default class GitLabProjectInfo extends LightningElement {

    projectDetails;
    errorMessage;

    @wire(getProjectDetails)
    wiredProjectDetails({ error, data }) {
        if (data) {
            this.projectDetails = data;
            this.errorMessage = undefined;
        } else if (error) {
            this.errorMessage = 'Failed to fetch * project details:' + error.body.message;
            this.projectDetails = undefined;
        }
    }
}