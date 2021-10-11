(************************************* Ext2D Engine *************************************)
(* Модуль     : E2DStream.pas                                                           *)
(* Автор      : Есин Владимир                                                           *)
(* Создан     : 30.04.06                                                                *)
(* Информация : Модуль содержит описание класса TFileStream для чтения и записи файлов  *)
(*              на диске.                                                               *)
(* Изменения  : нет изменений.                                                          *)
(****************************************************************************************)

unit E2DStream;

interface

type
  { Класс для чтения и записи файлов на диске. }
  TFileStream = class
  private
    { Файловая переменная }
    FHandle : file of Byte;
    { Функция для получения текущей позиции файла.
      Возвращаемое значение : текущая позиция в файле, если произошла ошибка - 0. }
    function GetPosition : Longint;
    { Процедура для установки позиции в файле. Параметры :
        Value : новая позиция в файле. }
    procedure SetPosition(Value : Longint);
    { Функция для получения размера файла.
      Возвращаемое значение : размер файла, если произошла ошибка - 0. }
    function GetSize : Longint;
  public
    { Деструктор обьекта. }
    destructor Destroy; override;
    { Функция для открытия файла. Параметры :
        FileName : имя файла для открытия.
      Возвращаемое значение : если функция выполниласть успешно - True, если неудачно -
                              False.}
    function OpenFile(FileName : String) : Boolean;
    { Функция для создания нового файла. Параметры :
        FileName : имя файла для создания.
      Возвращаемое значение : если функция выполниласть успешно - True, если неудачно -
                              False. }
    function CreateFile(FileName : String) : Boolean;
    { Процедура для закрытия файла. }
    procedure CloseFile;
    { Функция для записи данных в файл. Параметры :
        Buffer : буфер с данными;
        Count  : размер буфера.
      Возвращаемое значение : количество записанных в файл байт, если произошла ошибка -
                              0. }
    function Write(const Buffer; Count : Longint) : Longint; virtual;
    { Функция для чтения данных из файла. Параметры :
        Buffer : буфер для прочитанных данных;
        Count  : размер буфера.
      Возвращаемое значение : количество прочитанных из файла байт, если произошла
                              ошибка - 0. }
    function Read(var Buffer; Count : Longint) : Longint; virtual;
    { Процедура для чтения данных из файла. Параметры :
        Buffer : буфер для прочитанных данных;
        Count  : размер буфера. }
    procedure WriteBuffer(const Buffer; Count : Longint);
    { Процедура для чтения данных из файла. Параметры :
        Buffer : буфер для прочитанных данных;
        Count  : размер буфера. }
    procedure ReadBuffer(var Buffer; Count : Longint);
    { Функция для установки позиции в файле. Параметры :
        Offset : смещение позиции;
        Origin : напрвление смещения.
      Возвращаемое значение : если функция выполниласть успешно - 1, если неудачно - 0. }
    function Seek(Offset : Longint; Origin : Word) : Longint; virtual;
    { Позиция в файле }
    property Position : Longint read GetPosition write SetPosition;
    { Размер файла }
    property Size : Longint read GetSize;
  end; { TFileStream }

implementation

{$I-}

function TFileStream.GetPosition;
begin { GetPosition }
  // Получаем позицию в файле.
  Result := FilePos(FHandle);
  // Если не получилось
  if IOResult <> 0 then
    // помещаем в результат 0.
    Result := 0;
end; { GetPosition }

procedure TFileStream.SetPosition;
begin { SetPosition }
  // Устанавливаем новую позицию в файле.
  System.Seek(FHandle, Value);
  // Если не получилось
  if IOResult <> 0 then
    // делаем результат ввода/вывода успешным.
    SetInOutRes(0);
end; { SetPosition }

function TFileStream.GetSize;
begin { GetSize }
  // Получаем размер файла.
  Result := FileSize(FHandle);
  // Если не получилось
  if IOResult <> 0 then
    // помещаем в результат 0.
    Result := 0;
end; { GetSize }

function TFileStream.OpenFile;
begin { OpenFile }
  // Закрываем файл.
  Self.CloseFile;
  // Назначаем файловой переменной новый файл.
  AssignFile(FHandle, FileName);
  // Открываем файл.
  Reset(FHandle);
  // Проверяем результат ввода/вывода.
  Result := (IOResult = 0);
end; { OpenFile }

function TFileStream.CreateFile;
begin { CreateFile }
  // Закрываем файл.
  Self.CloseFile;
  // Назначаем файловой переменной новый файл.
  AssignFile(FHandle, FileName);
  // ОСоздаем файл.
  Rewrite(FHandle);
  // Проверяем результат ввода/вывода.
  Result := (IOResult = 0);
end; { CreateFile }

procedure TFileStream.CloseFile;
begin { CloseFile }
  // Закрываем файл.
  System.CloseFile(FHandle);
  // Если не получилось
  if IOResult <> 0 then
    // делаем результат ввода/вывода успешным.
    SetInOutRes(0);
end; { CloseFile }

function TFileStream.Write;
begin { Write }
  // Помещаем в результат 0.
  Result := 0;
  // Записываем данные в файл.
  BlockWrite(FHandle, Buffer, Count, Result);
end; { Write }

function TFileStream.Read;
begin { Read }
  // Помещаем в результат 0.
  Result := 0;
  // Читаем данные из файла.
  BlockRead(FHandle, Buffer, Count, Result);
end; { Read }

procedure TFileStream.WriteBuffer(const Buffer; Count : Integer);
begin { WriteBuffer }
  // Записываем данные в файл.
  Write(Buffer, Count);
end; { WriteBuffer }

procedure TFileStream.ReadBuffer(var Buffer; Count : Integer);
begin { ReadBuffer }
  // Читаем данные из файла.
  Read(Buffer, Count);
end; { ReadBuffer }

function TFileStream.Seek;
begin { Seek }
  // Устанавливаем новую позицию в файле.
  System.Seek(FHandle, Offset);
  // Проверяем результат ввода/вывода.
  Result := Longint(IOResult = 0);
end; { Seek }

destructor TFileStream.Destroy;
begin { Destroy }
  // Закрываем файл.
  Self.CloseFile;
  // Вызываем родительский метод.
  inherited Destroy;
end; { Destroy }

end.
