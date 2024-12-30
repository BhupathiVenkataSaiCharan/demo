import { LightningElement } from 'lwc';

export default class CalculatorApp extends LightningElement {

    calcValue = '';
    calcResult;

    handleChange(e){
        const {name,value} = e.target;
        this[name] = value;
    }

    handleClick(e){
        const label = e.target.label;
        console.log('Event on click ===>', label);
        if(label === 'CLR'){
            this.calcValue = '';
            this.calcResult = '';
        }else if(label === '='){
            console.log('Before replace===>',this.calcValue);
            this.calcValue = this.calcValue.replace(/[\+\-\*\/]+$/, '');
            console.log('after replace ===>', this.calcValue);
            console.log('after eval===>', eval(this.calcValue));
            this.calcResult = eval(this.calcValue);
            // this.calcValue = '';
        }else{
            const lastChar = this.calcValue.slice(-1);
            if (['+', '-', '*', '/'].includes(label) && ['+', '-', '*', '/'].includes(lastChar)) {
                this.calcValue = this.calcValue.slice(0, -1) + label; // Replace last operator
            } else {
                this.calcValue += label;
            }
        }
    }
}