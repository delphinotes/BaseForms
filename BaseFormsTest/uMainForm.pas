unit uMainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseForms, StdCtrls, ExtCtrls;

type
  TMainForm = class(TBaseForm)
    btnNewModalForm: TButton;
    lblModalResult: TLabel;
    btnNewFormWithFreeOnClose: TButton;
    btnTestAutoFree: TButton;
    memAutoFreeObjsLog: TMemo;
    btnTestAutoFree2: TButton;
    Bevel1: TBevel;
    procedure btnNewModalFormClick(Sender: TObject);
    procedure btnNewFormWithFreeOnCloseClick(Sender: TObject);
    procedure btnTestAutoFreeClick(Sender: TObject);
    procedure btnTestAutoFree2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

  procedure LogAF(const Msg: string);

implementation

{$R *.dfm}

uses
  uSomeForm, uAutoFreeObjsForm;

  procedure LogAF(const Msg: string);
  begin
    MainForm.memAutoFreeObjsLog.Lines.Add(Msg);
  end;

procedure TMainForm.btnNewModalFormClick(Sender: TObject);
var
  Result: TModalResult;
begin
  with TSomeForm.Create(Self) do
  try
    Result := ShowModal;
    lblModalResult.Caption := 'ModalResult = ' + IntToStr(Result);
  finally
    Free;
  end;
end;

procedure TMainForm.btnTestAutoFree2Click(Sender: TObject);
begin
  memAutoFreeObjsLog.Lines.Clear;
  TTestAutoFree.Create(Self).ShowModal;
end;

procedure TMainForm.btnTestAutoFreeClick(Sender: TObject);
begin
  memAutoFreeObjsLog.Lines.Clear;
  TTestAutoFree.Create(Self).Show;
end;

procedure TMainForm.btnNewFormWithFreeOnCloseClick(Sender: TObject);
begin
  with TSomeForm.Create(Self) do
  begin
    FreeOnClose := True;
    Show;
  end;
end;


end.
