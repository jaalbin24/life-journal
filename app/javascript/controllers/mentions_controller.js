import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="mentions"
export default class extends Controller {
  connect() {
    csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
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

  delete(event) {
    const url = event.currentTarget.getAttribute("url");
    if (url === null) return;
    console.log(url);
    fetch(url, {
      method: 'DELETE',
      headers: {
        "Accept": "text/vnd.turbo-stream.html",
        "X-Requested-With": "Turbo-Frame",
        'X-CSRF-Token': csrfToken
      },
    }).then(response => response.text())
      .then(body => Turbo.renderStreamMessage(body));
  }

  new(event) {
    const keyword = event.target.value;
    const url = event.target.getAttribute("data-url");
  
    // Clear the previous timer if it exists
    clearTimeout(delayTimer);
  
    // And set the timer to make the request after no input has been received for 200ms
    delayTimer = setTimeout(() => {
      if (keyword == null) {
        keyword = '';
      }
      let wildcard = '?'
      if (url.includes('?')) {
        wildcard = '&';
      }
      fetch(`${url}${wildcard}keyword=${keyword}`, {
        headers: {
          "Accept": "text/vnd.turbo-stream.html",
          "X-Requested-With": "Turbo-Frame",
        },
      }).then(response => response.text())
        .then(body => Turbo.renderStreamMessage(body));
    }, 100); // Wait for 200ms before searching. This can be adjusted
  }

  create(event) {
    console.log("CREATE");
    const url = event.currentTarget.getAttribute("url");
    if (url === null) return;
    console.log(url);
    fetch(url, {
      method: 'POST',
      headers: {
        "Accept": "text/vnd.turbo-stream.html",
        "X-Requested-With": "Turbo-Frame",
        'X-CSRF-Token': csrfToken
      },
    }).then(response => response.text())
      .then(body => Turbo.renderStreamMessage(body));
  }
}
let delayTimer;
let csrfToken;