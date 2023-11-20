import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["address", "dropdown", "clearButton"];

  connect() {
    console.log("Address Autocomplete Controller connected!");

    this.handleInput = this.handleInput.bind(this);
    this.closeDropdown = this.closeDropdown.bind(this);

    this.toggleClearButton();
    this.addressTarget.addEventListener('input', this.handleInput);
    document.addEventListener('click', this.closeDropdown);
  }

  handleInput(event) {
    const query = event.target.value;
    this.toggleClearButton();

    if (query.length > 2) {
      fetch(`/mapbox/search?query=${query}`)
        .then(response => response.json())
        .then(data => this.showResults(data.features))
        .catch(error => {
          console.error("Error fetching address data: ", error);
        });
    }
  }

  closeDropdown(event) {
    if (!this.element.contains(event.target)) {
        this.dropdownTarget.innerHTML = "";
    }
  }

  showResults(features) {
    this.dropdownTarget.innerHTML = "";
    this.dropdownTarget.style.border = "1px solid #ccc";
    this.dropdownTarget.style.maxHeight = "150px";
    this.dropdownTarget.style.overflowY = "auto";

    features.forEach(feature => {
        const option = document.createElement("div");
        option.textContent = feature.place_name;  // Use textContent for XSS protection
        option.classList.add("dropdown-option");
        option.style.padding = "10px";
        option.style.cursor = "pointer";

        option.addEventListener("mouseover", () => option.style.backgroundColor = "#eee");
        option.addEventListener("mouseout", () => option.style.backgroundColor = "");
        option.addEventListener("click", () => {
            this.addressTarget.value = feature.place_name;
            document.getElementById('flat_latitude').value = feature.center[1];
            document.getElementById('flat_longitude').value = feature.center[0];

            const countryCode = extractCountryCode(feature);
            if (countryCode) {
                document.getElementById('flat_country_code').value = countryCode;
            }

            this.dropdownTarget.innerHTML = "";
        });
        this.dropdownTarget.appendChild(option);
    });
  }

  clearInput(event) {
    event.preventDefault();
    this.addressTarget.value = "";
    this.toggleClearButton();
  }

  toggleClearButton() {
    if (this.addressTarget.value) {
      this.clearButtonTarget.style.display = 'flex';
    } else {
      this.clearButtonTarget.style.display = 'none';
    }
  }

  disconnect() {
    this.addressTarget.removeEventListener('input', this.handleInput);
    document.removeEventListener('click', this.closeDropdown);
  }
}

function extractCountryCode(feature) {
  const country = feature.context.find(item => item.id.startsWith('country'));
  return country ? country.short_code.toUpperCase() : null;
}
