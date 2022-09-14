object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Form2'
  ClientHeight = 700
  ClientWidth = 702
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 8
    Top = 16
    Width = 185
    Height = 25
    Caption = 'Document Repository'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 8
    Top = 56
    Width = 185
    Height = 25
    Caption = 'Incoming Document Repository'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 8
    Top = 87
    Width = 185
    Height = 25
    Caption = 'Document Charge Sheet Repository'
    TabOrder = 2
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 8
    Top = 118
    Width = 185
    Height = 25
    Caption = 'Employee Repository'
    TabOrder = 3
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 8
    Top = 149
    Width = 185
    Height = 25
    Caption = 'Employee Reference Service'
    TabOrder = 4
    OnClick = Button5Click
  end
  object ZConnection1: TZConnection
    Protocol = 'postgresql-8'
    HostName = 'srv-pg2'
    Port = 5432
    Database = 'ump_nightly'
    User = 'u_59968'
    Password = '123456'
    Connected = True
    Left = 392
    Top = 248
  end
end
