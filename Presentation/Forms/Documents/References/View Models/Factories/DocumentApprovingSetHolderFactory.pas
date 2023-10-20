unit DocumentApprovingSetHolderFactory;

interface

uses

  DocumentApprovingCycleSetHolder,
  AbstractDataSetHolder,
  AbstractDataSetHolderFactory,
  DB,
  DataSetBuilder,
  SysUtils,
  Classes;

type


  IDocumentApprovingSetHolderFactory = interface (IDataSetHolderFactory)
    ['{CDF4E7DE-58E9-4632-B6A1-E7C14A5A95A0}']

    function CreateDocumentApprovingSetHolder: TDocumentApprovingSetHolder;

  end;

  TDocumentApprovingSetHolderFactory =
    class (TAbstractDataSetHolderFactory, IDocumentApprovingSetHolderFactory)

      protected

        function InternalCreateDataSetHolderInstance: TAbstractDataSetHolder; override;
        procedure FillDataSetFieldDefs(FieldDefs: TAbstractDataSetFieldDefs); override;

        procedure CustomizeDataSetBuilder(
          DataSetBuilder: IDataSetBuilder;
          DataSetHolder: TAbstractDataSetHolder
        ); override;

      public

        function CreateDocumentApprovingSetHolder: TDocumentApprovingSetHolder;

    end;


implementation

{ TDocumentApprovingSetHolderFactory }

function TDocumentApprovingSetHolderFactory
  .CreateDocumentApprovingSetHolder: TDocumentApprovingSetHolder;
begin

  Result := TDocumentApprovingSetHolder(CreateDataSetHolder);

end;

procedure TDocumentApprovingSetHolderFactory.FillDataSetFieldDefs(
  FieldDefs: TAbstractDataSetFieldDefs);
begin

  inherited FillDataSetFieldDefs(FieldDefs);

  with TDocumentApprovingSetFieldDefs(FieldDefs) do begin

    TopLevelApprovingIdFieldName := 'top_level_approving_id';
    PerformerIdFieldName := 'performer_id';
    PerformerNameFieldName := 'performer_name';
    PerformerDepartmentNameFieldName := 'performer_department_name';
    PerformerSpecialityFieldName := 'performer_speciality';
    ActuallyPerformedEmployeeIdFieldName := 'performed_employee_id';
    ActuallyPerformedEmployeeNameFieldName := 'performed_employee_name';
    PerformingResultIdFieldName := 'performing_result_id';
    PerformingResultFieldName := 'performing_result';
    PerformingResultServiceNameFieldName := 'performing_result_service_name';
    PerformingDateTimeFieldName := 'performing_datetime';
    NoteFieldName := 'note';
    IsViewedByPerformerFieldName := 'is_viewed_by_performer';
    IsNewFieldName := 'is_new';
    IsApprovingAccessibleFieldName := 'is_accessible';
    ApprovingCycleIdFieldName := 'cycle_id';
      
  end;

end;

procedure TDocumentApprovingSetHolderFactory.CustomizeDataSetBuilder(
  DataSetBuilder: IDataSetBuilder;
  DataSetHolder: TAbstractDataSetHolder
);
begin

  inherited CustomizeDataSetBuilder(DataSetBuilder, DataSetHolder);

  with TDocumentApprovingSetFieldDefs(DataSetHolder.FieldDefs) do begin

    DataSetBuilder
      .AddField(TopLevelApprovingIdFieldName, ftInteger)
      .AddField(PerformerIdFieldName, ftInteger)
      .AddField(PerformerNameFieldName, ftString, 300)
      .AddField(PerformerDepartmentNameFieldName, ftString, 200)
      .AddField(PerformerSpecialityFieldName, ftString, 200)
      .AddField(ActuallyPerformedEmployeeIdFieldName, ftInteger)
      .AddField(ActuallyPerformedEmployeeNameFieldName, ftString, 300)
      .AddField(PerformingResultIdFieldName, ftInteger)
      .AddField(PerformingResultFieldName, ftString, 150)
      .AddField(PerformingResultServiceNameFieldName, ftString, 150)
      .AddField(PerformingDateTimeFieldName, ftDateTime)
      .AddField(NoteFieldName, ftString, 500)
      .AddField(IsViewedByPerformerFieldName, ftBoolean)
      .AddField(IsNewFieldName, ftBoolean)
      .AddField(IsApprovingAccessibleFieldName, ftBoolean)
      .AddField(ApprovingCycleIdFieldName, ftInteger);
      
  end;

end;

function TDocumentApprovingSetHolderFactory.InternalCreateDataSetHolderInstance: TAbstractDataSetHolder;
begin

  Result := TDocumentApprovingSetHolder.Create;

end;

end.
