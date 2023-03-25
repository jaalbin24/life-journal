import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="entry-form"
export default class extends Controller {
  connect() {
  }
  publish(e) {
    e.preventDefault();
    console.log("PUBLISHED IT RIGHT HERE");
    let formEl = document.querySelector("form#entry_form");
    let inputEl = document.createElement('input');
    inputEl.setAttribute('name', 'entry[published]');
    inputEl.setAttribute('value', 'true');
    inputEl.setAttribute('type', 'hidden');
    formEl.appendChild(inputEl);
    formEl.submit();
  }
}
