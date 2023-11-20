import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="share-modal"
export default class extends Controller {
  connect() {
    // console.log("share modal controller connected");
  }

  copyLink() {
    console.log("copy link");
    navigator.clipboard.writeText(this.element.dataset.shareUrl).then(() => {
      alert("Copied to clipboard!");
    });
  }

  sendByEmail() {
    console.log("send by email");
  }
}
