const stars = document.querySelector(".ratings").children;
const ratingValue = document.getElementById("rating_value");
const ratingValueDisplay = document.getElementById("rating_value_display");

let index;

for(let i=0; i<stars.length; i++){
  stars[i].addEventListener("mouseover",function(){
    for(let j=0; j<stars.length; j++){
      stars[j].classList.remove("fas");
      stars[j].classList.add("far");
    }
    for(let j=0; j<=i; j++){
      stars[j].classList.remove("far");
      stars[j].classList.add("fas");
    }
  });
  stars[i].addEventListener("click",function(){
    ratingValue.value = i+1;
    ratingValueDisplay.textContent = ratingValue.value
    index = i;
  });
  stars[i].addEventListener("mouseout",function(){
    for(let j=0; j<stars.length; j++){
      stars[j].classList.remove("fas");
      stars[j].classList.add("far");
    }
    for(let j=0; j<=index; j++){
      stars[j].classList.remove("far");
      stars[j].classList.add("fas");
    }
  });
}
