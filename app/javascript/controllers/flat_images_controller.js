import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="flat-images"
export default class extends Controller {
  connect() {
  }

  show(e) {
    e.preventDefault();
    document.getElementById('images-modal-trigger').click();
  }
}
