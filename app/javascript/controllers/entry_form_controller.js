import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="entry-form"
export default class extends Controller {
  connect() {
    this.formEl = document.querySelector("form#entry_form");
    this.pictureInputField = form.querySelector("input[type='file'][]");
  }
  publish(e) {
    e.preventDefault();
    let formEl = document.querySelector("form#entry_form");
    let inputEl = document.createElement('input');
    inputEl.setAttribute('name', 'entry[published]');
    inputEl.setAttribute('value', 'true');
    inputEl.setAttribute('type', 'hidden');
    formEl.appendChild(inputEl);
    formEl.submit();
  }
  renderPicture(file) {

  }
}
