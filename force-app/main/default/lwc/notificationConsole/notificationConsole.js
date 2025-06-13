import { LightningElement, track } from "lwc";
import { subscribe, unsubscribe, onError } from "lightning/empApi";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class NotificationConsole extends LightningElement {
  
    @track notifications = [];

    get notificationCount() {
        return this.notifications.length;
    }
  
    async connectedCallback() {
        onError((error) => {
            this.dispatchEvent(
                new ShowToastEvent({
                variant: "error",
                title: "EMP API Error",
                message: JSON.stringify(error)
                })
            );
        });

        this.subscription = await subscribe(
            "/event/Notification__e",
            -1,
            (event) => this.handleNotificationEvent(event)
        );

        this.dispatchEvent(
            new ShowToastEvent({
                variant: "success",
                title: "Ready to receive notifications"
            })
        );
    }

    disconnectedCallback() {
        unsubscribe(this.subscription);
    }

    handleClearClick() {
        this.notifications = [];
    }

    handleNotificationEvent(event) {
        console.dir(event);

        const id = event.data.event.replayId;
        const message = event.data.payload.Message__c;
        const utcDate = new Date(event.data.payload.CreatedDate);
        const time = `${utcDate.getMinutes()}:${utcDate.getSeconds()}`;

        this.notifications.push({
            id,
            message,
            time
        });

        this.dispatchEvent(
            new ShowToastEvent({
            variant: "info",
            title: message
            })
        );
    }
}