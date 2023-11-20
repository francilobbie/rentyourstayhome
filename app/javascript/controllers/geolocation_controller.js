import { Controller } from "@hotwired/stimulus"
import { getDistance, convertDistance } from "geolib"

// Connects to data-controller="geolocation"
export default class extends Controller {
  static targets = [ "flat" ]
  connect() {
    window.navigator.geolocation.getCurrentPosition((pos) => {
      const { latitude: lat, longitude: lon } = pos.coords;
      this.element.dataset.latitude = lat;
      this.element.dataset.longitude = lon;

      const distance = getDistance(
        { latitude: lat, longitude: lon },
        { latitude: 51.5103, longitude: 7.49347 }
      )

      this.flatTargets.forEach((target) => {
        const flatLat = target.dataset.latitude;
        const flatLon = target.dataset.longitude;

        const flatDistance = getDistance(
          { latitude: lat, longitude: lon },
          { latitude: flatLat, longitude: flatLon }
        )
        target.querySelector('[data-distance]').innerHTML = `${Math.round(convertDistance(flatDistance, 'km'))} Kilometers away`;
      });
    });
  }
}
