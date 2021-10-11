(************************************* Ext2D Engine *************************************)
(* Модуль     : E2DErrors.pas                                                           *)
(* Автор      : Есин Владимир                                                           *)
(* Создан     : 16.05.06                                                                *)
(* Информация : Модуль содержит описание констант ошибок.                               *)
(* Изменения  : нет изменений.                                                          *)
(****************************************************************************************)

unit E2DErrors;

interface

uses
  E2DTypes; 

  { Функция возвращает информацию об ошибке. Параметры :
      ErrorCode : код возникшей ошибки.
    Возвращаемое значение : указатель на строку с описанием ошибки. }
  function E2D_ErrorString(ErrorCode : E2D_Result) : PChar; stdcall; export;

implementation

uses
  E2DConsts; { Для костант ошибок }

function E2D_ErrorString;
begin { E2D_ErrorString }
  // Проверяем код ошибки.
  case ErrorCode of
    // Если код опознан, возвращаем описание ошибки.
    E2DERR_OK                 : Result := PChar('Нет ошибок.');
    
    E2DERR_SYSTEM_INVPOINTER  : Result := PChar('Неправильный указатель.');
    E2DERR_SYSTEM_CANTGETMEM  : Result := PChar('Невозможно выделить память.');
    E2DERR_SYSTEM_CANTCOPYMEM : Result := PChar('Невозможно копировать память.');
    E2DERR_SYSTEM_INVALIDID   : Result := PChar('Неправильный идентификатор.');
    E2DERR_SYSTEM_SETCOOPLVL  : Result := PChar('Невозможно установить уровень кооперации.');

    E2DERR_LOAD_CANTOPEN      : Result := PChar('Невозможно открыть файл.');
    E2DERR_LOAD_CANTREAD      : Result := PChar('Невозможно выполнить чтение из файла.');
    E2DERR_LOAD_INVALID       : Result := PChar('Файл неправильный или поврежден.');
    E2DERR_LOAD_DECOMPRESS    : Result := PChar('Ошибка декомпрессии.');

    E2DERR_MANAGE_OUTOFMEM    : Result := PChar('Недостаточно памяти массива.');
    E2DERR_MANAGE_CREATESURF  : Result := PChar('Невозможно создать поверхность.');
    E2DERR_MANAGE_CREATEBUF   : Result := PChar('Невозможно создать буфер.');
    E2DERR_MANAGE_CANTLOCK    : Result := PChar('Невозможно заблокировать обьект.');

    E2DERR_SCREEN_CREATEDD    : Result := PChar('Невозможно создать главный обьект DirectDraw.');
    E2DERR_SCREEN_SETDISPMD   : Result := PChar('Невозможно установить видеорежим.');
    E2DERR_SCREEN_GETDESCR    : Result := PChar('Невозможно получить описание устройства.');
    E2DERR_SCREEN_CREATEGAM   : Result := PChar('Невозможно создать гамма контроль.');
    E2DERR_SCREEN_CREATESURF  : Result := PChar('Невозможно создать поверхность.');
    E2DERR_SCREEN_CANTDRAW    : Result := PChar('Невозможно выполнить вывод.');
    E2DERR_SCREEN_CANTFLIP    : Result := PChar('Невозможно выполнить переключение.');
    E2DERR_SCREEN_CANTCLEAR   : Result := PChar('Невозможно очистить буфер.');
    E2DERR_SCREEN_CANTRESTORE : Result := PChar('Невозможно восстановить поверхность.');
    E2DERR_SCREEN_CANTSETGAM  : Result := PChar('Невозможно установить яркость.');

    E2DERR_SOUND_CREATEDS     : Result := PChar('Невозможно создать главный обьект DirectSound.');
    E2DERR_SOUND_CANTPLAY     : Result := PChar('Невозможно воспроизвести звук.');
    E2DERR_SOUND_CANTSTOP     : Result := PChar('Невозможно остановить звук.');
    E2DERR_SOUND_CANTGETVOL   : Result := PChar('Невозможно получить громкость.');
    E2DERR_SOUND_CANTSETVOL   : Result := PChar('Невозможно установить громкость.');
    E2DERR_SOUND_CANTGETPAN   : Result := PChar('Невозможно получить панораму.');
    E2DERR_SOUND_CANTSETPAN   : Result := PChar('Невозможно установить панораму.');

    E2DERR_INPUT_CREATEDI     : Result := PChar('Невозможно создать главный обьект DirectInput.');
    E2DERR_INPUT_CREATEDEV    : Result := PChar('Невозможно создать устройство.');
    E2DERR_INPUT_SETDATAFMT   : Result := PChar('Невозможно задать формат данных.');
    E2DERR_INPUT_CANTACQR     : Result := PChar('Невозможно захватить устройство.');
    E2DERR_INPUT_GETSTATE     : Result := PChar('Невозможно получить данные.');

    // В противном случае возвращаем "неизвестная ошибка".
    else                        Result := PChar('Неизвестный код ошибки.');
  end; { case }
end; { E2D_ErrorString }

end.
