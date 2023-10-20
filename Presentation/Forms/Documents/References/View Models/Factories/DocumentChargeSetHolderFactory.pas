unit DocumentChargeSetHolderFactory;

interface

uses

  AbstractDataSetHolder,
  DocumentChargeSetHolder,
  AbstractDataSetHolderFactory,
  DB,
  DataSetBuilder,
  SysUtils,
  Classes;

type

  IDocumentChargeSetHolderFactory = interface (IDataSetHolderFactory)
    ['{B501D20B-3EBF-4316-868C-3A731D21624C}']
    
    function CreateDocumentChargeSetHolder: TDocumentChargeSetHolder;
    
  end;
  
  TDocumentChargeSetHolderFactory = class (TAbstractDataSetHolderFactory, IDocumentChargeSetHolderFactory)

    protected

      function InternalCreateDataSetHolderInstance: TAbstractDataSetHolder; override;
      procedure FillDataSetFieldDefs(FieldDefs: TAbstractDataSetFieldDefs); override;

      procedure CustomizeDataSetBuilder(
        DataSetBuilder: IDataSetBuilder;
        DataSetHolder: TAbstractDataSetHolder
      ); override;

    public

      function CreateDocumentChargeSetHolder: TDocumentChargeSetHolder;

  end;


implementation

{ TDocumentChargeSetHolderFactory }

function TDocumentChargeSetHolderFactory.InternalCreateDataSetHolderInstance: TAbstractDataSetHolder;
begin

  Result := TDocumentChargeSetHolder.Create;

end;

procedure TDocumentChargeSetHolderFactory.FillDataSetFieldDefs(
  FieldDefs: TAbstractDataSetFieldDefs);
begin

  inherited FillDataSetFieldDefs(FieldDefs);
  
  with TDocumentChargeSetFieldDefs(FieldDefs) do begin

    KindIdFieldName := 'kind_id';
    KindNameFieldName := 'kind_name';
    KindServiceNameFieldName := 'kind_service_name';
    PerformerFullNameFieldName := 'full_name';
    PerformerSpecialityFieldName := 'speciality';
    PerformerIdFieldName := 'employee_id';
    PerformerDepartmentNameFieldName := 'department_short_name';
    PerformerCommentFieldName := 'comment';
    PerformingDateTimeFieldName := 'performing_date';
    ChargeTextFieldName := 'charge';
    IsPerformerForeignFieldName := 'is_receiver_foreign';
    ActualPerformerFullNameFieldName := 'performed_employee_name';
    IsForAcquaitanceFieldName := 'is_for_acquaitance';

  end;

end;

function TDocumentChargeSetHolderFactory.CreateDocumentChargeSetHolder: TDocumentChargeSetHolder;
begin

  Result := TDocumentChargeSetHolder(CreateDataSetHolder);
  
end;

procedure TDocumentChargeSetHolderFactory.CustomizeDataSetBuilder(
  DataSetBuilder: IDataSetBuilder;
  DataSetHolder: TAbstractDataSetHolder
);
begin

  inherited CustomizeDataSetBuilder(DataSetBuilder, DataSetHolder);
  
  with TDocumentChargeSetFieldDefs(DataSetHolder.FieldDefs) do begin

    DataSetBuilder
      .AddField(KindIdFieldName, ftInteger)
      .AddField(KindNameFieldName, ftString, 300)
      .AddField(KindServiceNameFieldName, ftString, 300)
      .AddField(PerformingDateTimeFieldName, ftDateTime)
      .AddField(PerformerDepartmentNameFieldName, ftString, 50)
      .AddField(PerformerSpecialityFieldName, ftString, 100)
      .AddField(PerformerCommentFieldName, ftString, 500)
      .AddField(IsForAcquaitanceFieldName, ftBoolean)
      .AddField(PerformerIdFieldName, ftInteger)
      .AddField(PerformerFullNameFieldName, ftString, 200)
      .AddField(IsPerformerForeignFieldName, ftBoolean)
      .AddField(ChargeTextFieldName, ftString, 500)
      .AddField(ActualPerformerFullNameFieldName, ftString, 200)

  end;

end;

end.
