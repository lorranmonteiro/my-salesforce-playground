import { LightningElement } from 'lwc';
import SkillsTitleLabel from "@salesforce/label/c.PortfolioSkillsSectionTitle";
import ApexLabel from "@salesforce/label/c.PortfolioApex";
import LwcLabel from "@salesforce/label/c.PortfolioLwc";
import RestApiLabel from "@salesforce/label/c.PortfolioRestApi";
import DeclarativeLabel from "@salesforce/label/c.PortfolioDeclarative";
import PlatformEventsLabel from "@salesforce/label/c.PortfolioPlatformEvents";
import CiCdLabel from "@salesforce/label/c.PortfolioCiCd";

export default class PortfolioSkills extends LightningElement {

    titleLabel = SkillsTitleLabel;

    skills = [
        {
            id: 'apex',
            iconName: 'standard:apex',
            title: 'Apex & Async Processing',
            description: ApexLabel
        },
        {
            id: 'lwc',
            iconName: 'custom:custom9',
            title: 'Lightning Web Components',
            description: LwcLabel
        },
        {
            id: 'declarative',
            iconName: 'standard:flow',
            title: 'Declarative Automation (Low-Code)',
            description: DeclarativeLabel
        },
        {
            id: 'rest-api',
            iconName: 'standard:data_transforms',
            title: 'REST API Integrations',
            description: RestApiLabel
        },
        {
            id: 'platform-events',
            iconName: 'custom:custom30',
            title: 'Platform Events & CDC',
            description: PlatformEventsLabel
        },
        {
            id: 'cicd',
            iconName: 'standard:dx_pipeline',
            title: 'CI/CD Pipelines with SFDX',
            description: CiCdLabel
        }
    ];
}