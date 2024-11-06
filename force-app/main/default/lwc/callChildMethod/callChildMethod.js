import { LightningElement } from 'lwc';

export default class CallChildMethod extends LightningElement {
    
    childMethod(){
        this.template.querySelector("c-child-method").handleClick();
    }
}