inherited DocumentRecordsTableForm: TDocumentRecordsTableForm
  Caption = 'DocumentRecordsTableForm'
  PixelsPerInch = 96
  TextHeight = 13
  inherited DataOperationToolBar: TToolBar
    inherited ChooseRecordsSeparator: TToolButton
      Visible = False
    end
  end
  inherited ClientAreaPanel: TPanel
    inherited DataRecordGrid: TcxGrid
      inherited DataRecordGridTableView: TcxGridDBTableView
        OptionsData.Deleting = False
        OptionsData.Editing = False
        OptionsData.Inserting = False
        object DocumentNumberColumn: TcxGridDBColumn
          Caption = #1053#1086#1084#1077#1088
          DataBinding.FieldName = 'document_number'
          Width = 135
        end
        object DocumentNameColumn: TcxGridDBColumn
          Caption = #1053#1072#1079#1074#1072#1085#1080#1077
          DataBinding.FieldName = 'name'
          Width = 225
        end
        object DocumentCreationDateColumn: TcxGridDBColumn
          Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103
          DataBinding.FieldName = 'creation_date'
          Width = 164
        end
        object DocumentPerformerEmployeeColumn: TcxGridDBColumn
          Caption = #1040#1074#1090#1086#1088
          DataBinding.FieldName = 'performer_full_name'
          Width = 250
        end
        object DocumentPerformerDepartmentColumn: TcxGridDBColumn
          Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' '#1072#1074#1090#1086#1088#1072
          DataBinding.FieldName = 'performer_department_short_name'
          Width = 160
        end
      end
    end
  end
  inherited DataOperationActionList: TActionList
    inherited actExit: TAction
      Visible = False
    end
    inherited actChooseRecords: TAction
      Visible = False
    end
  end
  inherited TargetDataSource: TDataSource
    DataSet = ZQuery1
  end
  object ZQuery1: TZQuery
    SQL.Strings = (
      'select '
      'a.id,'
      'a.id_for_search,'
      'a.type_id,'
      'a.name, '
      'a.document_number, '
      'a.creation_date,'
      'a.correspondent_id,'
      'a.acceptance_posting_kind, '
      'a.note::::text, '
      'a.current_life_cycle_stage_id, '
      'a.content::::text, '
      'a.employee_login_who_created, '
      'a.performer_id, '
      'a.performer_department_id, '
      'a.employee_login_who_agreed, '
      'a.agreement_date,'
      'a.changing_date,'
      'a.changing_user, '
      'a.phone::::text performer_telephone_number, '
      'd.name::::text document_type_name,'
      'e.stage_name::::text document_life_cycle_stage_name,'
      'b.tab_nbr::::text performer_personnel_number,'
      
        '(b.family || '#39' '#39' || b.name || '#39' '#39' || b.patronymic)::::text perfo' +
        'rmer_full_name,'
      
        'exchange.person_get_fio_by_login(lower(a.employee_login_who_agre' +
        'ed)) employee_full_name_who_agreed,'
      'c.code::::text department_code,'
      'c.short_name::::text performer_department_short_name'
      'from doc.service_notes a'
      
        'left join exchange.spr_person b on a.performer_id is not null an' +
        'd a.performer_id = b.id'
      
        'left join doc.departments c on a.performer_department_id is not ' +
        'null and a.performer_department_id = c.id'
      'join doc.document_types d on d.id = a.type_id'
      
        'left join doc.document_type_life_cycle_stages e on e.id = a.curr' +
        'ent_life_cycle_stage_id')
    Params = <>
    Left = 496
    Top = 64
  end
end
