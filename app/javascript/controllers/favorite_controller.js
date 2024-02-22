import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["favButton", "favCount"]

  connect() {
    this.updateFavIcon();
  }

  toggleFav() {
    console.log('Toggle fav button');
    const newFavValue = this.data.get('is-favorite') === '1' ? '0' : '1';
    this.data.set('is-favorite', newFavValue);

    this.updateFavCount(newFavValue);
    this.updateFavIcon(newFavValue);
  }

  updateFavIcon(newFavValue) {
    // Update the button classes
    if (newFavValue === '1') {
      this.favButtonTarget.classList.remove('fav-off');
      this.favButtonTarget.classList.add('fav-on');
    } else {
      this.favButtonTarget.classList.remove('fav-on');
      this.favButtonTarget.classList.add('fav-off');
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