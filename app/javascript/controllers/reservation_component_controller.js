import { Controller } from "@hotwired/stimulus"
import { Datepicker } from "vanillajs-datepicker"
import Swal from "sweetalert2"

// Connects to data-controller="reservation-component"
export default class extends Controller {
  static targets = ['checkin', 'checkout', 'numOfNights', 'nightlyTotal', 'serviceFee', 'total']

  connect() {

    const checkinPicker = new Datepicker(this.checkinTarget, {
      minDate: this.element.dataset.defaultCheckinDate
    });


    const checkoutPicker = new Datepicker(this.checkoutTarget, {
      minDate: this.element.dataset.defaultCheckoutDate
    });

    this.checkinTarget.addEventListener('changeDate', (e) => {
      const date = new Date(e.target.value);
      date.setDate(date.getDate() + 1);
      checkoutPicker.setOptions({
        minDate: date
      })
      this.updateNightlyTotal();
    })

    this.checkoutTarget.addEventListener('changeDate', (e) => {
      const date = new Date(e.target.value);
      date.setDate(date.getDate() - 1);
      checkinPicker.setOptions({
        maxDate: date
      })
      this.updateNightlyTotal();
    })

  }

    calculateNightlyTotal() {
      const nightlyTotal = this.numberOfNights() * this.element.dataset.nightlyPrice;
      return nightlyTotal;
  }

  calculateServiceFee() {
      const serviceFee = (this.calculateNightlyTotal() * this.element.dataset.serviceFeePercentage).toFixed(2);
      return serviceFee;
  }

  updateNightlyTotal() {
      this.numOfNightsTarget.innerText = this.numberOfNights();
      const nightlyTotal = this.numberOfNights() * this.element.dataset.nightlyPrice;
      this.nightlyTotalTarget.innerText = `${nightlyTotal} €`;
      this.updateServiceFee(nightlyTotal);
  }

    updateServiceFee(nightlyTotal) {
      const serviceFee = (nightlyTotal * this.element.dataset.serviceFeePercentage).toFixed(2);
      this.serviceFeeTarget.innerText = `${serviceFee} €`;
      this.updateTotal();
}


  calculateTotal() {
      const total = (parseFloat(this.nightlyTotalTarget.innerText) + parseFloat(this.serviceFeeTarget.innerText) + parseFloat(this.element.dataset.cleaningFee)).toFixed(2);
      return total;
  }

  updateTotal() {
    const nightlyTotal = parseFloat(this.nightlyTotalTarget.innerText) || 0;
    const serviceFee = parseFloat(this.serviceFeeTarget.innerText) || 0;
    const cleaningFee = parseFloat(this.element.dataset.cleaningFee) || 0;

    const total = nightlyTotal + serviceFee + cleaningFee;

    this.totalTarget.innerText = `${total.toFixed(2)} €`;
}


  numberOfNights() {
    if (this.checkinTarget.value.trim().length === 0 || this.checkoutTarget.value.trim().length === 0) {
      return 0;
    }

    const checkinDate = new Date(this.checkinTarget.value);
    const checkoutDate = new Date(this.checkoutTarget.value);

    // Calculate the difference in days and round it
    const diffDays = Math.round((checkoutDate - checkinDate) / (1000 * 3600 * 24));

    return diffDays;
  }


  buildReservationParams() {
    const params = {
      checkin_date: this.checkinTarget.value,
      checkout_date: this.checkoutTarget.value,
      subtotal: this.calculateNightlyTotal(),
      cleaning_fee: parseFloat(this.element.dataset.cleaningFee),
      service_fee: this.calculateServiceFee(),
      total: this.calculateTotal(),  // Call the function with parentheses
    };

    const searchParams = new URLSearchParams(params);
    return searchParams.toString();
  }

  buildSubmitUrl(url) {
    return `${url}?${this.buildReservationParams()}`
  }

  sumbitReservationComponent(e) {
    if (this.checkinTarget.value.trim().length === 0 || this.checkoutTarget.value.trim().length === 0) {
      Swal.fire({
        text: 'Please select both the checkin and the checkout dates',
        icon: 'error'
      });
      return;
    }
    Turbo.visit(this.buildSubmitUrl(e.target.dataset.submitUrl));
  }
}
