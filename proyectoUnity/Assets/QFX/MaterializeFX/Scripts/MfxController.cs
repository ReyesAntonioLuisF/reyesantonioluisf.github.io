using System;
using System.Linq;
using UnityEngine;

// ReSharper disable once CheckNamespace
namespace QFX.MFX
{
    public sealed class MfxController : MonoBehaviour
    {
        private const string MfxMaskOffsetProperty = "_MaskOffset";
        private const string MfxMaskPositionProperty = "_MaskWorldPosition";

        public MaskOffsetDirection MaskOffsetDirection;

        public AnimationCurve MaskOffsetCurve = AnimationCurve.Linear(0f, 0f, 1f, 1f);
        public float ScaleTimeFactor = 1;
        public float ScaleOffsetFactor = 1;
        public bool ModifyChildren = true;
        public GameObject TargetObject;

        public bool ByDistance;
        public GameObject DistanceBasedObject;

        public bool ReplaceMaterial;
        public bool ReplaceMaterialMode; //Runtime, Editor
        public Material MfxMaterial;
        public MfxShaderType MfxShaderType;

        public bool DetermineWorkflowAutomatically;

        public bool AutoDestroy;
        public bool AutoReplace;
        public bool AutoAnimate;
        public bool AutoStop;

        private float _startTime;
        private bool _isRunning;
        private MfxObjectMaterialUpdater _mfxObjectMaterialUpdater;
        private Transform _targetTransform;
        private bool _wasEventGenerated;

        public GameObject Target
        {
            get
            {
                return TargetObject != null ? TargetObject : gameObject;
            }
        }

        public Action MfxAnimationFinished;

        public void ReplaceMaterials()
        {
            if (!_mfxObjectMaterialUpdater.IsMaterialsReplaced)
                _mfxObjectMaterialUpdater.Replace(MfxMaterial);
        }

        public void RevertMaterials()
        {
            _mfxObjectMaterialUpdater.Revert();
        }

        public void Reset()
        {
            _startTime = Time.time;
        }

        public void Activate()
        {
            Reset();
            if (ReplaceMaterialMode)
                ReplaceMaterials();
            _isRunning = true;
        }

        public void ActivateForward()
        {
            MaskOffsetDirection = MaskOffsetDirection.Forward;
            Activate();
        }

        public void ActivateBackward()
        {
            MaskOffsetDirection = MaskOffsetDirection.Backward;
            Activate();
        }

        public void SetHitPosition(Vector3 hitPositionWorldPos)
        {
            _mfxObjectMaterialUpdater.SetVector("_MaskWorldPosition", hitPositionWorldPos);
        }

        #region Private Methods

        private void Start()
        {
            Init();
        }

        private void OnEnable()
        {
            Init();

            //set first value from curve before animation
            if (!ByDistance)
            {
                float time = 0;

                if (MaskOffsetDirection == MaskOffsetDirection.Backward && MaskOffsetCurve.keys.Length != 0)
                    time = MaskOffsetCurve.keys.Last().time - time;

                var maskOffset = MaskOffsetCurve.Evaluate(time) * ScaleOffsetFactor;

                _mfxObjectMaterialUpdater.SetFloat(MfxMaskOffsetProperty, maskOffset);
            }

            AnimateIfNeeded();
        }

        private void OnDisable()
        {
            _isRunning = false;
        }

        private void Init()
        {
            if (_mfxObjectMaterialUpdater == null)
                _mfxObjectMaterialUpdater = new MfxObjectMaterialUpdater(Target, ModifyChildren, ReplaceMaterial, MfxMaterial, DetermineWorkflowAutomatically, MfxShaderType);
            _targetTransform = Target.transform;
        }

        private void Update()
        {
            if (_targetTransform == null)
                return;

            if (ByDistance)
            {
                if (DistanceBasedObject == null)
                {
                    Debug.LogError("By distance property was set, but object was not set");
                    return;
                }

                _mfxObjectMaterialUpdater.SetVector(MfxMaskPositionProperty, DistanceBasedObject.transform.position);

                return;
            }

            if (!_isRunning)
                return;

            var time = (Time.time - _startTime) / ScaleTimeFactor;

            if (MaskOffsetDirection == MaskOffsetDirection.Backward && MaskOffsetCurve.keys.Length != 0)
                time = MaskOffsetCurve.keys.Last().time - time;

            var maskOffset = MaskOffsetCurve.Evaluate(time) * ScaleOffsetFactor;

            _mfxObjectMaterialUpdater.SetFloat(MfxMaskOffsetProperty, maskOffset);

            if (MaskOffsetCurve.keys.Length != 0)
            {
                var firstCurveTime = MaskOffsetCurve.keys.First();
                var lastCurveTime = MaskOffsetCurve.keys.Last();

                if (!_wasEventGenerated && (MaskOffsetDirection == MaskOffsetDirection.Backward && time < firstCurveTime.time ||
                                            MaskOffsetDirection == MaskOffsetDirection.Forward && time > lastCurveTime.time))
                {
                    _wasEventGenerated = true;

                    if (MfxAnimationFinished != null)
                        MfxAnimationFinished.Invoke();

                    if (AutoStop)
                        _isRunning = false;

                    if (AutoReplace)
                        RevertMaterials();

                    if (AutoDestroy)
                        Destroy(Target);
                }
            }
        }

        private void AnimateIfNeeded()
        {
            _startTime = Time.time;
            _isRunning = AutoAnimate;
        }

        #endregion
    }
}