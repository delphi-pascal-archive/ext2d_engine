(************************************* Ext2D Engine *************************************)
(* Модуль     : E2DSound.pas                                                            *)
(* Автор      : Есин Владимир                                                           *)
(* Создан     : 03.11.06                                                                *)
(* Информация : Модуль содежит функции для работы со звуком.                            *)
(* Изменения  : нет изменений.                                                          *)
(****************************************************************************************)

unit E2DSound;

interface

uses
  E2DTypes;

  { Функция для создания обьектов DirectSound.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_CreateSound : E2D_Result; stdcall; export;

  { Функция для воспроизведения звука. Параметры :
      SoundID : идентификатор звука, который необходимо воспроизвести;
      Loop    : флаг, сигнализирующий надо ли зациклить воспроизведение.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_PlaySound(SoundID : E2D_TSoundID;
                         Loop : Boolean) : E2D_Result; stdcall; export;

  { Функция для остановки воспроизведения звука. Параметры :
      SoundID : идентификатор звука, который необходимо остановить.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_StopSound(SoundID : E2D_TSoundID) : E2D_Result; stdcall; export;

  { Функция для получения громкости звука. Параметры :
      SoundID : идентификатор звука, громкость которго необходимо получить;
      Volume  : переменная для сохранения громкости.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_GetSoundVolume(SoundID : E2D_TSoundID; var
                              Volume : E2D_TSoundVolume) : E2D_Result; stdcall; export;

  { Функция для установления громкости звука. Параметры :
      SoundID : идентификатор звука, громкость которго необходимо установить;
      Volume  : громкость.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_SetSoundVolume(SoundID : E2D_TSoundID;
                              Volume : E2D_TSoundVolume) : E2D_Result; stdcall; export;

  { Функция для получения глобальной громкости.
    Возвращаемое значение : громкость. }
  function E2D_GetGlobalVolume : E2D_TSoundVolume; stdcall; export;

  { Функция для установления глобальной громкости. Параметры :
      Volume : громкость.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_SetGlobalVolume(Volume : E2D_TSoundVolume) : E2D_Result; stdcall; export;

  { Функция для получения панорамы звука. Параметры :
      SoundID : идентификатор звука, панораму которго необходимо получить;
      Pan     : переменная для сохранения панорамы.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_GetSoundPan(SoundID : E2D_TSoundID;
                           var Pan : E2D_TSoundPan) : E2D_Result; stdcall; export;

  { Функция для установления панорамы звука. Параметры :
      SoundID : идентификатор звука, панораму которго необходимо установить;
      Pan     : панорама.
    Возвращаемое значение : если функция выполнилась успешно - E2DERR_OK, если неудачно -
                            код ошибки. }
  function E2D_SetSoundPan(SoundID : E2D_TSoundID;
                           Pan : E2D_TSoundPan) : E2D_Result; stdcall; export;


implementation

uses
  E2DVars,     { Для переменных звука }
  E2DConsts,   { Для констант ошибок }
  DirectSound; { Для функций DirectSound }

function E2D_CreateSound;
begin { E2D_CreateSound }
  // Создаем главный обьект DirectSound.
  if DirectSoundCreate8(nil, DS_Main, nil) <> DS_OK then begin { if }
    // Если не получилось помещаем код ошибки в результат
    Result := E2DERR_SOUND_CREATEDS;
    // и выходим из функции.
    Exit;
  end; { if }

  // Задаем уровень кооперации.
  if DS_Main.SetCooperativeLevel(Window_Handle,
                                 DSSCL_EXCLUSIVE) <> DS_OK then begin { if }
    // Если не получилось помещаем код ошибки в результат,
    Result := E2DERR_SYSTEM_SETCOOPLVL;
    // удаляем главный обьект DirectSound
    DS_Main := nil;
    // и выходим из функции.
    Exit;
  end; { if }

  // Делаем результат успешным.
  Result := E2DERR_OK;
end; { E2D_CreateSound }

function E2D_PlaySound;
begin { E2D_PlaySound }
  // Проверяем идентификатор звука.
  if SoundID >= NumSounds then begin { if }
    // Если не получилось помещаем код ошибки в результат
    Result := E2DERR_SYSTEM_INVALIDID;
    // и выходим из функции.
    Exit;
  end; { if }

  // Воспроизводим звук.
  if Sounds[SoundID].Buffer.Play(0, 0,
                                 Byte(Loop) * DSBPLAY_LOOPING) <> DS_OK then begin { if }
    // Если не получилось помещаем код ошибки в результат
    Result := E2DERR_SOUND_CANTPLAY;
    // и выходим из функции.
    Exit;
  end; { if }
  
  // Делаем результат успешным.
  Result := E2DERR_OK;
end; { E2D_PlaySound }

function E2D_StopSound;
begin { E2D_StopSound }
  // Проверяем идентификатор звука.
  if SoundID >= NumSounds then begin { if }
    // Если не получилось помещаем код ошибки в результат
    Result := E2DERR_SYSTEM_INVALIDID;
    // и выходим из функции.
    Exit;
  end; { if }

  // Останавливаем звук.
  if Sounds[SoundID].Buffer.Stop <> DS_OK then begin { if }
    // Если не получилось помещаем код ошибки в результат
    Result := E2DERR_SOUND_CANTSTOP;
    // и выходим из функции.
    Exit;
  end; { if }

  // Делаем результат успешным.
  Result := E2DERR_OK;
end; { E2D_StopSound }

function E2D_GetSoundVolume;
begin { E2D_GetSoundVolume }
  // Проверяем идентификатор звука.
  if SoundID >= NumSounds then begin { if }
    // Если не получилось помещаем код ошибки в результат
    Result := E2DERR_SYSTEM_INVALIDID;
    // и выходим из функции.
    Exit;
  end; { if }

  // Получаем громкость.
  if Sounds[SoundID].Buffer.GetVolume(PInteger(@Volume)^) <> DS_OK then begin { if }
    // Если не получилось помещаем код ошибки в результат
    Result := E2DERR_SOUND_CANTGETVOL;
    // и выходим из функции.
    Exit;
  end; { if }

  // Делаем результат успешным.
  Result := E2DERR_OK;
end; { E2D_GetSoundVolume }

function E2D_SetSoundVolume;
begin { E2D_SetSoundVolume }
  // Проверяем идентификатор звука.
  if SoundID >= NumSounds then begin { if }
    // Если не получилось помещаем код ошибки в результат
    Result := E2DERR_SYSTEM_INVALIDID;
    // и выходим из функции.
    Exit;
  end; { if }

  // Устанавливаем громкость.
  if Sounds[SoundID].Buffer.SetVolume(Volume) <> DS_OK then begin { if }
    // Если не получилось помещаем код ошибки в результат
    Result := E2DERR_SOUND_CANTSETVOL;
    // и выходим из функции.
    Exit;
  end; { if }

  // Делаем результат успешным.
  Result := E2DERR_OK;
end; { E2D_SetSoundVolume }

function E2D_GetGlobalVolume;
begin { E2D_GetGlobalVolume }
  // Помещаем в результат громкость.
  Result := Volume_Global;
end; { E2D_GetGlobalVolume }

function E2D_SetGlobalVolume;
var
  i : Longword; { Счетчик цикла }
begin { E2D_SetGlobalVolume }
  // Делаем результат успешным.
  Result := E2DERR_OK;

  // Проверяем количество загруженных звуков.
  if NumSounds > 0 then
    // Если необходимо устанавливаем громкость всех звуков.
    for i := 0 to NumSounds - 1 do begin
      // Устанавливаем громкость.
      Result := E2D_SetSoundVolume(i, Volume);
      // Проверяем результат выполнения.
      if Result <> E2DERR_OK then
        // Если не получилось выходим из функции.
        Exit;
    end;

  // Сохраняем новую громкость.  
  Volume_Global := Volume;
end; { E2D_SetGlobalVolume }

function E2D_GetSoundPan;
begin { GetSoundPan }
  // Проверяем идентификатор звука.
  if SoundID >= NumSounds then begin { if }
    // Если не получилось помещаем код ошибки в результат
    Result := E2DERR_SYSTEM_INVALIDID;
    // и выходим из функции.
    Exit;
  end; { if }

  // Получаем панораму.
  if Sounds[SoundID].Buffer.GetPan(PInteger(@Pan)^) <> DS_OK then begin { if }
    // Если не получилось помещаем код ошибки в результат
    Result := E2DERR_SOUND_CANTGETPAN;
    // и выходим из функции.
    Exit;
  end; { if }

  // Делаем результат успешным.
  Result := E2DERR_OK;
end; { GetSoundPan }

function E2D_SetSoundPan;
begin { SetSoundPan }
  // Проверяем идентификатор звука.
  if SoundID >= NumSounds then begin { if }
    // Если не получилось помещаем код ошибки в результат
    Result := E2DERR_SYSTEM_INVALIDID;
    // и выходим из функции.
    Exit;
  end; { if }

  // Устанавливаем панораму.
  if Sounds[SoundID].Buffer.SetPan(Pan) <> DS_OK then begin { if }
    // Если не получилось помещаем код ошибки в результат
    Result := E2DERR_SOUND_CANTSETPAN;
    // и выходим из функции.
    Exit;
  end; { if }

  // Делаем результат успешным.
  Result := E2DERR_OK;
end; { SetSoundPan }

end.
