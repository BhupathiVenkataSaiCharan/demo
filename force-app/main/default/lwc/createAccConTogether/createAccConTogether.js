import { LightningElement } from 'lwc';
import createAccCon from '@salesforce/apex/CreateAccConTogetherController.createAccCon';
import Email from '@salesforce/schema/Contact.Email';

export default class CreateAccConTogether extends LightningElement {

    accountName = '';
    contactLastName = '';
    contactEmail = '';

    file;

    handleFile(event){
        this.file = event.target.files[0];
    }

    handleInput(event){
        this[event.target.dataset.id] = event.target.value;
    }


    handleSave(){
        console.log('Account Name ===> ', this.accountName);
        console.log('Contact Last Name ===> ', this.contactLastName);
        console.log('Contact Email ===> ', this.contactEmail);
        
        createAccCon({accName : this.accountName, conName : this.contactLastName, conEmail : this.contactEmail, file : this.file})
        .then(result=>{
            this.clearInputs();
        })
        .catch(error=>{
            alert('Failed to create records');
        })
    }

    clearInputs(){
        this.accountName = '';
        this.contactLastName = '';
        this.contactEmail = '';
        this.file = null;
    }
}