import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="google-maps"
export default class extends Controller {
  static targets = [ "map", "flat" ]

  connect() {
    this.mapTarget.style.height = '100%';
    const firstFlat = this.flatTargets[0];
    this.firstPosition = { lat: parseFloat(firstFlat.dataset.latitude), lng: parseFloat(firstFlat.dataset.longitude) };

    const map = this.initMap(this.firstPosition); // Pass firstPosition to initMap

    window.myGoogleMap = map; // Consider if you really want to attach the map to the global window object

    this.flatTargets.forEach((flat) => {
      new google.maps.Marker({
        position: { lat: parseFloat(flat.dataset.latitude), lng: parseFloat(flat.dataset.longitude) }, // Parse string data attributes to float
        map: map,
        optimized: true,
      });
    });
  }

  initMap(centerPosition) {
    const map = new google.maps.Map(this.mapTarget, {
      center: centerPosition,
      zoom: 8,
    });

    return map; // Return the map instance
  }
}
