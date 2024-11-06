import { api, LightningElement, wire } from 'lwc';
import getContacts from '@salesforce/apex/AccountRelatedContacts.getContacts';

export default class ChildWireComponent extends LightningElement {
    
    @api accountId;

    data = [];
    error;
    columns = [
        {label : 'Id', fieldName : 'Id'},
        {label : 'Contact Name', fieldName : 'contactUrl',type : 'url', typeAttributes : {label : {fieldName : 'Name'}, target : '__self'}},
        {label: 'Account Name', fieldName : 'AccountName'}
    ];

    @wire(getContacts,{accId : '$accountId'})
    wiredContacts({data,error}){
        if(data){
            this.data = data.map(contact=>({
                ...contact,
                contactUrl : `/${contact.Id}`,
                AccountName : `${contact.Account.Name}`
            }));
        }else{
            this.error = error;
        }
    }
}