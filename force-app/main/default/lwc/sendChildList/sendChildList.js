import { api, LightningElement } from 'lwc';

export default class SendChildList extends LightningElement {

    sendList(){
        this.dispatchEvent(new CustomEvent(
            'sendlist',
            {
                detail : {
                    names : [
                        {
                            first : 'John'
                        },
                        {
                            second : 'Smith'
                        }
                    ],
                    email : 'email'
                }
            } 
        ));
    }
}