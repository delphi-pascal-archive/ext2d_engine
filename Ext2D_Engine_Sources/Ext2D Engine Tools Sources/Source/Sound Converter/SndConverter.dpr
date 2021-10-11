program SndConverter;

uses
  Forms,
  Main in 'Main.pas' {ConverterForm},
  About in 'About.pas' {AboutForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Конвертор звуков для Ext2D Engine';
  Application.CreateForm(TConverterForm, ConverterForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.Run;
end.
