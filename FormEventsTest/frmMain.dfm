object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'MainForm'
  ClientHeight = 263
  ClientWidth = 453
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    453
    263)
  PixelsPerInch = 96
  TextHeight = 13
  object Button2: TButton
    Left = 7
    Top = 8
    Width = 75
    Height = 25
    Action = acCreateEventsForm
    TabOrder = 0
  end
  object Button3: TButton
    Left = 7
    Top = 103
    Width = 75
    Height = 25
    Action = acShowEventsForm
    TabOrder = 1
  end
  object Button4: TButton
    Left = 7
    Top = 197
    Width = 75
    Height = 25
    Action = acHideEventsForm
    TabOrder = 2
  end
  object Button5: TButton
    Left = 7
    Top = 228
    Width = 75
    Height = 25
    Action = acDestroyEventsForm
    TabOrder = 3
  end
  object CheckBox1: TCheckBox
    Left = 12
    Top = 39
    Width = 70
    Height = 17
    Action = acEventsFormVisible
    TabOrder = 4
  end
  object memBkLog: TMemo
    Left = 96
    Top = 39
    Width = 345
    Height = 214
    Anchors = [akLeft, akTop, akRight, akBottom]
    ScrollBars = ssVertical
    TabOrder = 5
  end
  object Button1: TButton
    Left = 7
    Top = 166
    Width = 75
    Height = 25
    Action = acCloseEventsForm
    TabOrder = 6
  end
  object Button6: TButton
    Left = 7
    Top = 134
    Width = 75
    Height = 25
    Action = acCloseQueryEventsForm
    TabOrder = 7
  end
  object btnClearEventsFormLog: TButton
    Left = 96
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Clear Log'
    TabOrder = 8
    OnClick = btnClearEventsFormLogClick
  end
  object Button7: TButton
    Left = 7
    Top = 72
    Width = 75
    Height = 25
    Action = acShowModalEventsForm
    TabOrder = 9
  end
  object chkLogActivateEvents: TCheckBox
    Left = 184
    Top = 12
    Width = 257
    Height = 17
    Caption = 'Log Activate/Deactivate Events'
    TabOrder = 10
  end
  object ActionList1: TActionList
    Left = 104
    Top = 48
    object acCreateEventsForm: TAction
      Caption = 'Create'
      OnExecute = acCreateEventsFormExecute
      OnUpdate = acXXXUpdate
    end
    object acShowEventsForm: TAction
      Caption = 'Show'
      OnExecute = acShowEventsFormExecute
      OnUpdate = acXXXUpdate
    end
    object acCloseEventsForm: TAction
      Caption = 'Close'
      OnExecute = acCloseEventsFormExecute
      OnUpdate = acXXXUpdate
    end
    object acCloseQueryEventsForm: TAction
      Caption = 'Close Query'
      OnExecute = acCloseQueryEventsFormExecute
      OnUpdate = acXXXUpdate
    end
    object acHideEventsForm: TAction
      Caption = 'Hide'
      OnExecute = acHideEventsFormExecute
      OnUpdate = acXXXUpdate
    end
    object acEventsFormVisible: TAction
      Caption = 'Visible'
      OnExecute = acEventsFormVisibleExecute
      OnUpdate = acXXXUpdate
    end
    object acDestroyEventsForm: TAction
      Caption = 'Destroy'
      OnExecute = acDestroyEventsFormExecute
      OnUpdate = acXXXUpdate
    end
    object acShowModalEventsForm: TAction
      Caption = 'Show Modal'
      OnExecute = acShowModalEventsFormExecute
      OnUpdate = acXXXUpdate
    end
  end
end
