import { api, LightningElement, track, wire } from 'lwc';
import getCaseRecords from '@salesforce/apex/FilterCasesOnClientSideController.getCaseRecords';

export default class FilterCasesOnClientSide extends LightningElement {

    @api recordId;
    contacts = [];
    cases = [];
    columns = [
        {label : 'Case Number', fieldName : 'caseUrl', type : 'url', typeAttributes : {label : {fieldName : 'CaseNumber'}}},
        {label : 'Case Status', fieldName : 'Status'},
        {label : 'Created Date', fieldName : 'CreatedDate'},
        {label : 'Last Modified Date', fieldName : 'LastModifiedDate'}
    ];

    statusValue = 'All';
    dateValue = 'All';
    contactValue = 'All';

    @wire(getCaseRecords,{ accId : '$recordId'})
    wiredCases({data,error}){
        if(data){
            this.contacts = data.contacts || [];
            this.cases = data.cases.map(caseList=>({
                    ...caseList,
                    caseUrl : `/${caseList.Id}`
            })) || [];
        }else{
            console.log(error);
        }
    }

    get filteredCases(){
        // console.log('Items list ===> ', JSON.stringify(this.cases));
        return this.cases.filter(item => {
            console.log('item: ', JSON.stringify(item));
            console.log('item.status: ', JSON.stringify(item.Status));
            console.log('this.statusvalue ', JSON.stringify(this.statusValue));
            return this.statusValue === 'All' ? true : item.Status === this.statusValue;
        })
        .filter(item => {
            switch (this.dateValue) {
                case 'today':
                    // return item.CreatedDate.slice(0, 10) == new Date().toISOString().slice(0, 10);
                    return new Date(item.CreatedDate).getDate() == new Date().getDate();
                case 'pastMonth':
                    var month1 = new Date(item.CreatedDate).getMonth();
                    var month2 = new Date().getMonth();
                    
                    return month2-month1 == 0;
                default:
                    return true;
            }
        })
       .filter(item=>{
            switch (this.contactValue){
                case 'All' : 
                    return true;
                default : 
                    return item.ContactId == this.contactValue
            }
        })
    }

    handleStatus(e){
        this.statusValue = e.target.value;
    }
    handleDate(e){
        this.dateValue = e.target.value;
    }
    handleContact(e){
        this.contactValue = e.target.value;
    }

    get statusOptions(){
        return [
            {label : 'All', value : 'All'},
            {label : 'New', value : 'New'},
            {label : 'Working', value : 'Working'},
            {label : 'Escalated', value : 'Escalated'}
        ]
    }
    get dateOptions(){
        return [
            {label : 'All', value : 'All'},
            {label : 'Today', value : 'today'},
            {label : 'Last 30 Days', value : 'pastMonth'},
        ]
    }

    get contactOptions(){
        return[
            {label : 'All', value : 'All'},
            ...this.contacts.map(conList=>({
                label : conList.Name,
                value : conList.Id
            }))
        ]
    }
}