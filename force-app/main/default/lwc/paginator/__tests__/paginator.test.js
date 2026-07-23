import { createElement } from 'lwc';
import Paginator from 'c/paginator';

describe('c-paginator', () => {
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    function createComponent() {
        const element = createElement('c-paginator', {
            is: Paginator
        });
        document.body.appendChild(element);
        return element;
    }

    describe('default state', () => {
        it('hasPrevious defaults to false', () => {
            const element = createComponent();
            expect(element.hasPrevious).toBe(false);
        });

        it('hasNext defaults to false', () => {
            const element = createComponent();
            expect(element.hasNext).toBe(false);
        });
    });

    describe('handlePrevious', () => {
        it('dispatches "previous" event when Previous button is clicked and hasPrevious is true', () => {
            const element = createComponent();
            element.hasPrevious = true;

            const handler = jest.fn();
            element.addEventListener('previous', handler);

            return Promise.resolve().then(() => {
                const buttons = element.shadowRoot.querySelectorAll(
                    'lightning-button'
                );
                const prevButton = buttons[0];
                prevButton.click();
                expect(handler).toHaveBeenCalledTimes(1);
            });
        });

        it('does not dispatch "previous" event when Previous button is clicked and hasPrevious is false', () => {
            const element = createComponent();
            element.hasPrevious = false;

            const handler = jest.fn();
            element.addEventListener('previous', handler);

            return Promise.resolve().then(() => {
                const buttons = element.shadowRoot.querySelectorAll(
                    'lightning-button'
                );
                const prevButton = buttons[0];
                prevButton.click();
                expect(handler).not.toHaveBeenCalled();
            });
        });
    });

    describe('handleNext', () => {
        it('dispatches "next" event when Next button is clicked and hasNext is true', () => {
            const element = createComponent();
            element.hasNext = true;

            const handler = jest.fn();
            element.addEventListener('next', handler);

            return Promise.resolve().then(() => {
                const buttons = element.shadowRoot.querySelectorAll(
                    'lightning-button'
                );
                const nextButton = buttons[1];
                nextButton.click();
                expect(handler).toHaveBeenCalledTimes(1);
            });
        });

        it('does not dispatch "next" event when Next button is clicked and hasNext is false', () => {
            const element = createComponent();
            element.hasNext = false;

            const handler = jest.fn();
            element.addEventListener('next', handler);

            return Promise.resolve().then(() => {
                const buttons = element.shadowRoot.querySelectorAll(
                    'lightning-button'
                );
                const nextButton = buttons[1];
                nextButton.click();
                expect(handler).not.toHaveBeenCalled();
            });
        });
    });

    describe('button disabled state', () => {
        it('Previous button is disabled when hasPrevious is false', () => {
            const element = createComponent();
            return Promise.resolve().then(() => {
                const buttons = element.shadowRoot.querySelectorAll(
                    'lightning-button'
                );
                const prevButton = buttons[0];
                expect(prevButton.disabled).toBe(true);
            });
        });

        it('Previous button is enabled when hasPrevious is true', () => {
            const element = createComponent();
            element.hasPrevious = true;
            return Promise.resolve().then(() => {
                const buttons = element.shadowRoot.querySelectorAll(
                    'lightning-button'
                );
                const prevButton = buttons[0];
                expect(prevButton.disabled).toBe(false);
            });
        });

        it('Next button is disabled when hasNext is false', () => {
            const element = createComponent();
            return Promise.resolve().then(() => {
                const buttons = element.shadowRoot.querySelectorAll(
                    'lightning-button'
                );
                const nextButton = buttons[1];
                expect(nextButton.disabled).toBe(true);
            });
        });

        it('Next button is enabled when hasNext is true', () => {
            const element = createComponent();
            element.hasNext = true;
            return Promise.resolve().then(() => {
                const buttons = element.shadowRoot.querySelectorAll(
                    'lightning-button'
                );
                const nextButton = buttons[1];
                expect(nextButton.disabled).toBe(false);
            });
        });
    });
});
