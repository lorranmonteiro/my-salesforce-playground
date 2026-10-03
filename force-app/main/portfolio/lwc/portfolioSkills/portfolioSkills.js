import { LightningElement } from 'lwc';
import ApexLabel from "@salesforce/label/c.PortfolioApex";
import RestApiLabel from "@salesforce/label/c.PortfolioRestApi";
import LwcLabel from "@salesforce/label/c.PortfolioLwc";
import PlatformEventsLabel from "@salesforce/label/c.PortfolioPlatformEvents";
import LowCodeLabel from "@salesforce/label/c.PortfolioLowCode";
import CiCdLabel from "@salesforce/label/c.PortfolioCiCd";

export default class PortfolioSkills extends LightningElement {
    skills = [
        {
            id: 'apex',
            iconName: 'standard:apex',
            title: 'Apex',
            description: ApexLabel
        },
        {
            id: 'rest-api',
            iconName: 'standard:data_transforms',
            title: 'REST APIs',
            description: RestApiLabel
        },
        {
            id: 'lwc',
            iconName: 'standard:lightning_component',
            title: 'Lightning Web Components',
            description: LwcLabel
        },
        {
            id: 'platform-events',
            iconName: 'standard:events',
            title: 'Platform Events & CDC',
            description: PlatformEventsLabel
        },
        {
            id: 'low-code',
            iconName: 'standard:flow',
            title: 'Low-Code Development',
            description: LowCodeLabel
        },
        {
            id: 'cicd',
            iconName: 'standard:dx_pipeline',
            title: 'CI/CD Pipelines & Salesforce DX',
            description: CiCdLabel
        }
    ];
}
