import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="entries"
export default class extends Controller {
  connect() {
    form = this.element
    statusField = form.querySelector("input#entry_status");
  }

  publish() {
    statusField.setAttribute("value", "published")
    form.submit();
  }
  unpublish() {
    statusField.setAttribute("value", "draft")
    form.submit();
  }
}

let form;
let statusField;