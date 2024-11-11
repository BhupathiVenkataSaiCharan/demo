import { LightningElement, wire } from 'lwc';
import getAccountRecords from '@salesforce/apex/SearchOccuranceController.getAccountRecords';

export default class SearchOccurance extends LightningElement {

    accounts = [];
    searchTerm = '';

    handleInputChange(e){
        this.searchTerm = e.target.value.toLowerCase();
        console.log('SearchTerm ===> ', this.searchTerm);
    }
    
    @wire(getAccountRecords)
    wiredData({data,error}){
        if(data){
            this.accounts = data;
        }
        else{
            console.log('Error', JSON.stringify(error));
        }
    }

    get filteredAccounts(){
        return this.accounts
                    .filter(item=>item.Name.toLowerCase().includes(this.searchTerm))
                    .sort((a,b)=> a.Name.toLowerCase().indexOf(this.searchTerm) - b.Name.toLowerCase().indexOf(this.searchTerm));
    }
}