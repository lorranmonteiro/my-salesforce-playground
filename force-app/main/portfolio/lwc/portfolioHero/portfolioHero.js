import { LightningElement } from 'lwc';
import PORTFOLIO_IMAGES_URL from '@salesforce/resourceUrl/PortfolioImages';

export default class PortfolioHero extends LightningElement {

    profileImage = PORTFOLIO_IMAGES_URL + '/Profile.png';
}
