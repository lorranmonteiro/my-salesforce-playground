import { LightningElement } from 'lwc';
import GmailLabel from "@salesforce/label/c.PortfolioGmail";
import LinkedInLabel from "@salesforce/label/c.PortfolioLinkedIn";
import GitHubLabel from "@salesforce/label/c.PortfolioGitHub";

export default class PortfolioSocialLinks extends LightningElement {
    links = [
        {
            id: 'gmail',
            iconName: 'standard:email_chatter',
            title: 'Gmail',
            description: GmailLabel,
            url: 'mailto:lorranmonteiro@gmail.com'
        },
        {
            id: 'linkedin',
            iconName: 'standard:link',
            title: 'LinkedIn',
            description: LinkedInLabel,
            url: 'https://www.linkedin.com/in/lorranmonteiro'
        },
        {
            id: 'github',
            iconName: 'action:apex',
            title: 'Portfolio on GitHub',
            description: GitHubLabel,
            url: 'https://github.com/lorranmonteiro/my-salesforce-playground'
        }
    ];
}
