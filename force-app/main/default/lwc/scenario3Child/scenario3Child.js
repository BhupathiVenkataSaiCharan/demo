import { api, LightningElement } from 'lwc';

export default class Scenario3Child extends LightningElement {
    Name = '';
    Phone = '';
    Email = '';

    @api showName = false;
    showPhone = false;
    showEmail = false;

    handleChange(event){
        const name = event.target.name;
        const value = event.target.value;

        if(name === 'Name'){
            this.Name = value;
        }
        if(name === 'Phone'){
            this.Phone = value;
        }
        if(name === 'Email'){
            this.Email = value;
        }
    }


    @api toggleName(){
        this.showName = !this.showName;
    }
    @api togglePhone(){
        this.showPhone = !this.showPhone;
    }
    @api toggleEmail(){
        this.showEmail = !this.showEmail;
    }


    get nameClass(){
        return this.showName ? '' : 'hidden'
    }

    get phoneClass(){
        return this.showPhone ? '' : 'hidden'
    }

    get emailClass(){
        return this.showEmail ? '' : 'hidden'
    }
}