// ReSharper disable once CheckNamespace
namespace QFX.MFX
{
    internal static class MfxExtensions
    {
        private const string MfxStandardShaderName = "QFX/MFX/Standard";
        private const string MfxStandardSpecularShaderName = "QFX/MFX/Standard Specular";
        private const string MfxStandardTransparentShaderName = "QFX/MFX/Standard Transparent";
        private const string MfxUnlitShaderName = "QFX/MFX/Unlit";

        public static string GetShaderName(this MfxShaderType mfxShaderType)
        {
            switch (mfxShaderType)
            {
                case MfxShaderType.Standard:
                    return MfxStandardShaderName;
                case MfxShaderType.StandardSpecular:
                    return MfxStandardSpecularShaderName;
                case MfxShaderType.StandardTransparent:
                    return MfxStandardTransparentShaderName;
                case MfxShaderType.Unlit:
                    return MfxUnlitShaderName;
                default:
                    return MfxUnlitShaderName;
            }
        }
    }
}