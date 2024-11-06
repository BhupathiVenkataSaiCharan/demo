import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ParentMethod extends LightningElement {
    handleClick(){
        this.dispatchEvent(new ShowToastEvent({
            title : 'SUCCESS',
            message : 'Hi from Parent',
            variant : 'success'
        }));
    }
}