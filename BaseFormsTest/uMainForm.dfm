object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'MainForm'
  ClientHeight = 306
  ClientWidth = 475
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  CloseByEscape = False
  PixelsPerInch = 96
  TextHeight = 13
  object lblModalResult: TLabel
    Left = 144
    Top = 13
    Width = 68
    Height = 13
    Caption = 'lblModalResult'
  end
  object Bevel1: TBevel
    Left = 8
    Top = 75
    Width = 459
    Height = 6
    Shape = bsTopLine
  end
  object btnNewModalForm: TButton
    Left = 12
    Top = 8
    Width = 121
    Height = 25
    Caption = 'Show Modal Form'
    TabOrder = 0
    OnClick = btnNewModalFormClick
  end
  object btnNewFormWithFreeOnClose: TButton
    Left = 12
    Top = 44
    Width = 217
    Height = 25
    Caption = 'Create Form With Free On Close'
    TabOrder = 1
    OnClick = btnNewFormWithFreeOnCloseClick
  end
  object btnTestAutoFree: TButton
    Left = 12
    Top = 87
    Width = 217
    Height = 25
    Caption = 'Create Form With AutoFree Objects'
    TabOrder = 2
    OnClick = btnTestAutoFreeClick
  end
  object memAutoFreeObjsLog: TMemo
    Left = 235
    Top = 87
    Width = 222
    Height = 209
    Lines.Strings = (
      'memAutoFreeObjsLog')
    ScrollBars = ssVertical
    TabOrder = 3
  end
  object btnTestAutoFree2: TButton
    Left = 12
    Top = 118
    Width = 217
    Height = 25
    Caption = 'Create Modal Form With AutoFree Objects'
    TabOrder = 4
    OnClick = btnTestAutoFree2Click
  end
end
