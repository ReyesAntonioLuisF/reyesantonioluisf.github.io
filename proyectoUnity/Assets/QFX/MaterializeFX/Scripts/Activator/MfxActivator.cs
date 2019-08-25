using UnityEngine;

// ReSharper disable once CheckNamespace
namespace QFX.MFX
{
    [RequireComponent(typeof(MfxController))]
    internal class MfxActivator : MonoBehaviour
    {
        private MfxController _mfxController;
        private bool _isAlreadyActivated;

        public void Activate(Vector3 hitWorldPos)
        {
            if (_isAlreadyActivated)
                return;

            _isAlreadyActivated = true;
            _mfxController.ReplaceMaterials();
            _mfxController.Activate();
            _mfxController.SetHitPosition(hitWorldPos);
        }

        private void Awake()
        {
            _mfxController = GetComponent<MfxController>();
        }
    }
}
