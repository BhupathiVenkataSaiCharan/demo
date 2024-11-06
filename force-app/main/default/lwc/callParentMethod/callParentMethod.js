import { LightningElement } from 'lwc';

export default class CallParentMethod extends LightningElement {
    handleClick(){
        this.dispatchEvent(new CustomEvent('call'))
    }
}