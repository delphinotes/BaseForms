object SomeForm: TSomeForm
  Left = 0
  Top = 0
  Caption = 'Some Form'
  ClientHeight = 218
  ClientWidth = 363
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = BaseFormShow
  DesignSize = (
    363
    218)
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 280
    Top = 185
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = Button1Click
  end
  object chkCloseByEscape: TCheckBox
    Left = 16
    Top = 20
    Width = 169
    Height = 17
    Caption = 'Allow Close Me By Escape Key'
    TabOrder = 1
    OnClick = chkCloseByEscapeClick
  end
  object btnNewModal: TButton
    Left = 16
    Top = 84
    Width = 75
    Height = 25
    Caption = 'btnNewModal'
    TabOrder = 2
    OnClick = btnNewModalClick
  end
end
