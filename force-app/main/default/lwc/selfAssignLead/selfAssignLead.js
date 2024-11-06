import { api, LightningElement } from 'lwc';
import selfAssign from '@salesforce/apex/SelfAssignLeadController.selfAssign';
import {RefreshEvent} from 'lightning/refresh';

export default class SelfAssignLead extends LightningElement {

    @api recordId;

    @api invoke(){
        selfAssign({leadId : this.recordId})
        .then(result=>{
            this.dispatchEvent(new RefreshEvent());
        })
        .catch(error=>{

        })
    }
}