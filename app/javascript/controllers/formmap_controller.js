import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { icon: String, tabid: Number, newrecord: Boolean, coords: Array }
 
  
  initialize() {
    this.pageShow = this.pageShow.bind(this);
    this.marker =  new L.marker()
    this.circle =  new L.marker()
    this.manualSelectionEnabled = false
  }

  connect() {
    window.addEventListener('pageshow',  this.pageShow);
    document.addEventListener('turbo:load', this.pageShow);
  }

  disconnect(){
    document.removeEventListener("turbo:load", this.pageShow);
    window.removeEventListener("pageshow", this.pageShow);
    this.formmap.off()
    this.formmap.remove()
  }

  toggleGeoloc({ params: { tabid }} ){
    var tab = document.getElementById(tabid);
    if (tab) {
      var tabs = document.querySelectorAll('.tabs li');
      Array.from(tabs).forEach(function (itab) {
        itab.classList.remove('is-active');
      });

      tab.classList.add('is-active');
      if (tabid == "man-tab"){
        this.manualSelectionEnabled = true; 
      } else { 
        this.manualSelectionEnabled = false;
      }
      this.findLoc();
    }

  }

  pageShow () {

    if (this.formmap == undefined){
        this.formmap = L.map('formmap').setView([-13.8586, -171.7539], 13);
        L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
        maxZoom: 19,
        attribution: 'Map Tiles &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
      }).addTo(this.formmap);
      this.formmap.attributionControl.setPrefix(false);

      this.formmap.on('locationfound', (e) => { this.onLocationFound(e, this)});
      this.formmap.on('locationerror', (e) => { this.onLocationError(e, this)});
      
      if (this.newrecordValue){
        this.findLoc();
      }else{
        //add the point
        if (this.coordsValue && this.coordsValue.length > 0){
          if(this.formmap.hasLayer(this.circle) && this.formmap.hasLayer(this.marker)) {
            this.formmap.removeLayer(this.circle);
            this.formmap.removeLayer(this.marker);
          } 
         
          var icon = new L.Icon({iconAnchor:L.Icon.Default.prototype.options.iconAnchor,  iconUrl: this.iconValue});
          this.marker = L.marker(this.coordsValue, {icon: icon})
          this.marker.addTo(this.formmap)
          this.circle = L.circle(this.coordsValue, 0.001)
          this.circle.addTo(this.formmap);
      
          this.formmap.setView(this.coordsValue, 13);
        }
        this.toggleGeoloc({params:{tabid:"man-tab"}})
        
      }
      
    }
   
  }

  findLoc() {
    this.formmap.off('click');
    if (navigator.geolocation && !this.manualSelectionEnabled) {
        this.formmap.locate({watch: true,  enableHighAccuracy:true, setView: true, maxZoom: 18});
      } else {

       if (this.manualSelectionEnabled) {
          this.formmap.on('click', (e) => { this.onLocationFound(e, this)});
        } else {
          this.formmap.off('click');
        }
    }
  }

  onLocationError(e){
    var tab = document.getElementById("man-tab");
    if (tab) {
      var tabs = document.querySelectorAll('.tabs li');
      Array.from(tabs).forEach(function (itab) {
        itab.classList.remove('is-active');
      });

      tab.classList.add('is-active');
     
      this.manualSelectionEnabled = true; 
     
      this.findLoc();
    }
  }

  onLocationFound(e, f){
    let radius = e.accuracy; 
  
    if(this.formmap.hasLayer(this.circle) && this.formmap.hasLayer(this.marker)) {
      this.formmap.removeLayer(this.circle);
      this.formmap.removeLayer(this.marker);
    } 
   
    var icon = new L.Icon({iconAnchor:L.Icon.Default.prototype.options.iconAnchor,  iconUrl: this.iconValue});
    this.marker = L.marker(e.latlng, {icon: icon})
   
    this.marker.addTo(this.formmap)
    this.circle = L.circle(e.latlng, radius)
    this.circle.addTo(this.formmap);

    const lonlat = "POINT("+e.latlng.lng+ " " + e.latlng.lat+")";
    document.getElementById("survey_lonlat").value = lonlat;

    updateProgress();  // for progress bar
  }



}