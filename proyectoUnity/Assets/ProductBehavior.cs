using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ProductBehavior : MonoBehaviour
{
    //Variables de la rotación
    private float turnAngleDelta = 0;
    private float turnAngle = 0;
    private float pinchTurnRatio = Mathf.PI / 2;
    private float minTurnAngle = 0;

    //Variables para mirar a la cámara
    private Camera mainCamera;
    //private Transform tempTransform;

    // Start is called before the first frame update
    void Start()
    {
        mainCamera = FindObjectOfType<Camera>();
        
        MirarACamara();
    }

    // Update is called once per frame
    void Update()
    {
        //MirarACamara();
        
    }

    private void LateUpdate()
    {
        if (Input.touchCount == 2)
        {
            
            Rotar();
            
        }
    }

    /// <summary>
	///   Calculates Pinch and Turn - This should be used inside LateUpdate
	/// </summary>
	void Rotar()
    {
        // if two fingers are touching the screen at the same time ...
        if (Input.touchCount == 2)
        {
            Quaternion desiredRotation = transform.rotation;

            Touch touch1 = Input.touches[0];
            Touch touch2 = Input.touches[1];

            // ... if at least one of them moved ...
            if (touch1.phase == TouchPhase.Moved || touch2.phase == TouchPhase.Moved)
            {
                // check the delta angle between them ...
                turnAngle = Angle(touch1.position, touch2.position);
                float prevTurn = Angle(touch1.position - touch1.deltaPosition,
                                       touch2.position - touch2.deltaPosition);
                turnAngleDelta = Mathf.DeltaAngle(prevTurn, turnAngle);

                // ... if it's greater than a minimum threshold, it's a turn!
                if (Mathf.Abs(turnAngleDelta) > minTurnAngle)
                {
                    turnAngleDelta *= pinchTurnRatio;
                }
                else
                {
                    turnAngle = turnAngleDelta = 0;
                }
            }

            if (Mathf.Abs(turnAngleDelta) > 0)
            { // rotate
                Vector3 rotationDeg = Vector3.zero;
                rotationDeg.y = -turnAngleDelta;
                desiredRotation *= Quaternion.Euler(rotationDeg);
            }
            // not so sure those will work:
            transform.rotation = desiredRotation;
        }
    }

    static private float Angle(Vector2 pos1, Vector2 pos2)
    {
        Vector2 from = pos2 - pos1;
        Vector2 to = new Vector2(1, 0);

        float result = Vector2.Angle(from, to);
        Vector3 cross = Vector3.Cross(from, to);

        if (cross.z > 0)
        {
            result = 360f - result;
        }

        return result;
    }

    void MirarACamara()
    {
        Vector3 camAux = new Vector3(mainCamera.transform.position.x, transform.position.y, mainCamera.transform.position.z);
        transform.LookAt(camAux);
        //transform.rotation = new Quaternion(transform.rotation.x, tempTransform.rotation.y, transform.rotation.z, transform.rotation.w);
    }
}
