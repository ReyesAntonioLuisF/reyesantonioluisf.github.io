// Your web app's Firebase configuration
import * as firebase from 'firebase';
import 'firebase/firestore';

var firebaseConfig = {
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
var firestore = firebase.firestore();
const decRef =  firestore.doc("/samples/objetos")

function insertar(){
    docRef.set({
        id: 1,
        nombre: "Antena Plana Para Interiores Master TVANTFLATHD",
        height: 27,
        length: 50,
        weight: 430,
        price: "$199.00",
        disponible: true
    })
        .then(() => {
            console.log("Guardado")
        })
        .catch( () => {
            console.log("hubo error")
        })
}
/*function insertarTask() {
    let 
    let nombre= "Antena Plana Para Interiores Master TVANTFLATHD"
    let height= 27
    let length= 50
    let weight= 430
    let foto= "https://elektraqapre.vteximg.com.br/arquivos/ids/157064-292-292/177602.jpg?v=636568020153600000"
    let price= "$199.00"
    let descripcion= "Antena Plana Para Interiores Master TVANTFLATHD"
    let disponible= true;

    let arrayData = {nombre: nombre, alto: height, largo: length, ancho: weight, foto: foto, precio: price, descripcion: descripcion, disponibilidad: disponible};
    var task = firebase.database().ref("task/"+id);
    task.set(arrayData)
}*/

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
    } else if (isAndroid()) {
        UnityInAppBrowser.sendMessageFromJS(message);
    }
}

function sendPing() {
    sendMessageToUnity("ping");
}