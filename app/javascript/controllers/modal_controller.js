import { Controller } from "@hotwired/stimulus"
// import { Turbo } from "@hotwired/turbo-rails"

// Connects to data-controller="modal"
export default class extends Controller {
  static values = { url: String }

  connect() {
    modalFrame = document.querySelector("turbo-frame#modal");
  }

  openModal() {
    modalFrame.src = this.urlValue
  }
}

let modalFrame;