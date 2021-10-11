unit Main;

interface

{$WARNINGS OFF}

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
  FileCtrl, ExtCtrls, ComCtrls, IdGlobal, ToolWin, Menus, ImgList, ShellApi,
  Zlib;

{$WARNINGS ON}

type
  TConverterForm = class(TForm)
    LeftPanel: TPanel;
    DrivesList: TDriveComboBox;
    DirectoriesList: TDirectoryListBox;
    split1: TSplitter;
    BitmapsPanel: TPanel;
    BitmapsList: TFileListBox;
    split2: TSplitter;
    Status: TStatusBar;
    ImagePanel: TScrollBox;
    labBitmaps: TLabel;
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
    labInfo: TLabel;
    BitmapsListPM: TPopupMenu;
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
    StatsMemo: TMemo;
    split3: TSplitter;
    miLog: TMenuItem;
    miSave: TMenuItem;
    miClear: TMenuItem;
    SaveLog: TSaveDialog;
    bev1: TBevel;
    ImageScroll: TScrollBox;
    Preview: TImage;
    labBitmapPreview: TLabel;
    DirectoriesListPM: TPopupMenu;
    dpmiConvert: TMenuItem;
    dpmiWithSubfolders: TMenuItem;
    dpmiFolder: TMenuItem;
    procedure DirectoriesListChange(Sender: TObject);
    procedure BitmapsListChange(Sender: TObject);
    procedure BitmapsListClick(Sender: TObject);
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

function ConvertBitmap(srcName, dstName : PChar) : Boolean;
var
  src : TBitmap;
  dst : TFileStream;
  zcs : TCompressionStream;
  i, j : Cardinal;
  w, h : Cardinal;
  wrk : Cardinal;
  val : WORD;
  r, g, b : Byte;
  wrkDir : string;
  addPath : String;
label
  OnDone;
begin
  ConverterForm.Status.Panels[0].Text := 'Конвертирование "' + ExtractFileName(srcName) + '"';
  Application.ProcessMessages;
  Result := False;
  src := TBitmap.Create;
  try
    src.LoadFromFile(srcName);
  except
    src.Free;
    Exit;
  end;
  src.PixelFormat := pf24bit;
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
    wrk := $5F464945;
    dst.WriteBuffer(wrk, 4);
    w := src.Width;
    dst.WriteBuffer(w, 4);
    h := src.Height;
    dst.WriteBuffer(h, 4);
    wrk := w * h * 2;
    dst.WriteBuffer(wrk, 4);
    wrk := $61746164;;
    dst.WriteBuffer(wrk, 4);
    zcs := TCompressionStream.Create(clMax, dst);
    for j := 0 to h - 1 do
      for i := 0 to w - 1 do begin
        wrk := src.Canvas.Pixels[i, j];
        r := GetRValue(wrk);
        g := GetGValue(wrk);
        b := GetBValue(wrk);
        val := (Round(b / 255 * $1F) or (Round(g / 255 * $3F) shl 5) or (Round(r / 255 * $1F) shl 11));
        zcs.WriteBuffer(val, 2);
      end;
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

procedure TConverterForm.BitmapsListChange(Sender: TObject);
var
  i : Integer;
  s : Int64;
begin
  with BitmapsList do begin
    s := 0;
    if SelCount > 0 then
      for i := 0 to Count - 1 do
        if Selected[i] then
          try
            s := s + FileSizeByName(DirectoriesList.Directory + '\' + Items[i]);
          except
          end;
    Status.Panels[1].Text := IntToStr(SelCount) + ' изображение(ий), ' + IntToStr(s) + ' байт(а)'
  end;
end;

procedure TConverterForm.BitmapsListClick(Sender: TObject);
begin
  if (BitmapsList.ItemIndex >= 0) and (BitmapsList.Count > 0) then
    try
      Preview.Picture.LoadFromFile(DirectoriesList.Directory + '\' +
                                   BitmapsList.Items[BitmapsList.ItemIndex]);
      labInfo.Caption := BitmapsList.Items[BitmapsList.ItemIndex] + ' - ' +
                         IntToStr(Preview.Picture.Width) + ' x ' + IntToStr(Preview.Picture.Height);
      case Preview.Picture.Bitmap.PixelFormat of
        pf24bit : labInfo.Caption := labInfo.Caption + ' @ 24 бита';
        pf8bit : labInfo.Caption := labInfo.Caption + ' @ 8 бит';
        pf4bit : labInfo.Caption := labInfo.Caption + ' @ 4 бита';
        pf1bit : labInfo.Caption := labInfo.Caption + ' Монохромное';
      end;
    except
      Application.MessageBox(PChar('Невозможно открыть изображение!'), PChar('Ошибка'), MB_ICONSTOP)
    end;
end;

procedure TConverterForm.FormCreate(Sender: TObject);
begin
  DirectoriesList.OnChange(nil);
end;

procedure TConverterForm.miAllClick(Sender: TObject);
begin
  if BitmapsList.Count > 0 then begin
    BitmapsList.SelectAll;
    BitmapsList.OnChange(nil);
  end;
end;

procedure TConverterForm.miNothingClick(Sender: TObject);
var
  i : Integer;
begin
  if BitmapsList.Count > 0 then begin
    for i := 0 to BitmapsList.Count - 1 do
      BitmapsList.Selected[i] := False;
    BitmapsList.OnChange(nil);
  end;
end;

procedure TConverterForm.miInvertClick(Sender: TObject);
var
  i : Integer;
begin
  if BitmapsList.Count > 0 then begin
    for i := 0 to BitmapsList.Count - 1 do
      BitmapsList.Selected[i] := not BitmapsList.Selected[i];
    BitmapsList.OnChange(nil);
  end;
end;

procedure TConverterForm.miEditClick(Sender: TObject);
begin
  if (BitmapsList.ItemIndex >= 0) and (BitmapsList.Count > 0) then
    if ShellExecute(Handle, PChar('edit'), PChar(DirectoriesList.Directory + '\' +
                    BitmapsList.Items[BitmapsList.ItemIndex]), nil, nil, SW_SHOWNORMAL) <= 32 then
      Application.MessageBox(PChar('Невозможно запустить редактор изображений!'),
                             PChar('Ошибка'), MB_ICONSTOP);
end;

procedure TConverterForm.miOpenClick(Sender: TObject);
begin
  if (BitmapsList.ItemIndex >= 0) and (BitmapsList.Count > 0) then
    if ShellExecute(Handle, PChar('open'), PChar(DirectoriesList.Directory + '\' +
                    BitmapsList.Items[BitmapsList.ItemIndex]), nil, nil, SW_SHOWNORMAL) <= 32 then
      Application.MessageBox(PChar('Невозможно запустить просмотр изображений!'),
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
  i := FindFirst(Folder + '\*.bmp', faAnyFile, fs);
  while i = 0 do begin
    Application.ProcessMessages;
    if flgCancel then
      Exit;
    fname := fs.Name;
    while fname[Length(fname)] <> '.' do
      Delete(fname, Length(fname), 1);
    fname := fname + 'eif';
    if ConvertBitmap(PChar(Folder + '\' + fs.Name), PChar(OutDir + '\' + fname)) then
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
  if SelectDirectory('Выберите папку для сохранения изображений', '', outDir) then begin
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
  BitmapsList.Enabled      := st;
  Refresh;
end;

procedure TConverterForm.miWithSubfoldersClick(Sender: TObject);
begin
  if SelectDirectory('Выберите папку для сохранения изображений', '', outDir) then begin
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
  if BitmapsList.SelCount > 0 then
    if SelectDirectory('Выберите папку для сохранения изображений', '', outDir) then begin
      SetMenuState(False);
      numConv := 0;
      StatsMemo.Lines.Add('Начато конвертирование выбранных файлов...');
      flgCancel := False;
      for i := 0 to BitmapsList.Count - 1 do
        if BitmapsList.Selected[i] then begin
          fname := BitmapsList.Items[i];
          while fname[Length(fname)] <> '.' do
            Delete(fname, Length(fname), 1);
          fname := fname + 'eif';
          if ConvertBitmap(PChar(DirectoriesList.Directory + '\' + BitmapsList.Items[i]),
                           PChar(outDir + '\' + fname)) then
            numConv := numConv + 1
          else
            StatsMemo.Lines.Add('- Невозможно конвертировать "' + DirectoriesList.Directory + '\' +
                                BitmapsList.Items[i]);
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

end.
