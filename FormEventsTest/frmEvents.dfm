object EventsForm: TEventsForm
  Left = 0
  Top = 0
  Caption = 'EventsForm'
  ClientHeight = 293
  ClientWidth = 425
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = BaseFormActivate
  OnClose = BaseFormClose
  OnCloseQuery = BaseFormCloseQuery
  OnCreate = BaseFormCreate
  OnDestroy = BaseFormDestroy
  OnDeactivate = BaseFormDeactivate
  OnHide = BaseFormHide
  OnMouseActivate = BaseFormMouseActivate
  OnShow = BaseFormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 213
    Height = 69
    Caption = 'Base Form properties'
    TabOrder = 0
    object chkCloseByEscape: TCheckBox
      Left = 12
      Top = 43
      Width = 97
      Height = 17
      Caption = 'CloseByEscape'
      TabOrder = 0
      OnClick = chkCloseByEscapeClick
    end
    object chkFreeOnClose: TCheckBox
      Left = 12
      Top = 20
      Width = 97
      Height = 17
      Caption = 'FreeOnClose'
      TabOrder = 1
      OnClick = chkFreeOnCloseClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 83
    Width = 409
    Height = 173
    Caption = 'Event Handlers'
    TabOrder = 1
    object chkCanClose: TCheckBox
      Left = 12
      Top = 24
      Width = 185
      Height = 17
      Caption = 'OnCloseQuery: Can Close'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object rgCloseAction: TRadioGroup
      Left = 12
      Top = 47
      Width = 185
      Height = 117
      Caption = 'OnClose: Close Action'
      ItemIndex = 4
      Items.Strings = (
        'caNone'
        'caHide'
        'caFree'
        'caMinimize'
        '( not change )')
      TabOrder = 1
    end
    object rgMouseActivate: TRadioGroup
      Left = 212
      Top = 24
      Width = 185
      Height = 140
      Caption = 'OnMouseActivate: MouseActivate'
      ItemIndex = 5
      Items.Strings = (
        'maDefault'
        'maActivate'
        'maActivateAndEat'
        'maNoActivate'
        'maNoActivateAndEat'
        '( not change )')
      TabOrder = 2
    end
  end
  object btnOk: TButton
    Left = 342
    Top = 262
    Width = 75
    Height = 25
    Caption = 'Modal OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object btnHide: TButton
    Left = 180
    Top = 262
    Width = 75
    Height = 25
    Caption = 'Hide'
    TabOrder = 3
    OnClick = btnHideClick
  end
  object btnClose: TButton
    Left = 261
    Top = 262
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 4
    OnClick = btnCloseClick
  end
end
