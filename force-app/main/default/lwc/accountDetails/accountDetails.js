import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getAccountByNumber from '@salesforce/apex/AccountSelector.getAccountsByAccountNumber';

import { subscribe, MessageContext } from 'lightning/messageService';
import ACCOUNT_CHANNEL from '@salesforce/messageChannel/GitlabProjectAccountDetails__c';

import NAME_FIELD from '@salesforce/schema/Account.Name';
import TYPE_FIELD from '@salesforce/schema/Account.Type';
import CREATED_DATE_FIELD from '@salesforce/schema/Account.CreatedDate';
import SITE_FIELD from '@salesforce/schema/Account.Site';
import ACCOUNT_NUMBER_FIELD from '@salesforce/schema/Account.AccountNumber';

const FIELDS = [NAME_FIELD, TYPE_FIELD, CREATED_DATE_FIELD, SITE_FIELD, ACCOUNT_NUMBER_FIELD];

export default class AccountDetails extends LightningElement {

    @api recordId;

    accountData;
    editedFields = {};
    accountNumber;
    accountSite;
    error;
    subscription = null;

    @wire(MessageContext) messageContext;

    connectedCallback() {
        this.subscribeToMessageChannel();
    }

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredAccount({ error, data }) {
        if (data) {
            this.accountData = this.buildAccountData(data);
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.accountData = undefined;
        }
    }

    // Handle input field changes and store the updated values
    handleInputChange(event) {
        const field = event.target.dataset.field;
        const value = event.target.value;
        this.editedFields[field] = value;
    }

    async handleSave() {
        const updatedRecord = {
            Id: this.accountData.Id,
            ...this.editedFields
        };

        const recordInput = { fields: updatedRecord };

        try {
            await updateRecord(recordInput);

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Account updated successfully.',
                    variant: 'success'
                })
            );
        } catch (error) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Error updating account: ' + error.body.message,
                    variant: 'error'
                })
            );
        }
    }

    subscribeToMessageChannel() {
        this.subscription = subscribe(
            this.messageContext,
            ACCOUNT_CHANNEL,
            (message) => this.handleMessage(message)
        );
    }

    async handleMessage(message) {
        this.accountNumber = message.accountNumber;
        this.accountSite = message.accountSite;

        try {
            const accounts = await getAccountByNumber({ accountNumber: this.accountNumber });
            const account = accounts.length > 0 ? accounts[0] : null;

            if (account) {
                this.accountData = this.buildAccountData(account);
                this.error = undefined;
            } else {
                this.accountData = undefined;
                this.error = 'No account found with the provided account number.';
            }
        } catch (error) {
            this.accountData = undefined;
            this.error = error.body?.message || error.message;
        }
    }

    buildAccountData(account) {
        const isWireData = account.fields !== undefined;

        return {
            Id: isWireData ? account.id : account.Id,
            Name: isWireData ? account.fields.Name.value : account.Name,
            Type: isWireData ? account.fields.Type.value : account.Type,
            Site: this.accountSite || (isWireData ? account.fields.Site?.value : account.Site),
            AccountNumber: this.accountNumber || (isWireData ? account.fields.AccountNumber?.value : account.AccountNumber),
            CreatedDate: this.getFormattedDate(isWireData ? account.fields.CreatedDate.value : account.CreatedDate)
        };
    }

    getFormattedDate(dateString) {
        let date = new Date(dateString);
        return date.toLocaleDateString('pt-BR');
    }
}