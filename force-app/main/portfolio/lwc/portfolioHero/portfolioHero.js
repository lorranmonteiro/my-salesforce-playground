import { LightningElement } from 'lwc';
import portfolioImagesURL from '@salesforce/resourceUrl/PortfolioImages';
import Summary from "@salesforce/label/c.PortfolioSummary";
import SalesforceCoreLabel from "@salesforce/label/c.PortfolioSalesforceCore";
import SoftwareBackgroundLabel from "@salesforce/label/c.PortfolioTechnicalBackground";
import AiDrivenLabel from "@salesforce/label/c.PortfolioAiDriven";

const PROFILE_IMAGE_URL = portfolioImagesURL + '/Profile.png';

export default class PortfolioHero extends LightningElement {

    profileImage = PROFILE_IMAGE_URL;

    labels = {
        Summary
    };

    highlights = [
        {
            icon: 'utility:salesforce1',
            text: SalesforceCoreLabel
        },
        {
            icon: 'standard:code_playground',
            text: SoftwareBackgroundLabel
        },
        {
            icon: 'standard:agent_astro',
            text: AiDrivenLabel
        }
    ];
}
