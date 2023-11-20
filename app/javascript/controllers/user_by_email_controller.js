import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"
import axios from "axios"

// Connects to data-controller="user-by-email"
export default class extends Controller {
  static targets = [ "email", "submit", "emailWrapper" ]

  connect() {

    this.submitTarget.addEventListener("click", (e) => {
      e.preventDefault();

      if (this.emailTarget.value.length === 0) {
        console.log('Email is empty');
        this.emailWrapperTarget.classList.add('invalid-input');
        this.emailWrapperTarget.classList.remove('focus-within:border-black');
        this.emailWrapperTarget.classList.remove('focus-within:ring-black');
        this.emailWrapperTarget.classList.remove('focus-within:ring-1');
      } else {
        console.log('Email is not empty');
        axios.get(`/api/user_by_email`, {
          params: {
            email: this.emailTarget.value
          },
          headers: {
            'Accept': 'application/json',
          }
        }).then((response) => {
          Turbo.visit('/users/sign_in');
        }).catch((response) => {
          Turbo.visit('/users/sign_up');
        });
      }
    });
  }
}
