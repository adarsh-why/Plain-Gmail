NodeList.prototype.forEach = Array.prototype.forEach;

window.onhashchange = filterEmails;

function filterEmails() {
  var label = window.location.hash.substr(1);
  var mails = document.querySelectorAll("tbody tr");

  mails.forEach(function(mail) {
    if (label == "all" || mail.className == label)
      mail.style.display = "table-row";
    else
      mail.style.display = "none";
  });
}