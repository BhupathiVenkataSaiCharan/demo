import { api, LightningElement, wire } from 'lwc';
import getCaseList from '@salesforce/apex/datatableWithFiltersController.getCaseList';


export default class DatatableWithFilters extends LightningElement {

    @api recordId;
    contacts = [];
    cases = [];

    columns = [
        {label : 'Case Number', fieldName : 'caseUrl', type : 'url', typeAttributes : { label : {fieldName : 'CaseNumber'}}},
        {label : 'Case Status', fieldName : 'Status'},
        {label : 'Created Date', fieldName : 'CreatedDate'},
        {label : 'Last Modified Date', fieldName : 'LastModifiedDate'}
    ];

    statusValue = '';
    dateValue = '';
    contactsValue = '';

    get statusOptions(){
        return [
            {label : 'All', value : ''},
            {label : 'New', value : 'New'},
            {label : 'Working', value : 'Working'},
            {label : 'Escalated', value : 'Escalated'},
        ]
    }

    get dateOptions(){
        return [
            {label : 'All', value : ''},
            {label : 'Today', value : 'today'},
            {label : 'Last 30 Days', value : 'last30days'}
        ]
    }

    get contactOptions(){
        return [
            {label : 'All', value : ''},
            ...this.contacts.map(contact=>({
                label : contact.Name,
                value : contact.Id
            }))
        ];
    }

    handleStatus(event){
        this.statusValue = event.target.value;
    }

    handleDate(event){
        this.dateValue = event.target.value;
        console.log('Date ===> ', this.dateValue);
    }
    
    handleContacts(event){
        this.contactsValue = event.target.value;
    }

    @wire(getCaseList,{accId : '$recordId', status : '$statusValue', createddate : '$dateValue', contact : '$contactsValue'})
    wiredData({data,error}){
        console.log('RecordId==>', this.recordId);
        console.log('CCC==>', JSON.stringify(data));
        if(data){
            console.log('Contacts===>', JSON.stringify(data.contacts))
            console.log('Cases===>', JSON.stringify(data.cases))
            this.contacts = data.contacts || [];
            this.cases = data.cases?.map(caselist=>({
                ...caselist,
                caseUrl : `/${caselist.Id}`
            })) || [];
        }else{
            console.log('Error', JSON.stringify(error));
        }
    }

}