import { LightningElement } from 'lwc';

export default class GetChildList extends LightningElement {
    namesfromchild=[];
    emailfromchild = '';

    handleList(event){
        console.log('names list ===> ', JSON.stringify(event.detail.names));
        console.log('names list ===> ', JSON.stringify(event.detail.names[0].first));
        console.log('names list ===> ', JSON.stringify(event.detail.names[1].second));
        this.namefromchild = event.detail.names;
        this.emailfromchild = event.detail.email;
    }
}