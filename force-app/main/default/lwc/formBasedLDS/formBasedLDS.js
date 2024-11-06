import { LightningElement } from 'lwc';
import NAME_FIELD from '@salesforce/schema/Contact.Name';

export default class FormBasedLDS extends LightningElement {
    fields = [NAME_FIELD];
}