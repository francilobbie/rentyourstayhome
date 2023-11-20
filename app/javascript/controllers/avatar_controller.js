import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="avatar"
export default class extends Controller {
  connect() {
  }

  show(e) {
    e.preventDefault();
    document.getElementById('avatar-modal-trigger').click();
  }
}
