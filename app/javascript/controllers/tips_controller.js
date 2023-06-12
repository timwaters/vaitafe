import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  initialize() {
    this.pageShow = this.pageShow.bind(this);
  }

  connect() {
    window.addEventListener('pageshow',  this.pageShow);
    document.addEventListener('turbo:load', this.pageShow);
  }

  disconnect(){
    document.removeEventListener("turbo:load", this.pageShow);
    window.removeEventListener("pageshow", this.pageShow);
  }

  nextTip(){
    const num_tips =  this.element.querySelectorAll('.tip').length;
    let skip = false;
   
    this.element.querySelectorAll('.tip').forEach((tip) => {
      
      if (!skip && !tip.classList.contains("is-hidden")){
        
        var nexttip_int = parseInt(tip.id.slice(4)) + 1 ;
        let nexttip_id;
        if (nexttip_int >= num_tips){
          nexttip_id = "tip-0";
        }else{
          nexttip_id = "tip-"+nexttip_int;
        }
        
        var nexttip = document.getElementById(nexttip_id)
        nexttip.classList.remove("is-hidden");

        tip.classList.add("is-hidden"); //hide original tip
        skip = true;
      }
      
    });
  }

  pageHide() {
   
  }
  pageShow () {
  
    if (readCookie("tips") != "hide" && !this.element.classList.contains('is-active')){
      
      this.element.querySelectorAll('.tip').forEach((tip) => {
        tip.classList.add("is-hidden");
      });
      // open random tip
      let tips = this.element.querySelectorAll('.tip');
      tips[Math.floor(Math.random() * tips.length )].classList.remove("is-hidden")
      this.element.classList.add('is-active')
    }
  }

  //hides for 30 days
  hideTips(){
    this.element.classList.remove('is-active');
    createCookie('tips', 'hide', 30)
  }

  //hides for 0.24 of an hour 14 mins
  hideTipsTemp(){
    this.element.classList.remove('is-active');
    createCookie('tips', 'hide', 0.01)
  }


}
