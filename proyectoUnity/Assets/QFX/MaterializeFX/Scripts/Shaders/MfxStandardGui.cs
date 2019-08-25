#if UNITY_EDITOR
using System;
using UnityEngine;

// ReSharper disable once CheckNamespace
namespace UnityEditor
{
    internal class MfxStandardGui : MfxCommonShaderGUI
    {
        public enum WorkflowMode
        {
            Specular = 0,
            Metallic
        }

        public enum SmoothnessMapChannel
        {
            SpecularMetallicAlpha,
            AlbedoAlpha,
        }

        private static class Styles
        {
            public static GUIContent albedoText = new GUIContent("Albedo", "Albedo (RGB) and Transparency (A)");
            public static GUIContent specularMapText = new GUIContent("Specular", "Specular (RGB) and Smoothness (A)");
            public static GUIContent metallicMapText = new GUIContent("Metallic", "Metallic (R) and Smoothness (A)");
            public static GUIContent smoothnessText = new GUIContent("Smoothness", "Smoothness value");
            public static GUIContent smoothnessScaleText = new GUIContent("Smoothness", "Smoothness scale factor");
            public static GUIContent smoothnessMapChannelText = new GUIContent("Source", "Smoothness texture and channel");
            public static GUIContent highlightsText = new GUIContent("Specular Highlights", "Specular Highlights");
            public static GUIContent reflectionsText = new GUIContent("Reflections", "Glossy Reflections");
            public static GUIContent normalMapText = new GUIContent("Normal Map", "Normal Map");
            public static GUIContent occlusionText = new GUIContent("Occlusion", "Occlusion (G)");
            public static GUIContent emissionText = new GUIContent("Color", "Emission (RGB)");
            public static GUIContent bumpScaleNotSupported = new GUIContent("Bump scale is not supported on mobile platforms");
            public static GUIContent fixNow = new GUIContent("Fix now");

            public static string surfaceProperties = "Surface Properties";
            public static string workflowModeText = "Workflow Mode";
            public static readonly string[] workflowNames = Enum.GetNames(typeof(WorkflowMode));
            public static readonly string[] metallicSmoothnessChannelNames = { "Metallic Alpha", "Albedo Alpha" };
            public static readonly string[] specularSmoothnessChannelNames = { "Specular Alpha", "Albedo Alpha" };
        }

        private WorkflowMode workflowMode;

        private MaterialProperty albedoColor;
        private MaterialProperty albedoMap;

        private MaterialProperty smoothness;
        private MaterialProperty smoothnessScale;
        private MaterialProperty smoothnessMapChannel;

        private MaterialProperty metallic;
        private MaterialProperty specColor;
        private MaterialProperty metallicGlossMap;
        private MaterialProperty specGlossMap;
        private MaterialProperty highlights;
        private MaterialProperty reflections;

        private MaterialProperty bumpScale;
        private MaterialProperty bumpMap;
        private MaterialProperty occlusionStrength;
        private MaterialProperty occlusionMap;
        private MaterialProperty emissionColorForRendering;
        private MaterialProperty emissionMap;

#if UNITY_2017
        private const float kMaxfp16 = 65536f; // Clamp to a value that fits into fp16.
        ColorPickerHDRConfig m_ColorPickerHDRConfig = new ColorPickerHDRConfig(0f, kMaxfp16, 1 / kMaxfp16, 3f);
#endif

        public override void FindProperties(MaterialProperty[] properties)
        {
            base.FindProperties(properties);

//            workflowMode = FindProperty("_WorkflowMode", properties, false);
            albedoColor = FindProperty("_Color", properties, false);
            albedoMap = FindProperty("_MainTex", properties, false);

            smoothness = FindProperty("_Glossiness", properties, false);
            smoothnessScale = FindProperty("_GlossMapScale", properties, false);
            smoothnessMapChannel = FindProperty("_SmoothnessTextureChannel", properties, false);

            metallic = FindProperty("_Metallic", properties, false);
            specColor = FindProperty("_SpecColor", properties, false);
            metallicGlossMap = FindProperty("_MetallicGlossMap", properties, false);
            specGlossMap = FindProperty("_SpecGlossMap", properties, false);
            highlights = FindProperty("_SpecularHighlights", properties, false);
            reflections = FindProperty("_GlossyReflections", properties, false);

            bumpScale = FindProperty("_BumpScale", properties, false);
            bumpMap = FindProperty("_BumpMap", properties, false);
            occlusionStrength = FindProperty("_OcclusionStrength", properties, false);
            occlusionMap = FindProperty("_OcclusionMap", properties, false);
            emissionColorForRendering = FindProperty("_EmissionColor", properties);
            emissionMap = FindProperty("_EmissionMap", properties);

            if (metallicGlossMap != null)
                workflowMode = WorkflowMode.Metallic;
            else if (specGlossMap != null)
                workflowMode = WorkflowMode.Specular;
        }

        public override void MaterialChanged(Material material)
        {
            material.shaderKeywords = null;
            SetupMaterialBlendMode(material);
            SetMaterialKeywords(material);
        }

        public override void ShaderPropertiesGUI(Material material)
        {
            // Use default labelWidth
            EditorGUIUtility.labelWidth = 0f;

            // Detect any changes to the material
            EditorGUI.BeginChangeCheck();
            {
                //DoPopup(Styles.workflowModeText, workflowMode, Styles.workflowNames);

                base.ShaderPropertiesGUI(material);
                GUILayout.Label(Styles.surfaceProperties, EditorStyles.boldLabel);

                DoAlbedoArea();
                DoMetallicSpecularArea();
                DoNormalArea();

                if (occlusionMap != null)
                    m_MaterialEditor.TexturePropertySingleLine(Styles.occlusionText, occlusionMap, occlusionMap.textureValue != null ? occlusionStrength : null);

                DoEmissionArea(material);
                EditorGUI.BeginChangeCheck();
                if (albedoMap != null)
                    m_MaterialEditor.TextureScaleOffsetProperty(albedoMap);
                if (EditorGUI.EndChangeCheck())
                    emissionMap.textureScaleAndOffset = albedoMap.textureScaleAndOffset; // Apply the main texture scale and offset to the emission texture as well, for Enlighten's sake

                EditorGUILayout.Space();

                if (highlights != null)
                    m_MaterialEditor.ShaderProperty(highlights, Styles.highlightsText);
                if (reflections != null)
                    m_MaterialEditor.ShaderProperty(reflections, Styles.reflectionsText);
            }
            if (EditorGUI.EndChangeCheck())
            {
                //foreach (var obj in blendModeProp.targets)
                //    MaterialChanged((Material)obj);
                MaterialChanged(material);
            }

            DoMaterialRenderingOptions();
        }
        
        public override void AssignNewShaderToMaterial(Material material, Shader oldShader, Shader newShader)
        {
            // _Emission property is lost after assigning Standard shader to the material
            // thus transfer it before assigning the new shader
            if (material.HasProperty("_Emission"))
            {
                material.SetColor("_EmissionColor", material.GetColor("_Emission"));
            }

            base.AssignNewShaderToMaterial(material, oldShader, newShader);

            //if (oldShader == null || !oldShader.name.Contains("Legacy Shaders/"))
            //{
            //    SetupMaterialBlendMode(material);
            //    return;
            //}

            //SurfaceType surfaceType = SurfaceType.Opaque;
            //BlendMode blendMode = BlendMode.Alpha;
            //if (oldShader.name.Contains("/Transparent/Cutout/"))
            //{
            //    surfaceType = SurfaceType.Opaque;
            //    material.SetFloat("_AlphaClip", 1);
            //}
            //else if (oldShader.name.Contains("/Transparent/"))
            //{
            //    // NOTE: legacy shaders did not provide physically based transparency
            //    // therefore Fade mode
            //    surfaceType = SurfaceType.Transparent;
            //    blendMode = BlendMode.Alpha;
            //}
            ////material.SetFloat("_Surface", (float)surfaceType);
            ////material.SetFloat("_Blend", (float)blendMode);

            //if (oldShader.name.Equals("Standard (Specular setup)"))
            //{
            //    material.SetFloat("_WorkflowMode", (float)WorkflowMode.Specular);
            //    Texture texture = material.GetTexture("_SpecGlossMap");
            //    if (texture != null)
            //        material.SetTexture("_MetallicSpecGlossMap", texture);
            //}
            //else
            //{
            //    material.SetFloat("_WorkflowMode", (float)WorkflowMode.Metallic);
            //    Texture texture = material.GetTexture("_MetallicGlossMap");
            //    if (texture != null)
            //        material.SetTexture("_MetallicSpecGlossMap", texture);
            //}

            MaterialChanged(material);
        }

        void DoAlbedoArea()
        {
            if (albedoMap != null)
                m_MaterialEditor.TexturePropertySingleLine(Styles.albedoText, albedoMap, albedoColor);
        }

        void DoNormalArea()
        {
            if (bumpMap == null)
                return;
            
            m_MaterialEditor.TexturePropertySingleLine(Styles.normalMapText, bumpMap, bumpMap.textureValue != null ? bumpScale : null);
#if UNITY_2018_2_OR_NEWER
            if (bumpScale.floatValue != 1 && UnityEditorInternal.InternalEditorUtility.IsMobilePlatform(EditorUserBuildSettings.activeBuildTarget))
                if (m_MaterialEditor.HelpBoxWithButton(Styles.bumpScaleNotSupported, Styles.fixNow))
                    bumpScale.floatValue = 1;
#endif
}

        void DoEmissionArea(Material material)
        {
            // Emission for GI?
            if (m_MaterialEditor.EmissionEnabledProperty())
            {
                bool hadEmissionTexture = emissionMap.textureValue != null;

                // Texture and HDR color controls
#if UNITY_2017
                m_MaterialEditor.TexturePropertyWithHDRColor(Styles.emissionText, emissionMap, emissionColorForRendering, m_ColorPickerHDRConfig, false);
#endif
                
#if UNITY_2018_2_OR_NEWER
                m_MaterialEditor.TexturePropertyWithHDRColor(Styles.emissionText, emissionMap, emissionColorForRendering, false);
#endif
                // If texture was assigned and color was black set color to white
                float brightness = emissionColorForRendering.colorValue.maxColorComponent;
                if (emissionMap.textureValue != null && !hadEmissionTexture && brightness <= 0f)
                    emissionColorForRendering.colorValue = Color.white;

                // LW does not support RealtimeEmissive. We set it to bake emissive and handle the emissive is black right.
                material.globalIlluminationFlags = MaterialGlobalIlluminationFlags.BakedEmissive;
                if (brightness <= 0f)
                    material.globalIlluminationFlags |= MaterialGlobalIlluminationFlags.EmissiveIsBlack;
            }
        }

        void DoMetallicSpecularArea()
        {
            if (specGlossMap == null && metallicGlossMap == null)
                return;
            
            string[] metallicSpecSmoothnessChannelName;
            bool hasGlossMap = false;
            if ((WorkflowMode)workflowMode == WorkflowMode.Metallic)
            {
                hasGlossMap = metallicGlossMap.textureValue != null;
                metallicSpecSmoothnessChannelName = Styles.metallicSmoothnessChannelNames;
                m_MaterialEditor.TexturePropertySingleLine(Styles.metallicMapText, metallicGlossMap,
                    hasGlossMap ? null : metallic);
            }
            else
            {
                hasGlossMap = specGlossMap.textureValue != null;
                metallicSpecSmoothnessChannelName = Styles.specularSmoothnessChannelNames;
                m_MaterialEditor.TexturePropertySingleLine(Styles.specularMapText, specGlossMap,
                    hasGlossMap ? null : specColor);
            }

            bool showSmoothnessScale = hasGlossMap;
            if (smoothnessMapChannel != null)
            {
                int smoothnessChannel = (int)smoothnessMapChannel.floatValue;
                if (smoothnessChannel == (int)SmoothnessMapChannel.AlbedoAlpha)
                    showSmoothnessScale = true;
            }

            int indentation = 2; // align with labels of texture properties
            m_MaterialEditor.ShaderProperty(showSmoothnessScale ? smoothnessScale : smoothness, showSmoothnessScale ? Styles.smoothnessScaleText : Styles.smoothnessText, indentation);

            int prevIndentLevel = EditorGUI.indentLevel;
            EditorGUI.indentLevel = 3;
            if (smoothnessMapChannel != null)
                DoPopup(Styles.smoothnessMapChannelText.text, smoothnessMapChannel, metallicSpecSmoothnessChannelName);
            EditorGUI.indentLevel = prevIndentLevel;
        }

        static SmoothnessMapChannel GetSmoothnessMapChannel(Material material)
        {
            int ch = (int)material.GetFloat("_SmoothnessTextureChannel");
            if (ch == (int)SmoothnessMapChannel.AlbedoAlpha)
                return SmoothnessMapChannel.AlbedoAlpha;

            return SmoothnessMapChannel.SpecularMetallicAlpha;
        }

        void SetMaterialKeywords(Material material)
        {
            // Note: keywords must be based on Material value not on MaterialProperty due to multi-edit & material animation
            // (MaterialProperty value might come from renderer material property block)
//            bool isSpecularWorkFlow = material.HasProperty("_WorkflowMode") && (WorkflowMode)material.GetFloat("_WorkflowMode") == WorkflowMode.Specular;
            //CoreUtils.SetKeyword(material, "_SPECULAR_SETUP_ON", isSpecularWorkFlow);

            var hasMet = material.HasProperty("_MetallicGlossMap") && material.GetTexture("_MetallicGlossMap") != null;
            var hasSpec = material.HasProperty("_SpecGlossMap") && material.GetTexture("_SpecGlossMap") != null;
            
            SetKeyword(material, "_METALLICGLOSSMAP_ON", hasMet);
            SetKeyword(material, "_SPECGLOSSMAP_ON", hasSpec);

            SetKeyword(material, "_METALLICSPECGLOSSMAP_ON", hasMet || hasSpec);
            
            //SetKeyword(material, "_SPECULAR_SETUP", false);
            //CoreUtils.SetKeyword(material, "_METALLICGLOSSMAP_ON", hasGlossMap && !isSpecularWorkFlow);

            SetKeyword(material, "_NORMALMAP", material.GetTexture("_BumpMap"));

            if (highlights != null)
                SetKeyword(material, "_SPECULARHIGHLIGHTS_OFF", material.GetFloat("_SpecularHighlights") == 0.0f);
            if (reflections != null)
                SetKeyword(material, "_GLOSSYREFLECTIONS_OFF", material.GetFloat("_GlossyReflections") == 0.0f);

            SetKeyword(material, "_OCCLUSIONMAP", material.GetTexture("_OcclusionMap"));
            //CoreUtils.SetKeyword(material, "_PARALLAXMAP", material.GetTexture("_ParallaxMap"));
            //CoreUtils.SetKeyword(material, "_DETAIL_MULX2", material.GetTexture("_DetailAlbedoMap") || material.GetTexture("_DetailNormalMap"));

            if (material.HasProperty("_ReceiveShadows"))
                SetKeyword(material, "_RECEIVE_SHADOWS_OFF", material.GetFloat("_ReceiveShadows") == 0.0f);

            // A material's GI flag internally keeps track of whether emission is enabled at all, it's enabled but has no effect
            // or is enabled and may be modified at runtime. This state depends on the values of the current flag and emissive color.
            // The fixup routine makes sure that the material is in the correct state if/when changes are made to the mode or color.
            MaterialEditor.FixupEmissiveFlag(material);
            bool shouldEmissionBeEnabled = (material.globalIlluminationFlags & MaterialGlobalIlluminationFlags.EmissiveIsBlack) == 0;
            SetKeyword(material, "_EMISSION", shouldEmissionBeEnabled);

            if (material.HasProperty("_SmoothnessTextureChannel"))
            {
                SetKeyword(material, "_SMOOTHNESSTEXTURECHANNEL_ALBEDOALPHA", GetSmoothnessMapChannel(material) == SmoothnessMapChannel.AlbedoAlpha);
            }
            
            material.EnableKeyword("_ALPHATEST_ON");
        }

        protected static void SetKeyword(Material m, string keyword, bool state)
        {
            if (state)
                m.EnableKeyword(keyword);
            else
                m.DisableKeyword(keyword);
        }
    }
}
#endif
