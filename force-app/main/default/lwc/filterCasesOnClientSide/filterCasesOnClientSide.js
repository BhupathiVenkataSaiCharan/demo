import { api, LightningElement, wire } from 'lwc';
import getCaseRecords from '@salesforce/apex/FilterCasesOnClientSideController.getCaseRecords';

export default class FilterCasesOnClientSide extends LightningElement {

    @api recordId;
    contacts = [];
    cases = [];

    columns = [
        {label : 'Case Number', fieldName : 'CaseNumber'},
        {label : 'Case Status', fieldName : 'Status'},
        {label : 'Created Date', fieldName : 'CreatedDate'},
        {label : 'Last Modified Date', fieldName : 'LastModifiedDate'}
    ];


    @wire(getCaseRecords, { accId : '$recordId' })
    wiredData({data,error}){
        if(data){
            this.contacts = data.contacts || [];
            this.cases = data.cases || [];
        }else{
            console.log('Error',JSON.stringify(error));
        }
    }
}