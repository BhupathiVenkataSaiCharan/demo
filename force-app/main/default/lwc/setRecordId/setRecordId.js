import { api, LightningElement } from 'lwc';

export default class SetRecordId extends LightningElement {
    
    _recordId;

    @api set recordId(value){
        this._recordId = value;

        // do your thing right here with this.recordId / value
    }

    get recordId(){
        return this._recordId;
    }
}