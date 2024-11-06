import { LightningElement } from 'lwc';
import sendEmail from '@salesforce/apex/UserLookupController.sendEmail';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class UserLookup extends LightningElement {
    userId;

    handleChange(event){
        this.userId = event.detail.recordId;
    }

    sendEmail(){
        console.log('User Id ====> ', this.userId);
        sendEmail({recId : this.userId})
        .then(result=>{
            this.showToast('SUCCESS','Email Sent Successfully','success');
        })
        .catch(error=>{
            this.showToast('FAILED','Error Sending Email','error');
        })
    }

    showToast(title,message,variant){
        this.dispatchEvent(new ShowToastEvent({
            title : title,
            message : message,
            variant : variant
        }))
    }
}