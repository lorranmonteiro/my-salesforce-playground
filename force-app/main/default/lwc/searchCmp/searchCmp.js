import { LightningElement } from 'lwc';
import searchWithAi from '@salesforce/apex/SearchCmp.search';

export default class Search extends LightningElement {

    userInput;
    aiResponse;
    errorMessage;
    isLoading = false;

    get isIAResponseEmpty() {
        return this.aiResponse === undefined || this.aiResponse === null || this.aiResponse.trim() === '';
    }

    handleInputChange(event) {
        this.userInput = event.target.value;
    }

    handleClear() {
        this.aiResponse = null;
        this.errorMessage = null;
    }

    async handleSearch() {
        this.errorMessage = null;
        this.aiResponse = null;

        if (this.userInput == undefined || this.userInput.trim() === '') {
            this.errorMessage = 'Input cannot be empty';
            return;
        }

        this.isLoading = true;

        try {
            this.aiResponse = await searchWithAi({ textInput: this.userInput });
            this.errorMessage = undefined;
        } catch (error) {
            this.errorMessage = error.body ? error.body.message : 'An unexpected error occurred';
            this.aiResponse = undefined;
        }

        this.isLoading = false;
    }
}