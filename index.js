// Your web app's Firebase configuration
/*var firebaseConfig = {
    apiKey: "AIzaSyCs7PUMT3SrA5fHc8h6KyS0Wv_cqrHVlmc",
    authDomain: "arelektra-cb680.firebaseapp.com",
    databaseURL: "https://arelektra-cb680.firebaseio.com",
    projectId: "arelektra-cb680",
    storageBucket: "",
    messagingSenderId: "335620122141",
    appId: "1:335620122141:web:593b4cbd15e04414"
  };
  // Initialize Firebase
  firebase.initializeApp(firebaseConfig);
*/
var userAgent = navigator.userAgent || navigator.vendor || window.opera;

function isIOS() {
  if (/iPad|iPhone|iPod/.test(userAgent) && !window.MSStream) {
      return true;
  } else {
    return false;
  }
}

function isAndroid() {
  return (/android/i.test(userAgent));
}

function appendIframeWithURL(url) {
  var iframe = document.createElement("IFRAME");
  iframe.setAttribute("src", url);
  document.documentElement.appendChild(iframe);
  iframe.parentNode.removeChild(iframe);
  iframe = null;
}

function sendMessageToUnity(message) {
  if (isIOS()) {
    appendIframeWithURL('inappbrowserbridge://' + message);
  } else if (isAndroid()){
    UnityInAppBrowser.sendMessageFromJS(message);
  }
}

function sendPing() {
  sendMessageToUnity("ping");
}