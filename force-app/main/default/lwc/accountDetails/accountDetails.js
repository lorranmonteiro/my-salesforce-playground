import { LightningElement, api, wire } from 'lwc';
import { getRecord, updateRecord } from 'lightning/uiRecordApi';
import { getPicklistValues, getObjectInfo } from "lightning/uiObjectInfoApi";
import { getRelatedListRecords } from 'lightning/uiRelatedListApi';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getAccountByNumber from '@salesforce/apex/AccountDetails.getAccountsByAccountNumber';
import { loadStyle } from 'lightning/platformResourceLoader';
import globalStyles from '@salesforce/resourceUrl/GlobalCSS';

import { subscribe, unsubscribe, MessageContext } from 'lightning/messageService';
import ACCOUNT_CHANNEL from '@salesforce/messageChannel/GitlabProjectAccountDetails__c';

import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import ID_FIELD from '@salesforce/schema/Account.Id';
import NAME_FIELD from '@salesforce/schema/Account.Name';
import TYPE_FIELD from '@salesforce/schema/Account.Type';
import CREATED_DATE_FIELD from '@salesforce/schema/Account.CreatedDate';
import SITE_FIELD from '@salesforce/schema/Account.Site';
import NUMBER_FIELD from '@salesforce/schema/Account.AccountNumber';

import CONTACT_ID_FIELD from '@salesforce/schema/Contact.Id';
import CONTACT_NAME_FIELD from '@salesforce/schema/Contact.Name';
import CONTACT_PHONE_FIELD from '@salesforce/schema/Contact.Phone';
import CONTACT_EMAIL_FIELD from '@salesforce/schema/Contact.Email';

const ACCOUNT_FIELDS = [ID_FIELD, NAME_FIELD, TYPE_FIELD, CREATED_DATE_FIELD, SITE_FIELD, NUMBER_FIELD];
const CONTACT_RELATED_LIST = 'Contacts';
const CONTACT_FIELDS = [
    CONTACT_ID_FIELD,
    CONTACT_NAME_FIELD,
    CONTACT_PHONE_FIELD,
    CONTACT_EMAIL_FIELD
].map(field => `${field.objectApiName}.${field.fieldApiName}`);

export default class AccountDetails extends NavigationMixin(LightningElement) {

    @api recordId;

    accountId;
    accountData;
    accountNumber;
    accountSite;
    accountTypes;

    contactRecords;
    numberOfUpdatedContacts = 0;

    editedFields = {};
    error;

    blockSaveButton = true;
    subscription = null;

    @wire(MessageContext) messageContext;

    @wire(getObjectInfo, { objectApiName: ACCOUNT_OBJECT })
    accountObjectInfo;

    @wire(getRelatedListRecords, {
        parentRecordId: '$accountId',
        relatedListId: CONTACT_RELATED_LIST,
        fields: CONTACT_FIELDS
    })
    relatedContacts({ error, data }) {
        if (data) {
            this.contactRecords = data.records;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.contactRecords = undefined;
        }
    }

    @wire(getPicklistValues, { recordTypeId: "$recordTypeId", fieldApiName: TYPE_FIELD })
    typePicklist({ error, data }) {
        if (data) {
            this.accountTypes = data.values.map(picklistValue => ({
                label: picklistValue.label,
                value: picklistValue.value
            }));

            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.accountTypes = undefined;
        }
    }

    @wire(getRecord, { recordId: '$recordId', fields: ACCOUNT_FIELDS })
    wiredAccount({ error, data }) {
        if (data) {
            this.accountId = data.fields.Id.value;
            this.accountData = this.buildAccountData(data);
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.accountData = undefined;
        }
    }

    get isDataLoaded() {
        return this.accountData && this.accountTypes && this.contactRecords;
    }

    get recordTypeId() {
        return this.accountObjectInfo.data?.defaultRecordTypeId;
    }

    get isNumberOfUpdatedContactsPositive() {
        return this.numberOfUpdatedContacts > 0;
    }

    connectedCallback() {
        this.subscribeToMessageChannel();

        loadStyle(this, globalStyles);
    }

    disconnectedCallback() {
        unsubscribe(this.subscription);
    }

    handleInputChange(event) {
        const field = event.target.dataset.field;
        const value = event.target.value;
        this.editedFields[field] = value;

        this.blockSaveButton = false;
    }

    async handleSave() {
        const updatedRecord = {
            Id: this.accountData.Id,
            ...this.editedFields
        };

        const recordInput = { fields: updatedRecord };

        try {
            await updateRecord(recordInput);
            this.editedFields = {};

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
                    message: 'Error updating account: ' + (error.body?.message || error.message),
                    variant: 'error'
                })
            );
        }
    }

    handleContactUpdate(event) {
        this.numberOfUpdatedContacts++;
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
                this.accountId = account.Id;
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

    handleViewRecord() {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.accountId,
                objectApiName: ACCOUNT_OBJECT.objectApiName,
                actionName: 'view'
            }
        });
    }

    buildAccountData(account) {
        const isWireData = account.fields !== undefined;

        return {
            Id: this.accountId,
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