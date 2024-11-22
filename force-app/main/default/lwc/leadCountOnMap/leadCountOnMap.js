import { LightningElement, wire } from 'lwc';
import getLeadCount from '@salesforce/apex/LeadCountOnMapController.getLeadCount';

export default class LeadCountOnMap extends LightningElement {

    data = [];

    @wire(getLeadCount)
    wiredLeadCount({ data, error }) {
        if(data){
            this.data = data || [
                {
                    location : {
                        City : 'Hyderabad',
                        Country : 'India'
                    },
                    title : 'Hyderabad',
                    description: '2'
                }
            ];
        }
    }

    get defaultMark() {
        return this.data.map(item => ({
            location: {
                City: item.city,
                Country: 'India'
            },
            title: item.city,
            description: `Count : ${item.count}`
        }));
    }
    
}