import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { icon: String, coords: Array }

  initialize() {
    this.pageShow = this.pageShow.bind(this);
    this.map;
  }

  connect() {
    window.addEventListener('pageshow',  this.pageShow);
    document.addEventListener('turbo:load', this.pageShow);
  }

  disconnect(){
    document.removeEventListener("turbo:load", this.pageShow);
    window.removeEventListener("pageshow", this.pageShow);
    this.map.off()
    this.map.remove()
  }

  pageShow () {
    
    if (this.map == undefined){
      this.map = L.map('map').setView(this.coordsValue, 13);
      L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
        maxZoom: 19,
        attribution: 'Map Tiles &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
      }).addTo(this.map);
      let icon = new L.Icon({iconAnchor:L.Icon.Default.prototype.options.iconAnchor,  iconUrl: this.iconValue});
      let marker = L.marker(this.coordsValue, {icon: icon})
      marker.addTo(this.map)
    }
  }


}