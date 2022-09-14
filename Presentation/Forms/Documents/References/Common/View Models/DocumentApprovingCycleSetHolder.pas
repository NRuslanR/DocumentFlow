unit DocumentApprovingCycleSetHolder;

interface

uses

  AbstractDataSetHolder,
  Disposable,
  DB,
  SysUtils,
  Classes,
  Variants;

type

  TDocumentApprovingSetFieldDefs = class (TAbstractDataSetFieldDefs)

    protected

      function GetIdFieldName: String;
      procedure SetIdFieldName(const Value: String);
      
    public

      TopLevelApprovingIdFieldName: String;
      PerformerIdFieldName: String;
      PerformerNameFieldName: String;
      PerformerDepartmentNameFieldName: String;
      PerformerSpecialityFieldName: String;
      ActuallyPerformedEmployeeIdFieldName: String;
      ActuallyPerformedEmployeeNameFieldName: String;
      PerformingResultIdFieldName: String;
      PerformingResultFieldName: String;
      PerformingDateTimeFieldName: String;
      NoteFieldName: String;
      IsViewedByPerformerFieldName: String;
      IsNewFieldName: String;
      IsApprovingAccessibleFieldName: String;

      ApprovingCycleIdFieldName: String;

      property IdFieldName: String
      read GetIdFieldName write SetIdFieldName;
      
  end;
  
  TDocumentApprovingSetHolder = class (TAbstractDataSetHolder)

    protected

      class function GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass; override;

    private

      FPerformingResultIsApprovedValue: Variant;
      FPerformingResultIsNotApprovedValue: Variant;
      FPerformingResultIsNotPerformedValue: Variant;
      
      function GetIsApprovedFieldValue: Boolean;
      function GetIsNotApprovedFieldValue: Boolean;
      function GetIsNotPerformedFieldValue: Boolean;
      
    protected

      function GetIdFieldName: String;
      function GetTopLevelApprovingIdFieldName: String;
      function GetIsViewedByPerformerFieldName: String;
      function GetNoteFieldName: String;
      function GetPerformerIdFieldName: String;
      function GetPerformerNameFieldName: String;
      function GetPerformingDateTimeFieldName: String;
      function GetPerformingResultFieldName: String;
      function GetPerformingResultIdFieldName: String;
      function GetApprovingCycleIdFieldName: String;
      function GetIsNewFieldName: String;
      function GetPerformerDepartmentNameFieldName: String;
      function GetPerformerSpecialityFieldName: String;
      function GetActuallyPerformedEmployeeIdFieldName: String;
      function GetActuallyPerformedEmployeeNameFieldName: String;

      procedure SetIdFieldName(const Value: String);
      procedure SetTopLevelApprovingIdFieldName(const Value: String);
      procedure SetIsViewedByPerformerFieldName(const Value: String);
      procedure SetNoteFieldName(const Value: String);
      procedure SetPerformerIdFieldName(const Value: String);
      procedure SetPerformerNameFieldName(const Value: String);
      procedure SetPerformingDateTimeFieldName(const Value: String);
      procedure SetPerformingResultFieldName(const Value: String);
      procedure SetPerformingResultIdFieldName(const Value: String);
      procedure SetIsNewFieldName(const Value: String);
      procedure SetPerformerDepartmentNameFieldName(const Value: String);
      procedure SetPerformerSpecialityFieldName(const Value: String);
      procedure SetActuallyPerformedEmployeeIdFieldName(const Value: String);
      procedure SetActuallyPerformedEmployeeNameFieldName(const Value: String);

      function GetIsApprovingAccessibleFieldName: String;
      function GetIsApprovingAccessibleFieldValue: Boolean;
      
      procedure SetIsApprovingAccessibleFieldName(const Value: String);
      procedure SetCanBePerformedFielValue(const Value: Boolean);

    protected

      function GetApprovingCycleIdFieldValue: Variant;
      function GetIdFieldValue: Variant;
      function GetTopLevelApprovingIdFieldValue: Variant;
      function GetIsViewedByPerformerFieldValue: Boolean;
      function GetNoteFieldValue: String;
      function GetPerformerIdFieldValue: Variant;
      function GetPerformerNameFieldValue: String;
      function GetPerformingDateTimeFieldValue: Variant;
      function GetPerformingResultFieldValue: String;
      function GetPerformingResultIdFieldValue: Variant;
      function GetIsNewFieldValue: Boolean;
      function GetPerformerDepartmentNameFieldValue: String;
      function GetPerformerSpecialityFieldValue: String;
      function GetActuallyPerformedEmployeeIdFieldValue: Variant;
      function GetActuallyPerformedEmployeeNameFieldValue: String;

      procedure SetApprovingCycleIdFieldName(const Value: String);
      procedure SetApprovingCycleIdFieldValue(const Value: Variant);
      procedure SetDocumentApprovingSet(const Value: TDataSet);
      procedure SetIdFieldValue(const Value: Variant);
      procedure SetTopLevelApprovingIdFieldValue(const Value: Variant);
      procedure SetIsViewedByPerformerFieldValue(const Value: Boolean);
      procedure SetNoteFieldValue(const Value: String);
      procedure SetPerformerIdFieldValue(const Value: Variant);
      procedure SetPerformerNameFieldValue(const Value: String);
      procedure SetPerformingDateTimeFieldValue(const Value: Variant);
      procedure SetPerformingResultFieldValue(const Value: String);
      procedure SetPerformingResultIdFieldValue(const Value: Variant);
      procedure SetIsNewFieldValue(const Value: Boolean);
      procedure SetPerformerDepartmentNameFieldValue(const Value: String);
      procedure SetPerformerSpecialityFieldValue(const Value: String);
      procedure SetActuallyPerformedEmployeeIdFieldValue(const Value: Variant);
      procedure SetActuallyPerformedEmployeeNameFieldValue(const Value: String);

      
    protected

      function GetApprovingsDataSet: TDataSet;

      function GetDataSetFieldDefs: TDocumentApprovingSetFieldDefs;

      procedure SetDataSetFieldDefs(
        const Value: TDocumentApprovingSetFieldDefs
      );

    public

      destructor Destroy; override;
      constructor Create;
      constructor CreateFrom(
        DocumentApprovingSet: TDataSet;
        DocumentApprovingSetFieldDefs: TDocumentApprovingSetFieldDefs
      );

      procedure FilterByCycleId(
        const CycleId: Variant;
        const FilterApplyingMode: TDataSetHolderFilterApplyingMode = famNotDisableControls
      );

      procedure FilterByNewApprovings(
        const IsNewApprovings: Boolean;
        const FilterApplyingMode: TDataSetHolderFilterApplyingMode = famNotDisableControls
      );

      function LocateByApproverId(
        const ApproverId: Variant
      ): Boolean;

    public

      procedure AppendAsActive;
      procedure AppendAsNonActive;

      function GetIsCurrentRecordIdGenerated: Boolean; override;
      
    published

      property DocumentApprovingSet: TDataSet
      read GetApprovingsDataSet write SetDocumentApprovingSet;
      
    published

      property IdFieldName: String
      read GetIdFieldName write SetIdFieldName;

      property TopLevelApprovingIdFieldName: String
      read GetTopLevelApprovingIdFieldName
      write SetTopLevelApprovingIdFieldName;

      property PerformerIdFieldName: String
      read GetPerformerIdFieldName write SetPerformerIdFieldName;

      property PerformerNameFieldName: String
      read GetPerformerNameFieldName write SetPerformerNameFieldName;
      
      property PerformingResultIdFieldName: String
      read GetPerformingResultIdFieldName
      write SetPerformingResultIdFieldName;
      
      property PerformingResultFieldName: String
      read GetPerformingResultFieldName
      write SetPerformingResultFieldName;
      
      property PerformingDateTimeFieldName: String
      read GetPerformingDateTimeFieldName write SetPerformingDateTimeFieldName;
      
      property NoteFieldName: String
      read GetNoteFieldName write SetNoteFieldName;
      
      property IsViewedByPerformerFieldName: String
      read GetIsViewedByPerformerFieldName
      write SetIsViewedByPerformerFieldName;

      property ApprovingCycleIdFieldName: String
      read GetApprovingCycleIdFieldName write SetApprovingCycleIdFieldName;

      property IsNewFieldName: String
      read GetIsNewFieldName write SetIsNewFieldName;

      property IsApprovingAccessibleFieldName: String
      read GetIsApprovingAccessibleFieldName
      write SetIsApprovingAccessibleFieldName;
      
    published

      property IdFieldValue: Variant
      read GetIdFieldValue write SetIdFieldValue;

      property TopLevelApprovingIdFieldValue: Variant
      read GetTopLevelApprovingIdFieldValue
      write SetTopLevelApprovingIdFieldValue;
      
      property PerformerIdFieldValue: Variant
      read GetPerformerIdFieldValue write SetPerformerIdFieldValue;

      property PerformerNameFieldValue: String
      read GetPerformerNameFieldValue write SetPerformerNameFieldValue;
      
      property PerformingResultIdFieldValue: Variant
      read GetPerformingResultIdFieldValue
      write SetPerformingResultIdFieldValue;
      
      property PerformingResultFieldValue: String
      read GetPerformingResultFieldValue
      write SetPerformingResultFieldValue;
      
      property PerformingDateTimeFieldValue: Variant
      read GetPerformingDateTimeFieldValue write SetPerformingDateTimeFieldValue;
      
      property NoteFieldValue: String
      read GetNoteFieldValue write SetNoteFieldValue;
      
      property IsViewedByPerformerFieldValue: Boolean
      read GetIsViewedByPerformerFieldValue
      write SetIsViewedByPerformerFieldValue;

      property ApprovingCycleIdFieldValue: Variant
      read GetApprovingCycleIdFieldValue write SetApprovingCycleIdFieldValue;

      property IsNewFieldValue: Boolean
      read GetIsNewFieldValue write SetIsNewFieldValue;

      property IsApprovingAccessibleFieldValue: Boolean
      read GetIsApprovingAccessibleFieldValue
      write SetCanBePerformedFielValue;
      
      property PerformerDepartmentNameFieldValue: String
      read GetPerformerDepartmentNameFieldValue
      write SetPerformerDepartmentNameFieldValue;
      
      property PerformerSpecialityFieldValue: String
      read GetPerformerSpecialityFieldValue
      write SetPerformerSpecialityFieldValue;
      
      property ActuallyPerformedEmployeeIdFieldValue: Variant
      read GetActuallyPerformedEmployeeIdFieldValue
      write SetActuallyPerformedEmployeeIdFieldValue;

      property ActuallyPerformedEmployeeNameFieldValue: String
      read GetActuallyPerformedEmployeeNameFieldValue
      write SetActuallyPerformedEmployeeNameFieldValue;

      property IsApprovedFieldValue: Boolean
      read GetIsApprovedFieldValue;

      property IsNotApprovedFieldValue: Boolean
      read GetIsNotApprovedFieldValue;

      property IsNotPerformedFieldValue: Boolean
      read GetIsNotPerformedFieldValue;

    published

      property PerformingResultIsApprovedValue: Variant
      read FPerformingResultIsApprovedValue
      write FPerformingResultIsApprovedValue;

      property PerformingResultIsNotApprovedValue: Variant
      read FPerformingResultIsNotApprovedValue
      write FPerformingResultIsNotApprovedValue;
      
      property PerformingResultIsNotPerformedValue: Variant
      read FPerformingResultIsNotPerformedValue
      write FPerformingResultIsNotPerformedValue;

    published
      
      property FieldDefs: TDocumentApprovingSetFieldDefs
      read GetDataSetFieldDefs write SetDataSetFieldDefs;
      
  end;

  TDocumentApprovingCycleSetFieldDefs = class (TAbstractDataSetFieldDefs)

    protected

      function GetIdFieldName: String;
      procedure SetIdFieldName(const Value: String);
      
    public

      CycleNumberFieldName: String;
      CycleNameFieldName: String;
      IsCycleNewFieldName: String;
      CanBeCompletedFieldName: String;

      property IdFieldName: String
      read GetIdFieldName write SetIdFieldName;
      
  end;

  TDocumentApprovingCycleSetHolder = class (TAbstractDataSetHolder)

    protected

      class function GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass; override;
      
    private

    protected

      FDocumentApprovingSetHolder: TDocumentApprovingSetHolder;
      FFreeDocumentApprovingSetHolder: IDisposable;

    protected

      function GetIdFieldName: String;
      function GetCycleNumberFieldName: String;
      function GetCycleNameFieldName: String;
      function GetIsCycleNewFieldName: String;
      function GetCanBeCompletedFieldName: String;

      procedure SetIdFieldName(const Value: String);
      procedure SetCycleNumberFieldName(const Value: String);
      procedure SetCycleNameFieldName(const Value: String);
      procedure SetIsCycleNewFieldName(const Value: String);
      procedure SetCanBeCompletedFieldName(const Value: String);
      
    protected

      function GetIdFieldValue: Variant;
      function GetCycleNumberFieldValue: Integer;
      function GetCycleNameFieldValue: String;
      function GetIsCycleNewFieldValue: Boolean;
      function GetCanBeCompletedFieldValue: Variant;

      procedure SetIdFieldValue(const Value: Variant);
      procedure SetCycleNumberFieldValue(const Value: Integer);
      procedure SetCycleNameFieldValue(const Value: String);
      procedure SetIsCycleNewFieldValue(const Value: Boolean);
      procedure SetCanBeCompletedFieldValue(const Value: Variant);
      
    protected

      function GetDocumentApprovingCycleSet: TDataSet;

      procedure SetDocumentApprovingCycleSet(const Value: TDataSet);
      
      procedure SetDocumentApprovingSetHolder(
        const Value: TDocumentApprovingSetHolder
      );

      function GetDocumentApprovingCycleSetFieldDefs: TDocumentApprovingCycleSetFieldDefs;

      procedure SetDataSetFieldDefs (
        Value: TDocumentApprovingCycleSetFieldDefs
      );
      
    public

      destructor Destroy; override;
      constructor Create;
      constructor CreateFrom(
        DocumentApprovingCycleSet: TDataSet;

        DocumentApprovingCycleSetFieldDefs:
          TDocumentApprovingCycleSetFieldDefs;

        DocumentApprovingSetHolder: TDocumentApprovingSetHolder
      );

      function LocateNewApprovingCycleRecord: Boolean;
      
    published

      property IdFieldName: String
      read GetIdFieldName write SetIdFieldName;
      
      property CycleNumberFieldName: String
      read GetCycleNumberFieldName write SetCycleNumberFieldName;

      property CycleNameFieldName: String
      read GetCycleNameFieldName write SetCycleNameFieldName;

      property IsCycleNewFieldName: String
      read GetIsCycleNewFieldName write SetIsCycleNewFieldName;

      property CanBeCompletedFieldName: String
      read GetCanBeCompletedFieldName write SetCanBeCompletedFieldName;
      
    published

      property IdFieldValue: Variant
      read GetIdFieldValue write SetIdFieldValue;
      
      property CycleNumberFieldValue: Integer
      read GetCycleNumberFieldValue write SetCycleNumberFieldValue;

      property CycleNameFieldValue: String
      read GetCycleNameFieldValue write SetCycleNameFieldValue;

      property IsCycleNewFieldValue: Boolean
      read GetIsCycleNewFieldValue write SetIsCycleNewFieldValue;

      property CanBeCompletedFieldValue: Variant
      read GetCanBeCompletedFieldValue
      write SetCanBeCompletedFieldValue;
      
    published

      property DocumentApprovingSetHolder: TDocumentApprovingSetHolder
      read FDocumentApprovingSetHolder
      write SetDocumentApprovingSetHolder;

      property DocumentApprovingCycleSet: TDataSet
      read GetDocumentApprovingCycleSet
      write SetDocumentApprovingCycleSet;

      property FieldDefs: TDocumentApprovingCycleSetFieldDefs
      read GetDocumentApprovingCycleSetFieldDefs
      write SetDataSetFieldDefs;

  end;

implementation

{ TDocumentApprovingSetHolder }

procedure TDocumentApprovingSetHolder.AppendAsActive;
begin

  Append;

  IsNewFieldValue := True;
  
end;

procedure TDocumentApprovingSetHolder.AppendAsNonActive;
begin

  Append;

  IsNewFieldValue := False;
  
end;

constructor TDocumentApprovingSetHolder.Create;
begin

  inherited;

end;

constructor TDocumentApprovingSetHolder.CreateFrom(
  DocumentApprovingSet: TDataSet;
  DocumentApprovingSetFieldDefs: TDocumentApprovingSetFieldDefs);
begin

  inherited CreateFrom(DocumentApprovingSet);

  FieldDefs := DocumentApprovingSetFieldDefs;
  
end;

destructor TDocumentApprovingSetHolder.Destroy;
begin
      
  if Assigned(DataSet) then
    DataSet.DisableControls;

  inherited;

end;

function TDocumentApprovingSetHolder.LocateByApproverId(
  const ApproverId: Variant
): Boolean;
begin

  Result :=
    DocumentApprovingSet.Locate(
      PerformerIdFieldName,
      ApproverId,
      []
    );
  
end;

procedure TDocumentApprovingSetHolder.FilterByCycleId(
  const CycleId: Variant;
  const FilterApplyingMode: TDataSetHolderFilterApplyingMode
);
begin

  ApplyFilter(
    Format(
      '%s=%s',
      [ApprovingCycleIdFieldName, VarToStr(CycleId)]
    )
  );

end;

procedure TDocumentApprovingSetHolder.FilterByNewApprovings(
  const IsNewApprovings: Boolean;
  const FilterApplyingMode: TDataSetHolderFilterApplyingMode
);
begin

  ApplyFilter(
    Format(
      '%s=%s',
      [
        IsNewFieldName,
        BoolToStr(IsNewApprovings, True)
      ]
    ),
    FilterApplyingMode
  );
  
end;

function TDocumentApprovingSetHolder.GetActuallyPerformedEmployeeIdFieldName: String;
begin

  Result := FieldDefs.ActuallyPerformedEmployeeIdFieldName;
  
end;

function TDocumentApprovingSetHolder.GetActuallyPerformedEmployeeIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(
              GetActuallyPerformedEmployeeIdFieldName,
              Null
            );
            
end;

function TDocumentApprovingSetHolder.GetActuallyPerformedEmployeeNameFieldName: String;
begin

  Result := FieldDefs.ActuallyPerformedEmployeeNameFieldName;

end;

function TDocumentApprovingSetHolder.GetActuallyPerformedEmployeeNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(
              GetActuallyPerformedEmployeeNameFieldName,
              ''
            );
            
end;

function TDocumentApprovingSetHolder.GetApprovingCycleIdFieldName: String;
begin

  Result := FieldDefs.ApprovingCycleIdFieldName;
  
end;

function TDocumentApprovingSetHolder.GetApprovingCycleIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(ApprovingCycleIdFieldName, Null);
  
end;

function TDocumentApprovingSetHolder.GetApprovingsDataSet: TDataSet;
begin

  Result := DataSet;

end;

function TDocumentApprovingSetHolder.GetIsApprovedFieldValue: Boolean;
begin

  Result :=
    PerformingResultFieldValue = FPerformingResultIsApprovedValue;
    
end;

function TDocumentApprovingSetHolder.GetIsApprovingAccessibleFieldName: String;
begin

  Result := FieldDefs.IsApprovingAccessibleFieldName;
  
end;

function TDocumentApprovingSetHolder.GetIsApprovingAccessibleFieldValue: Boolean;
begin

  Result := GetDataSetFieldValue(IsApprovingAccessibleFieldName, False);
  
end;

function TDocumentApprovingSetHolder.GetDataSetFieldDefs: TDocumentApprovingSetFieldDefs;
begin

  Result := TDocumentApprovingSetFieldDefs(FFieldDefs);
  
end;

class function TDocumentApprovingSetHolder.GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass;
begin

  Result := TDocumentApprovingSetFieldDefs;
  
end;

function TDocumentApprovingSetHolder.GetIdFieldName: String;
begin

  Result := FieldDefs.IdFieldName;
  
end;

function TDocumentApprovingSetHolder.GetIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(IdFieldName, Null);
  
end;

function TDocumentApprovingSetHolder.GetIsNewFieldName: String;
begin

  Result := FieldDefs.IsNewFieldName;
  
end;

function TDocumentApprovingSetHolder.GetIsNewFieldValue: Boolean;
begin

  Result := GetDataSetFieldValue(
              FieldDefs.IsNewFieldName,
              False
            );
            
end;

function TDocumentApprovingSetHolder.GetIsNotApprovedFieldValue: Boolean;
begin

  Result :=
    PerformingResultFieldValue = FPerformingResultIsNotApprovedValue;
    
end;

function TDocumentApprovingSetHolder.GetIsNotPerformedFieldValue: Boolean;
begin

  Result :=
    PerformingResultFieldValue = FPerformingResultIsNotPerformedValue;

end;

function TDocumentApprovingSetHolder.GetIsCurrentRecordIdGenerated: Boolean;
begin

  Result := inherited GetIsCurrentRecordIdGenerated;
  
end;

function TDocumentApprovingSetHolder.GetIsViewedByPerformerFieldName: String;
begin

  Result := FieldDefs.IsViewedByPerformerFieldName;
  
end;

function TDocumentApprovingSetHolder.GetIsViewedByPerformerFieldValue: Boolean;
begin

  Result := GetDataSetFieldValue(IsViewedByPerformerFieldName, False);
  
end;

function TDocumentApprovingSetHolder.GetNoteFieldName: String;
begin

  Result := FieldDefs.NoteFieldName;
  
end;

function TDocumentApprovingSetHolder.GetNoteFieldValue: String;
begin

  Result := GetDataSetFieldValue(NoteFieldName, '');
  
end;

function TDocumentApprovingSetHolder.GetPerformerDepartmentNameFieldName: String;
begin

  Result := FieldDefs.PerformerDepartmentNameFieldName;
  
end;

function TDocumentApprovingSetHolder.GetPerformerDepartmentNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(
              GetPerformerDepartmentNameFieldName,
              ''
            );
            
end;

function TDocumentApprovingSetHolder.GetPerformerIdFieldName: String;
begin

  Result := FieldDefs.PerformerIdFieldName;

end;

function TDocumentApprovingSetHolder.GetPerformerIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(PerformerIdFieldName, Null);
  
end;

function TDocumentApprovingSetHolder.GetPerformerNameFieldName: String;
begin

  Result := FieldDefs.PerformerNameFieldName;
  
end;

function TDocumentApprovingSetHolder.GetPerformerNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(PerformerNameFieldName, '');
  
end;

function TDocumentApprovingSetHolder.GetPerformerSpecialityFieldName: String;
begin

  Result := FieldDefs.PerformerSpecialityFieldName;
  
end;

function TDocumentApprovingSetHolder.GetPerformerSpecialityFieldValue: String;
begin

  Result :=
    GetDataSetFieldValue(
      GetPerformerSpecialityFieldName,
      ''
    );
    
end;

function TDocumentApprovingSetHolder.GetPerformingDateTimeFieldName: String;
begin

  Result := FieldDefs.PerformingDateTimeFieldName;
  
end;

function TDocumentApprovingSetHolder.GetPerformingDateTimeFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(PerformingDateTimeFieldName, Null);
  
end;

function TDocumentApprovingSetHolder.GetPerformingResultFieldName: String;
begin

  Result := FieldDefs.PerformingResultFieldName;
  
end;

function TDocumentApprovingSetHolder.GetPerformingResultFieldValue: String;
begin

  Result := GetDataSetFieldValue(PerformingResultFieldName, '');
  
end;

function TDocumentApprovingSetHolder.GetPerformingResultIdFieldName: String;
begin

  Result := FieldDefs.PerformingResultIdFieldName;
  
end;

function TDocumentApprovingSetHolder.GetPerformingResultIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(PerformingResultIdFieldName, Null);
  
end;

function TDocumentApprovingSetHolder.GetTopLevelApprovingIdFieldName: String;
begin

  Result := FieldDefs.TopLevelApprovingIdFieldName;
  
end;

function TDocumentApprovingSetHolder.GetTopLevelApprovingIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(TopLevelApprovingIdFieldName, Null);
  
end;

procedure TDocumentApprovingSetHolder.SetActuallyPerformedEmployeeIdFieldName(
  const Value: String);
begin

  FieldDefs.ActuallyPerformedEmployeeIdFieldName := Value;

end;

procedure TDocumentApprovingSetHolder.SetActuallyPerformedEmployeeIdFieldValue(
  const Value: Variant);
begin

  SetDataSetFieldValue(GetActuallyPerformedEmployeeIdFieldName, Value);

end;

procedure TDocumentApprovingSetHolder.SetActuallyPerformedEmployeeNameFieldName(
  const Value: String);
begin

  FieldDefs.ActuallyPerformedEmployeeNameFieldName := Value;
  
end;

procedure TDocumentApprovingSetHolder.SetActuallyPerformedEmployeeNameFieldValue(
  const Value: String);
begin

  SetDataSetFieldValue(GetActuallyPerformedEmployeeNameFieldName, Value);
  
end;

procedure TDocumentApprovingSetHolder.SetApprovingCycleIdFieldName(
  const Value: String);
begin

  FieldDefs.ApprovingCycleIdFieldName := Value;
  
end;

procedure TDocumentApprovingSetHolder.SetApprovingCycleIdFieldValue(
  const Value: Variant);
begin

  SetDataSetFieldValue(ApprovingCycleIdFieldName, Value);

end;

procedure TDocumentApprovingSetHolder.SetIsApprovingAccessibleFieldName(
  const Value: String);
begin

  FieldDefs.IsApprovingAccessibleFieldName := Value;
  
end;

procedure TDocumentApprovingSetHolder.SetCanBePerformedFielValue(
  const Value: Boolean);
begin

  SetDataSetFieldValue(IsApprovingAccessibleFieldName, Value);
  
end;

procedure TDocumentApprovingSetHolder.SetDataSetFieldDefs(
  const Value: TDocumentApprovingSetFieldDefs);
begin

  SetFieldDefs(Value);

end;

procedure TDocumentApprovingSetHolder.SetDocumentApprovingSet(
  const Value: TDataSet);
begin

  DataSet := Value;

end;

procedure TDocumentApprovingSetHolder.SetIdFieldName(const Value: String);
begin

  FieldDefs.IdFieldName := Value;
  
end;

procedure TDocumentApprovingSetHolder.SetIdFieldValue(
  const Value: Variant);
begin

  SetDataSetFieldValue(IdFieldName, Value);

end;

procedure TDocumentApprovingSetHolder.SetIsNewFieldName(
  const Value: String);
begin

  FieldDefs.IsNewFieldName := Value;
  
end;

procedure TDocumentApprovingSetHolder.SetIsNewFieldValue(
  const Value: Boolean
);
begin

  SetDataSetFieldValue(IsNewFieldName, Value);

end;

procedure TDocumentApprovingSetHolder.SetIsViewedByPerformerFieldName(
  const Value: String);
begin

  FieldDefs.IsViewedByPerformerFieldName := Value;
  
end;

procedure TDocumentApprovingSetHolder.SetIsViewedByPerformerFieldValue(
  const Value: Boolean);
begin

  SetDataSetFieldValue(IsViewedByPerformerFieldName, Value);
  
end;

procedure TDocumentApprovingSetHolder.SetNoteFieldName(
  const Value: String);
begin

  FieldDefs.NoteFieldName := Value;

end;

procedure TDocumentApprovingSetHolder.SetNoteFieldValue(
  const Value: String);
begin

  SetDataSetFieldValue(NoteFieldName, Value);

end;

procedure TDocumentApprovingSetHolder.SetPerformerDepartmentNameFieldName(
  const Value: String);
begin

  FieldDefs.PerformerDepartmentNameFieldName := Value;
  
end;

procedure TDocumentApprovingSetHolder.SetPerformerDepartmentNameFieldValue(
  const Value: String);
begin

  SetDataSetFieldValue(GetPerformerDepartmentNameFieldName, Value);
  
end;

procedure TDocumentApprovingSetHolder.SetPerformerIdFieldName(
  const Value: String);
begin

  FieldDefs.PerformerIdFieldName := Value;
  
end;

procedure TDocumentApprovingSetHolder.SetPerformerIdFieldValue(
  const Value: Variant);
begin

  SetDataSetFieldValue(PerformerIdFieldName, Value);
  
end;

procedure TDocumentApprovingSetHolder.SetPerformerNameFieldName(
  const Value: String);
begin

  FieldDefs.PerformerNameFieldName := Value;
  
end;

procedure TDocumentApprovingSetHolder.SetPerformerNameFieldValue(
  const Value: String);
begin

  SetDataSetFieldValue(PerformerNameFieldName, Value);
  
end;

procedure TDocumentApprovingSetHolder.SetPerformerSpecialityFieldName(
  const Value: String);
begin

  FieldDefs.PerformerSpecialityFieldName := Value;

end;

procedure TDocumentApprovingSetHolder.SetPerformerSpecialityFieldValue(
  const Value: String);
begin

  SetDataSetFieldValue(GetPerformerSpecialityFieldName, Value);

end;

procedure TDocumentApprovingSetHolder.SetPerformingDateTimeFieldName(
  const Value: String);
begin

  FieldDefs.PerformingDateTimeFieldName := Value;
  
end;

procedure TDocumentApprovingSetHolder.SetPerformingDateTimeFieldValue(
  const Value: Variant);
begin

  SetDataSetFieldValue(PerformingDateTimeFieldName, Value);

end;

procedure TDocumentApprovingSetHolder.SetPerformingResultFieldName(
  const Value: String);
begin

  FieldDefs.PerformingResultFieldName := Value;
  
end;

procedure TDocumentApprovingSetHolder.SetPerformingResultFieldValue(
  const Value: String);
begin

  SetDataSetFieldValue(PerformingResultFieldName, Value);
  
end;

procedure TDocumentApprovingSetHolder.SetPerformingResultIdFieldName(
  const Value: String);
begin

  FieldDefs.PerformingResultIdFieldName := Value;

end;

procedure TDocumentApprovingSetHolder.SetPerformingResultIdFieldValue(
  const Value: Variant);
begin

  SetDataSetFieldValue(PerformingResultIdFieldName, Value);

end;

procedure TDocumentApprovingSetHolder.SetTopLevelApprovingIdFieldName(
  const Value: String);
begin

  FieldDefs.TopLevelApprovingIdFieldName := Value;
  
end;

procedure TDocumentApprovingSetHolder.SetTopLevelApprovingIdFieldValue(
  const Value: Variant);
begin

  SetDataSetFieldValue(TopLevelApprovingIdFieldName, Value);
  
end;

{ TDocumentApprovingCycleSetHolder }

constructor TDocumentApprovingCycleSetHolder.Create;
begin

  inherited;

  FieldDefs := TDocumentApprovingCycleSetFieldDefs.Create;

end;

constructor TDocumentApprovingCycleSetHolder.CreateFrom(
  DocumentApprovingCycleSet: TDataSet;
  DocumentApprovingCycleSetFieldDefs: TDocumentApprovingCycleSetFieldDefs;
  DocumentApprovingSetHolder: TDocumentApprovingSetHolder
);
begin

  inherited CreateFrom(DocumentApprovingCycleSet);

  FieldDefs := DocumentApprovingCycleSetFieldDefs;
  
  Self.DocumentApprovingSetHolder := DocumentApprovingSetHolder;
  
end;

destructor TDocumentApprovingCycleSetHolder.Destroy;
begin

  if Assigned(DataSet) then
    DataSet.DisableControls;

  inherited;

end;

function TDocumentApprovingCycleSetHolder.GetCanBeCompletedFieldName: String;
begin

  Result := FieldDefs.CanBeCompletedFieldName;
  
end;

function TDocumentApprovingCycleSetHolder.GetCanBeCompletedFieldValue: Variant;
begin

  Result :=
    GetDataSetFieldValue(
      FieldDefs.CanBeCompletedFieldName,
      False
    );
    
end;

function TDocumentApprovingCycleSetHolder.GetCycleNameFieldName: String;
begin

  Result := FieldDefs.CycleNameFieldName;
  
end;

function TDocumentApprovingCycleSetHolder.GetCycleNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(CycleNameFieldName, '');
  
end;

function TDocumentApprovingCycleSetHolder.GetCycleNumberFieldName: String;
begin

  Result := FieldDefs.CycleNumberFieldName;
  
end;

function TDocumentApprovingCycleSetHolder.GetCycleNumberFieldValue: Integer;
begin

  Result := GetDataSetFieldValue(CycleNumberFieldName, -1);
  
end;

class function TDocumentApprovingCycleSetHolder.GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass;
begin

  Result := TDocumentApprovingCycleSetFieldDefs;
  
end;

function TDocumentApprovingCycleSetHolder.GetDocumentApprovingCycleSet: TDataSet;
begin

  Result := DataSet;
  
end;

function TDocumentApprovingCycleSetHolder.GetDocumentApprovingCycleSetFieldDefs: TDocumentApprovingCycleSetFieldDefs;
begin

  Result := TDocumentApprovingCycleSetFieldDefs(FFieldDefs);
  
end;

function TDocumentApprovingCycleSetHolder.GetIdFieldName: String;
begin

  Result := FieldDefs.IdFieldName;
  
end;

function TDocumentApprovingCycleSetHolder.GetIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(IdFieldName, Null);
  
end;

function TDocumentApprovingCycleSetHolder.GetIsCycleNewFieldName: String;
begin

  Result := FieldDefs.IsCycleNewFieldName;
  
end;

function TDocumentApprovingCycleSetHolder.GetIsCycleNewFieldValue: Boolean;
begin

  Result :=
    GetDataSetFieldValue(
      FieldDefs.IsCycleNewFieldName,
      Null
    );

end;

function TDocumentApprovingCycleSetHolder.LocateNewApprovingCycleRecord: Boolean;
begin

  Result :=
    DocumentApprovingCycleSet.Locate(
      IsCycleNewFieldName,
      True,
      []
    );
    
end;

procedure TDocumentApprovingCycleSetHolder.SetCanBeCompletedFieldName(
  const Value: String);
begin

  FieldDefs.CanBeCompletedFieldName := Value;

end;

procedure TDocumentApprovingCycleSetHolder.SetCanBeCompletedFieldValue(
  const Value: Variant);
begin

  SetDataSetFieldValue(CanBeCompletedFieldName, Value);

end;

procedure TDocumentApprovingCycleSetHolder.SetCycleNameFieldName(
  const Value: String);
begin

  FieldDefs.CycleNameFieldName := Value;
  
end;

procedure TDocumentApprovingCycleSetHolder.SetCycleNameFieldValue(
  const Value: String);
begin

  SetDataSetFieldValue(CycleNameFieldName, Value);
  
end;

procedure TDocumentApprovingCycleSetHolder.SetCycleNumberFieldName(
  const Value: String);
begin

  FieldDefs.CycleNumberFieldName := Value;
  
end;

procedure TDocumentApprovingCycleSetHolder.SetCycleNumberFieldValue(
  const Value: Integer);
begin

  SetDataSetFieldValue(CycleNumberFieldName, Value);
  
end;

procedure TDocumentApprovingCycleSetHolder.SetDataSetFieldDefs(
  Value: TDocumentApprovingCycleSetFieldDefs);
begin

  SetFieldDefs(Value);

end;

procedure TDocumentApprovingCycleSetHolder.SetDocumentApprovingCycleSet(
  const Value: TDataSet);
begin

  DataSet := Value;
  
end;

procedure TDocumentApprovingCycleSetHolder.SetDocumentApprovingSetHolder(
  const Value: TDocumentApprovingSetHolder);
begin

  FDocumentApprovingSetHolder := Value;
  FFreeDocumentApprovingSetHolder := FDocumentApprovingSetHolder;
  
end;

procedure TDocumentApprovingCycleSetHolder.SetIdFieldName(
  const Value: String);
begin

  FieldDefs.IdFieldName := Value;
  
end;

procedure TDocumentApprovingCycleSetHolder.SetIdFieldValue(
  const Value: Variant);
begin

  SetDataSetFieldValue(IdFieldName, Value);
  
end;

procedure TDocumentApprovingCycleSetHolder.SetIsCycleNewFieldName(
  const Value: String);
begin

  FieldDefs.IsCycleNewFieldName := Value;
  
end;

procedure TDocumentApprovingCycleSetHolder.SetIsCycleNewFieldValue(
  const Value: Boolean);
begin

  SetDataSetFieldValue(GetIsCycleNewFieldName, Value);
  
end;

{ TDocumentApprovingSetFieldDefs }

function TDocumentApprovingSetFieldDefs.GetIdFieldName: String;
begin

  Result := RecordIdFieldName;

end;

procedure TDocumentApprovingSetFieldDefs.SetIdFieldName(
  const Value: String);
begin

  RecordIdFieldName := Value;
  
end;

{ TDocumentApprovingCycleSetFieldDefs }

function TDocumentApprovingCycleSetFieldDefs.GetIdFieldName: String;
begin

  Result := RecordIdFieldName;
  
end;

procedure TDocumentApprovingCycleSetFieldDefs.SetIdFieldName(
  const Value: String);
begin

  RecordIdFieldName := Value;
  
end;

end.
