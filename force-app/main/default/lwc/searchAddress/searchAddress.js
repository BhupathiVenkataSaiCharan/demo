import { LightningElement } from 'lwc';
import fetchAddress from '@salesforce/apex/SearchAddressController.fetchAddress';

export default class SearchAddress extends LightningElement {

    searchKey = '';
    suggestions = [];

    handleSearch(e){
        this.searchKey = e.target.value;
        if(this.searchKey.length>10){
            this.searchResults();
        }
        // console.log('Search value: ', this.searchVal);
    }

    searchResults(){
        // console.log('Search results: ', val);
        fetchAddress({query : this.searchKey})
        .then(result => {
            this.suggestions = result;
        })
        .catch(error=>{
            console.error('Error: ', error);
        })
    }
}