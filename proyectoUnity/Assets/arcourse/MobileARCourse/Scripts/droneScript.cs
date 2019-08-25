using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class droneScript : MonoBehaviour
{
    private Transform[] destinationPoints = null;
    private int arrowsAmount;
    private int i = 0;

    public void SetDestinationPoints(Transform[] aux, int a)
    {
        destinationPoints = aux;
        arrowsAmount = a;

    }
    void Update()
    {
        if (destinationPoints.Equals(null))
        {

        }
        else
        {
            if (Mathf.Abs(destinationPoints[i].position.magnitude - transform.position.magnitude) > 0.01f)
            {
                //                debug.text = "Moviendo a punto " + i;
                // Vector3 aux = new Vector3(destinationPoints[i].position.x, 0.5f, destinationPoints[i].position.z);
                transform.position = Vector3.MoveTowards(transform.position, destinationPoints[i].position, .01f);
            }
            else
            {
                if (i < arrowsAmount - 1)
                {
                    i++;
                }
                else
                {
                    i = 0;
                }

            }
        }

    }
}
