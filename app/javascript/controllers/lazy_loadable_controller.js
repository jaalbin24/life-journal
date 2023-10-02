import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="lazy-loadable"
export default class extends Controller {
  connect() {
    this.load();
  }

  load() {
    const url = this.element.dataset.url;
    if (url) {
      this.element.src = url;
    }
  }
}
