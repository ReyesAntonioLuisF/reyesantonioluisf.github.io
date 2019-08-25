---------------------------------------------------------------------------------------------------------
MfxController
---------------------------------------------------------------------------------------------------------

This script does all work.

Main Params:

“Modify children” - if enabled, script will animate and replace materials of all children.

“Target object” - you can add MfxController script to “fake” object and specify target object, which should be materialized. If “Target” is not specified, the script will get the current gameObject.

Distance Params:

“Depending on the distance” - if enabled, you need to specify the object to calculate distance so the shader will work in “Distance Based” mode. 
It will materialize or disintegrate the object based on the distance between objects.

The script will provide the position of “Target Object” in the world coordinates into the shader.

Mfx Params:

“Mask Direction” : Direction of the animation curve: you don’t need to change the curve if you want to change only the direction.

“Mask Offset Curve” : The animation Curve of the “Mask Offset” shader parameter: the object materializes and disintegrates depended on this parameter.

“Scale Time Factor” : the value to scale time.

“Scale Value Factor” : the value to scale value.


Auto Params:

“Animate after the start” : if enabled, the script will do all the work immediately after the start.

“Revert materials after animation is complete” : When the curve will end, the script will revert materials to original (materials on object before they were replaced).

“Destroy after animation is complete” : when the curve will end, “Target” object will be destroyed.

Replace materials Params:

Determine workflow automatically : if enabled, the script will try to determine workflow of the shader, you don’t need to specify shader of replacement material.

If you added new version of shader, or want to change it, you need to modify the function: GetShaderByWorkflow in the MfxMaterialUtil script

If you want to add new version of shader, you need to add it to the MfxShaderType enum.


“Shader type” : the script will set this shader in the replaced material.

 “Mfx Material Template” : the template of the MaterializeFx material. All MaterializeFx properties of the shader will be copied from this template to the replaced material.

“Replace Material At Start” : material on target object will be replaced after the start.

“Replace in editor” : adds opinion to Copy and Replace original material. All materials on target object will be copied and replaced by a copy (mfx params will set by template material). 

The copies will store in the original material folder with “MFX” postfix. 

 
---------------------------------------------------------------------------------------------------------
Public Api:
---------------------------------------------------------------------------------------------------------

void ReplaceMaterials() - replace materials.

void RevertMaterials() - revert materials.

void Reset() - reset animation curve time.

void Activate() - start animation.

void SetHitPosition(Vector3 hitPositionWorldPos) - set position of the mask in the world coordinates.



