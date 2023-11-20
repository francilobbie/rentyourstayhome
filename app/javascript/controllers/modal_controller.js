import { Controller } from "@hotwired/stimulus"
import { enter, leave, toggle } from "el-transition"

// Connects to data-controller="modal"
export default class extends Controller {
  static targets = [ "closeButton" ]

  connect() {
    document.getElementById(`modal-${this.element.dataset.modalTriggerId}-wrapper`).addEventListener("click", (event) => {
      this.closeModal(event, this.element.dataset.modalTriggerId)});
    this.closeButtonTarget.addEventListener("click", () => {
      leave(document.getElementById(`modal-${this.element.dataset.modalTriggerId}-wrapper`))
      leave(document.getElementById(`modal-${this.element.dataset.modalTriggerId}-backdrop`))
      leave(document.getElementById(`modal-${this.element.dataset.modalTriggerId}-panel`))
    });
  }

  closeModal(event, triggerId) {
    const modalPanelClicked = document.getElementById(`modal-${triggerId}-panel`).contains(event.target)
    if (!modalPanelClicked && event.target.id !== triggerId) {
    leave(document.getElementById(`modal-${triggerId}-wrapper`))
    leave(document.getElementById(`modal-${triggerId}-backdrop`))
    leave(document.getElementById(`modal-${triggerId}-panel`))
    }
  }

  showModal() {
    // Reference to the modal panel
    const modalPanel = document.getElementById(`modal-${this.element.dataset.modalTriggerId}-panel`);
    const backdrop = document.getElementById(`modal-${this.element.dataset.modalTriggerId}-backdrop`);

    // Check if the content of the modal matches your criteria
    // For example, see if the modal contains an element with data-controller="share-modal"
    if (modalPanel.querySelector('[data-controller="share-modal"]')) {
      // Modify the modal's size classes when the "share flat" content is present
      modalPanel.classList.add('sm:max-w-2xl'); // This will resize the modal
      modalPanel.classList.remove('sm:max-w-4xl'); // Remove this if it exists
    }

    if (modalPanel.id === 'modal-search-form-panel') {
      // Modify the modal's size classes when the "share flat" content is present
      modalPanel.classList.add('sm:max-w-2xl'); // This will resize the modal
      modalPanel.classList.remove('sm:max-w-4xl'); // Remove this if it exists
    }

    // if (backdrop.id === 'modal-search-form-backdrop') {
    //   const followingDiv = backdrop.nextElementSibling;

    //   // Ensure the next sibling is a div and then modify its classes
    //   if (followingDiv && followingDiv.tagName === 'DIV') {
    //     followingDiv.classList.add('z-30');
    //     followingDiv.classList.remove('z-50');
    //   }
    // }

    if (modalPanel.querySelector('[data-controller="avatar"]')) {
      setupDeleteButtonEvent();
    }

    enter(document.getElementById(`modal-${this.element.dataset.modalTriggerId}-wrapper`))
    enter(backdrop)
    enter(modalPanel);
  }

  setupDeleteButtonEvent() {
    const deleteButton = document.getElementById('delete-avatar-button');
    if (deleteButton && !deleteButton.dataset.listenerAttached) {
      deleteButton.dataset.listenerAttached = 'true'; // Add a marker to know that the listener has been attached
      deleteButton.addEventListener('click', (e) => {
        e.preventDefault(); // Prevent any default behavior

        // Assuming you have an API endpoint at `/profiles/:id/avatar`
        // that handles the DELETE request. We get the id from the delete button's data attribute
        const profileId = deleteButton.getAttribute('data-profile-id');
        fetch(`/profiles/${profileId}/avatar`, {
          method: 'DELETE',
          headers: {
            'Content-Type': 'application/json',
            // Add other headers like authentication tokens if required
          },
        })
        .then(response => response.json())
        .then(data => {
          if (data.success) {
            // Assuming you have a container that wraps the avatar
            const avatarContainer = document.querySelector('.avatar-container');
            avatarContainer.innerHTML = "<p>Avatar deleted</p>"; // Update this to whatever you'd like shown after deletion
            this.closeModal(new Event('click'), this.element.dataset.modalTriggerId);
          } else {
            console.error('Error deleting avatar:', data.error);
          }
        })
        .catch(error => {
          console.error('There was an error sending the delete request:', error);
        });
      });
    }
  }

}
