using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ActivationBehavior : MonoBehaviour
{
    [SerializeField] Transform MotoContainer;
    [SerializeField] Transform LaptopContainer;
    [SerializeField] Transform RefriContainer;
    [SerializeField] Transform TvContainer;

    //Dirección inicial de la página
    [SerializeField] string initialPage;
    [SerializeField] string motoPage;
    [SerializeField] string refriPage;
    [SerializeField] string laptopPage;
    [SerializeField] string tvPage;

    [SerializeField] Transform regresarPanel;



    private void Start()
    {
        
        OpenBrowser("init");
        InAppBrowserBridge bridge = FindObjectOfType<InAppBrowserBridge>();
        bridge.onJSCallback.AddListener(OnMessageFromJS);
        
    }

    void OnMessageFromJS(string jsMessage)
    {
        Debug.Log(jsMessage + "message received!");

        if (jsMessage.Equals("moto"))
        {
            regresarPanel.gameObject.SetActive(true);

            RefriContainer.gameObject.SetActive(false);
            TvContainer.gameObject.SetActive(false);
            LaptopContainer.gameObject.SetActive(false);

            MotoActivation();
            InAppBrowser.CloseBrowser();
        }
        if (jsMessage.Equals("laptop"))
        {
            RefriContainer.gameObject.SetActive(false);
            TvContainer.gameObject.SetActive(false);
            MotoContainer.gameObject.SetActive(false);

            regresarPanel.gameObject.SetActive(true);
            LaptopActivation();
            InAppBrowser.CloseBrowser();
        }
        if (jsMessage.Equals("refri"))
        {
            MotoContainer.gameObject.SetActive(false);
            TvContainer.gameObject.SetActive(false);
            LaptopContainer.gameObject.SetActive(false);

            regresarPanel.gameObject.SetActive(true);
            RefriActivation();
            InAppBrowser.CloseBrowser();
        }
        if (jsMessage.Equals("tv"))
        {
            RefriContainer.gameObject.SetActive(false);
            MotoContainer.gameObject.SetActive(false);
            LaptopContainer.gameObject.SetActive(false);

            regresarPanel.gameObject.SetActive(true);
            TvActivation();
            InAppBrowser.CloseBrowser();
        }
    }

    public void OpenBrowser(string url)
    {
        if (url.Equals("init"))
        {
            InAppBrowser.DisplayOptions options = new InAppBrowser.DisplayOptions();
            options.hidesTopBar = true;
            InAppBrowser.OpenURL(initialPage, options);
        }
        if (url.Equals("moto"))
        {
            InAppBrowser.DisplayOptions options = new InAppBrowser.DisplayOptions();
            options.hidesTopBar = true;
            InAppBrowser.OpenURL(motoPage, options);
        }
        if (url.Equals("laptop"))
        {
            InAppBrowser.DisplayOptions options = new InAppBrowser.DisplayOptions();
            options.hidesTopBar = true;
            InAppBrowser.OpenURL(laptopPage, options);
        }
        if (url.Equals("refri"))
        {
            InAppBrowser.DisplayOptions options = new InAppBrowser.DisplayOptions();
            options.hidesTopBar = true;
            InAppBrowser.OpenURL(refriPage, options);
        }
        if (url.Equals("tv"))
        {
            InAppBrowser.DisplayOptions options = new InAppBrowser.DisplayOptions();
            options.hidesTopBar = true;
            InAppBrowser.OpenURL(tvPage, options);
        }


        
    }
    

    public void MotoActivation()
    {
        MotoContainer.gameObject.SetActive(true);
    }

    public void LaptopActivation()
    {
        LaptopContainer.gameObject.SetActive(true);
    }

    public void RefriActivation()
    {
        RefriContainer.gameObject.SetActive(true);
    }
    
    public void TvActivation()
    {
        TvContainer.gameObject.SetActive(true);
    }

    public void Regresar()
    {

        if (MotoContainer.gameObject.activeSelf)
        {
            
            regresarPanel.gameObject.SetActive(false);
            MotoContainer.gameObject.SetActive(false);
            InAppBrowser.DisplayOptions options = new InAppBrowser.DisplayOptions();
            options.hidesTopBar = true;
            InAppBrowser.OpenURL(motoPage, options);
            
        }
        if (LaptopContainer.gameObject.activeSelf)
        {
            
            regresarPanel.gameObject.SetActive(false);
            LaptopContainer.gameObject.SetActive(false);
            InAppBrowser.DisplayOptions options = new InAppBrowser.DisplayOptions();
            options.hidesTopBar = true;
            InAppBrowser.OpenURL(laptopPage, options);
            
        }
        if (RefriContainer.gameObject.activeSelf)
        {
            
            regresarPanel.gameObject.SetActive(false);
            RefriContainer.gameObject.SetActive(false);
            InAppBrowser.DisplayOptions options = new InAppBrowser.DisplayOptions();
            options.hidesTopBar = true;
            InAppBrowser.OpenURL(refriPage, options);
            
        }
        if (TvContainer.gameObject.activeSelf)
        {
            
            regresarPanel.gameObject.SetActive(false);
            TvContainer.gameObject.SetActive(false);
            InAppBrowser.DisplayOptions options = new InAppBrowser.DisplayOptions();
            options.hidesTopBar = true;
            InAppBrowser.OpenURL(tvPage, options);
            
        }
    }
}
