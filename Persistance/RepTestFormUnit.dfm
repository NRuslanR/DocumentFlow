object Form7: TForm7
  Left = 0
  Top = 0
  Caption = 'Form7'
  ClientHeight = 725
  ClientWidth = 711
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 16
    Top = 8
    Width = 217
    Height = 25
    Caption = 'Repository Registry'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 16
    Top = 39
    Width = 217
    Height = 25
    Caption = 'Department Repository'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 16
    Top = 70
    Width = 217
    Height = 25
    Caption = 'Employee Repository'
    TabOrder = 2
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 16
    Top = 101
    Width = 217
    Height = 25
    Caption = 'Outcomming Service Note Repository'
    TabOrder = 3
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 16
    Top = 132
    Width = 217
    Height = 25
    Caption = 'Incomming Service Note Repository'
    TabOrder = 4
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 16
    Top = 163
    Width = 217
    Height = 25
    Caption = 'Document Files Repository'
    TabOrder = 5
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 16
    Top = 194
    Width = 217
    Height = 25
    Caption = 'Document Relations Repository'
    TabOrder = 6
    OnClick = Button7Click
  end
  object Button8: TButton
    Left = 16
    Top = 225
    Width = 217
    Height = 25
    Caption = 'Employee Replacement Repository'
    TabOrder = 7
    OnClick = Button8Click
  end
  object Button9: TButton
    Left = 16
    Top = 256
    Width = 217
    Height = 25
    Caption = 'Document Charge Sheet Repository'
    TabOrder = 8
    OnClick = Button9Click
  end
  object ZConnection1: TZConnection
    Protocol = 'postgresql'
    HostName = 'srv-pg2'
    Port = 5432
    Database = 'ump_nightly'
    User = 'u_59968'
    Password = '123456'
    Left = 448
    Top = 8
  end
end
