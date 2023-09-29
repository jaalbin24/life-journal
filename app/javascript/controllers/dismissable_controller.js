import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dismissable"
export default class extends Controller {

  connect() {
    if (this.element.getAttribute('data-autodismiss') == "true") {
      this.startTimer();
    }
    setTimeout(() => {
      this.element.classList.add("extended");
    }, 10);
  }

  startTimer() {
    // Clear the existing timer if it's running
    clearTimeout(this.dimissTimer); 
    
    // Start a new timer with a delay of 7000ms (7 second)
    this.dimissTimer = setTimeout(() => {
      this.element.classList.add("opacity-0");
      this.element.addEventListener('transitionend', () => {
        this.element.remove();
      }, { once: true });
    }, 9000);
  }

  dismiss() {
    console.log("Dismissing!");
    this.element.remove();
  }
}