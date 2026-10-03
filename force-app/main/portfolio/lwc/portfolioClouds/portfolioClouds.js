import { LightningElement } from 'lwc';
import SalesCloudLabel from "@salesforce/label/c.PortfolioSalesCloud";
import ServiceCloudLabel from "@salesforce/label/c.PortfolioServiceCloud";
import ExperienceCloudLabel from "@salesforce/label/c.PortfolioExperienceCloud";

export default class PortfolioClouds extends LightningElement {
    clouds = [
        {
            id: 'sales-cloud',
            iconName: 'standard:high_velocity_sales',
            title: 'Sales Cloud',
            description: SalesCloudLabel
        },
        {
            id: 'service-cloud',
            iconName: 'standard:knowledge',
            title: 'Service Cloud',
            description: ServiceCloudLabel
        },
        {
            id: 'experience-cloud',
            iconName: 'standard:customer_360',
            title: 'Experience Cloud',
            description: ExperienceCloudLabel
        }
    ];
}
