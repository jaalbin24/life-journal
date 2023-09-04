import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dismissable"
export default class extends Controller {
  static targets = ['alertBox']

  connect() {
  }

  dismiss() {
    this.alertBoxTarget.classList.add("hidden");
  }
}
