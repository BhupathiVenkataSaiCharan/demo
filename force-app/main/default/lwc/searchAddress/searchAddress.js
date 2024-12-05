import { LightningElement } from 'lwc';
import fetchAddress from '@salesforce/apex/SearchAddressController.fetchAddress';

export default class SearchAddress extends LightningElement {

    searchKey = '';
    suggestions = [];

    address1 ='';
    address2 = '';
    postCode = '';
    city = '';

    handleSearch(e){
        this.searchKey = e.target.value;
            this.searchResults();
        // console.log('Search value: ', this.searchVal);
    }

    searchResults(){
        // console.log('Search results: ', val);
        fetchAddress({query : this.searchKey})
        .then(result => {
            // console.log('result:', result);
            this.suggestions = result;
            // console.log('suggestions:', this.suggestions);
        })
        .catch(error=>{
            console.error('Error: ', error);
        })
    }

    handleSelect(event){

        console.log('event ===>' ,event.target.dataset.value);
        
        const fullAddress = event.target.dataset.value;

        const splitAddress = fullAddress.split(',')

        this.address1 = splitAddress[0];
        this.address2 = splitAddress[1];

        console.log('split address length', splitAddress.length - 1);
        console.log('split address length', splitAddress[splitAddress.length - 1]);

        const postndcity = splitAddress[splitAddress.length - 1].split(' ');
        
        this.postCode = postndcity[1];

        this.city = postndcity[2];


    }
}