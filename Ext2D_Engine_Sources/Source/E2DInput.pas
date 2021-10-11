(************************************* Ext2D Engine *************************************)
(* Модуль     : E2DInput.pas                                                            *)
(* Автор      : Есин Владимир                                                           *)
(* Создан     : 21.10.06                                                                *)
(* Информация : Модуль содежит функции для работы с клавиатурой и мышью.                *)
(* Изменения  : нет изменений.                                                          *)
(****************************************************************************************)

unit E2DInput;

interface

uses
  E2DTypes, Windows;

  { Функция для создания обьектов DirectInput.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_CreateInput : E2D_Result; stdcall; export;

  { Функция для создания устройства клавиатуры.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_AddKeyboard : E2D_Result; stdcall; export;

  { Функция для создания устройства мыши.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_AddMouse : E2D_Result; stdcall; export;

  { Функция для обновления данных клавиатуры.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_UpdateKeyboard : E2D_Result; stdcall; export;

  { Функция для обновления данных мыши.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_UpdateMouse : E2D_Result; stdcall; export;

  { Функция для получения информации о том, нажата ли клавиша на клавиатуре. Параметры :
      Key : код клавиши, информацию о которой необходимо получить.
    Возвращаемое значение : если клавиша нажата - True, если нет - False. }
  function E2D_IsKeyboardKeyDown(Key : Byte) : Boolean; stdcall; export;

  { Процедура для получения позиции курсора. Параметры :
      CursorPos : переменная для сохранения позиции курсора. }
  procedure E2D_GetCursorPosition(var CursorPos : TPoint); stdcall; export;

  { Процедура для получения приращения позиции курсора. Параметры :
      CursorDeltas : переменная для сохранения приращений позиции курсора. }
  procedure E2D_GetCursorDelta(var CursorDeltas : TPoint); stdcall; export;

  { Функция для получения информации о том, нажата ли кнопка мыши. Параметры :
      Button : кнопка, информацию о которой необходимо получить.
    Возвращаемое значение : если клавиша нажата - True, если нет - False. }
  function E2D_IsMouseButtonDown(Button : E2D_TMouseButton) : Boolean; stdcall; export;

implementation

uses
  E2DConsts,    { Для констант ошибок }
  E2DVars,      { Для переменных ввода }
  DirectInput8; { Для функций DirectInput }

function E2D_CreateInput;
begin { E2D_CreateInput }
  // Создаем главный обьект DirectInput.
  if DirectInput8Create(HInstance, DIRECTINPUT_VERSION, IID_IDirectInput8,
                        DI_Main, nil) <> DI_OK then begin { if }
    // Если не получилось помещаем код ошибки в результат
    Result := E2DERR_INPUT_CREATEDI;
    // и выходим из функции.
    Exit;
  end; { if }

  // Делаем результат успешным.
  Result := E2DERR_OK;
end; { E2D_CreateInput }

function E2D_AddKeyboard;
begin { E2D_AddKeyboard }
  // Создаем устройство клавиатуры.
  if DI_Main.CreateDevice(GUID_SysKeyboard, DID_Keyboard, nil) <> DI_OK then begin { if }
    // Если не получилось помещаем код ошибки в результат
    Result := E2DERR_INPUT_CREATEDEV;
    // и выходим из функции.
    Exit;
  end; { if }

  // Задаем формат данных клавиатуры.
  if DID_Keyboard.SetDataFormat(c_dfDIKeyboard) <> DI_OK then begin { if }
    // Если не получилось помещаем код ошибки в результат,
    Result := E2DERR_INPUT_SETDATAFMT;
    // удаляем клавиатуру
    DID_Keyboard := nil;
    // и выходим из функции.
    Exit;
  end; { if }

  // Задаем уровень кооперации.
  if DID_Keyboard.SetCooperativeLevel(Window_Handle, DISCL_EXCLUSIVE or
                                      DISCL_FOREGROUND) <> DI_OK then begin { if }
    // Если не получилось помещаем код ошибки в результат,
    Result := E2DERR_SYSTEM_SETCOOPLVL;
    // удаляем клавиатуру
    DID_Keyboard := nil;
    // и выходим из функции.
    Exit;
  end; { if }

  // Захватываем клавиатуру.
  if DID_Keyboard.Acquire <> DI_OK then begin { if }
    // Если не получилось помещаем код ошибки в результат,
    Result := E2DERR_INPUT_CANTACQR;
    // удаляем клавиатуру
    DID_Keyboard := nil;
    // и выходим из функции.
    Exit;
  end; { if }

  // Делаем результат успешным.
  Result := E2DERR_OK;
end; { E2D_AddKeyboard }

function E2D_AddMouse;
begin { E2D_AddMouse }
  // Создаем устройство мыши.
  if DI_Main.CreateDevice(GUID_SysMouse, DID_Mouse, nil) <> DI_OK then begin { if }
    // Если не получилось помещаем код ошибки в результат
    Result := E2DERR_INPUT_CREATEDEV;
    // и выходим из функции.
    Exit;
  end; { if }

  // Задаем формат данных мыши.
  if DID_Mouse.SetDataFormat(c_dfDIMouse2) <> DI_OK then begin { if }
    // Если не получилось помещаем код ошибки в результат,
    Result := E2DERR_INPUT_SETDATAFMT;
    // удаляем мышь
    DID_Mouse := nil;
    // и выходим из функции.
    Exit;
  end; { if }

  // Задаем уровень кооперации.
  if DID_Mouse.SetCooperativeLevel(Window_Handle, DISCL_EXCLUSIVE or
                                   DISCL_FOREGROUND) <> DI_OK then begin { if }
    // Если не получилось помещаем код ошибки в результат,
    Result := E2DERR_SYSTEM_SETCOOPLVL;
    // удаляем мышь
    DID_Mouse := nil;
    // и выходим из функции.
    Exit;
  end; { if }

  // Захватываем мышь.
  if DID_Mouse.Acquire <> DI_OK then begin { if }
    // Если не получилось помещаем код ошибки в результат,
    Result := E2DERR_INPUT_CANTACQR;
    // удаляем мышь
    DID_Mouse := nil;
    // и выходим из функции.
    Exit;
  end; { if }

  // Делаем результат успешным.
  Result := E2DERR_OK;
end; { E2D_AddMouse }

function E2D_UpdateKeyboard;
var
  res : HRESULT;
begin { E2D_UpdateKeyboard }
  // Обнуляем структуру.
  ZeroMemory(@Keyboard_Data, SizeOf(Keyboard_Data));
  // Получаем данные с клавиатуры.
  res := DID_Keyboard.GetDeviceState(SizeOf(Keyboard_Data), @Keyboard_Data);
  // Проверяем результат выполнения.
  if res <> DI_OK then
    // Если не получилось проверяем результат выполнения.
    if res = DIERR_INPUTLOST then begin
      repeat
        // Если необходимо захватываем клавиатуру
        res := DID_Keyboard.Acquire;
      until
        // до тех пор, пока не добьемся успеха.
        res = DI_OK;
    end else begin
      // Если не получилось помещаем код ошибки в результат
      Result := E2DERR_INPUT_GETSTATE;
      // и выходим из функции.
      Exit;
    end;

  // Делаем результат успешным.
  Result := E2DERR_OK;
end; { E2D_UpdateKeyboard }


function E2D_UpdateMouse;
var
  res : HRESULT;
begin { E2D_UpdateMouse }
  // Обнуляем структуру.
  ZeroMemory(@Mouse_Data, SizeOf(Mouse_Data));
  // Получаем данные с мыши.
  res := DID_Mouse.GetDeviceState(SizeOf(Mouse_Data), @Mouse_Data);
  // Проверяем результат выполнения.
  if res <> DI_OK then
    // Если не получилось проверяем результат выполнения.
    if res = DIERR_INPUTLOST then begin
      repeat
        // Если необходимо захватываем мышь
        res := DID_Mouse.Acquire;
      until
        // до тех пор, пока не добьемся успеха.
        res = DI_OK;
    end else begin
      // Если не получилось помещаем код ошибки в результат
      Result := E2DERR_INPUT_GETSTATE;
      // и выходим из функции.
      Exit;
    end
  else begin
    // Если получилось сохраняем приращение по горизонтали 
    Cursor_dX := Mouse_Data.lX;
    // и вертикали.
    Cursor_dY := Mouse_Data.lY;

    {$WARNINGS OFF}
    // Проверяем, не вышли ли за левую границу экрана.
    if Cursor_X + Cursor_dX < 0 then
      // Если вышли устанавливаем новое значение.
      Cursor_X := 0
    else
      // Если не вышли проверяем, не вышли ли за правую границу экрана.
      if Cursor_X + Cursor_dX >= Screen_Width then
        // Если вышли устанавливаем новое значение.
        Cursor_X := Screen_Width - 1
      else
        // Если не вышли сохраняем позицию курсора по горизонтали.
        Cursor_X := Cursor_X + Cursor_dX;

    // Проверяем, не вышли ли за верхнюю границу экрана.
    if Cursor_Y + Cursor_dY < 0 then
      // Если вышли устанавливаем новое значение.
      Cursor_Y := 0
    else
      // Если не вышли проверяем, не вышли ли за нижнюю границу экрана.
      if Cursor_Y + Cursor_dY >= Screen_Height then
        // Если вышли устанавливаем новое значение.
        Cursor_Y := Screen_Height - 1
      else
        // Если не вышли сохраняем позицию курсора по вертикали.
        Cursor_Y := Cursor_Y + Cursor_dY;
   {$WARNINGS ON}
  end;

  // Делаем результат успешным.
  Result := E2DERR_OK;
end; { E2D_UpdateMouse }

function E2D_IsKeyboardKeyDown;
begin { E2D_IsKeyboardKeyDown }
  // Помещаем в результат нажата ли клавиша.
  Result := (Keyboard_Data[Key] = 128);
end; { E2D_IsKeyboardKeyDown }

procedure E2D_GetCursorPosition;
begin { E2D_GetCursorPosition }
  // Сохраняем позицию курсора по горизонтали
  CursorPos.X := Cursor_X;
  // и вертикали.
  CursorPos.Y := Cursor_Y;
end; { E2D_GetCursorPosition }

procedure E2D_GetCursorDelta;
begin { E2D_GetCursorDelta }
  // Сохраняем приращение позиции курсора по горизонтали
  CursorDeltas.X := Cursor_dX;
  // и вертикали.
  CursorDeltas.Y := Cursor_dY;
end; { E2D_GetCursorDelta }

function E2D_IsMouseButtonDown;
begin { E2D_IsMouseButtonDown }
  // Помещаем в результат нажата ли кнопка.
  Result := (Mouse_Data.rgbButtons[Button] = 128);
end; { E2D_IsMouseButtonDown }

end.
