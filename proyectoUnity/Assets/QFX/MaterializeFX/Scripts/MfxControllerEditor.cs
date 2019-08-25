#if UNITY_EDITOR
using System.Globalization;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.SceneManagement;

// ReSharper disable once CheckNamespace
namespace QFX.MFX
{
    [CustomEditor(typeof(MfxController))]
    internal sealed class MfxControllerEditor : Editor
    {
        public override void OnInspectorGUI()
        {
            var mfxController = (MfxController)target;

            // Modify children
            EditorGUILayout.Separator();
            mfxController.ModifyChildren = EditorGUILayout.Toggle(MfxEditorLocalization.ModifyChildrenLabel, mfxController.ModifyChildren);

            // Target object
            mfxController.TargetObject = (GameObject)EditorGUILayout.ObjectField(MfxEditorLocalization.TargetObjectLabel, mfxController.TargetObject, typeof(GameObject), true);

            ShowByDistanceUi(mfxController);

            if (!mfxController.ByDistance)
                ShowMaskOffsetUi(mfxController);

            ShowAutoParamsUi(mfxController);

            ShowReplaceMaterialsUi(mfxController);

            if (GUI.changed)
            {
                EditorUtility.SetDirty((MfxController)target);
                EditorSceneManager.MarkSceneDirty(SceneManager.GetActiveScene());
            }
        }

        private static void ShowByDistanceUi(MfxController mfxController)
        {
            EditorGUILayout.Separator();
            EditorGUILayout.LabelField(MfxEditorLocalization.DistanceParamsLabel, EditorStyles.boldLabel);

            // ReplaceMaterials depending on the distance
            mfxController.ByDistance = EditorGUILayout.Toggle(MfxEditorLocalization.ByDistanceLabel, mfxController.ByDistance);

            // Object To Calculate Distance
            if (mfxController.ByDistance)
                mfxController.DistanceBasedObject = (GameObject)EditorGUILayout.ObjectField(MfxEditorLocalization.DistanceBasedObjectLabel, mfxController.DistanceBasedObject, typeof(GameObject), true);
        }

        private static void ShowReplaceMaterialsUi(MfxController mfxController)
        {
            EditorGUILayout.Separator();
            EditorGUILayout.LabelField(MfxEditorLocalization.ReplaceMaterialParamsLabel, EditorStyles.boldLabel);

            mfxController.DetermineWorkflowAutomatically = EditorGUILayout.Toggle(MfxEditorLocalization.DetermineWorkflowAutomaticallyLabel, mfxController.DetermineWorkflowAutomatically);

            if (!mfxController.DetermineWorkflowAutomatically)
                mfxController.MfxShaderType = (MfxShaderType)EditorGUILayout.EnumPopup(MfxEditorLocalization.ShaderTypeLabel, mfxController.MfxShaderType);

            mfxController.MfxMaterial = (Material)EditorGUILayout.ObjectField(MfxEditorLocalization.MaterialLabel, mfxController.MfxMaterial, typeof(Material), true);

            mfxController.ReplaceMaterial = EditorGUILayout.Toggle(MfxEditorLocalization.ReplaceMaterialLabel, mfxController.ReplaceMaterial);

            //if (mfxController.ReplaceMaterial)
            {
                mfxController.ReplaceMaterialMode = EditorGUILayout.Toggle(MfxEditorLocalization.ReplaceMaterialInEditorLabel, mfxController.ReplaceMaterialMode);

                if (mfxController.ReplaceMaterialMode)
                {
                    var materialsCount = MfxMaterialUtil.GetMaterialsCount(mfxController.TargetObject);

                    EditorGUILayout.LabelField(MfxEditorLocalization.MaterialsCountLabel + materialsCount);

                    if (GUILayout.Button(MfxEditorLocalization.ReplaceMaterialButton))
                    {
                        if (mfxController.MfxMaterial == null)
                            Debug.LogWarning("template mfx materials is not selected");
                        else
                            MfxMaterialUtil.ReplaceRenderersMaterials(mfxController.MfxMaterial, mfxController.Target, mfxController.DetermineWorkflowAutomatically,
                                mfxController.MfxShaderType, true);
                    }
                }
            }
        }

        private static void ShowMaskOffsetUi(MfxController mfxController)
        {
            EditorGUILayout.Separator();
            EditorGUILayout.LabelField(MfxEditorLocalization.MfxParamsLabel, EditorStyles.boldLabel);

            mfxController.MaskOffsetDirection = (MaskOffsetDirection)EditorGUILayout.EnumPopup(MfxEditorLocalization.MaskOffsetDirection, mfxController.MaskOffsetDirection);
            mfxController.MaskOffsetCurve = EditorGUILayout.CurveField(MfxEditorLocalization.MaskOffsetCurve, mfxController.MaskOffsetCurve);
            mfxController.ScaleTimeFactor = float.Parse(EditorGUILayout.TextField(MfxEditorLocalization.ScaleTimeLabel, mfxController.ScaleTimeFactor.ToString(CultureInfo.InvariantCulture)));
            mfxController.ScaleOffsetFactor = float.Parse(EditorGUILayout.TextField(MfxEditorLocalization.ScalePositionLabel, mfxController.ScaleOffsetFactor.ToString(CultureInfo.InvariantCulture)));
        }

        private static void ShowAutoParamsUi(MfxController mfxController)
        {
            EditorGUILayout.Separator();
            EditorGUILayout.LabelField(MfxEditorLocalization.AutoParamsLabel, EditorStyles.boldLabel);

            mfxController.AutoAnimate = EditorGUILayout.Toggle(MfxEditorLocalization.AutoAnimateLabel, mfxController.AutoAnimate);

            mfxController.AutoStop = EditorGUILayout.Toggle(MfxEditorLocalization.AutoStopLabel, mfxController.AutoStop);

            if (!mfxController.AutoDestroy)
                mfxController.AutoReplace = EditorGUILayout.Toggle(MfxEditorLocalization.AutoReplaceLabel, mfxController.AutoReplace);

            if (!mfxController.AutoReplace)
                mfxController.AutoDestroy = EditorGUILayout.Toggle(MfxEditorLocalization.AutoDestroyLabel, mfxController.AutoDestroy);
        }

        private static class MfxEditorLocalization
        {
            public const string ShaderTypeLabel = "Shader Type";

            public const string TargetObjectLabel = "Target Object";
            public const string ModifyChildrenLabel = "Modify Children";
            public const string DistanceParamsLabel = "Distance Params";
            public const string ByDistanceLabel = "Depending on the distance";
            public const string DistanceBasedObjectLabel = "Object to calcualte distance";

            public const string MfxParamsLabel = "Mfx Params";
            public const string MaskOffsetDirection = "Mask Direction";
            public const string MaskOffsetCurve = "Mask Offset Curve";
            public const string ScaleTimeLabel = "Scale Time Factor";
            public const string ScalePositionLabel = "Scale Offset Factor";

            public const string ReplaceMaterialParamsLabel = "Replace Material Params";
            public const string DetermineWorkflowAutomaticallyLabel = "Determine Workflow Automatically";
            public const string ReplaceMaterialLabel = "Replace Material At Start";
            public const string ReplaceMaterialInEditorLabel = "Replace in Editor";
            public const string ReplaceMaterialButton = "Copy & Replace";
            public const string MaterialLabel = "Mfx Material Template";

            public const string AutoParamsLabel = "Auto Params";
            public const string AutoDestroyLabel = "Destroy after animation is complete";
            public const string AutoReplaceLabel = "Revert materials after animation is complete";
            public const string AutoAnimateLabel = "Animate after the start";
            public const string AutoStopLabel = "Stop animation after it's completion";

            public const string MaterialsCountLabel = "Materials Count: ";
        }
    }
}
#endif