import { api, LightningElement } from 'lwc';
import USER_ID from '@salesforce/user/Id';
import OWNER_FIELD from '@salesforce/schema/Lead.OwnerId';
import { updateRecord } from 'lightning/uiRecordApi';
import { RefreshEvent } from 'lightning/refresh';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class SelfAssignLeadWithoutApex extends LightningElement {

    @api recordId;

    @api invoke(){
        updateRecord({
            fields : {
                Id : this.recordId,
                [OWNER_FIELD.fieldApiName] : USER_ID
            }
        })
        .then((result)=>{
            this.showToast('SUCCESS','Updated the Lead Owner','success');
            this.dispatchEvent(new RefreshEvent());
        })
        .catch(error=>{
            this.showToast('ERROR','Failed to Updated Lead Owner','error')
        })
    }

    showToast(title,message,variant){
        this.dispatchEvent(
            new ShowToastEvent({
                title : title,
                message : message,
                variant : variant
            })
        );
    }

}