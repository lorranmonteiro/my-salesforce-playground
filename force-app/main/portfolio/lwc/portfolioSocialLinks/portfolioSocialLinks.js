import { LightningElement } from 'lwc';
import portfolioImagesURL from '@salesforce/resourceUrl/PortfolioImages';
import SocialTitleLabel from '@salesforce/label/c.PortfolioSocialSectionTitle';
import GmailLabel from '@salesforce/label/c.PortfolioGmail';
import LinkedInLabel from '@salesforce/label/c.PortfolioLinkedIn';
import GitHubLabel from '@salesforce/label/c.PortfolioGitHub';
import ResumeLabel from '@salesforce/label/c.PortfolioResume';
import TrailblazerLabel from '@salesforce/label/c.PortfolioTrailblazer';

const IMAGES = portfolioImagesURL + '/';

export default class PortfolioSocialLinks extends LightningElement {

    titleLabel = SocialTitleLabel;

    links = [
        {
            id: 'gmail',
            title: 'Email',
            description: GmailLabel,
            url: 'mailto:contact@lorranmonteiro.dev',
            iconName: 'standard:email_chatter'
        },
        {
            id: 'linkedin',
            title: 'LinkedIn',
            description: LinkedInLabel,
            url: 'https://www.linkedin.com/in/lorranmonteiro',
            imgSrc: IMAGES + 'linkedin.svg'
        },
        {
            id: 'resume',
            iconName: 'doctype:pdf',
            title: 'Resume',
            description: ResumeLabel,
            url: 'https://drive.google.com/uc?export=download&id=1a0pck9n5bgl652YbF_rIAMDuwrTQ9o_c'
        },
        {
            id: 'github',
            title: 'GitHub',
            description: GitHubLabel,
            url: 'https://github.com/lorranmonteiro/my-salesforce-playground',
            imgSrc: IMAGES + 'github.svg'
        },
        {
            id: 'trailblazer',
            iconName: 'standard:trailhead_alt',
            title: 'Trailblazer Community',
            description: TrailblazerLabel,
            url: 'https://www.salesforce.com/trailblazer/lorranmonteiro'
        }
    ];
}
