import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["favButton", "favCount", "favIcon"]

  connect() {
    this.setFavIcon();
  }

  toggleFav(event) {
    event.preventDefault()

    const comicId = this.data.get("comicId")
    const isFavorited = this.data.get("isFavorite") === '1'
    const url = `/home/${comicId}/fav`
    const method = isFavorited ? 'DELETE' : 'POST'
    const userId = localStorage.getItem('userId')
    const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content')

    fetch(url, {
      method: method,
      headers: {
        'X-Requested-With': 'XMLHttpRequest',
        'Content-Type': 'application/json',
        'X-CSRF-Token': csrfToken
      },
      body: JSON.stringify({ user_id: userId }),
      credentials: 'same-origin'
    })
    .then(response => response.json())
    .then(data => {
      var newFavValue = data.is_favorited ? '1' : '0'
      this.data.set("isFavorite", newFavValue)
      //this.favCountTarget.textContent = data.fav_count
      this.updateFavIcon(newFavValue);
    })
  }

  setFavIcon() {
    var currentValue = this.data.get('is-favorite');
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
}