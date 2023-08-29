import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search"
export default class extends Controller {
  connect() {
  }

  updateResults(event) {
    const query = event.target.value;
    const url = event.target.getAttribute("data-url");
    if (query === null || query === '') {
      return;
    }
    fetch(`${url}?query=${query}`, {
      headers: {
        "Accept": "text/vnd.turbo-stream.html",
        "X-Requested-With": "Turbo-Frame",
      },
    }).then(response => response.text())
      .then(body => Turbo.renderStreamMessage(body));
  }
}
