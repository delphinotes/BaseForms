unit BaseForms;
(*
  BaseForms - ������� ����� � ������� ������

****************************************************************
  Author    : Zverev Nikolay (delphinotes.ru)
  Created   : 30.08.2006
  Modified  : 19.01.2013
  Version   : 1.00
  History   :
****************************************************************

  ����� �������������� ���������� ���������� �����:
    packages\BaseFormsDesignXXX.dpk

  ��� ��������� �����, ����� ���������� ��������������
*)

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Contnrs;

type
  TAutoFreeOnEvent = (afDefault, afHide, afDestroy);

  TBaseForm = class;
  TBaseFormClass = class of TBaseForm;

  TBaseFrame = class;
  TBaseFrameClass = class of TBaseFrame;

  { TBaseForm }

  TBaseForm = class(TForm)
  private
    FCloseByEscape: Boolean;
    FFreeOnClose: Boolean;

    procedure CMDialogKey(var Message: TCMDialogKey); message CM_DIALOGKEY;
    procedure WMSetIcon(var Message: TWMSetIcon); message WM_SETICON;
    procedure WMSysCommand(var Message: TWMSysCommand); message WM_SYSCOMMAND;
    procedure WMActivate(var Message: TWMActivate); message WM_ACTIVATE;
  protected
    FAutoFreeOnHide: TObjectList;
    FAutoFreeOnDestroy: TObjectList;

    procedure InitializeNewForm; override;
    procedure DoClose(var Action: TCloseAction); override;
    procedure DoHide; override;
    procedure DoDestroy; override;
  public
    function AutoFree(AObject: TObject; OnEvent: TAutoFreeOnEvent = afDefault): Pointer;
  published
    // ���� ��������������� �������� ����� �� Escape
    property CloseByEscape: Boolean read FCloseByEscape write FCloseByEscape default True;

    // ���� ��������������� ����������� ����� ��� ��������
    property FreeOnClose: Boolean read FFreeOnClose write FFreeOnClose default False;
  end;

  { TBaseFrame }

  TBaseFrame = class(TFrame)
  end;

implementation

uses
  StdCtrls;

var
  IsRestoringPositions: Boolean;

procedure RestoreFormsPositions;
var
  List: TList;
  i: Integer;
  F: TCustomForm;
begin
  if IsRestoringPositions then
    Exit;
  IsRestoringPositions := True;
  try
    List := TList.Create;
    try
      // ������� ��������� ������ ���� � ��� �������, � ������� ��� ���� ����������
      List.Capacity := Screen.CustomFormCount;
      for i := 0 to Screen.CustomFormCount - 1 do
        List.Add(Screen.CustomForms[i]);

      // ������ ��������������� ���� �������
      for i := List.Count - 1 downto 0 do
      begin
        F := TCustomForm(List[i]);
        BringWindowToTop(F.Handle);
      end;
    finally
      List.Free;
    end;
  finally
    IsRestoringPositions := False;
  end;
end;

{ TBaseForm }

procedure TBaseForm.InitializeNewForm;
begin
  inherited InitializeNewForm;
  FCloseByEscape := True;
end;

procedure TBaseForm.DoClose(var Action: TCloseAction);
begin
  if FreeOnClose then
    Action := caFree;
  inherited DoClose(Action);  // <- Form.OnClose
end;

procedure TBaseForm.DoHide;
begin
  inherited DoHide;           // <- Form.OnHide
  // destory auto free objects
  FreeAndNil(FAutoFreeOnHide);
end;

procedure TBaseForm.DoDestroy;
begin
  inherited DoDestroy;        // <- Form.OnDestroy
  // destory auto free objects
  FreeAndNil(FAutoFreeOnHide);
  FreeAndNil(FAutoFreeOnDestroy);
end;

function TBaseForm.AutoFree(AObject: TObject; OnEvent: TAutoFreeOnEvent = afDefault): Pointer;
begin
  if OnEvent = afDefault then
    if fsShowing in FormState
      then OnEvent := afHide
      else OnEvent := afDestroy;

  case OnEvent of
    afHide:
      begin
        if not Assigned(FAutoFreeOnHide) then
          FAutoFreeOnHide := TObjectList.Create;
        FAutoFreeOnHide.Add(AObject);
      end;
    afDestroy:
      begin
        if not Assigned(FAutoFreeOnDestroy) then
          FAutoFreeOnDestroy := TObjectList.Create;
        FAutoFreeOnDestroy.Add(AObject);
      end;
  else
    Assert(False);
  end;
  Result := AObject;
end;

procedure TBaseForm.CMDialogKey(var Message: TCMDialogKey);
begin
  // ��������� CloseByEscape
  if CloseByEscape then
    with Message do
      if (CharCode = VK_ESCAPE) and (KeyDataToShiftState(KeyData) = []) then
      begin
        // ��� ���������� ������ - ������� Cancel
        if fsModal in FormState then
        begin
          ModalResult := mrCancel;
          Result := 1;
        end else
          // ��� �������� - �������� ������� �� ��������
          Result := Integer(PostMessage(Handle, WM_CLOSE, 0, 0));

        if Result <> 0 then
          Exit;
      end;

  inherited;
end;

procedure TBaseForm.WMSetIcon(var Message: TWMSetIcon);
begin
  // � ������ ����������� ���� ���������� ��������� ������ (����� ��� ������� ��� �������� � Windows Aero)
  if (csDesigning in ComponentState) or not (csDestroying in ComponentState) then
    inherited;
end;

procedure TBaseForm.WMSysCommand(var Message: TWMSysCommand);
begin
  // ���� ���� ������� � ��������� ������, ��, ������ ������������ ����, ����������� ����������
  if (Message.CmdType = SC_MINIMIZE) and (fsModal in FormState) then
    Application.Minimize
  else
    inherited;
end;

procedure TBaseForm.WMActivate(var Message: TWMActivate);
begin
  if not (csDesigning in ComponentState) and (Message.Active > 0) and not IsWindowEnabled(Handle) then
    // �����: ���� ���� ���������, �� �����-�� ������� ������������
    // ������ ����� ���� ��������� ����, ���� ����� ���� - �� ���� �� ��������
    RestoreFormsPositions;
  inherited;
end;

end.