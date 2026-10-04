import { LightningElement } from 'lwc';
import portfolioImagesURL from '@salesforce/resourceUrl/PortfolioImages';
import TitleLabel from "@salesforce/label/c.PortfolioTitle";
import Summary from "@salesforce/label/c.PortfolioSummary";
import SalesforceCoreLabel from "@salesforce/label/c.PortfolioSalesforceCore";
import SoftwareBackgroundLabel from "@salesforce/label/c.PortfolioTechnicalBackground";
import AiDrivenLabel from "@salesforce/label/c.PortfolioAiDriven";

export default class PortfolioHero extends LightningElement {

    profileImage = portfolioImagesURL + '/profile.png';

    labels = {
        Title: TitleLabel,
        Summary: Summary
    };

    highlights = [
        {
            imgSrc: portfolioImagesURL + '/salesforce.svg',
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
