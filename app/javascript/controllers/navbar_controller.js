import { Controller } from "@hotwired/stimulus"
import { toggle } from "el-transition"

// Connects to data-controller="navbar"
export default class extends Controller {

  static targets = [ "openUserMenu", "userAuthLink", "searchInput" ]
  connect() {
    this.openUserMenuTarget.addEventListener("click", this.toggleDropDownMenu );

    this.userAuthLinkTargets.forEach((link) => {
      link.addEventListener('click', (e) => {
        e.preventDefault();
        document.getElementById('user-auth-modal-trigger').click();
      });
      // link.addEventListener("click", this.toggleDropDownMenu );
    });

    this.searchInputTarget.addEventListener("click", (e) => {
      e.preventDefault();
      document.getElementById(e.target.dataset.targetId).click();
    } );

  }

  toggleDropDownMenu() {
    toggle(document.getElementById('user-menu'))
  }
}
