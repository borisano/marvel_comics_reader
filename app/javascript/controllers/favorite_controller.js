import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["favButton", "favCount", "favIcon"]

  connect() {
    this.setFavIcon();
  }

  toggleFav() {
    console.log('Toggle fav button');
    const newFavValue = this.data.get('is-favorite') === '1' ? '0' : '1';
    this.data.set('is-favorite', newFavValue);

    this.updateFavCount(newFavValue);
    this.updateFavIcon(newFavValue);
  }

  setFavIcon() {
    currentValue = this.data.get('is-favorite');
    this.updateFavIcon(currentValue);
  }

  updateFavIcon(newFavValue) {
    // Update the button classes
    if (newFavValue === '1') {
      this.favIconTarget.classList.remove('fav-off');
      this.favIconTarget.classList.add('fav-on');
    } else {
      this.favIconTarget.classList.remove('fav-on');
      this.favIconTarget.classList.add('fav-off');
    }
  }

  updateFavCount(newFavValue) {
    if (newFavValue === '1') {
      this.favCountTarget.textContent = parseInt(this.favCountTarget.textContent) + 1;
    } else {
      this.favCountTarget.textContent = parseInt(this.favCountTarget.textContent) - 1;
    }
  }
}