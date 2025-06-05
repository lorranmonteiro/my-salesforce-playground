import { LightningElement, api, wire, track } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

// Define the fields you want to fetch for the Account
const FIELDS = ['Account.Name', 'Account.Type', 'Account.CreatedDate'];

export default class AccountDetails extends LightningElement {
    @api recordId; // The Account record ID passed to the component
    accountData; // Holds the Account data
    error; // Holds any error messages
    @track updatedFields = {}; // Tracks the fields modified by the user

    // Wire adapter to fetch Account details using uiRecordApi
    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredAccount({ error, data }) {
        if (data) {
            // Store the Account data in the component
            this.accountData = {
                Id: data.id,
                Name: data.fields.Name.value,
                Type: data.fields.Type.value,
                CreatedDate: data.fields.CreatedDate.value
            };
            this.error = undefined;
        } else if (error) {
            // Handle any errors
            this.error = error;
            this.accountData = undefined;
        }
    }

    // Handle input field changes and store the updated values
    handleInputChange(event) {
        const field = event.target.dataset.field;
        const value = event.target.value;
        this.updatedFields[field] = value;
    }

    // Handle the Save button click
    async handleSave() {
        // Create a new object with the updated fields
        const updatedRecord = {
            Id: this.accountData.Id,
            ...this.updatedFields
        };

        // Prepare the record input for the update
        const recordInput = { fields: updatedRecord };

        try {
            // Call updateRecord to save the changes
            await updateRecord(recordInput);

            // Show success * message
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Account updated successfully.',
                    variant: 'success'
                })
            );
        } catch (error) {
            // Show error * message
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Error updating account: ' + error.body.message,
                    variant: 'error'
                })
            );
        }
    }
}