unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseForms, StdCtrls, ExtCtrls;

type
  TForm1 = class(TBaseForm)
    btnNewModalForm: TButton;
    lblModalResult: TLabel;
    btnNewFormWithFreeOnClose: TButton;
    btnTestAutoFree: TButton;
    memAutoFreeObjsLog: TMemo;
    btnTestAutoFree2: TButton;
    Bevel1: TBevel;
    procedure btnNewModalFormClick(Sender: TObject);
    procedure btnNewFormWithFreeOnCloseClick(Sender: TObject);
    procedure BaseFormShow(Sender: TObject);
    procedure btnTestAutoFreeClick(Sender: TObject);
    procedure btnTestAutoFree2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

  procedure LogAF(const Msg: string);

implementation

{$R *.dfm}

uses
  uSomeForm, uAutoFreeObjsForm;

  procedure LogAF(const Msg: string);
  begin
    Form1.memAutoFreeObjsLog.Lines.Add(Msg);
  end;

procedure TForm1.btnNewModalFormClick(Sender: TObject);
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

procedure TForm1.btnTestAutoFree2Click(Sender: TObject);
begin
  memAutoFreeObjsLog.Lines.Clear;
  TTestAutoFree.Create(Self).ShowModal;
end;

procedure TForm1.btnTestAutoFreeClick(Sender: TObject);
begin
  memAutoFreeObjsLog.Lines.Clear;
  TTestAutoFree.Create(Self).Show;
end;

procedure TForm1.BaseFormShow(Sender: TObject);
begin
  //if Application.MainForm = Self then
  //  Caption := 'Main Form';
end;

procedure TForm1.btnNewFormWithFreeOnCloseClick(Sender: TObject);
begin
  with TSomeForm.Create(Self) do
  begin
    FreeOnClose := True;
    Show;
  end;
end;


end.
