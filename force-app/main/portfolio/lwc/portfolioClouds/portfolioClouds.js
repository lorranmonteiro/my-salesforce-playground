import { LightningElement } from 'lwc';
import CloudsTitleLabel from "@salesforce/label/c.PortfolioCloudsSectionTitle";
import SalesCloudLabel from "@salesforce/label/c.PortfolioSalesCloud";
import ServiceCloudLabel from "@salesforce/label/c.PortfolioServiceCloud";
import ExperienceCloudLabel from "@salesforce/label/c.PortfolioExperienceCloud";

export default class PortfolioClouds extends LightningElement {

    titleLabel = CloudsTitleLabel;

    clouds = [
        {
            id: 'sales-cloud',
            iconName: 'custom:custom14',
            title: 'Sales Cloud',
            description: SalesCloudLabel
        },
        {
            id: 'service-cloud',
            iconName: 'custom:custom1',
            title: 'Service Cloud',
            description: ServiceCloudLabel
        },
        {
            id: 'experience-cloud',
            iconName: 'custom:custom103',
            title: 'Experience Cloud',
            description: ExperienceCloudLabel
        }
    ];
}
