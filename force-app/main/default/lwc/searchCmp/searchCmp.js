import { LightningElement } from 'lwc';
import searchWithAi from '@salesforce/apex/SearchCmp.search';
import { loadScript } from 'lightning/platformResourceLoader';
import markdownIt from '@salesforce/resourceUrl/MarkdownIt';

export default class Search extends LightningElement {

    userInput;
    aiResponse;
    errorMessage;
    parsedResponse;
    isLoading = false;

    get isIAResponseEmpty() {
        return this.aiResponse === undefined || this.aiResponse === null || this.aiResponse.trim() === '';
    }

    connectedCallback() {
        loadScript(this, markdownIt);
    }

    renderedCallback() {
        if (this.parsedResponse) {
            const container = this.template.querySelector('.markdown-output');

            // eslint-disable-next-line @lwc/lwc/no-inner-html
            if (container) container.innerHTML = this.parsedResponse;
        }
    }

    handleInputChange(event) {
        this.userInput = event.target.value;
    }

    handleClear() {
        this.aiResponse = null;
        this.errorMessage = null;
        this.parsedResponse = null;
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

            const md = window.markdownit();
            this.parsedResponse = md.render(this.aiResponse);

            this.errorMessage = undefined;
        } catch (error) {
            this.errorMessage = error.body?.message || error.message;
            this.aiResponse = undefined;
        }

        this.isLoading = false;
    }
}