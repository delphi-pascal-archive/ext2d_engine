library Ext2D;

{$R *.res}
                      
uses
  E2DMain,
  E2DLoader,
  E2DManager,
  E2DScreen,
  E2DSound,
  E2DInput,
  E2DSelect,
  E2DPhysic,
  E2DEffects,
  E2DErrors;

exports
  { Из модуля E2DMain }
  E2D_InitEngine,
  E2D_FreeEngine,
  E2D_GetEngineVersion,

  { Из модуля E2DLoader }
  E2D_LoadImage,
  E2D_LoadSound,
  E2D_LoadFont,
  E2D_FreeMem,

  { Из модуля E2DManager }
  E2D_AddImageFromFile,
  E2D_AddImageFromMem,
  E2D_DeleteImages,
  E2D_GetImageInfo,
  E2D_AddSoundFromFile,
  E2D_AddSoundFromMem,
  E2D_DeleteSounds,
  E2D_GetSoundInfo,
  E2D_AddFontFromFile,
  E2D_AddFontFromMem,
  E2D_DeleteFonts,
  E2D_GetFontInfo,

  { Из модуля E2DScreen }
  E2D_CreateFullscreen,
  E2D_GetDeviceDesc,
  E2D_DrawImage,
  E2D_StretchDraw,
  E2D_ShowBuffer,
  E2D_ClearBuffer,
  E2D_RestoreSurfaces,
  E2D_DrawText,
  E2D_DrawRect,
  E2D_GetGamma,
  E2D_SetGamma,
  E2D_SetRGBGamma,
  E2D_FlipImage,

  { Из модуля E2DSound }
  E2D_CreateSound,
  E2D_PlaySound,
  E2D_StopSound,
  E2D_GetSoundVolume,
  E2D_SetSoundVolume,
  E2D_GetGlobalVolume,
  E2D_SetGlobalVolume,
  E2D_GetSoundPan,
  E2D_SetSoundPan,

  { Из модуля E2DInput }
  E2D_CreateInput,
  E2D_AddKeyboard,
  E2D_AddMouse,
  E2D_UpdateKeyboard,
  E2D_UpdateMouse,
  E2D_IsKeyboardKeyDown,
  E2D_GetCursorPosition,
  E2D_GetCursorDelta,
  E2D_IsMouseButtonDown,

  { Из модуля E2DSelect }
  E2D_CreateSelection,
  E2D_DrawImageToSelect,
  E2D_DrawRectToSelect,
  E2D_ClearSelect,
  E2D_BeginSelection,
  E2D_EndSelection,
  E2D_GetSelectionVal,

  { Из модуля E2DPhysic }
  E2D_GetCollision,

  { Из модуля E2DEffects }
  E2D_BeginEffects,
  E2D_EndEffects,
  E2D_EffectBlend,
  E2D_EffectAlphaMask,
  E2D_EffectUser,
  E2D_PutPoint,

  { Из модуля E2DErrors }
  E2D_ErrorString;
  
begin

end.
 