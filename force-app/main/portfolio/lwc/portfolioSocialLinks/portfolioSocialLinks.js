import { LightningElement } from 'lwc';
import GmailLabel from "@salesforce/label/c.PortfolioGmail";
import LinkedInLabel from "@salesforce/label/c.PortfolioLinkedIn";
import GitHubLabel from "@salesforce/label/c.PortfolioGitHub";
import ResumeLabel from "@salesforce/label/c.PortfolioResume";
import TrailblazerLabel from "@salesforce/label/c.PortfolioTrailblazer";

export default class PortfolioSocialLinks extends LightningElement {
    links = [
        {
            id: 'gmail',
            iconName: 'standard:email_chatter',
            title: 'Gmail',
            description: GmailLabel,
            url: 'mailto:lorrandec@gmail.com'
        },
        {
            id: 'linkedin',
            iconName: 'standard:link',
            title: 'LinkedIn',
            description: LinkedInLabel,
            url: 'https://www.linkedin.com/in/lorranmonteiro'
        },
        {
            id: 'resume',
            iconName: 'doctype:pdf',
            title: 'Download Resume',
            description: ResumeLabel,
            url: 'https://drive.google.com/uc?export=download&id=1a0pck9n5bgl652YbF_rIAMDuwrTQ9o_c'
        },
        {
            id: 'github',
            iconName: 'action:apex',
            title: 'Portfolio on GitHub',
            description: GitHubLabel,
            url: 'https://github.com/lorranmonteiro/my-salesforce-playground'
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
