import { Controller } from "@hotwired/stimulus"
import mapboxgl from 'mapbox-gl' // Don't forget this!

export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array
  }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v12",
    })

    // Disable zoom by default
    this.map.scrollZoom.disable();

    // Add event listeners
    document.addEventListener('keydown', this.enableZoomWithKey);
    document.addEventListener('keyup', this.disableZoomWithKey);

    this.addMarkersToMap()
    this.setMapBounds()
  }

  enableZoomWithKey = (event) => {
    console.log('Keydown event detected');
    if (event.key === 'Shift') {
      console.log('Shift key pressed');
      this.map.scrollZoom.enable();
    }
  }


  // Disable zoom when the 'Shift' key is released
  disableZoomWithKey = (event) => {
    if (event.key === 'Shift') {
      this.map.scrollZoom.disable();
    }
  }

  disconnect() {
    // Remove the event listeners when the controller is disconnected
    document.removeEventListener('keydown', this.enableZoomWithKey);
    document.removeEventListener('keyup', this.disableZoomWithKey);
  }

  addMarkersToMap() {
    this.markersValue.forEach((marker) => {
      const popup = new mapboxgl.Popup().setHTML(marker.info_html) // Add this
      new mapboxgl.Marker()
        .setLngLat([ marker.lng, marker.lat ])
        .setPopup(popup) // Add this
        .addTo(this.map)
    })
  }

  setMapBounds() {
    const bounds = new mapboxgl.LngLatBounds();

    this.markersValue.forEach(marker => {
        bounds.extend([marker.lng, marker.lat]);
    });

    this.map.fitBounds(bounds, { padding: 30 });
  }
}
