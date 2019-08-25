using UnityEngine;

// ReSharper disable once CheckNamespace
namespace Assets.MaterializeFX
{
    public class SimpleFpsController : MonoBehaviour
    {
        private readonly float lookSensitivity = 5;
        private readonly float _lookSmoothnes = 0.1f;
        private float _yRotation;
        private float _xRotation;
        private float _currentXRotation;
        private float _currentYRotation;
        private float _yRotationV;
        private float _xRotationV;

        private void Update()
        {
            _yRotation += Input.GetAxis("Mouse X") * lookSensitivity;
            _xRotation -= Input.GetAxis("Mouse Y") * lookSensitivity;
            _xRotation = Mathf.Clamp(_xRotation, -80, 100);
            _currentXRotation = Mathf.SmoothDamp(_currentXRotation, _xRotation, ref _xRotationV, _lookSmoothnes);
            _currentYRotation = Mathf.SmoothDamp(_currentYRotation, _yRotation, ref _yRotationV, _lookSmoothnes);
            transform.rotation = Quaternion.Euler(_xRotation, _yRotation, 0);
        }
    }
}
