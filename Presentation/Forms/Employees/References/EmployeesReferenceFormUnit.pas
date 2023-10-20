unit EmployeesReferenceFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Menus, cxControls, cxStyles, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, ActnList, ImgList, PngImageList,
  cxGridLevel, cxClasses, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, cxButtons, ComCtrls, pngimage,
  ExtCtrls, StdCtrls, ToolWin, ZAbstractRODataset, ZAbstractDataset, ZDataset,
  cxCheckBox, DBDataTableFormUnit,
  EmployeeSetHolder, cxLocalization,
  VariantListUnit,
  DocumentFlowBaseReferenceFormUnit;

type

  TEmployeesReferenceFormRecord = class (TDBDataTableRecord)

    private

      FFieldDefs: TEmployeeSetFieldDefs;

    protected

      function GetDepartmentCodeFieldValue: String;
      function GetDepartmentShortNameFieldValue: String;
      function GetIdFieldValue: Variant;
      function GetNameFieldValue: String;
      function GetPatronymicFieldValue: String;
      function GetPersonnelNumberFieldValue: String;
      function GetSpecialityFieldValue: String;
      function GetSurnameFieldValue: String;
      function GetTelephoneNumberFieldValue: String;
      function GetIsForeignFieldValue: Boolean;
      
    public

      constructor Create(FieldDefs: TEmployeeSetFieldDefs);

      property Id: Variant read GetIdFieldValue;
      property PersonnelNumber: String read GetPersonnelNumberFieldValue;
      property Name: String read GetNameFieldValue;
      property Surname: String read GetSurnameFieldValue;
      property Patronymic: String read GetPatronymicFieldValue;
      property Speciality: String read GetSpecialityFieldValue;
      property DepartmentCode: String read GetDepartmentCodeFieldValue;
      property DepartmentShortName: String read GetDepartmentShortNameFieldValue;
      property TelephoneNumber: String read GetTelephoneNumberFieldValue;
      property IsForeign: Boolean read GetIsForeignFieldValue;
      
  end;

  TEmployeesReferenceFormRecordClass = class of TEmployeesReferenceFormRecord;
  
  TEmployeesReferenceFormRecords = class;

  TEmployeesReferenceFormRecordsEnumerator =
    class (TDBDataTableRecordsEnumerator)

      protected

        function GetCurrentEmployeesReferenceFormRecord:
          TEmployeesReferenceFormRecord;

      public

        constructor Create(
          EmployeesReferenceFormRecords: TEmployeesReferenceFormRecords
        );

        property Current: TEmployeesReferenceFormRecord
        read GetCurrentEmployeesReferenceFormRecord;

    end;

  TEmployeesReferenceFormRecords = class (TDBDataTableRecords)

    protected

      FFieldDefs: TEmployeeSetFieldDefs;

    protected

      function GetEmployeesReferenceFormRecordByIndex(
        Index: Integer
      ): TEmployeesReferenceFormRecord;

    public

      constructor Create(FieldDefs: TEmployeeSetFieldDefs);

      function FetchEmployeeIdValues: TVariantList;

      function GetEnumerator: TEmployeesReferenceFormRecordsEnumerator;

      property Items[Index: Integer]: TEmployeesReferenceFormRecord
      read GetEmployeesReferenceFormRecordByIndex; default;

  end;

  TOnEmployeeRecordsRefreshRequestedEventHandler =
    procedure (
      Sender: TObject
    )of object;

  TEmployeesReferenceForm = class(TDocumentFlowBaseReferenceForm)

    IdColumn: TcxGridDBColumn;
    NameColumn: TcxGridDBColumn;
    SurnameColumn: TcxGridDBColumn;
    PatronymicColumn: TcxGridDBColumn;
    PersonnelNumberColumn: TcxGridDBColumn;
    DepartmentCodeColumn: TcxGridDBColumn;
    DepartmentShortNameColumn: TcxGridDBColumn;
    SpecialityColumn: TcxGridDBColumn;
    TelephoneNumberColumn: TcxGridDBColumn;
    IsForeignColumn: TcxGridDBColumn;
    
  private

    FOnEmployeeRecordsRefreshRequestedEventHandler:
      TOnEmployeeRecordsRefreshRequestedEventHandler;

    function GetChoosenEmployeeRecords: TEmployeesReferenceFormRecords;

  protected

    FDataSetHolder: TEmployeeSetHolder;

    procedure SetDataSetHolder(
      const Value: TEmployeeSetHolder
    );

    procedure SetTableColumnLayout(FieldDefs: TEmployeeSetFieldDefs);

    procedure Init(
      const Caption: String = ''; ADataSet:
      TDataSet = nil
    ); override;

    procedure OnRefreshRecords; override;
    
    procedure UpdateDataOperationControls; override;

  protected

    function CreateDBDataTableRecord: TDBDataTableRecord; override;
    function CreateDBDataTableRecords: TDBDataTableRecords; override;

    function GetTotalRecordCountPanelLabel: String; override;

  protected

    function GetSelectedEmployeesRecords: TEmployeesReferenceFormRecords;
    
  protected

  public

    property SelectedEmployeesRecords: TEmployeesReferenceFormRecords
    read GetSelectedEmployeesRecords;

    property ChoosenEmployeeRecords: TEmployeesReferenceFormRecords
    read GetChoosenEmployeeRecords;

    function CurrentSelectedEmployeesRecords: TEmployeesReferenceFormRecords;

    property DataSetHolder: TEmployeeSetHolder
    read FDataSetHolder write SetDataSetHolder;

    property OnEmployeeRecordsRefreshRequestedEventHandler:
      TOnEmployeeRecordsRefreshRequestedEventHandler

    read FOnEmployeeRecordsRefreshRequestedEventHandler
    write FOnEmployeeRecordsRefreshRequestedEventHandler;

  end;
  
implementation

uses

  AuxDebugFunctionsUnit;

{$R *.dfm}

{ TDocumentEmployeesDBTableForm }

function TEmployeesReferenceForm.CreateDBDataTableRecord: TDBDataTableRecord;
begin

  if Assigned(DataSetHolder) then
    Result := TEmployeesReferenceFormRecord.Create(DataSetHolder.FieldDefs)

  else Result := nil;

end;

function TEmployeesReferenceForm.CurrentSelectedEmployeesRecords: TEmployeesReferenceFormRecords;
begin

  Result := TEmployeesReferenceFormRecords(CurrentSelectedRecords);

end;

function TEmployeesReferenceForm.CreateDBDataTableRecords: TDBDataTableRecords;
begin

  if Assigned(DataSetHolder) then
    Result := TEmployeesReferenceFormRecords.Create(DataSetHolder.FieldDefs)

  else Result := nil;
  
end;

function TEmployeesReferenceForm.GetChoosenEmployeeRecords: TEmployeesReferenceFormRecords;
begin

  Result := TEmployeesReferenceFormRecords(CurrentChoosenRecords);
  
end;

function TEmployeesReferenceForm.GetSelectedEmployeesRecords: TEmployeesReferenceFormRecords;
begin

  Result := TEmployeesReferenceFormRecords(SelectedRecords);

end;

function TEmployeesReferenceForm.GetTotalRecordCountPanelLabel: String;
begin

  Result := 'Количество сотрудников: ';

end;

procedure TEmployeesReferenceForm.Init(const Caption: String;
  ADataSet: TDataSet);
begin

  inherited Init(Caption, ADataSet);

end;

procedure TEmployeesReferenceForm.OnRefreshRecords;
begin

  if not Assigned(FOnEmployeeRecordsRefreshRequestedEventHandler) then
    inherited OnRefreshRecords

  else begin

    FOnEmployeeRecordsRefreshRequestedEventHandler(Self);

    UpdateMainUI;

  end;

end;

procedure TEmployeesReferenceForm.SetDataSetHolder(
  const Value: TEmployeeSetHolder
);
begin

  if FDataSetHolder = Value then Exit;

  FreeAndNil(FDataSetHolder);

  FDataSetHolder := Value;

  SetTableColumnLayout(Value.FieldDefs);
  
  DataSet := FDataSetHolder.DataSet;
  
end;

procedure TEmployeesReferenceForm.SetTableColumnLayout(
  FieldDefs: TEmployeeSetFieldDefs);
begin

  with FieldDefs do begin

    IdColumn.DataBinding.FieldName := RecordIdFieldName;
    IsForeignColumn.DataBinding.FieldName := IsForeignFieldName;
    PersonnelNumberColumn.DataBinding.FieldName := PersonnelNumberFieldName;
    SurnameColumn.DataBinding.FieldName := SurnameFieldName;
    NameColumn.DataBinding.FieldName := NameFieldName;
    PatronymicColumn.DataBinding.FieldName := PatronymicFieldName;
    SpecialityColumn.DataBinding.FieldName := SpecialityFieldName;
    DepartmentCodeColumn.DataBinding.FieldName := DepartmentCodeFieldName;
    DepartmentShortNameColumn.DataBinding.FieldName := DepartmentShortNameFieldName;
    TelephoneNumberColumn.DataBinding.FieldName := TelephoneNumberFieldName;

    DataRecordGridTableView.DataController.KeyFieldNames := RecordIdFieldName;

  end;

end;

procedure TEmployeesReferenceForm.UpdateDataOperationControls;
begin

  inherited;

  actRefreshData.Visible := True;

  if Assigned(DataSetHolder) then
    SetFocusedColumnByFieldName(DataSetHolder.SurnameFieldName);

end;

{ TEmployeesReferenceFormRecord }

constructor TEmployeesReferenceFormRecord.Create(
  FieldDefs: TEmployeeSetFieldDefs);
begin

  inherited Create;

  FFieldDefs := FieldDefs;

end;

function TEmployeesReferenceFormRecord.GetDepartmentCodeFieldValue: String;
begin

  Result := Self[FFieldDefs.DepartmentCodeFieldName];

end;

function TEmployeesReferenceFormRecord.GetDepartmentShortNameFieldValue: String;
begin

  Result := Self[FFieldDefs.DepartmentShortNameFieldName];

end;

function TEmployeesReferenceFormRecord.GetIdFieldValue: Variant;
begin

  Result := Self[FFieldDefs.RecordIdFieldName];
  
end;

function TEmployeesReferenceFormRecord.GetIsForeignFieldValue: Boolean;
begin

  Result := Self[FFieldDefs.IsForeignFieldName];
  
end;

function TEmployeesReferenceFormRecord.GetNameFieldValue: String;
begin

  Result := Self[FFieldDefs.NameFieldName];
  
end;

function TEmployeesReferenceFormRecord.GetPatronymicFieldValue: String;
begin

  Result := Self[FFieldDefs.PatronymicFieldName];
  
end;

function TEmployeesReferenceFormRecord.GetPersonnelNumberFieldValue: String;
begin

  Result := Self[FFieldDefs.PersonnelNumberFieldName];
  
end;

function TEmployeesReferenceFormRecord.GetSpecialityFieldValue: String;
begin

  Result := Self[FFieldDefs.SpecialityFieldName];
  
end;

function TEmployeesReferenceFormRecord.GetSurnameFieldValue: String;
begin

  Result := Self[FFieldDefs.SurnameFieldName];

end;

function TEmployeesReferenceFormRecord.GetTelephoneNumberFieldValue: String;
begin

  Result := Self[FFieldDefs.TelephoneNumberFieldName];
  
end;

{ TEmployeesReferenceFormRecordsEnumerator }

constructor TEmployeesReferenceFormRecordsEnumerator.Create(
  EmployeesReferenceFormRecords: TEmployeesReferenceFormRecords);
begin

  inherited Create(EmployeesReferenceFormRecords);
  
end;

function TEmployeesReferenceFormRecordsEnumerator.
  GetCurrentEmployeesReferenceFormRecord: TEmployeesReferenceFormRecord;
begin

  Result := GetCurrentDBDataTableRecord as TEmployeesReferenceFormRecord;
  
end;

{ TEmployeesReferenceFormRecords }

constructor TEmployeesReferenceFormRecords.Create(
  FieldDefs: TEmployeeSetFieldDefs);
begin

  inherited Create;

  FFieldDefs := FieldDefs;

end;

function TEmployeesReferenceFormRecords.FetchEmployeeIdValues: TVariantList;
begin

  Result := FetchFieldValues(FFieldDefs.RecordIdFieldName);
  
end;

function TEmployeesReferenceFormRecords.
  GetEmployeesReferenceFormRecordByIndex(
    Index: Integer
  ): TEmployeesReferenceFormRecord;
begin

  Result := TEmployeesReferenceFormRecord(GetDBDataTableRecordByIndex(Index));

end;

function TEmployeesReferenceFormRecords.GetEnumerator: TEmployeesReferenceFormRecordsEnumerator;
begin

  Result := TEmployeesReferenceFormRecordsEnumerator.Create(Self);
  
end;

end.
