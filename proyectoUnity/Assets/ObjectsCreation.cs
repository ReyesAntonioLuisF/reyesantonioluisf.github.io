using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR.ARFoundation;
using System;
using TMPro;

public class ObjectsCreation : MonoBehaviour
{

    [SerializeField] Transform objetoOriginal;
    [SerializeField] public Transform objetoSombra;

    [SerializeField] GameObject colocarPanel;

    [SerializeField] GameObject editarPanel;



    private ARRaycastManager raycastManager;

    private bool colocandoSombra;
    private bool objetoColocado;
    private bool estoySobrePlano;
    private Vector2 screenCenter;


    private void Start()
    {
        float xValue = Screen.width / 2;
        float yValue = Screen.height / 2;
        screenCenter = new Vector2(xValue, yValue);
        estoySobrePlano = false;

        
        
        
    }
    private void OnEnable()
    {
        if (objetoOriginal.gameObject.activeSelf)
        {
            colocandoSombra = false;
            objetoColocado = true;
            editarPanel.SetActive(true);
        }
        else
        {
            editarPanel.SetActive(false);
            colocandoSombra = true;
        }
    }

    // Update is called once per frame
    void LateUpdate()
    {
        if (colocandoSombra)
        {
            raycastManager = FindObjectOfType<ARRaycastManager>();
            List<ARRaycastHit> aux = new List<ARRaycastHit>();
            try
            {
                if (raycastManager.Raycast(screenCenter, aux))
                {
                    objetoSombra.gameObject.SetActive(true);
                    objetoSombra.position = aux[0].pose.position;
                    estoySobrePlano = true;
                }
                else
                {
                    colocarPanel.gameObject.SetActive(false);
                    objetoSombra.gameObject.SetActive(false);
                    estoySobrePlano = false;
                }
            }
            catch (ArgumentException e)
            {
                Debug.Log(e);
            }
        }
        else
        {
            if (!objetoColocado)
            {
                raycastManager = FindObjectOfType<ARRaycastManager>();
                List<ARRaycastHit> aux = new List<ARRaycastHit>();
                try
                {
                    if (raycastManager.Raycast(screenCenter, aux))
                    {
                        objetoOriginal.rotation = objetoSombra.rotation;
                        objetoSombra.gameObject.SetActive(false);
                        objetoOriginal.gameObject.SetActive(true);
                        objetoOriginal.position = aux[0].pose.position;

                        objetoColocado = true;
                        colocarPanel.gameObject.SetActive(false);
                        editarPanel.gameObject.SetActive(true);
                    }
                }
                catch (ArgumentException e)
                {
                    Debug.Log(e);
                }
            }

        }

        if (estoySobrePlano && colocandoSombra)
        {
            colocarPanel.gameObject.SetActive(true);
        }
    }

    public void SombraColocada()
    {

        colocandoSombra = false;
    }

    public void RecolocarSombra()
    {
        editarPanel.SetActive(false);
        colocandoSombra = true;
        objetoColocado = false;
        estoySobrePlano = false;
        objetoOriginal.gameObject.SetActive(false);
        objetoSombra.gameObject.SetActive(false);
    }

    private void OnDisable()
    {
        colocarPanel.SetActive(false);
        editarPanel.SetActive(false);
    }
}
