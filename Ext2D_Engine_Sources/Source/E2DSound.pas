(************************************* Ext2D Engine *************************************)
(* ������     : E2DSound.pas                                                            *)
(* �����      : ���� ��������                                                           *)
(* ������     : 03.11.06                                                                *)
(* ���������� : ������ ������� ������� ��� ������ �� ������.                            *)
(* ���������  : ��� ���������.                                                          *)
(****************************************************************************************)

unit E2DSound;

interface

uses
  E2DTypes;

  { ������� ��� �������� �������� DirectSound.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_CreateSound : E2D_Result; stdcall; export;

  { ������� ��� ��������������� �����. ��������� :
      SoundID : ������������� �����, ������� ���������� �������������;
      Loop    : ����, ��������������� ���� �� ��������� ���������������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_PlaySound(SoundID : E2D_TSoundID;
                         Loop : Boolean) : E2D_Result; stdcall; export;

  { ������� ��� ��������� ��������������� �����. ��������� :
      SoundID : ������������� �����, ������� ���������� ����������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_StopSound(SoundID : E2D_TSoundID) : E2D_Result; stdcall; export;

  { ������� ��� ��������� ��������� �����. ��������� :
      SoundID : ������������� �����, ��������� ������� ���������� ��������;
      Volume  : ���������� ��� ���������� ���������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_GetSoundVolume(SoundID : E2D_TSoundID; var
                              Volume : E2D_TSoundVolume) : E2D_Result; stdcall; export;

  { ������� ��� ������������ ��������� �����. ��������� :
      SoundID : ������������� �����, ��������� ������� ���������� ����������;
      Volume  : ���������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_SetSoundVolume(SoundID : E2D_TSoundID;
                              Volume : E2D_TSoundVolume) : E2D_Result; stdcall; export;

  { ������� ��� ��������� ���������� ���������.
    ������������ �������� : ���������. }
  function E2D_GetGlobalVolume : E2D_TSoundVolume; stdcall; export;

  { ������� ��� ������������ ���������� ���������. ��������� :
      Volume : ���������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_SetGlobalVolume(Volume : E2D_TSoundVolume) : E2D_Result; stdcall; export;

  { ������� ��� ��������� �������� �����. ��������� :
      SoundID : ������������� �����, �������� ������� ���������� ��������;
      Pan     : ���������� ��� ���������� ��������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_GetSoundPan(SoundID : E2D_TSoundID;
                           var Pan : E2D_TSoundPan) : E2D_Result; stdcall; export;

  { ������� ��� ������������ �������� �����. ��������� :
      SoundID : ������������� �����, �������� ������� ���������� ����������;
      Pan     : ��������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_SetSoundPan(SoundID : E2D_TSoundID;
                           Pan : E2D_TSoundPan) : E2D_Result; stdcall; export;


implementation

uses
  E2DVars,     { ��� ���������� ����� }
  E2DConsts,   { ��� �������� ������ }
  DirectSound; { ��� ������� DirectSound }

function E2D_CreateSound;
begin { E2D_CreateSound }
  // ������� ������� ������ DirectSound.
  if DirectSoundCreate8(nil, DS_Main, nil) <> DS_OK then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������
    Result := E2DERR_SOUND_CREATEDS;
    // � ������� �� �������.
    Exit;
  end; { if }

  // ������ ������� ����������.
  if DS_Main.SetCooperativeLevel(Window_Handle,
                                 DSSCL_EXCLUSIVE) <> DS_OK then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������,
    Result := E2DERR_SYSTEM_SETCOOPLVL;
    // ������� ������� ������ DirectSound
    DS_Main := nil;
    // � ������� �� �������.
    Exit;
  end; { if }

  // ������ ��������� ��������.
  Result := E2DERR_OK;
end; { E2D_CreateSound }

function E2D_PlaySound;
begin { E2D_PlaySound }
  // ��������� ������������� �����.
  if SoundID >= NumSounds then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������
    Result := E2DERR_SYSTEM_INVALIDID;
    // � ������� �� �������.
    Exit;
  end; { if }

  // ������������� ����.
  if Sounds[SoundID].Buffer.Play(0, 0,
                                 Byte(Loop) * DSBPLAY_LOOPING) <> DS_OK then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������
    Result := E2DERR_SOUND_CANTPLAY;
    // � ������� �� �������.
    Exit;
  end; { if }
  
  // ������ ��������� ��������.
  Result := E2DERR_OK;
end; { E2D_PlaySound }

function E2D_StopSound;
begin { E2D_StopSound }
  // ��������� ������������� �����.
  if SoundID >= NumSounds then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������
    Result := E2DERR_SYSTEM_INVALIDID;
    // � ������� �� �������.
    Exit;
  end; { if }

  // ������������� ����.
  if Sounds[SoundID].Buffer.Stop <> DS_OK then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������
    Result := E2DERR_SOUND_CANTSTOP;
    // � ������� �� �������.
    Exit;
  end; { if }

  // ������ ��������� ��������.
  Result := E2DERR_OK;
end; { E2D_StopSound }

function E2D_GetSoundVolume;
begin { E2D_GetSoundVolume }
  // ��������� ������������� �����.
  if SoundID >= NumSounds then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������
    Result := E2DERR_SYSTEM_INVALIDID;
    // � ������� �� �������.
    Exit;
  end; { if }

  // �������� ���������.
  if Sounds[SoundID].Buffer.GetVolume(PInteger(@Volume)^) <> DS_OK then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������
    Result := E2DERR_SOUND_CANTGETVOL;
    // � ������� �� �������.
    Exit;
  end; { if }

  // ������ ��������� ��������.
  Result := E2DERR_OK;
end; { E2D_GetSoundVolume }

function E2D_SetSoundVolume;
begin { E2D_SetSoundVolume }
  // ��������� ������������� �����.
  if SoundID >= NumSounds then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������
    Result := E2DERR_SYSTEM_INVALIDID;
    // � ������� �� �������.
    Exit;
  end; { if }

  // ������������� ���������.
  if Sounds[SoundID].Buffer.SetVolume(Volume) <> DS_OK then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������
    Result := E2DERR_SOUND_CANTSETVOL;
    // � ������� �� �������.
    Exit;
  end; { if }

  // ������ ��������� ��������.
  Result := E2DERR_OK;
end; { E2D_SetSoundVolume }

function E2D_GetGlobalVolume;
begin { E2D_GetGlobalVolume }
  // �������� � ��������� ���������.
  Result := Volume_Global;
end; { E2D_GetGlobalVolume }

function E2D_SetGlobalVolume;
var
  i : Longword; { ������� ����� }
begin { E2D_SetGlobalVolume }
  // ������ ��������� ��������.
  Result := E2DERR_OK;

  // ��������� ���������� ����������� ������.
  if NumSounds > 0 then
    // ���� ���������� ������������� ��������� ���� ������.
    for i := 0 to NumSounds - 1 do begin
      // ������������� ���������.
      Result := E2D_SetSoundVolume(i, Volume);
      // ��������� ��������� ����������.
      if Result <> E2DERR_OK then
        // ���� �� ���������� ������� �� �������.
        Exit;
    end;

  // ��������� ����� ���������.  
  Volume_Global := Volume;
end; { E2D_SetGlobalVolume }

function E2D_GetSoundPan;
begin { GetSoundPan }
  // ��������� ������������� �����.
  if SoundID >= NumSounds then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������
    Result := E2DERR_SYSTEM_INVALIDID;
    // � ������� �� �������.
    Exit;
  end; { if }

  // �������� ��������.
  if Sounds[SoundID].Buffer.GetPan(PInteger(@Pan)^) <> DS_OK then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������
    Result := E2DERR_SOUND_CANTGETPAN;
    // � ������� �� �������.
    Exit;
  end; { if }

  // ������ ��������� ��������.
  Result := E2DERR_OK;
end; { GetSoundPan }

function E2D_SetSoundPan;
begin { SetSoundPan }
  // ��������� ������������� �����.
  if SoundID >= NumSounds then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������
    Result := E2DERR_SYSTEM_INVALIDID;
    // � ������� �� �������.
    Exit;
  end; { if }

  // ������������� ��������.
  if Sounds[SoundID].Buffer.SetPan(Pan) <> DS_OK then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������
    Result := E2DERR_SOUND_CANTSETPAN;
    // � ������� �� �������.
    Exit;
  end; { if }

  // ������ ��������� ��������.
  Result := E2DERR_OK;
end; { SetSoundPan }

end.
