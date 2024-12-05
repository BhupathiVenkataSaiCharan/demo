import { api, LightningElement, wire } from 'lwc';
import getProducts from '@salesforce/apex/AddCustomProductsController.getProducts';
import { CloseActionScreenEvent } from 'lightning/actions';
import createLineItems from '@salesforce/apex/AddCustomProductsController.createLineItems';

export default class AddCustomProducts extends LightningElement {
    
    @api recordId;
    products = [];
    columns = [
        {label : 'Product Name', fieldName : 'Name'}
    ];
    selectedProducts = [];
    isProducts = true;
    prodQuantity = 0;
    prodPrice = 0;
    prodTotal = 0;
    createProducts = [];

    @wire(getProducts)
    wiredLineItems({data,error}){
        if(data){
            this.products = data;
            console.log('Products not empty ===> ', this.products);
        }
        else{
            console.log('Error ===> ' , error);        
        }
    }

    handleNext(){
        this.isProducts = false;
    }

    get ifProduct(){
        return this.selectedProducts.length == 0;
    }

    handleRowSelection(event){
        this.selectedProducts = event.detail.selectedRows;
    }


    // handleQuantity(event){
    //     this.prodQuantity = event.target.value;
    //     this.prodTotal = this.prodQuantity * this.prodPrice;
    // }
    // handlePrice(event){
    //     this.prodPrice = event.target.value;
    //     this.prodTotal = this.prodQuantity * this.prodPrice;
    // }

    handleTotal(event){
        const name = event.target.name;
        if(name == 'Quantity'){
            this.prodQuantity = event.target.value;
        }
        if(name == 'Price'){
            this.prodPrice = event.target.value;
        }
        this.prodTotal = this.prodQuantity * this.prodPrice;
    }

    handleAddProducts(event){
        this.closeAction();
        console.log('Selected Products ===> ', this.selectedProducts);
        this.createProducts = this.selectedProducts.map(item=>({
            Name : 'Products',
            CustomOpportunity__c : this.recordId,
            CustomProduct__c : item.Id,
            Quantity__c : this.prodQuantity,
            Price__c : this.prodPrice,
            Total_Amount__c : this.prodTotal
        }))
        console.log('Selected Products ===> ', JSON.stringify(this.createProducts));  
        createLineItems({lineItemList : JSON.stringify(this.createProducts)})
        .then(result=>{
            console.log('Result ===> ', result);
        })
        .catch(error=>{
            console.log('Error ===> ', error);
        })
    }
    closeAction(){
        this.dispatchEvent(new CloseActionScreenEvent());
        console.log('Close Action==>');
        setTimeout(()=>{
            window.location.reload();
            console.log('reload')
        },1000);
    }
}