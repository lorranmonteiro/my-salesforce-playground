import { LightningElement, api } from 'lwc';
import { updateRecord } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import CONTACT_OBJECT from '@salesforce/schema/Contact';

export default class ContactInfo extends NavigationMixin(LightningElement) {

    _record;
    blockSaveButton = true;
    editedFields = {};
    error;

    @api
    set record(value) {
        if (value?.fields) {
            this._record = {
                Id: value.fields.Id.value,
                Name: value.fields.Name.value,
                Email: value.fields.Email.value,
                Phone: value.fields.Phone.value
            };
        }
    }

    get record() {
        return this._record;
    }

    get isDataLoaded() {
        return this.record;
    }

    handleViewRecord() {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.record.Id,
                objectApiName: CONTACT_OBJECT.objectApiName,
                actionName: 'view'
            }
        });
    }

    handleInputChange(event) {
        const field = event.target.dataset.field;
        const value = event.target.value;
        this.editedFields[field] = value;

        this.blockSaveButton = false;
    }

    async handleSave() {
        const updatedRecord = {
            Id: this.record.Id,
            ...this.editedFields
        };

        const recordInput = { fields: updatedRecord };

        try {
            await updateRecord(recordInput);
            this.editedFields = {};

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Contact updated successfully.',
                    variant: 'success'
                })
            );

            this.dispatchEvent(new CustomEvent(
                'contactupdated',
                {
                    detail: updatedRecord,
                    bubbles: true
                }
            ));
        } catch (error) {
            this.error = error.body?.message || error.message;

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Error updating contact: ' + (error.body?.message || error.message),
                    variant: 'error'
                })
            );
        }
    }
}