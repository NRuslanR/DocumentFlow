object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 605
  ClientWidth = 699
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 8
    Top = 16
    Width = 121
    Height = 25
    Caption = 'Run document test'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 8
    Top = 47
    Width = 209
    Height = 25
    Caption = 'Run document charge sheet test'
    TabOrder = 1
    OnClick = Button2Click
  end
  object cxDBTreeList1: TcxDBTreeList
    Left = 8
    Top = 120
    Width = 686
    Height = 201
    Bands = <
      item
      end>
    DataController.DataSource = DataSource1
    DataController.ParentField = 'sender_id'
    DataController.KeyField = 'id'
    OptionsCustomizing.BandsQuickCustomization = True
    OptionsCustomizing.ColumnsQuickCustomization = True
    OptionsView.CellAutoHeight = True
    OptionsView.HeaderAutoHeight = True
    RootValue = -1
    TabOrder = 2
    object cxDBTreeList1cxDBTreeListColumn1: TcxDBTreeListColumn
      Caption.Text = #1060#1048#1054
      DataBinding.FieldName = 'full_name'
      Width = 100
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object cxDBTreeList1cxDBTreeListColumn2: TcxDBTreeListColumn
      DataBinding.FieldName = 'speciality'
      Width = 127
      Position.ColIndex = 1
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object cxDBTreeList1cxDBTreeListColumn3: TcxDBTreeListColumn
      Caption.Text = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
      DataBinding.FieldName = 'department_short_name'
      Width = 100
      Position.ColIndex = 2
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object cxDBTreeList1cxDBTreeListColumn4: TcxDBTreeListColumn
      Caption.Text = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
      DataBinding.FieldName = 'comment'
      Width = 246
      Position.ColIndex = 3
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object cxDBTreeList1cxDBTreeListColumn5: TcxDBTreeListColumn
      Caption.Text = #1044#1072#1090#1072' '#1080#1089#1087#1086#1083#1085#1077#1085#1080#1103
      DataBinding.FieldName = 'performing_date'
      Width = 100
      Position.ColIndex = 4
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object cxDBTreeList1cxDBTreeListColumn6: TcxDBTreeListColumn
      Visible = False
      DataBinding.FieldName = 'id'
      Options.Customizing = False
      Position.ColIndex = 5
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object cxDBTreeList1cxDBTreeListColumn7: TcxDBTreeListColumn
      Visible = False
      DataBinding.FieldName = 'sender_id'
      Options.Customizing = False
      Position.ColIndex = 6
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
  end
  object Button3: TButton
    Left = 56
    Top = 376
    Width = 75
    Height = 25
    Caption = 'Button3'
    TabOrder = 3
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 8
    Top = 78
    Width = 209
    Height = 25
    Caption = 'Run overlapping charge sheet test'
    TabOrder = 4
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 8
    Top = 327
    Width = 361
    Height = 25
    Caption = 'Run Document charge sheet control service'
    TabOrder = 5
    OnClick = Button5Click
  end
  object ZQuery1: TZQuery
    Connection = ZConnection1
    SQL.Strings = (
      'select '
      'b.id, '
      'b.sender_id,'
      
        'cast((a.surname || '#39' '#39' || a.name || '#39' '#39' || a.patronymic) as varc' +
        'har) as full_name,'
      'a.speciality, '
      'a.outside_id as employee_id,'
      'c.short_name as department_short_name, '
      
        'case when not e.is_foreign then b.comment else '#39#1059#1074#1077#1076#1086#1084#1083#1077#1085#1080#1077' '#1087#1086' '#1087 +
        #1086#1095#1090#1077#39' end as comment,'
      'b.charge,'
      
        '(b.input_number is not null and length(b.input_number) <> 0) as ' +
        'is_document_opened,'
      '0 as status,'
      'b.performing_date,'
      'b.outside_document_id as document_id,'
      'b.performing_date is not null as is_performed,'
      'a.leader_id,'
      'e.is_foreign as is_receiver_foreign,'
      '('
      'select '
      'e.short_full_name'
      'from doc.employees e '
      
        'where e.outside_id = doc.find_employee_id_by_login(b.changing_us' +
        'er) '
      ') as charge_sender'
      'from doc.employees a'
      
        'join doc.service_note_receivers b on a.outside_id = b.outside_em' +
        'ployee_id '
      'join doc.departments c on c.outside_id = a.department_id'
      'join doc.service_notes d on d.outside_id = b.outside_document_id'
      'join doc.employees e on e.outside_id = b.outside_employee_id '
      'where b.outside_document_id = 227473 and b.is_performer')
    Params = <>
    Left = 376
    Top = 192
    object ZQuery1id: TIntegerField
      FieldName = 'id'
      Required = True
    end
    object ZQuery1sender_id: TIntegerField
      FieldName = 'sender_id'
    end
    object ZQuery1full_name: TStringField
      FieldName = 'full_name'
      ReadOnly = True
      Size = 255
    end
    object ZQuery1speciality: TStringField
      FieldName = 'speciality'
      Size = 255
    end
    object ZQuery1employee_id: TIntegerField
      FieldName = 'employee_id'
      Required = True
    end
    object ZQuery1department_short_name: TStringField
      FieldName = 'department_short_name'
      Size = 255
    end
    object ZQuery1comment: TStringField
      FieldName = 'comment'
      ReadOnly = True
      Size = 255
    end
    object ZQuery1charge: TStringField
      FieldName = 'charge'
      Size = 255
    end
    object ZQuery1is_document_opened: TBooleanField
      FieldName = 'is_document_opened'
      ReadOnly = True
    end
    object ZQuery1status: TIntegerField
      FieldName = 'status'
      ReadOnly = True
    end
    object ZQuery1performing_date: TDateTimeField
      FieldName = 'performing_date'
    end
    object ZQuery1document_id: TIntegerField
      FieldName = 'document_id'
      Required = True
    end
    object ZQuery1is_performed: TBooleanField
      FieldName = 'is_performed'
      ReadOnly = True
    end
    object ZQuery1leader_id: TIntegerField
      FieldName = 'leader_id'
    end
    object ZQuery1is_receiver_foreign: TBooleanField
      FieldName = 'is_receiver_foreign'
      Required = True
    end
    object ZQuery1charge_sender: TStringField
      FieldName = 'charge_sender'
      ReadOnly = True
      Size = 255
    end
  end
  object ZConnection1: TZConnection
    Protocol = 'postgresql-8'
    HostName = 'srv-pg2'
    Port = 5432
    Database = 'ump_nightly'
    User = 'u_59968'
    Password = '123456'
    Left = 440
    Top = 168
  end
  object DataSource1: TDataSource
    DataSet = ZQuery1
    Left = 440
    Top = 240
  end
end
