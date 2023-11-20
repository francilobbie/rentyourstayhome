import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="stripe-elements-form"
export default class extends Controller {
  submitButtonClass = "w-full rounded-md border border-transparent bg-indigo-600 mt-4 cursor-pointer px-4 py-3 text-base font-medium text-white shadow-sm hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 focus:ring-offset-gray-50"

  connect() {
    this.getStripeSubmitButton().className += this.submitButtonClass;
    this.getStripeFormLabel().className += " hidden";
    this.getStripeCardElement().className += " mt-4";
  }

  getStripeSubmitButton() {
    return document.querySelector('#stripe-form input[type=submit]')
  }

  getStripeFormLabel() {
    return document.querySelector('label[for="card_element"]')
  }

  getStripeCardElement() {
    return document.getElementById('card-element')
  }
}
