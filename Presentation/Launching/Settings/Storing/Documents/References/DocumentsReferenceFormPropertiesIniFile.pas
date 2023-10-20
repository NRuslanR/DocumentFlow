unit DocumentsReferenceFormPropertiesIniFile;

interface

uses

  DocumentsReferenceFilterFormStatePropertiesIniFile,
  DBDataTableFormPropertiesIniFile,
  DBDataTableFormUnit,
  PropertiesIniFileUnit,
  IPropertiesStorageUnit,
  SysUtils,
  Classes,
  BaseDocumentsReferenceFormUnit;

type

  TDocumentsReferenceFormPropertiesIniFile =
    class (TDBDataTableFormPropertiesIniFile)

      protected

        procedure RestoreDBDataTableFormProperties(
          DBDataTableForm: TDBDataTableForm;
          PropertiesStorage: IPropertiesStorage
        ); override;

        procedure SaveDBDataTableFormProperties(
          DBDataTableForm: TDBDataTableForm;
          PropertiesStorage: IPropertiesStorage
        ); override; 


      public
        
        constructor Create(
          DocumentsReferenceFilterFormStatePropertiesIniFile:
            TDocumentsReferenceFilterFormStatePropertiesIniFile;

          const IniFilePath: String;
          const DefaultIniFilePath: String = ''
        );

    end;
    
implementation

uses

  cxGridTableView,
  cxGridDBTableView,
  cxEdit,
  cxSpinEdit,
  AuxiliaryStringFunctions;
  
{ TDocumentsReferenceFormPropertiesIniFile }

constructor TDocumentsReferenceFormPropertiesIniFile.Create(
  DocumentsReferenceFilterFormStatePropertiesIniFile:
    TDocumentsReferenceFilterFormStatePropertiesIniFile;

  const IniFilePath: String;
  const DefaultIniFilePath: String
);
begin

  inherited Create(
    DocumentsReferenceFilterFormStatePropertiesIniFile,
    IniFilePath,
    DefaultIniFilePath
  );

end;

procedure TDocumentsReferenceFormPropertiesIniFile.RestoreDBDataTableFormProperties(
  DBDataTableForm: TDBDataTableForm;
  PropertiesStorage: IPropertiesStorage
);
var
    CreationDateYearColumn: TcxGridDBColumn;
    CreationDateMonthColumn: TcxGridDBColumn;

    CreationDateYearColumnAlignment: TcxEditAlignment;
    CreationDateMonthColumnAlignment: TcxEditAlignment;

    BaseReferenceForm: TBaseDocumentsReferenceForm;
begin

  inherited RestoreDBDataTableFormProperties(DBDataTableForm, PropertiesStorage);

  CreationDateYearColumn :=

    DBDataTableForm.DataRecordGridTableView.GetColumnByFieldName(
      'creation_date_year'
    );

  CreationDateMonthColumn :=

    DBDataTableForm.DataRecordGridTableView.GetColumnByFieldName(
      'creation_date_month'
    );

  if Assigned(CreationDateYearColumn) then begin

    CreationDateYearColumnAlignment :=
      TcxEditAlignment.Create(CreationDateYearColumn);

    CreationDateYearColumnAlignment.Horz := taLeftJustify;
    CreationDateYearColumnAlignment.Vert := taVCenter;

    CreationDateYearColumn.Properties.Alignment :=
      CreationDateYearColumnAlignment;

  end;

  if Assigned(CreationDateMonthColumn) then begin

    CreationDateMonthColumnAlignment :=
      TcxEditAlignment.Create(CreationDateMonthColumn);

    CreationDateMonthColumnAlignment.Horz := taLeftJustify;
    CreationDateMonthColumnAlignment.Vert := taVCenter;

    CreationDateMonthColumn.Properties.Alignment :=
      CreationDateMonthColumnAlignment;

  end;

  if DBDataTableForm is TBaseDocumentsReferenceForm then
  begin

    BaseReferenceForm := DBDataTableForm as TBaseDocumentsReferenceForm;

    PropertiesStorage.GoToSection('SelectionSettigs');

    BaseReferenceForm.SelectedWorkCycleStageNames :=
      SplitStringByDelimiter(
        PropertiesStorage.ReadValueForProperty('SelectedWorkCycleStageNames', varString, ''),
        ','

        // по умолчанию стоит ', ', а пробел после зап€той не нужен ибо впоследсвии эта строка будет раздел€тьс€
        // с помощью функции SplitStringByDelimiter, у которой разделитель это char а не string
      );

  end;


end;

procedure TDocumentsReferenceFormPropertiesIniFile.SaveDBDataTableFormProperties(
  DBDataTableForm: TDBDataTableForm; PropertiesStorage: IPropertiesStorage);
var
  BaseReferenceForm: TBaseDocumentsReferenceForm;
begin

  inherited SaveDBDataTableFormProperties(DBDataTableForm, PropertiesStorage);

  if DBDataTableForm is TBaseDocumentsReferenceForm then
  begin

    BaseReferenceForm := DBDataTableForm as TBaseDocumentsReferenceForm;

    //  if not Assigned(BaseReferenceForm.ViewModel) then Exit;

    PropertiesStorage.GoToSection('SelectionSettigs');

    PropertiesStorage.WriteValueForProperty(
      'SelectedWorkCycleStageNames',
      CreateStringFromStringList(BaseReferenceForm.SelectedWorkCycleStageNames, ',')
    );

  end;

end;

end.
