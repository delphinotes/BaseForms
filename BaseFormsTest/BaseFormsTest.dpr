program BaseFormsTest;

uses
  Forms,
  uMainForm in 'uMainForm.pas' {MainForm},
  uAutoFreeObjsForm in 'uAutoFreeObjsForm.pas' {TestAutoFree: TBaseForm},
  uSomeForm in 'uSomeForm.pas' {SomeForm: TBaseForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
