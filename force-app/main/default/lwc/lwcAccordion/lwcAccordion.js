import { LightningElement, track, wire } from 'lwc';
import getAccounts from '@salesforce/apex/LwcAccordionController.getAccounts';
import getContacts from '@salesforce/apex/LwcAccordionController.getContacts';

export default class LwcAccordion extends LightningElement {

    @track accounts = [];
    currentAccId = '';
    @track contacts = [];

    @wire(getAccounts)
    wiredData({data,error}){
        if(data){
            this.accounts = data;
            console.log('Accounts===>', JSON.stringify(this.accounts));
        }else{
            console.log(error);
        }
    }

    handleClick(e){
        console.log(e.target.dataset.id);
        this.currentAccId = e.target.dataset.id;

        getContacts({accId : this.currentAccId})
        .then(result=>{
            console.log(result);
            this.contacts = result;
            console.log(this.contacts);
        })
        .catch(error=>{
            console.log(error);
        })
    }
}