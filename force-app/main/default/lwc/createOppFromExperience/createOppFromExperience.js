import { LightningElement, wire } from 'lwc';
import getProductsList from '@salesforce/apex/createOppFromExperienceController.getProductsList';
import createOrder from '@salesforce/apex/createOppFromExperienceController.createOrder';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CreateOppFromExperience extends LightningElement {

    firstName = '';
    lastName = '';
    email = '';
    userDetails = [];

    columns = [
        {label : 'Id', fieldName : 'Id'},
        {label : 'Product Name', fieldName : 'Name'},
        {label : 'Price per unit', fieldName : 'UnitPrice'}
    ];

    products = [];
    selectedProducts = [];
    orderList = [];

    userInfo = true;
    selectPage = false;
    orderPage = false;


    connectedCallback(){
        this.showToast('Toast Check','Toast Working fine','success');
    }

    //On change for User details 
    handleDetails(event){
        const name = event.target.name;
        if(name === 'firstName'){
            this.firstName = event.target.value;
        }
        if(name === 'lastName'){
            this.lastName = event.target.value;
        }
        if(name === 'Email'){
            this.email = event.target.value;
        }
    }

    //save user details and add products
    handleSave(){
        this.userInfo = false;
        this.selectPage = true;
        this.userDetails = [{
            FName : this.firstName,
            LName : this.lastName,
            Email : this.email
        }];
        console.log('Before toast');
        this.showToast('Toast Check 1','Toast Working fine','success');
        console.log('After toast');
    }

    //go back to user details
    handlePrevious(){
        this.selectPage = false;
        this.userInfo = true;
        this.firstName =this.userDetails[0].FName;
        this.lastName = this.userDetails[0].LName;
        this.email = this.userDetails[0].Email;
    }

    //get the list of products name and price
    @wire(getProductsList)
    wiredProducts({data,error}){
        console.log('data', data);
        this.showToast('Toast Check 2','Toast Working fine','success');
        if(data){
            console.log('data', data);
            this.products = data.map(item=>({
                ...item,
                Name : item.Product2.Name
            }))
        }
        else{
            console.log('error', error);
        }
    }
    
    //add selected rows to list
    handleRowSelection(event){
        this.selectedProducts = event.detail.selectedRows.map(item=>({
            Name : item.Product2.Name,
            Price : item.UnitPrice,
            Product2Id : item.Id
        }));
    }
    
    get ifSelected(){
        return this.selectedProducts.length == 0;
    }

    //add quantity for selected products
    handleNext(event){
        this.selectPage = false;
        this.orderPage = true;
        console.log('Selected products', JSON.stringify(this.selectedProducts));
    }


    // onchange of quantity assign it particular product
    handleChange(event){
        this.selectedProducts = this.selectedProducts.map(item=>{
            if(item.Product2Id == event.target.dataset.id){
                return {
                    ...item,
                    Quantity:event.target.value
                }
            }else{
                return item;
            }
        })
        console.log('this.selectedProducts: ', JSON.stringify(this.selectedProducts));
    }

    
    handleBack(){
        this.selectPage = true;
        this.orderPage = false;
    }

    handleOrder(){
        this.selectedProducts = this.selectedProducts.map(item=>({
            Name : item.Name,
            Price : item.Price,
            Quantity : item.Quantity,
            Product2Id : item.Product2Id
        }))
        console.log('this.selectedProducts: ', JSON.stringify(this.selectedProducts));
        this.createOrderMethod();
        this.resetOrder();
    }

    createOrderMethod(){
        console.log('selected products list', JSON.stringify(this.selectedProducts)); 
        createOrder({conEmail : this.email, lName : this.lastName, fName : this.firstName, productListJSON : JSON.stringify(this.selectedProducts)})
        .then(result=>{
        })
        .catch(error=>{
            console.error('Error creating order', error);
        })
    }


    resetOrder(){
        this.selectedProducts = [];
        this.firstName = '';
        this.lastName = '';
        this.email = '';
        this.userInfo = true;
        this.selectPage = false;
        this.orderPage = false;
    }

    showToast(title,message,variant){
        this.dispatchEvent(new ShowToastEvent({
            title : title,
            message : message,
            variant : variant
        }))
    }

}