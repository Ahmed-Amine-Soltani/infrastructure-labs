var xhr = new XMLHttpRequest();
xhr.open('POST', '/home/user-1/Downloads/codepen-gateway-lambda-basics.js');
xhr.onreadystatechange = function(event) {
  console.log(event.target);
}
xhr.send();