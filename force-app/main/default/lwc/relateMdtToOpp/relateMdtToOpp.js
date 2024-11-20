import { api, LightningElement, wire } from 'lwc';
import getMetadata from '@salesforce/apex/RelateMdtToOppController.getMetadata';
import updateOpportunity from '@salesforce/apex/RelateMdtToOppController.updateOpportunity';
import preCheckMetadata from '@salesforce/apex/RelateMdtToOppController.preCheckMetadata';

export default class RelateMdtToOpp extends LightningElement {
    
    @api recordId;
    metadata = [];
    checkedValues = [];

    savedValues = [];

    @wire(getMetadata)
    wiredMetadata({data,error}){
        if(data){
            this.metadata = data;
        }
        else{
            // console.log('Error');
        }
    }

    handleCheck(event){
        console.log('checked Id ===>', event.target.dataset.id);
        console.log('checked Label ===>', event.target.dataset.label);
        
        const mId = event.target.dataset.id;
        const mLabel = event.target.dataset.label;
        
        if(event.target.checked){
            this.checkedValues.push({
                Id : mId,
                Label : mLabel
            });
        }
        else{
            this.checkedValues = this.checkedValues.filter(item => item.Id !==mId);
        }
    }

    handleSave(){
        console.log('Checked Value ===> ', JSON.stringify(this.checkedValues));
        updateOpportunity({oppId : this.recordId, jsonData : JSON.stringify(this.checkedValues)})
        .then(result=>{
            console.log('Result ===> ', result);
        })
        .catch(error=>{
            console.log('Error ===> ', error);
        })
    }


    @wire(preCheckMetadata,{oppId : '$recordId'})
    wiredOpportunity({data,error}){
        if(data){
            this.savedValues = JSON.parse(data);
            this.preCheckInputs();
        }else{
            console.log('Error');
        }
    }

    preCheckInputs(){
        this.template.querySelectorAll('lightning-input').forEach(input=>{
            const ifChecked = this.savedValues.find(item=>item.Id === input.dataset.id);
            if(ifChecked){
                input.checked = true
                this.checkedValues.push(ifChecked);
            }
        })
    }
}