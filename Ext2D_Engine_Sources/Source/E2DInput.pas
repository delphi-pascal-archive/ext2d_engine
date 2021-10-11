(************************************* Ext2D Engine *************************************)
(* ������     : E2DInput.pas                                                            *)
(* �����      : ���� ��������                                                           *)
(* ������     : 21.10.06                                                                *)
(* ���������� : ������ ������� ������� ��� ������ � ����������� � �����.                *)
(* ���������  : ��� ���������.                                                          *)
(****************************************************************************************)

unit E2DInput;

interface

uses
  E2DTypes, Windows;

  { ������� ��� �������� �������� DirectInput.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_CreateInput : E2D_Result; stdcall; export;

  { ������� ��� �������� ���������� ����������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_AddKeyboard : E2D_Result; stdcall; export;

  { ������� ��� �������� ���������� ����.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_AddMouse : E2D_Result; stdcall; export;

  { ������� ��� ���������� ������ ����������.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_UpdateKeyboard : E2D_Result; stdcall; export;

  { ������� ��� ���������� ������ ����.
    ������������ �������� : ���� ������� ����������� ������� - E2DERR_OK, ���� �������� -
                            ��� ������. }
  function E2D_UpdateMouse : E2D_Result; stdcall; export;

  { ������� ��� ��������� ���������� � ���, ������ �� ������� �� ����������. ��������� :
      Key : ��� �������, ���������� � ������� ���������� ��������.
    ������������ �������� : ���� ������� ������ - True, ���� ��� - False. }
  function E2D_IsKeyboardKeyDown(Key : Byte) : Boolean; stdcall; export;

  { ��������� ��� ��������� ������� �������. ��������� :
      CursorPos : ���������� ��� ���������� ������� �������. }
  procedure E2D_GetCursorPosition(var CursorPos : TPoint); stdcall; export;

  { ��������� ��� ��������� ���������� ������� �������. ��������� :
      CursorDeltas : ���������� ��� ���������� ���������� ������� �������. }
  procedure E2D_GetCursorDelta(var CursorDeltas : TPoint); stdcall; export;

  { ������� ��� ��������� ���������� � ���, ������ �� ������ ����. ��������� :
      Button : ������, ���������� � ������� ���������� ��������.
    ������������ �������� : ���� ������� ������ - True, ���� ��� - False. }
  function E2D_IsMouseButtonDown(Button : E2D_TMouseButton) : Boolean; stdcall; export;

implementation

uses
  E2DConsts,    { ��� �������� ������ }
  E2DVars,      { ��� ���������� ����� }
  DirectInput8; { ��� ������� DirectInput }

function E2D_CreateInput;
begin { E2D_CreateInput }
  // ������� ������� ������ DirectInput.
  if DirectInput8Create(HInstance, DIRECTINPUT_VERSION, IID_IDirectInput8,
                        DI_Main, nil) <> DI_OK then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������
    Result := E2DERR_INPUT_CREATEDI;
    // � ������� �� �������.
    Exit;
  end; { if }

  // ������ ��������� ��������.
  Result := E2DERR_OK;
end; { E2D_CreateInput }

function E2D_AddKeyboard;
begin { E2D_AddKeyboard }
  // ������� ���������� ����������.
  if DI_Main.CreateDevice(GUID_SysKeyboard, DID_Keyboard, nil) <> DI_OK then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������
    Result := E2DERR_INPUT_CREATEDEV;
    // � ������� �� �������.
    Exit;
  end; { if }

  // ������ ������ ������ ����������.
  if DID_Keyboard.SetDataFormat(c_dfDIKeyboard) <> DI_OK then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������,
    Result := E2DERR_INPUT_SETDATAFMT;
    // ������� ����������
    DID_Keyboard := nil;
    // � ������� �� �������.
    Exit;
  end; { if }

  // ������ ������� ����������.
  if DID_Keyboard.SetCooperativeLevel(Window_Handle, DISCL_EXCLUSIVE or
                                      DISCL_FOREGROUND) <> DI_OK then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������,
    Result := E2DERR_SYSTEM_SETCOOPLVL;
    // ������� ����������
    DID_Keyboard := nil;
    // � ������� �� �������.
    Exit;
  end; { if }

  // ����������� ����������.
  if DID_Keyboard.Acquire <> DI_OK then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������,
    Result := E2DERR_INPUT_CANTACQR;
    // ������� ����������
    DID_Keyboard := nil;
    // � ������� �� �������.
    Exit;
  end; { if }

  // ������ ��������� ��������.
  Result := E2DERR_OK;
end; { E2D_AddKeyboard }

function E2D_AddMouse;
begin { E2D_AddMouse }
  // ������� ���������� ����.
  if DI_Main.CreateDevice(GUID_SysMouse, DID_Mouse, nil) <> DI_OK then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������
    Result := E2DERR_INPUT_CREATEDEV;
    // � ������� �� �������.
    Exit;
  end; { if }

  // ������ ������ ������ ����.
  if DID_Mouse.SetDataFormat(c_dfDIMouse2) <> DI_OK then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������,
    Result := E2DERR_INPUT_SETDATAFMT;
    // ������� ����
    DID_Mouse := nil;
    // � ������� �� �������.
    Exit;
  end; { if }

  // ������ ������� ����������.
  if DID_Mouse.SetCooperativeLevel(Window_Handle, DISCL_EXCLUSIVE or
                                   DISCL_FOREGROUND) <> DI_OK then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������,
    Result := E2DERR_SYSTEM_SETCOOPLVL;
    // ������� ����
    DID_Mouse := nil;
    // � ������� �� �������.
    Exit;
  end; { if }

  // ����������� ����.
  if DID_Mouse.Acquire <> DI_OK then begin { if }
    // ���� �� ���������� �������� ��� ������ � ���������,
    Result := E2DERR_INPUT_CANTACQR;
    // ������� ����
    DID_Mouse := nil;
    // � ������� �� �������.
    Exit;
  end; { if }

  // ������ ��������� ��������.
  Result := E2DERR_OK;
end; { E2D_AddMouse }

function E2D_UpdateKeyboard;
var
  res : HRESULT;
begin { E2D_UpdateKeyboard }
  // �������� ���������.
  ZeroMemory(@Keyboard_Data, SizeOf(Keyboard_Data));
  // �������� ������ � ����������.
  res := DID_Keyboard.GetDeviceState(SizeOf(Keyboard_Data), @Keyboard_Data);
  // ��������� ��������� ����������.
  if res <> DI_OK then
    // ���� �� ���������� ��������� ��������� ����������.
    if res = DIERR_INPUTLOST then begin
      repeat
        // ���� ���������� ����������� ����������
        res := DID_Keyboard.Acquire;
      until
        // �� ��� ���, ���� �� �������� ������.
        res = DI_OK;
    end else begin
      // ���� �� ���������� �������� ��� ������ � ���������
      Result := E2DERR_INPUT_GETSTATE;
      // � ������� �� �������.
      Exit;
    end;

  // ������ ��������� ��������.
  Result := E2DERR_OK;
end; { E2D_UpdateKeyboard }


function E2D_UpdateMouse;
var
  res : HRESULT;
begin { E2D_UpdateMouse }
  // �������� ���������.
  ZeroMemory(@Mouse_Data, SizeOf(Mouse_Data));
  // �������� ������ � ����.
  res := DID_Mouse.GetDeviceState(SizeOf(Mouse_Data), @Mouse_Data);
  // ��������� ��������� ����������.
  if res <> DI_OK then
    // ���� �� ���������� ��������� ��������� ����������.
    if res = DIERR_INPUTLOST then begin
      repeat
        // ���� ���������� ����������� ����
        res := DID_Mouse.Acquire;
      until
        // �� ��� ���, ���� �� �������� ������.
        res = DI_OK;
    end else begin
      // ���� �� ���������� �������� ��� ������ � ���������
      Result := E2DERR_INPUT_GETSTATE;
      // � ������� �� �������.
      Exit;
    end
  else begin
    // ���� ���������� ��������� ���������� �� ����������� 
    Cursor_dX := Mouse_Data.lX;
    // � ���������.
    Cursor_dY := Mouse_Data.lY;

    {$WARNINGS OFF}
    // ���������, �� ����� �� �� ����� ������� ������.
    if Cursor_X + Cursor_dX < 0 then
      // ���� ����� ������������� ����� ��������.
      Cursor_X := 0
    else
      // ���� �� ����� ���������, �� ����� �� �� ������ ������� ������.
      if Cursor_X + Cursor_dX >= Screen_Width then
        // ���� ����� ������������� ����� ��������.
        Cursor_X := Screen_Width - 1
      else
        // ���� �� ����� ��������� ������� ������� �� �����������.
        Cursor_X := Cursor_X + Cursor_dX;

    // ���������, �� ����� �� �� ������� ������� ������.
    if Cursor_Y + Cursor_dY < 0 then
      // ���� ����� ������������� ����� ��������.
      Cursor_Y := 0
    else
      // ���� �� ����� ���������, �� ����� �� �� ������ ������� ������.
      if Cursor_Y + Cursor_dY >= Screen_Height then
        // ���� ����� ������������� ����� ��������.
        Cursor_Y := Screen_Height - 1
      else
        // ���� �� ����� ��������� ������� ������� �� ���������.
        Cursor_Y := Cursor_Y + Cursor_dY;
   {$WARNINGS ON}
  end;

  // ������ ��������� ��������.
  Result := E2DERR_OK;
end; { E2D_UpdateMouse }

function E2D_IsKeyboardKeyDown;
begin { E2D_IsKeyboardKeyDown }
  // �������� � ��������� ������ �� �������.
  Result := (Keyboard_Data[Key] = 128);
end; { E2D_IsKeyboardKeyDown }

procedure E2D_GetCursorPosition;
begin { E2D_GetCursorPosition }
  // ��������� ������� ������� �� �����������
  CursorPos.X := Cursor_X;
  // � ���������.
  CursorPos.Y := Cursor_Y;
end; { E2D_GetCursorPosition }

procedure E2D_GetCursorDelta;
begin { E2D_GetCursorDelta }
  // ��������� ���������� ������� ������� �� �����������
  CursorDeltas.X := Cursor_dX;
  // � ���������.
  CursorDeltas.Y := Cursor_dY;
end; { E2D_GetCursorDelta }

function E2D_IsMouseButtonDown;
begin { E2D_IsMouseButtonDown }
  // �������� � ��������� ������ �� ������.
  Result := (Mouse_Data.rgbButtons[Button] = 128);
end; { E2D_IsMouseButtonDown }

end.
