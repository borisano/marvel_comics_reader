class HomeController < ApplicationController
  def index
    @comics = [
      { name: 'Calvin and Hobbes', cover_url: 'https://picsum.photos/200/300' },
      { name: 'sefesfs', cover_url: 'https://picsum.photos/200/300' },
      { name: 'Calvin and Hobbes', cover_url: 'https://picsum.photos/200/300' },
      { name: 'efinsefefbes', cover_url: 'https://picsum.photos/200/300' },
      { name: 'Cal2hthfesobbes', cover_url: 'https://picsum.photos/200/300' },
      { name: 'Cevin and Hobbes', cover_url: 'https://picsum.photos/200/300' },
      { name: 'Calsfefesbbes', cover_url: 'https://picsum.photos/200/300' },
      { name: 'asfyhs Hobbes', cover_url: 'https://picsum.photos/200/300' },
      { name: 'Calvisfefesbbes', cover_url: 'https://picsum.photos/200/300' },
      { name: 'ayhyd Hobbes', cover_url: 'https://picsum.photos/200/300' }
    ]
  end

  def about
  end
end
