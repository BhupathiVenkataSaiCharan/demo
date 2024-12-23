import { LightningElement } from 'lwc';

export default class DynamicOnChange extends LightningElement {

    fName = '';

    handleChange(event){
        const {name,value} = event.target;
        this[name] = value;
    }

    handleSubmit(){
        this.fName = this.firstName;
    }
}