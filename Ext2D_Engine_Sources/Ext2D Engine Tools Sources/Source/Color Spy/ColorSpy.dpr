program ColorSpy;

uses
  Forms,
  Main in 'Main.pas' {SpyForm},
  About in 'About.pas' {AboutForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Программа просмотра цветовых компонент для Ext2D Engine';
  Application.CreateForm(TSpyForm, SpyForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.Run;
end.
