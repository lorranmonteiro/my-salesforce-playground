import { LightningElement, api } from 'lwc';

export default class Paginator extends LightningElement {

    @api hasPrevious = false;
    @api hasNext = false;

    get notHasPrevious() {
        return !this.hasPrevious;
    }

    get notHasNext() {
        return !this.hasNext;
    }

    handlePrevious() {
        if (this.hasPrevious) {
            this.dispatchEvent(new CustomEvent('previous'));
        }
    }

    handleNext() {
        if (this.hasNext) {
            this.dispatchEvent(new CustomEvent('next'));
        }
    }
}