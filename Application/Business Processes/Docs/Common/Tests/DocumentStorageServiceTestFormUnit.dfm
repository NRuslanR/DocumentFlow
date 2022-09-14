object DocumentStorageServiceTestForm: TDocumentStorageServiceTestForm
  Left = 0
  Top = 0
  Caption = 'DocumentStorageServiceTestForm'
  ClientHeight = 501
  ClientWidth = 690
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
    Top = 8
    Width = 233
    Height = 25
    Caption = 'Run Getting Documnet Full Info Test'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 8
    Top = 71
    Width = 233
    Height = 25
    Caption = 'Run Adding Document Full Info Test'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 8
    Top = 102
    Width = 233
    Height = 25
    Caption = 'Run Removing Documents Info Test'
    TabOrder = 2
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 8
    Top = 39
    Width = 233
    Height = 25
    Caption = 'Run Changing Document Info Test'
    TabOrder = 3
    OnClick = Button4Click
  end
  object ZConnection1: TZConnection
    Protocol = 'postgresql-8'
    HostName = 'srv-pg2'
    Port = 5432
    Database = 'ump_nightly'
    User = 'u_59968'
    Password = '123456'
    Connected = True
    Left = 400
  end
end
