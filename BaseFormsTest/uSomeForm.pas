unit uSomeForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseForms, StdCtrls;

type
  TSomeForm = class(TBaseForm)
    Button1: TButton;
    chkCloseByEscape: TCheckBox;
    btnNewModal: TButton;
    procedure chkCloseByEscapeClick(Sender: TObject);
    procedure btnNewModalClick(Sender: TObject);
    procedure BaseFormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TSomeForm.BaseFormShow(Sender: TObject);
begin
  chkCloseByEscape.Checked := CloseByEscape;
  if (fsModal in FormState) then
    Caption := Caption + ' (Modal)';
  if FreeOnClose then
    Caption := Caption + ' (Auto Free On Close)';
end;

procedure TSomeForm.btnNewModalClick(Sender: TObject);
begin
  with TSomeForm.Create(Self) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TSomeForm.Button1Click(Sender: TObject);
begin
  if not (fsModal in FormState) then
    Close;
end;

procedure TSomeForm.chkCloseByEscapeClick(Sender: TObject);
begin
  CloseByEscape := chkCloseByEscape.Checked;
end;

end.
