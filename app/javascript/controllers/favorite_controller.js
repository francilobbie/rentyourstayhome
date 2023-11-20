import { Controller } from "@hotwired/stimulus"
import axios from "axios"

// Connects to data-controller="favorite"
export default class extends Controller {
  HEADERS = { 'accept': 'application/json' }
  connect() {
  }

  favorite(e) {
    e.preventDefault();
    if (this.element.dataset.userLoggedIn === "false") {
      return document.querySelector('[data-navbar-target="userAuthLink"]').click();
    }

    if (this.element.dataset.favorited === "true") {
      this.unFavorited();
    } else {
      this.favorited();
    }
  };

  getFavoritePath() {
    return '/api/favorites'
  }

  getUnFavoritePath(favoriteId) {
    return `/api/favorites/${favoriteId}`
  }

  favorited() {
    axios.post(this.getFavoritePath(), {
      flat_id: this.element.dataset.flatId,
      user_id: this.element.dataset.userId
    }, { headers:  this.HEADERS
    })
    .then(response => {
      this.element.dataset.favoriteId = response.data.id;
      this.element.dataset.favorited = 'true';
      this.element.setAttribute("fill", this.element.dataset.favoriteColor);
  })
  }

  unFavorited() {
    axios.delete(this.getUnFavoritePath(this.element.dataset.favoriteId))
    .then(response => {
      this.element.dataset.favoriteId = '';
      this.element.dataset.favorited = 'false'
      this.element.setAttribute("fill", this.element.dataset.unfavoriteColor);
    })
  }
}
