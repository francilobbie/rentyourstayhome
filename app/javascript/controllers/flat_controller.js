import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="flat"
export default class extends Controller {
  connect() {
  }

  showDescription(e) {
    e.preventDefault();
    document.getElementById("flat-description-trigger").click();
  }
}
