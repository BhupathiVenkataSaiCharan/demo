import { LightningElement, wire } from 'lwc';
import getAccounts from '@salesforce/apex/ServerSideSortingController.getAccounts';
import getTotal from '@salesforce/apex/ServerSideSortingController.getTotal';

export default class ServerSideSorting extends LightningElement {

    data = [];
    error;
    columns = [
        {label : 'Id', fieldName : 'Id', sortable : true},
        {label : 'Name', fieldName : 'Name', sortable : true},
        {label : 'Industry', fieldName : 'Industry', sortable : true}
    ];

    sortedBy = 'Name';
    sortedDirection = 'ASC';

    pageSize = 5;
    pageNumber = 1;

    totalRecords;
    countError;

    @wire(getAccounts,{orderBy : '$sortedBy', orderDirection : '$sortedDirection', pageSize : '$pageSize', pageNumber : '$pageNumber'})
    wireData({data,error}){
        if(data){
            this.data = data;
        }else{
            this.error = JSON.stringify(error);
        }
    }

    @wire(getTotal)
    wiredTotal({data,error}){
        if(data){
            this.totalRecords = data;
        }
        else{
            this.countError = error;
        }
    }

    handleSort(event){
        this.sortedBy = event.detail.fieldName;
        this.sortedDirection = event.detail.sortDirection;
    }

    handleNext(){
        if(this.pageNumber < Math.ceil(this.totalRecords/this.pageSize)){
            this.pageNumber++;
        }
    }

    handlePrevious(){
        if(this.pageNumber > 1){
            this.pageNumber--;
        }
    }

    get disablePrevious(){
        return this.pageNumber === 1;
    }
    get disableNext(){
        return this.pageNumber === Math.ceil(this.totalRecords/this.pageSize);
    }
}