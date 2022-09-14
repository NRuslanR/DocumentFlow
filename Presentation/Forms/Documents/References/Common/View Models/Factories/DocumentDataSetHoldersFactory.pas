unit DocumentDataSetHoldersFactory;

interface

uses

  DB,
  DataSetBuilder,
  UIDocumentKinds,
  DocumentFileSetHolder,
  DocumentChargeSetHolder,
  DocumentRelationSetHolder,
  DocumentApprovingCycleSetHolder,
  DocumentApprovingListSetHolder,
  IGetSelfUnit,
  DocumentApprovingListRecordSetHolder;

type

  IDocumentDataSetHoldersFactory = interface (IGetSelf)

    function CreateDocumentChargeSetHolder: TDocumentChargeSetHolder;
    function CreateDocumentFileSetHolder: TDocumentFileSetHolder;
    function CreateDocumentRelationSetHolder: TDocumentRelationSetHolder;
    function CreateDocumentApprovingCycleSetHolder: TDocumentApprovingCycleSetHolder;
    function CreateDocumentApprovingListSetHolder: TDocumentApprovingListSetHolder;

  end;
  
  TDocumentDataSetHoldersFactory = class abstract (TInterfacedObject, IDocumentDataSetHoldersFactory)

    protected

      FDataSetBuilder: IDataSetBuilder;

    protected

      function CreateDocumentChargeSetHolderInstance: TDocumentChargeSetHolder; virtual;
      function InternalCreateDocumentChargeSetHolderInstance: TDocumentChargeSetHolder; virtual;
      procedure FillDocumentChargeSetFieldDefs(FieldDefs: TDocumentChargeSetFieldDefs); virtual;
      function CreateDocumentChargeSet(FieldDefs: TDocumentChargeSetFieldDefs): TDataSet; virtual;

    protected

      function CreateDocumentFileSetHolderInstance: TDocumentFileSetHolder; virtual;
      function InternalCreateDocumentFileSetHolderInstance: TDocumentFileSetHolder; virtual;
      procedure FillDocumentFileSetFieldDefs(FieldDefs: TDocumentFileSetFieldDefs); virtual;
      function CreateDocumentFileSet(FieldDefs: TDocumentFileSetFieldDefs): TDataSet; virtual;

    protected

      function CreateDocumentRelationSetHolderInstance: TDocumentRelationSetHolder; virtual;
      function InternalCreateDocumentRelationSetHolderInstance: TDocumentRelationSetHolder; virtual;
      procedure FillDocumentRelationSetFieldDefs(FieldDefs: TDocumentRelationSetFieldDefs); virtual;
      function CreateDocumentRelationSet(FieldDefs: TDocumentRelationSetFieldDefs): TDataSet; virtual;

    protected

      function CreateDocumentApprovingSetHolder: TDocumentApprovingSetHolder;
      function CreateDocumentApprovingSetHolderInstance: TDocumentApprovingSetHolder; virtual;
      function InternalCreateDocumentApprovingSetHolderInstance: TDocumentApprovingSetHolder; virtual;
      procedure FillDocumentApprovingSetFieldDefs(FieldDefs: TDocumentApprovingSetFieldDefs); virtual;
      function CreateDocumentApprovingSet(FieldDefs: TDocumentApprovingSetFieldDefs): TDataSet; virtual;

    protected

      function CreateDocumentApprovingCycleSetHolderInstance: TDocumentApprovingCycleSetHolder; virtual;
      function InternalCreateDocumentApprovingCycleSetHolderInstance: TDocumentApprovingCycleSetHolder; virtual;
      procedure FillDocumentApprovingCycleSetFieldDefs(FieldDefs: TDocumentApprovingCycleSetFieldDefs); virtual;
      function CreateDocumentApprovingCycleSet(FieldDefs: TDocumentApprovingCycleSetFieldDefs): TDataSet; virtual;

    protected

      function CreateDocumentApprovingListSetHolderInstance: TDocumentApprovingListSetHolder; virtual;
      function InternalCreateDocumentApprovingListSetHolderInstance: TDocumentApprovingListSetHolder; virtual;
      procedure FillDocumentApprovingListSetFieldDefs(FieldDefs: TDocumentApprovingListSetFieldDefs); virtual;
      function CreateDocumentApprovingListSet(FieldDefs: TDocumentApprovingListSetFieldDefs): TDataSet; virtual;

      function CreateDocumentApprovingListRecordSetHolder: TDocumentApprovingListRecordSetHolder;
      function CreateDocumentApprovingListRecordSetHolderInstance: TDocumentApprovingListRecordSetHolder; virtual;
      function InternalCreateDocumentApprovingListRecordSetInstance: TDocumentApprovingListRecordSetHolder; virtual;
      procedure FillDocumentApprovingListRecordSetFieldDefs(FieldDefs: TDocumentApprovingListRecordSetFieldDefs); virtual;
      function CreateDocumentApprovingListRecordSet(FieldDefs: TDocumentApprovingListRecordSetFieldDefs): TDataSet; virtual;
      
    public

      constructor Create(DataSetBuilder: IDataSetBuilder); virtual;

      function CreateDocumentChargeSetHolder: TDocumentChargeSetHolder;
      function CreateDocumentFileSetHolder: TDocumentFileSetHolder;
      function CreateDocumentRelationSetHolder: TDocumentRelationSetHolder;
      function CreateDocumentApprovingCycleSetHolder: TDocumentApprovingCycleSetHolder;
      function CreateDocumentApprovingListSetHolder: TDocumentApprovingListSetHolder;

      function GetSelf: TObject;
      
  end;

implementation

uses

  AuxDataSetFunctionsUnit,
  AbstractDataSetHolder;
  
{ TDocumentDataSetHoldersFactory }

constructor TDocumentDataSetHoldersFactory.Create(DataSetBuilder: IDataSetBuilder);
begin

  inherited Create;

  FDataSetBuilder := DataSetBuilder;
  
end;

function TDocumentDataSetHoldersFactory.
  CreateDocumentChargeSetHolder: TDocumentChargeSetHolder;
begin

  Result := CreateDocumentChargeSetHolderInstance;

  Result.DataSet := CreateDocumentChargeSet(Result.FieldDefs);

  Result.ChargeRecordAddedStatusValue := 1;
  Result.ChargeRecordChangedStatusValue := 2;
  Result.ChargeRecordRemovedStatusValue := 3;
  Result.ChargeRecordNonChangedStatusValue := 0;

  Result.RecordIdGenerator :=
    TNegativeIntegerDataSetRecordIdGenerator.Create(
      TIntegerDataSetRecordIdGenerator.Create
    );

  Result.GenerateRecordIdOnAdding := True;

  Result.DataSet.Open;

end;

function TDocumentDataSetHoldersFactory.
  CreateDocumentChargeSetHolderInstance: TDocumentChargeSetHolder;
begin

  Result := InternalCreateDocumentChargeSetHolderInstance;

  FillDocumentChargeSetFieldDefs(Result.FieldDefs);

end;

function TDocumentDataSetHoldersFactory.InternalCreateDocumentChargeSetHolderInstance: TDocumentChargeSetHolder;
begin

  Result := TDocumentChargeSetHolder.Create;

end;

procedure TDocumentDataSetHoldersFactory.FillDocumentChargeSetFieldDefs(
  FieldDefs: TDocumentChargeSetFieldDefs);
begin

  with FieldDefs do begin

    IdFieldName := 'id';
    ChargeKindIdFieldName := 'kind_id';
    ChargeKindNameFieldName := 'kind_name';
    ChargeKindServiceNameFieldName := 'kind_service_name';
    RecordStatusFieldName := 'status';
    IsRecordIdGeneratedFieldName := 'is_id_generated';
    CanBeChangedFieldName := 'can_be_changed';
    CanBeRemovedFieldName := 'can_be_removed';
    TopLevelChargeSheetIdFieldName := 'top_level_charge_sheet_id';
    ReceiverFullNameFieldName := 'full_name';
    ReceiverSpecialityFieldName := 'speciality';
    ReceiverIdFieldName := 'employee_id';
    ReceiverDepartmentNameFieldName := 'department_short_name';
    ReceiverCommentFieldName := 'comment';
    ChargeRecordStatusFieldName := 'status';
    ReceiverPerformingDateTimeFieldName := 'performing_date';
    ReceiverDocumentIdFieldName := 'document_id';
    IsPerformedByReceiverFieldName := 'is_performed';
    ChargeTextFieldName := 'charge';
    ReceiverLeaderIdFieldName := 'leader_id';
    IsReceiverForeignFieldName := 'is_receiver_foreign';
    ViewingDateByPerformerFieldName := 'viewing_date_by_performer';
    IsAccessibleChargeFieldName := 'is_accessible_charge';
    ReceiverRoleIdFieldName := 'receiver_role_id';
    ChargeSheetSenderEmployeeNameFieldName := 'charge_sender';
    ChargeSheetSenderEmployeeIdFieldName := 'charge_sender_id';
    ChargeSheetIssuingDateTimeFieldName := 'issuing_datetime';
    PerformedChargeEmployeeNameFieldName := 'performed_employee_name';
    IsChargeForAcquaitanceFieldName := 'is_for_acquaitance';

  end;

end;

function TDocumentDataSetHoldersFactory.CreateDocumentChargeSet(
  FieldDefs: TDocumentChargeSetFieldDefs
): TDataSet;
begin

  with FieldDefs do begin

    Result :=
      FDataSetBuilder
        .AddField(IsPerformedByReceiverFieldName, ftBoolean)
        .AddField(ChargeKindIdFieldName, ftInteger)
        .AddField(ChargeKindNameFieldName, ftString, 300)
        .AddField(ChargeKindServiceNameFieldName, ftString, 300)
        .AddField(ReceiverDocumentIdFieldName, ftInteger)
        .AddField(ReceiverPerformingDateTimeFieldName, ftDateTime)
        .AddField(ReceiverDepartmentNameFieldName, ftString, 50)
        .AddField(ReceiverSpecialityFieldName, ftString, 100)
        .AddField(ReceiverCommentFieldName, ftString, 500)
        .AddField(IsChargeForAcquaitanceFieldName, ftBoolean)
        .AddField(TopLevelChargeSheetIdFieldName, ftInteger)
        .AddField(ReceiverIdFieldName, ftInteger)
        .AddField(IdFieldName, ftInteger)
        .AddField(ReceiverFullNameFieldName, ftString, 200)
        .AddField(ReceiverLeaderIdFieldName, ftInteger)
        .AddField(IsReceiverForeignFieldName, ftBoolean)
        .AddField(ChargeRecordStatusFieldName, ftInteger)
        .AddField(ChargeTextFieldName, ftString, 500)
        .AddField(ViewingDateByPerformerFieldName, ftDateTime)
        .AddField(IsAccessibleChargeFieldName, ftBoolean)
        .AddField(ReceiverRoleIdFieldName, ftInteger)
        .AddField(ChargeSheetSenderEmployeeNameFieldName, ftString, 200)
        .AddField(ChargeSheetSenderEmployeeIdFieldName, ftInteger)
        .AddField(PerformedChargeEmployeeNameFieldName, ftString, 200)
        .AddField(ChargeSheetIssuingDateTimeFieldName, ftDateTime)
        .AddField(IsRecordIdGeneratedFieldName, ftBoolean)
        .Build;

  end;

end;

function TDocumentDataSetHoldersFactory.
  CreateDocumentApprovingListSetHolder: TDocumentApprovingListSetHolder;
begin

  Result := CreateDocumentApprovingListSetHolderInstance;

  Result.DataSet := CreateDocumentApprovingListSet(Result.FieldDefs);

  Result.ApprovingListRecordSetHolder := CreateDocumentApprovingListRecordSetHolder;
  
  Result.DataSet.Open;
  
end;

function TDocumentDataSetHoldersFactory
  .CreateDocumentApprovingListSetHolderInstance: TDocumentApprovingListSetHolder;
begin

  Result := InternalCreateDocumentApprovingListSetHolderInstance;

  FillDocumentApprovingListSetFieldDefs(Result.FieldDefs);
  
end;

function TDocumentDataSetHoldersFactory.
  InternalCreateDocumentApprovingListSetHolderInstance: TDocumentApprovingListSetHolder;
begin

  Result := TDocumentApprovingListSetHolder.Create;

end;

procedure TDocumentDataSetHoldersFactory.FillDocumentApprovingListSetFieldDefs(
  FieldDefs: TDocumentApprovingListSetFieldDefs);
begin

  with FieldDefs do begin

    TitleFieldName := 'title';

  end;

end;

function TDocumentDataSetHoldersFactory.CreateDocumentApprovingListSet(
  FieldDefs: TDocumentApprovingListSetFieldDefs): TDataSet;
begin

  with FieldDefs do begin

    Result :=
      FDataSetBuilder
        .AddField(TitleFieldName, ftString, 200)
        .Build;

  end;

end;

function TDocumentDataSetHoldersFactory.
  CreateDocumentApprovingListRecordSetHolder: TDocumentApprovingListRecordSetHolder;
begin

  Result := CreateDocumentApprovingListRecordSetHolderInstance;

  Result.DataSet := CreateDocumentApprovingListRecordSet(Result.FieldDefs);

  Result.DataSet.Open;

end;

function TDocumentDataSetHoldersFactory.
  CreateDocumentApprovingListRecordSetHolderInstance: TDocumentApprovingListRecordSetHolder;
begin

  Result := InternalCreateDocumentApprovingListRecordSetInstance;

  FillDocumentApprovingListRecordSetFieldDefs(Result.FieldDefs);

end;

function TDocumentDataSetHoldersFactory.
  InternalCreateDocumentApprovingListRecordSetInstance: TDocumentApprovingListRecordSetHolder;
begin

  Result := TDocumentApprovingListRecordSetHolder.Create;
  
end;

procedure TDocumentDataSetHoldersFactory.FillDocumentApprovingListRecordSetFieldDefs(
  FieldDefs: TDocumentApprovingListRecordSetFieldDefs);
begin

  with FieldDefs do begin

    ListTitleFieldName := 'list_title';
    ApproverNameFieldName := 'approver_name';
    ApproverSpecialityFieldName := 'approver_speciality';
    ApprovingPerformingResultFieldName := 'approving_result_name';
    
  end;

end;

function TDocumentDataSetHoldersFactory.CreateDocumentApprovingListRecordSet(
  FieldDefs: TDocumentApprovingListRecordSetFieldDefs): TDataSet;
begin

  with FieldDefs do begin

    Result :=
      FDataSetBuilder
        .AddField(ListTitleFieldName, ftString, 200)
        .AddField(ApproverNameFieldName, ftString, 250)
        .AddField(ApproverSpecialityFieldName, ftString, 300)
        .AddField(ApprovingPerformingResultFieldName, ftString, 50)
        .Build;

  end;
  
end;

function TDocumentDataSetHoldersFactory.
  CreateDocumentApprovingCycleSetHolder: TDocumentApprovingCycleSetHolder;
begin

  Result := CreateDocumentApprovingCycleSetHolderInstance;

  Result.DataSet := CreateDocumentApprovingCycleSet(Result.FieldDefs);

  Result.DocumentApprovingSetHolder := CreateDocumentApprovingSetHolder;

  Result.RecordIdGenerator :=
    TNegativeIntegerDataSetRecordIdGenerator.Create(
      TIntegerDataSetRecordIdGenerator.Create
    );

  Result.GenerateRecordIdOnAdding := True;
  
  Result.DataSet.Open;

end;

function TDocumentDataSetHoldersFactory.
  CreateDocumentApprovingCycleSetHolderInstance: TDocumentApprovingCycleSetHolder;
begin

  Result := InternalCreateDocumentApprovingCycleSetHolderInstance;

  FillDocumentApprovingCycleSetFieldDefs(Result.FieldDefs);

end;

procedure TDocumentDataSetHoldersFactory.FillDocumentApprovingCycleSetFieldDefs(
  FieldDefs: TDocumentApprovingCycleSetFieldDefs);
begin

  with FieldDefs do begin

    IdFieldName := 'cycle_id';
    CycleNumberFieldName := 'cycle_number';
    CycleNameFieldName := 'cycle_name';
    IsCycleNewFieldName := 'is_new';
    CanBeChangedFieldName := 'can_be_changed';
    CanBeRemovedFieldName := 'can_be_removed';
    CanBeCompletedFieldName := 'can_be_completed';
    IsRecordIdGeneratedFieldName := 'is_id_generated'

  end;

end;

function TDocumentDataSetHoldersFactory.CreateDocumentApprovingCycleSet(
  FieldDefs: TDocumentApprovingCycleSetFieldDefs): TDataSet;
begin

  with FieldDefs do begin

    Result :=
      FDataSetBuilder
        .AddField(IdFieldName, ftInteger)
        .AddField(CycleNumberFieldName, ftInteger)
        .AddField(CycleNameFieldName, ftString, 200)
        .AddField(IsCycleNewFieldName, ftBoolean)
        .AddField(IsRecordIdGeneratedFieldName, ftBoolean)
        .AddField(CanBeChangedFieldName, ftBoolean)
        .AddField(CanBeRemovedFieldName, ftBoolean)
        .AddField(CanBeCompletedFieldName, ftBoolean)
        .Build;

  end;

end;

function TDocumentDataSetHoldersFactory.
  CreateDocumentApprovingSetHolder: TDocumentApprovingSetHolder;
begin

  { refactor: внедрять генератор идентификаторов записей в Options }

  Result := CreateDocumentApprovingSetHolderInstance;

  Result.DataSet := CreateDocumentApprovingSet(Result.FieldDefs);

  Result.RecordIdGenerator :=
    TNegativeIntegerDataSetRecordIdGenerator.Create(
      TIntegerDataSetRecordIdGenerator.Create
    );

  { refactor: take approving results from dto or oversee implementation }
  
  Result.PerformingResultIsApprovedValue := 1;
  Result.PerformingResultIsNotApprovedValue := 2;
  Result.PerformingResultIsNotPerformedValue := 3;

  Result.GenerateRecordIdOnAdding := True;
  
  Result.DataSet.Open;
  
end;

function TDocumentDataSetHoldersFactory.CreateDocumentApprovingSetHolderInstance: TDocumentApprovingSetHolder;
begin

  Result := InternalCreateDocumentApprovingSetHolderInstance;

  FillDocumentApprovingSetFieldDefs(Result.FieldDefs);

end;

function TDocumentDataSetHoldersFactory.InternalCreateDocumentApprovingCycleSetHolderInstance: TDocumentApprovingCycleSetHolder;
begin

  Result := TDocumentApprovingCycleSetHolder.Create;

end;

function TDocumentDataSetHoldersFactory.InternalCreateDocumentApprovingSetHolderInstance: TDocumentApprovingSetHolder;
begin

  Result := TDocumentApprovingSetHolder.Create;

end;

procedure TDocumentDataSetHoldersFactory.FillDocumentApprovingSetFieldDefs(
  FieldDefs: TDocumentApprovingSetFieldDefs);
begin

  with FieldDefs do begin

    IdFieldName := 'approving_id';
    PerformerIdFieldName := 'performer_id';
    PerformerNameFieldName := 'performer_name';
    PerformerSpecialityFieldName := 'performer_speciality';
    PerformerDepartmentNameFieldName := 'performer_department_name';
    PerformingResultIdFieldName := 'performing_result_id';
    PerformingResultFieldName := 'performing_result';
    PerformingDateTimeFieldName := 'performing_date';
    ActuallyPerformedEmployeeIdFieldName := 'actual_performer_id';
    ActuallyPerformedEmployeeNameFieldName := 'actual_performer_name';
    NoteFieldName := 'note';
    IsViewedByPerformerFieldName := 'is_viewed_by_performer';
    ApprovingCycleIdFieldName := 'cycle_id';
    IsNewFieldName := 'is_new';
    TopLevelApprovingIdFieldName := 'top_level_approving_id';
    CanBeChangedFieldName := 'can_be_changed';
    CanBeRemovedFieldName := 'can_be_removed';
    IsApprovingAccessibleFieldName := 'is_approving_accessible';
    IsRecordIdGeneratedFieldName := 'is_id_generated';

  end;

end;

function TDocumentDataSetHoldersFactory.CreateDocumentApprovingSet(
  FieldDefs: TDocumentApprovingSetFieldDefs
): TDataSet;
begin

  with FieldDefs do begin
  
    Result :=
      FDataSetBuilder
        .AddField(IdFieldName, ftInteger)
        .AddField(PerformerIdFieldName, ftInteger)
        .AddField(PerformerNameFieldName, ftString, 200)
        .AddField(PerformerSpecialityFieldName, ftString, 200)
        .AddField(PerformerDepartmentNameFieldName, ftString, 200)
        .AddField(ActuallyPerformedEmployeeIdFieldName, ftInteger)
        .AddField(ActuallyPerformedEmployeeNameFieldName, ftString, 200)
        .AddField(PerformingResultIdFieldName, ftInteger)
        .AddField(PerformingResultFieldName, ftString, 50)
        .AddField(PerformingDateTimeFieldName, ftDateTime)
        .AddField(NoteFieldName, ftString, 1024)
        .AddField(IsViewedByPerformerFieldName, ftBoolean)
        .AddField(ApprovingCycleIdFieldName, ftInteger)
        .AddField(TopLevelApprovingIdFieldName, ftInteger)
        .AddField(IsRecordIdGeneratedFieldName, ftBoolean)
        .AddField(CanBeChangedFieldName, ftBoolean)
        .AddField(CanBeRemovedFieldName, ftBoolean)
        .AddField(IsApprovingAccessibleFieldName, ftBoolean)
        .AddField(IsNewFieldName, ftBoolean)
        .Build;

  end;

end;

function TDocumentDataSetHoldersFactory.CreateDocumentFileSetHolder: TDocumentFileSetHolder;
begin

  Result := CreateDocumentFileSetHolderInstance;

  Result.DataSet := CreateDocumentFileSet(Result.FieldDefs);

  Result.RecordAddedStatusValue := 1;
  Result.RecordNonChangedStatusValue := 0;

  Result.Open;
  
end;

function TDocumentDataSetHoldersFactory.CreateDocumentFileSetHolderInstance: TDocumentFileSetHolder;
begin

  Result := InternalCreateDocumentFileSetHolderInstance;

  FillDocumentFileSetFieldDefs(Result.FieldDefs);
  
end;

function TDocumentDataSetHoldersFactory.InternalCreateDocumentFileSetHolderInstance: TDocumentFileSetHolder;
begin

  Result := TDocumentFileSetHolder.Create;

end;

procedure TDocumentDataSetHoldersFactory.FillDocumentFileSetFieldDefs(
  FieldDefs: TDocumentFileSetFieldDefs);
begin

   with FieldDefs do begin

    IdFieldName := 'id';
    FileNameFieldName := 'file_name';
    FilePathFieldName := 'file_path';
    RecordStatusFieldName := 'status';

  end;

end;

function TDocumentDataSetHoldersFactory.CreateDocumentFileSet(
  FieldDefs: TDocumentFileSetFieldDefs): TDataSet;
begin

  with FieldDefs do begin

    Result :=
      FDataSetBuilder
        .AddField(IdFieldName, ftInteger)
        .AddField(FileNameFieldName, ftString, 300)
        .AddField(FilePathFieldName, ftString, 5000)
        .AddField(RecordStatusFieldName, ftInteger)
        .Build;

  end;

end;

function TDocumentDataSetHoldersFactory.CreateDocumentRelationSetHolder: TDocumentRelationSetHolder;
begin

  Result := CreateDocumentRelationSetHolderInstance;

  Result.DataSet := CreateDocumentRelationSet(Result.FieldDefs);

  { refactor: inject generators or take it from appropriate injected factory }
  Result.RecordIdGenerator := TIntegerDataSetRecordIdGenerator.Create;

  Result.GenerateRecordIdOnAdding := True;
  
  Result.DataSet.Open;

end;

function TDocumentDataSetHoldersFactory.CreateDocumentRelationSetHolderInstance: TDocumentRelationSetHolder;
begin

  Result := InternalCreateDocumentRelationSetHolderInstance;

  FillDocumentRelationSetFieldDefs(Result.FieldDefs);

end;

function TDocumentDataSetHoldersFactory.InternalCreateDocumentRelationSetHolderInstance: TDocumentRelationSetHolder;
begin

  Result := TDocumentRelationSetHolder.Create;

end;

procedure TDocumentDataSetHoldersFactory.FillDocumentRelationSetFieldDefs(
  FieldDefs: TDocumentRelationSetFieldDefs);
begin

  with FieldDefs do begin

    RecordIdFieldName := 'record_id';
    IsRecordIdGeneratedFieldName := 'is_record_id_generated';
    DocumentIdFieldName := 'id';
    DocumentKindIdFieldName := 'type_id';
    DocumentKindNameFieldName := 'type_name';
    DocumentNameFieldName := 'name';
    DocumentNumberFieldName := 'number';
    DocumentDateFieldName := 'document_date';

  end;

end;

function TDocumentDataSetHoldersFactory.GetSelf: TObject;
begin

  Result := Self;
  
end;

function TDocumentDataSetHoldersFactory.CreateDocumentRelationSet(
  FieldDefs: TDocumentRelationSetFieldDefs): TDataSet;
begin

  with FieldDefs do begin

    Result :=
      FDataSetBuilder
        .AddField(RecordIdFieldName, ftInteger)
        .AddField(IsRecordIdGeneratedFieldName, ftBoolean)
        .AddField(DocumentIdFieldName, ftInteger)
        .AddField(DocumentNumberFieldName, ftString, 100)
        .AddField(DocumentDateFieldName, ftDateTime)
        .AddField(DocumentNameFieldName, ftString, 300)
        .AddField(DocumentKindIdFieldName, ftInteger)
        .AddField(DocumentKindNameFieldName, ftString, 100)
        .Build;

  end;

end;

end.

