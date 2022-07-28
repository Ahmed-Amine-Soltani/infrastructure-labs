var xhr = new XMLHttpRequest();
xhr.open("POST", "https://ksifiuwwe9.execute-api.eu-west-3.amazonaws.com/dev/first-api");
xhr.onreadystatechange = function (event) {
  console.log(event.target.response);
};
xhr.setRequestHeader("Content-Type", "application/json");
xhr.send(JSON.stringify({ age: 26, height: 71, income: 2100 }));