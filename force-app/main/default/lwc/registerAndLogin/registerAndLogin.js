import { LightningElement } from 'lwc';
import createNewUser from '@salesforce/apex/RegisterAndLoginController.createNewUser';
import checkUser from '@salesforce/apex/RegisterAndLoginController.checkUser';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

export default class RegisterAndLogin extends LightningElement {

    //variables for log in
    userEmail = '';
    userPassword = '';

    //variables for sign up
    newuserFirstName = '';
    newUserLastName = '';
    newUserEmail = '';
    newUserPassword = '';


    //onchange for inputs
    handleChange(event){
        const{name,value} = event.target;
        this[name] = value;
    }

    //user login with validation
    handleLogin(){
        this.userEmail = this.Email;
        this.userPassword = this.Password;
        console.log(this.userEmail);
        console.log(this.userPassword);
        checkUser({uEmail : this.userEmail, uPassword : this.userPassword})
        .then(result=>{
            console.log(result);
            if(result){
                this.showToast('SUCCESS', 'User is available in the org','success');
            }else{
                this.showToast('ERROR', 'Username and Passwords does not match','error');    
            }
        })
        .catch(error=>{
            console.log(error.body.message);
            this.showToast('ERROR2', error.body.message,'error');
        })
    }


    //onclick for user creation with password
    handleSignup(){
        this.newUserCreation();
    }

    //imperative call to create new user 
    newUserCreation(){
        this.newuserFirstName = this.newFirstName;
        this.newUserLastName = this.newLastName;
        this.newUserEmail = this.newEmail;
        this.newUserPassword = this.newPassword;
        createNewUser({fName : this.newuserFirstName, lName : this.newLastName, uEmail : this.newEmail, uPassword : this.newUserPassword})
        .then(result=>{
            this.showToast('SUCCESS', 'User Creation is Successful','success');
            this.newUserFirstName = '';
            this.newUserLastName = '';
            this.newUserEmail = '';
            this.newUserPassword = '';
        })
        .catch(error=>{
            console.log('Error===>', JSON.stringify(error))
            this.showToast('ERROR', error.body.message,'error');
        })
    }

    //toast message to show success or failure
    showToast(title,message,variant){
        this.dispatchEvent(new ShowToastEvent({
            title : title,
            message : message,
            variant : variant
        }));
    }


    
}