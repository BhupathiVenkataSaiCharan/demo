import { LightningElement, wire } from 'lwc';
import getContacts from '@salesforce/apex/LightningDatatableController.getContacts';

export default class LightningDatatable extends LightningElement {

    columns = [
        {label : 'Contact Name', fieldName : 'Name'},
        {label : 'Phone', fieldName : 'Phone'},
        {label : 'Account Name', fieldName : 'accName'},
        {
            type : 'action',
            typeAttributes : {
                rowActions : [
                    {label : 'Edit', name : 'edit'},
                    {label : 'Delete', name : 'delete'}
                ]
            }
        }
    ];
    data = [];
    error;

    @wire(getContacts)
    wiredContacts({data,error}){
        if(data){
            this.data = data.map(contact => {
                console.log('Contact ===> ', contact.Account?.Name)             //to leave empty accountname for contacts error
                return({
                    ...contact,
                    accName : `${contact.Account?.Name || ' '}`                 //assigning the value as empty if not related to any account
                })
            });
        }
        else{
            this.error = error;
        }
    }

    handleRowAction(event){
        const action = event.detail.action.name;
        const row = event.detail.row;
        this.selectedRowId = row.Id;
    }
}