import { LightningElement } from 'lwc';

export default class Scenario3Parent extends LightningElement {
    
    showName(){
        this.template.querySelector("c-scenario3-child").toggleName();
    }
    showPhone(){
        this.template.querySelector("c-scenario3-child").togglePhone();
    }
    showEmail(){
        this.template.querySelector("c-scenario3-child").toggleEmail();
    }
}