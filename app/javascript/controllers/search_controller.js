import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search"
export default class extends Controller {
  connect() {
    this.element.addEventListener("keypress", this.handleKeyPress);
  }

  disconnect() {
    this.element.removeEventListener("keypress", this.handleKeyPress);
  }

  handleKeyPress(event) {
    if (event.key === "Enter") {
      event.preventDefault();
      if (event.target.form != null) {
        event.target.form.submit();
      }
    }
  }

  
  updateResults(event) {
    const keyword = event.target.value;
    const url = event.target.getAttribute("data-url");
  
    // Clear the previous timer if it exists
    clearTimeout(delayTimer);
  
    // And set the timer to make the request after no input has been received for 200ms
    delayTimer = setTimeout(() => {
      if (keyword == null) {
        keyword = '';
      }
      fetch(`${url}?keyword=${keyword}`, {
        headers: {
          "Accept": "text/vnd.turbo-stream.html",
          "X-Requested-With": "Turbo-Frame",
        },
      }).then(response => response.text())
        .then(body => Turbo.renderStreamMessage(body));
    }, 300); // Wait for 200ms before searching. This can be adjusted
  }
}

let delayTimer;