import { api, LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ChildMethod extends LightningElement {

    @api handleClick(){
        this.dispatchEvent(new ShowToastEvent({
            title : 'SUCCESS',
            message : 'Hi from Child',
            variant : 'success'
        }));
    }
}