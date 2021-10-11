unit Main;

interface

{$WARNINGS OFF}

uses
  Windows, SysUtils, Classes, Controls, Forms, Dialogs, StdCtrls,
  FileCtrl, ExtCtrls, ComCtrls, IdGlobal, ToolWin, Menus, ImgList, ShellApi,
  MPlayer, Gauges, Zlib;

{$WARNINGS ON}

type
  TConverterForm = class(TForm)
    LeftPanel: TPanel;
    DrivesList: TDriveComboBox;
    DirectoriesList: TDirectoryListBox;
    split1: TSplitter;
    SoundsPanel: TPanel;
    SoundsList: TFileListBox;
    Status: TStatusBar;
    SoundPanel: TScrollBox;
    labSounds: TLabel;
    Tools: TToolBar;
    MainMenu: TMainMenu;
    miConvert: TMenuItem;
    miSelected: TMenuItem;
    miFolder: TMenuItem;
    miWithSubfolders: TMenuItem;
    miExit: TMenuItem;
    MenuImages: TImageList;
    tbSelected: TToolButton;
    tbSep1: TToolButton;
    tbFolder: TToolButton;
    tbWithSubfolders: TToolButton;
    tbSep2: TToolButton;
    miFile: TMenuItem;
    miSelect: TMenuItem;
    miAll: TMenuItem;
    miNothing: TMenuItem;
    miInvert: TMenuItem;
    tbAll: TToolButton;
    tbNothing: TToolButton;
    tbInvert: TToolButton;
    miEdit: TMenuItem;
    sep1: TMenuItem;
    tbSep3: TToolButton;
    miOpen: TMenuItem;
    miAbout: TMenuItem;
    SoundsListPM: TPopupMenu;
    bpmiSelected: TMenuItem;
    bpmiFolder: TMenuItem;
    mpSep1: TMenuItem;
    bpmiAll: TMenuItem;
    bpmiConvert: TMenuItem;
    tbStop: TToolButton;
    sep2: TMenuItem;
    miStop: TMenuItem;
    tbSep4: TToolButton;
    sep3: TMenuItem;
    miRestore: TMenuItem;
    miLog: TMenuItem;
    miSave: TMenuItem;
    miClear: TMenuItem;
    SaveLog: TSaveDialog;
    DirectoriesListPM: TPopupMenu;
    dpmiConvert: TMenuItem;
    dpmiWithSubfolders: TMenuItem;
    dpmiFolder: TMenuItem;
    labInfo: TLabel;
    SoundPlayer: TMediaPlayer;
    split2: TSplitter;
    StatsMemo: TMemo;
    PlayProgress: TGauge;
    PlayTimer: TTimer;
    procedure DirectoriesListChange(Sender: TObject);
    procedure SoundsListChange(Sender: TObject);
    procedure SoundsListClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure miAllClick(Sender: TObject);
    procedure miNothingClick(Sender: TObject);
    procedure miInvertClick(Sender: TObject);
    procedure miEditClick(Sender: TObject);
    procedure miOpenClick(Sender: TObject);
    procedure miExitClick(Sender: TObject);
    procedure miStopClick(Sender: TObject);
    procedure miFolderClick(Sender: TObject);
    procedure miWithSubfoldersClick(Sender: TObject);
    procedure miSelectedClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure miAboutClick(Sender: TObject);
    procedure miClearClick(Sender: TObject);
    procedure miSaveClick(Sender: TObject);
    procedure PlayTimerTimer(Sender: TObject);
    procedure SoundPlayerNotify(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ConvertFolder(Folder : PChar; wsf : Boolean);
    procedure SetMenuState(st : Boolean);
  end;

var
  ConverterForm: TConverterForm;
  flgCancel : Boolean = False;
  numConv : Cardinal = 0;
  outDir : String = '';

implementation

uses
  About;

{$R *.dfm}

function ConvertSound(srcName, dstName : PChar) : Boolean;
type
  TWAVEHeader = packed record
    Signature  : Cardinal;
    RiffSize   : Cardinal;
    WAVE       : Cardinal;
    fmt_       : Cardinal;
    fmtSize    : Cardinal;
    FormatTag  : Word;
    Channels   : Word;
    SamplesPS  : Cardinal;
    BytesPS    : Cardinal;
    BlockAlign : Word;
    BitsPSmpl  : Word;
    data       : Cardinal;
    DataSize   : Cardinal;
  end;

var
  src : TFileStream;
  dst : TFileStream;
  zcs : TCompressionStream;
  wrk : Cardinal;
  wrkW : Word;
  hd : TWAVEHeader;
  wrkDir : string;
  addPath : String;

const
  RIFF = $46464952;
  WAVE = $45564157;
  fmt_ = $20746D66;
  data = $61746164;

label
  OnDone;
begin
  ConverterForm.Status.Panels[0].Text := 'Конвертирование "' + ExtractFileName(srcName) + '"';
  Application.ProcessMessages;
  Result := False;
  try
    src := TFileStream.Create(srcName, fmOpenRead or fmShareDenyWrite);
  except
    Exit;
  end;
  src.Read(hd, SizeOf(hd));
  if (hd.Signature <> RIFF) or (hd.WAVE <> WAVE) or (hd.fmt_ <> fmt_) or
     (hd.DataSize > src.Size - src.Position) then
    goto OnDone;
  if FileExists(dstName) then
    case Application.MessageBox(PChar('Конечный файл "' + dstName +
                                '" уже существует. Заменить?'), PChar('Подтверждение'),
                                MB_YESNOCANCEL or MB_ICONINFORMATION) of
      IDCANCEL : begin
                   flgCancel := True;
                   goto OnDone;
                 end;
      IDNO : goto OnDone;
    end;

  if not DirectoryExists(ExtractFilePath(dstName)) then begin
    wrkDir := ExtractFilePath(dstName);
    addPath := '\';
    repeat
      while wrkDir[Length(wrkDir)] <> '\' do begin
        addPath := wrkDir[Length(wrkDir)] + addPath;
        Delete(wrkDir, Length(wrkDir), 1);
      end;
      Delete(wrkDir, Length(wrkDir), 1);
      addPath := '\' + addPath;
    until
      DirectoryExists(wrkDir);

    Delete(addPath, 1, 1);
    while Length(addPath) > 0 do begin
      wrkDir := wrkDir + '\';
      while addPath[1] <> '\' do begin
        wrkDir := wrkDir + addPath[1];
        Delete(addPath, 1, 1);
      end;
      Delete(addPath, 1, 1);
      CreateDir(wrkDir);
    end;
  end;

  try
    dst := TFileStream.Create(dstName, fmCreate);
  except
    src.Free;
    Exit;
  end;

  try
    wrk := $5F465345;
    dst.WriteBuffer(wrk, 4);
    wrkW := hd.Channels;
    dst.WriteBuffer(wrkW, 2);
    wrk := hd.SamplesPS;
    dst.WriteBuffer(wrk, 4);
    wrkW := hd.BlockAlign;
    dst.WriteBuffer(wrkW, 2);
    wrkW := hd.BitsPSmpl;
    dst.WriteBuffer(wrkW, 2);
    wrk := hd.DataSize;
    dst.WriteBuffer(wrk, 4);
    wrk := $61746164;
    dst.WriteBuffer(wrk, 4);
    zcs := TCompressionStream.Create(clMax, dst);
    zcs.CopyFrom(src, hd.DataSize);
  except
    src.Free;
    if Assigned(zcs) then
      zcs.Free;
    dst.Free;
    Exit;
  end;
  zcs.Free;
  dst.Free;
  Result := True;
OnDone :
  src.Free;
end;

procedure TConverterForm.DirectoriesListChange(Sender: TObject);
begin
  Status.Panels[2].Text := DirectoriesList.Directory
end;

procedure TConverterForm.SoundsListChange(Sender: TObject);
var
  i : Integer;
  s : Int64;
begin
  with SoundsList do begin
    s := 0;
    if SelCount > 0 then
      for i := 0 to Count - 1 do
        if Selected[i] then
          try
            s := s + FileSizeByName(DirectoriesList.Directory + '\' + Items[i]);
          except
          end;
    Status.Panels[1].Text := IntToStr(SelCount) + ' звук(ов), ' + IntToStr(s) + ' байт(а)'
  end;
end;

procedure TConverterForm.SoundsListClick(Sender: TObject);
begin
  if (SoundsList.ItemIndex >= 0) and (SoundsList.Count > 0) then
    try
      labInfo.Caption := SoundsList.Items[SoundsList.ItemIndex];
      SoundPlayer.FileName := DirectoriesList.Directory + '\' + SoundsList.Items[SoundsList.ItemIndex];
      SoundPlayer.Open;
      PlayTimer.Enabled := True;
    except
      Application.MessageBox(PChar('Невозможно открыть звук!'), PChar('Ошибка'), MB_ICONSTOP)
    end;
end;

procedure TConverterForm.FormCreate(Sender: TObject);
begin
  DirectoriesList.OnChange(nil);
end;

procedure TConverterForm.miAllClick(Sender: TObject);
begin
  if SoundsList.Count > 0 then begin
    SoundsList.SelectAll;
    SoundsList.OnChange(nil);
  end;
end;

procedure TConverterForm.miNothingClick(Sender: TObject);
var
  i : Integer;
begin
  if SoundsList.Count > 0 then begin
    for i := 0 to SoundsList.Count - 1 do
      SoundsList.Selected[i] := False;
    SoundsList.OnChange(nil);
  end;
end;

procedure TConverterForm.miInvertClick(Sender: TObject);
var
  i : Integer;
begin
  if SoundsList.Count > 0 then begin
    for i := 0 to SoundsList.Count - 1 do
      SoundsList.Selected[i] := not SoundsList.Selected[i];
    SoundsList.OnChange(nil);
  end;
end;

procedure TConverterForm.miEditClick(Sender: TObject);
begin
  if (SoundsList.ItemIndex >= 0) and (SoundsList.Count > 0) then
    if ShellExecute(Handle, PChar('edit'), PChar(DirectoriesList.Directory + '\' +
                    SoundsList.Items[SoundsList.ItemIndex]), nil, nil, SW_SHOWNORMAL) <= 32 then
      Application.MessageBox(PChar('Невозможно запустить редактор звуков!'),
                             PChar('Ошибка'), MB_ICONSTOP);
end;

procedure TConverterForm.miOpenClick(Sender: TObject);
begin
  if (SoundsList.ItemIndex >= 0) and (SoundsList.Count > 0) then
    if ShellExecute(Handle, PChar('open'), PChar(DirectoriesList.Directory + '\' +
                    SoundsList.Items[SoundsList.ItemIndex]), nil, nil, SW_SHOWNORMAL) <= 32 then
      Application.MessageBox(PChar('Невозможно запустить проигрыватель звуков!'),
                             PChar('Ошибка'), MB_ICONSTOP);
end;

procedure TConverterForm.miExitClick(Sender: TObject);
begin
  flgCancel := True;
  Close;
end;

procedure TConverterForm.miStopClick(Sender: TObject);
begin
  flgCancel := True;
end;

procedure TConverterForm.ConvertFolder(Folder: PChar; wsf: Boolean);
var
  fs : TSearchRec;
  i : Integer;
  fname : String;
  wrkDir : String;
begin
  Status.Panels[2].Text := Folder;
  Status.Panels[0].Text := 'Поиск...';
  Application.ProcessMessages;
  if flgCancel then
    Exit;
  i := FindFirst(Folder + '\*.wav', faAnyFile, fs);
  while i = 0 do begin
    Application.ProcessMessages;
    if flgCancel then
      Exit;
    fname := fs.Name;
    while fname[Length(fname)] <> '.' do
      Delete(fname, Length(fname), 1);
    fname := fname + 'esf';
    if ConvertSound(PChar(Folder + '\' + fs.Name), PChar(outDir + '\' + fname)) then
      numConv := numConv + 1
    else
      StatsMemo.Lines.Add('- Невозможно конвертировать "' + Folder + '\' + fs.Name);
    i := FindNext(fs);
  end;
  FindClose(fs);

  if wsf then begin
    wrkDir := outDir;
    i := FindFirst(Folder + '\*.*', faDirectory, fs);
    while i = 0 do begin
      Application.ProcessMessages;
      if flgCancel then
        Exit;
      if (fs.Name <> '.') and (fs.Name <> '..') and ((fs.Attr and faDirectory) <> 0) then begin
        if miRestore.Checked then
          OutDir := wrkDir + '\' + fs.Name;
        ConvertFolder(PChar(Folder + '\' + fs.Name), True);
      end;
      i := FindNext(fs);
    end;
    FindClose(fs);
  end;
end;

procedure TConverterForm.miFolderClick(Sender: TObject);
begin
  if SelectDirectory('Выберите папку для сохранения звуков', '', outDir) then begin
    SetMenuState(False);
    numConv := 0;
    StatsMemo.Lines.Add('Начато конвертирование папки "' + DirectoriesList.Directory + '"...');
    flgCancel := False;
    ConvertFolder(PChar(DirectoriesList.Directory), False);
    Status.Panels[0].Text := 'Сконвертировано : ' + IntToStr(numConv) + ' файл(ов).';
    Status.Panels[2].Text := DirectoriesList.Directory;
    SetMenuState(True);
  end;
end;

procedure TConverterForm.SetMenuState(st: Boolean);
begin
  miEdit.Enabled           := st;
  miOpen.Enabled           := st;
  miSelected.Enabled       := st;
  miFolder.Enabled         := st;
  miWithSubfolders.Enabled := st;
  miRestore.Enabled        := st;
  miAll.Enabled            := st;
  miNothing.Enabled        := st;
  miInvert.Enabled         := st;
  bpmiConvert.Enabled      := st;
  bpmiAll.Enabled          := st;
  dpmiConvert.Enabled      := st;
  tbSelected.Enabled       := st;
  tbFolder.Enabled         := st;
  tbWithSubfolders.Enabled := st;
  tbAll.Enabled            := st;
  tbNothing.Enabled        := st;
  tbInvert.Enabled         := st;
  DrivesList.Enabled       := st;
  DirectoriesList.Enabled  := st;
  SoundsList.Enabled       := st;
  SoundPlayer.Enabled      := st;
  Refresh;
end;

procedure TConverterForm.miWithSubfoldersClick(Sender: TObject);
begin
  if SelectDirectory('Выберите папку для сохранения звуков', '', outDir) then begin
    SetMenuState(False);
    numConv := 0;
    StatsMemo.Lines.Add('Начато конвертирование папки "' + DirectoriesList.Directory +
                        '" с подкаталогами...');
    flgCancel := False;
    ConvertFolder(PChar(DirectoriesList.Directory), True);
    Status.Panels[0].Text := 'Сконвертировано : ' + IntToStr(numConv) + ' файл(ов).';
    Status.Panels[2].Text := DirectoriesList.Directory;
    SetMenuState(True);
  end;
end;

procedure TConverterForm.miSelectedClick(Sender: TObject);
var
  i : Integer;
  fname : String;
begin
  if SoundsList.SelCount > 0 then
    if SelectDirectory('Выберите папку для сохранения звуков', '', outDir) then begin
      SetMenuState(False);
      numConv := 0;
      StatsMemo.Lines.Add('Начато конвертирование выбранных файлов...');
      flgCancel := False;
      for i := 0 to SoundsList.Count - 1 do
        if SoundsList.Selected[i] then begin
          fname := SoundsList.Items[i];
          while fname[Length(fname)] <> '.' do
            Delete(fname, Length(fname), 1);
          fname := fname + 'esf';
          if ConvertSound(PChar(DirectoriesList.Directory + '\' + SoundsList.Items[i]),
                           PChar(outDir + '\' + fname)) then
            numConv := numConv + 1
          else
            StatsMemo.Lines.Add('- Невозможно конвертировать "' + DirectoriesList.Directory + '\' +
                                SoundsList.Items[i]);
        end;
      Status.Panels[0].Text := 'Сконвертировано : ' + IntToStr(numConv) + ' файл(ов).';
      Status.Panels[2].Text := DirectoriesList.Directory;
      SetMenuState(True);
  end;
end;

procedure TConverterForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  flgCancel := True;
  CanClose := True;
end;

procedure TConverterForm.miAboutClick(Sender: TObject);
begin
  AboutForm.ShowModal;
end;

procedure TConverterForm.miClearClick(Sender: TObject);
begin
  StatsMemo.Clear;
end;

procedure TConverterForm.miSaveClick(Sender: TObject);
begin
  if SaveLog.Execute then
    StatsMemo.Lines.SaveToFile(SaveLog.FileName);
end;

procedure TConverterForm.PlayTimerTimer(Sender: TObject);
begin
  PlayProgress.Progress := Trunc(SoundPlayer.Position / SoundPlayer.Length * 100);
  if PlayProgress.Progress = 100 then begin
    SoundPlayer.Position := 0;
    PlayProgress.Progress := 0;
  end;
end;

procedure TConverterForm.SoundPlayerNotify(Sender: TObject);
begin
  if SoundPlayer.Mode = mpStopped then 
    SoundPlayer.Position := 0;
end;

end.
