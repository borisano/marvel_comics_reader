import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.checkIdentifier();
  }

  checkIdentifier() {
    let uniqueId = localStorage.getItem('uniqueId');
    if (!uniqueId) {
      uniqueId = this.generateUniqueId();
      localStorage.setItem('uniqueId', uniqueId);
    }
  }

  generateUniqueId() {
    return ([1e7]+-1e3+-4e3+-8e3+-1e11).replace(/[018]/g, c =>
      (c ^ crypto.getRandomValues(new Uint8Array(1))[0] & 15 >> c / 4).toString(16)
    )
  }
}