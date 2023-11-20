import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["star", "starContainer", "ratingInput"];

  connect() {
    this.noOfStars = this.data.get("stars") || 5; // You can set this via data attributes
    this.rating = 0;

    this.initStarComponent();
    this.renderChanges(this.rating);
  }

  initStarComponent() {
    this.starComponent = this.starContainerTarget;
    for (let i = 0; i < this.noOfStars; i++) {
      const li = document.createElement("li");
      li.setAttribute("data-rating", i + 1);
      li.setAttribute("data-star-target", "star");  // Add this line
      li.className = "star";
      if (i === 0) li.tabIndex = 0;
      this.starComponent.append(li);
    }
  }

  renderChanges(rating) {
    for (let index = 0; index < rating; index++) {
      this.starTargets[index].classList.add("star-filled");
    }
    for (let index = rating; index < this.noOfStars; index++) {
      this.starTargets[index].classList.remove("star-filled");
    }
  }

  handleMouseOver(event) {
    let star = event.target;
    if (star.classList.contains("star")) {
      const rating = star.dataset.rating;
      this.renderChanges(rating);
    }
  }

  handleMouseLeave() {
    this.renderChanges(this.rating);
  }

  handleStarClick(event) {
    let star = event.target;
    if (star.classList.contains("star")) {
      const newRating = parseInt(star.dataset.rating);
      if (newRating === this.rating) {
        this.rating = 0;
      } else {
        this.rating = newRating;
      }
      this.renderChanges(this.rating);
    }
    this.ratingInputTarget.value = this.rating;
  }

  handleKeyUp(event) {
    // ... the previous keyUp logic, with slight modifications to adjust for the Stimulus setup
  }

  // Add more of the given functions, adjusting them to work within this controller...
}
