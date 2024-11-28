import { LightningElement } from 'lwc';
import fetchAddress from '@salesforce/apex/SearchAddressController.fetchAddress';

export default class SearchAddress extends LightningElement {

    searchKey = '';
    suggestions = [];

    handleSearch(e){
        this.searchKey = e.target.value;
            this.searchResults();
        // console.log('Search value: ', this.searchVal);
    }

    searchResults(){
        // console.log('Search results: ', val);
        fetchAddress({query : this.searchKey})
        .then(result => {
            console.log('result:', result);
            this.suggestions = result;
            console.log('suggestions:', this.suggestions);
        })
        .catch(error=>{
            console.error('Error: ', error);
        })
    }
}