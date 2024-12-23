import { LightningElement } from 'lwc';
import getContacts from '@salesforce/apex/SearchContactsController.getContacts';

export default class SearchContacts extends LightningElement {

    searchVal = '';
    contacts = [];
    errorMessage = '';
    showError = false;
    showNoRecords = false;

    handleChange(event){
        this.searchVal = event.target.value;
    }

    handleSearch(){
        getContacts({searchKey : this.searchVal})
        .then(result=>{
            console.log('result',JSON.stringify(result));
            
            if(result.length > 0){
                this.contacts = result;
            }else{
                this.showNoRecords = true;
            }
        })
        .catch(error=>{
            this.errorMessage = error.body.message;
        })
    }
}