using System.Collections.Generic;
using UnityEngine;
using Object = UnityEngine.Object;

// ReSharper disable once CheckNamespace
namespace QFX.MFX
{
    internal sealed class MfxObjectMaterialUpdater
    {
        private readonly bool _determineWorkflow;
        private readonly MfxShaderType _mfxShaderType;
        private readonly Renderer[] _renderers;

        private readonly Dictionary<Renderer, Material[]> _rendererToOriginalMaterialsMap =
            new Dictionary<Renderer, Material[]>();

        private readonly List<Material> _mfxMaterials = new List<Material>();

        public bool IsMaterialsReplaced { get; private set; }

        public MfxObjectMaterialUpdater(GameObject targetObject, bool modifyChildren, bool replaceMaterialsAtStart,
            Material mfxTemplateMaterial, bool determineWorkflow, MfxShaderType mfxShaderType)
        {
            _determineWorkflow = determineWorkflow;
            _mfxShaderType = mfxShaderType;

            _renderers = modifyChildren
                ? targetObject.GetComponentsInChildren<Renderer>()
                : targetObject.GetComponents<Renderer>();

            if (!replaceMaterialsAtStart)
            {
                foreach (var renderer in _renderers)
                    foreach (var material in renderer.materials)
                        _mfxMaterials.Add(material);
                return;
            }

            Replace(mfxTemplateMaterial);
        }

        public void SetFloat(string propertyName, float value)
        {
            foreach (var mfxMaterial in _mfxMaterials)
                mfxMaterial.SetFloat(propertyName, value);
        }

        public void SetInt(string propertyName, int value)
        {
            foreach (var mfxMaterial in _mfxMaterials)
                mfxMaterial.SetInt(propertyName, value);
        }

        public void SetVector(string propertyName, Vector3 value)
        {
            foreach (var mfxMaterial in _mfxMaterials)
                mfxMaterial.SetVector(propertyName, value);
        }

        public void Replace(Material mfxMaterialTemplate)
        {
            IsMaterialsReplaced = true;

            _rendererToOriginalMaterialsMap.Clear();
            _mfxMaterials.Clear();

            foreach (var renderer in _renderers)
            {
                var rendererSharedMaterials = renderer.materials;

                _rendererToOriginalMaterialsMap[renderer] = rendererSharedMaterials;

                var newMaterials = MfxMaterialUtil.ReplaceMaterialsToMfx(mfxMaterialTemplate, rendererSharedMaterials,
                    _determineWorkflow, _mfxShaderType, false);

                renderer.materials = newMaterials.ToArray();
                _mfxMaterials.AddRange(newMaterials);
            }
        }

        public void Revert()
        {
            IsMaterialsReplaced = false;

            // ReSharper disable once ForCanBeConvertedToForeach
            for (int i = 0; i < _renderers.Length; i++)
            {
                if (_rendererToOriginalMaterialsMap.ContainsKey(_renderers[i]))
                    _renderers[i].materials = _rendererToOriginalMaterialsMap[_renderers[i]];
            }

            _rendererToOriginalMaterialsMap.Clear();

            foreach (var mfxMaterial in _mfxMaterials)
                Object.DestroyImmediate(mfxMaterial);

            _mfxMaterials.Clear();
        }
    }
}