(************************************* Ext2D Engine *************************************)
(* ������     : E2DStream.pas                                                           *)
(* �����      : ���� ��������                                                           *)
(* ������     : 30.04.06                                                                *)
(* ���������� : ������ �������� �������� ������ TFileStream ��� ������ � ������ ������  *)
(*              �� �����.                                                               *)
(* ���������  : ��� ���������.                                                          *)
(****************************************************************************************)

unit E2DStream;

interface

type
  { ����� ��� ������ � ������ ������ �� �����. }
  TFileStream = class
  private
    { �������� ���������� }
    FHandle : file of Byte;
    { ������� ��� ��������� ������� ������� �����.
      ������������ �������� : ������� ������� � �����, ���� ��������� ������ - 0. }
    function GetPosition : Longint;
    { ��������� ��� ��������� ������� � �����. ��������� :
        Value : ����� ������� � �����. }
    procedure SetPosition(Value : Longint);
    { ������� ��� ��������� ������� �����.
      ������������ �������� : ������ �����, ���� ��������� ������ - 0. }
    function GetSize : Longint;
  public
    { ���������� �������. }
    destructor Destroy; override;
    { ������� ��� �������� �����. ��������� :
        FileName : ��� ����� ��� ��������.
      ������������ �������� : ���� ������� ������������ ������� - True, ���� �������� -
                              False.}
    function OpenFile(FileName : String) : Boolean;
    { ������� ��� �������� ������ �����. ��������� :
        FileName : ��� ����� ��� ��������.
      ������������ �������� : ���� ������� ������������ ������� - True, ���� �������� -
                              False. }
    function CreateFile(FileName : String) : Boolean;
    { ��������� ��� �������� �����. }
    procedure CloseFile;
    { ������� ��� ������ ������ � ����. ��������� :
        Buffer : ����� � �������;
        Count  : ������ ������.
      ������������ �������� : ���������� ���������� � ���� ����, ���� ��������� ������ -
                              0. }
    function Write(const Buffer; Count : Longint) : Longint; virtual;
    { ������� ��� ������ ������ �� �����. ��������� :
        Buffer : ����� ��� ����������� ������;
        Count  : ������ ������.
      ������������ �������� : ���������� ����������� �� ����� ����, ���� ���������
                              ������ - 0. }
    function Read(var Buffer; Count : Longint) : Longint; virtual;
    { ��������� ��� ������ ������ �� �����. ��������� :
        Buffer : ����� ��� ����������� ������;
        Count  : ������ ������. }
    procedure WriteBuffer(const Buffer; Count : Longint);
    { ��������� ��� ������ ������ �� �����. ��������� :
        Buffer : ����� ��� ����������� ������;
        Count  : ������ ������. }
    procedure ReadBuffer(var Buffer; Count : Longint);
    { ������� ��� ��������� ������� � �����. ��������� :
        Offset : �������� �������;
        Origin : ���������� ��������.
      ������������ �������� : ���� ������� ������������ ������� - 1, ���� �������� - 0. }
    function Seek(Offset : Longint; Origin : Word) : Longint; virtual;
    { ������� � ����� }
    property Position : Longint read GetPosition write SetPosition;
    { ������ ����� }
    property Size : Longint read GetSize;
  end; { TFileStream }

implementation

{$I-}

function TFileStream.GetPosition;
begin { GetPosition }
  // �������� ������� � �����.
  Result := FilePos(FHandle);
  // ���� �� ����������
  if IOResult <> 0 then
    // �������� � ��������� 0.
    Result := 0;
end; { GetPosition }

procedure TFileStream.SetPosition;
begin { SetPosition }
  // ������������� ����� ������� � �����.
  System.Seek(FHandle, Value);
  // ���� �� ����������
  if IOResult <> 0 then
    // ������ ��������� �����/������ ��������.
    SetInOutRes(0);
end; { SetPosition }

function TFileStream.GetSize;
begin { GetSize }
  // �������� ������ �����.
  Result := FileSize(FHandle);
  // ���� �� ����������
  if IOResult <> 0 then
    // �������� � ��������� 0.
    Result := 0;
end; { GetSize }

function TFileStream.OpenFile;
begin { OpenFile }
  // ��������� ����.
  Self.CloseFile;
  // ��������� �������� ���������� ����� ����.
  AssignFile(FHandle, FileName);
  // ��������� ����.
  Reset(FHandle);
  // ��������� ��������� �����/������.
  Result := (IOResult = 0);
end; { OpenFile }

function TFileStream.CreateFile;
begin { CreateFile }
  // ��������� ����.
  Self.CloseFile;
  // ��������� �������� ���������� ����� ����.
  AssignFile(FHandle, FileName);
  // �������� ����.
  Rewrite(FHandle);
  // ��������� ��������� �����/������.
  Result := (IOResult = 0);
end; { CreateFile }

procedure TFileStream.CloseFile;
begin { CloseFile }
  // ��������� ����.
  System.CloseFile(FHandle);
  // ���� �� ����������
  if IOResult <> 0 then
    // ������ ��������� �����/������ ��������.
    SetInOutRes(0);
end; { CloseFile }

function TFileStream.Write;
begin { Write }
  // �������� � ��������� 0.
  Result := 0;
  // ���������� ������ � ����.
  BlockWrite(FHandle, Buffer, Count, Result);
end; { Write }

function TFileStream.Read;
begin { Read }
  // �������� � ��������� 0.
  Result := 0;
  // ������ ������ �� �����.
  BlockRead(FHandle, Buffer, Count, Result);
end; { Read }

procedure TFileStream.WriteBuffer(const Buffer; Count : Integer);
begin { WriteBuffer }
  // ���������� ������ � ����.
  Write(Buffer, Count);
end; { WriteBuffer }

procedure TFileStream.ReadBuffer(var Buffer; Count : Integer);
begin { ReadBuffer }
  // ������ ������ �� �����.
  Read(Buffer, Count);
end; { ReadBuffer }

function TFileStream.Seek;
begin { Seek }
  // ������������� ����� ������� � �����.
  System.Seek(FHandle, Offset);
  // ��������� ��������� �����/������.
  Result := Longint(IOResult = 0);
end; { Seek }

destructor TFileStream.Destroy;
begin { Destroy }
  // ��������� ����.
  Self.CloseFile;
  // �������� ������������ �����.
  inherited Destroy;
end; { Destroy }

end.
