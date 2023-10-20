unit DocumentApprovingListRecordSetHolderFactory;

interface

uses

  AbstractDataSetHolder,
  DocumentApprovingListRecordSetHolder,
  AbstractDataSetHolderFactory,
  DataSetBuilder,
  DB,
  SysUtils,
  Classes;

type

  IDocumentApprovingListRecordSetHolderFactory =
    interface (IDataSetHolderFactory)

      function CreateDocumentApprovingListRecordSetHolder: TDocumentApprovingListRecordSetHolder;

    end;

  TDocumentApprovingListRecordSetHolderFactory =
    class (TAbstractDataSetHolderFactory, IDocumentApprovingListRecordSetHolderFactory)

      protected

        function InternalCreateDataSetHolderInstance: TAbstractDataSetHolder; override;
        procedure FillDataSetFieldDefs(FieldDefs: TAbstractDataSetFieldDefs); override;

        procedure CustomizeDataSetBuilder(
          DataSetBuilder: IDataSetBuilder;
          DataSetHolder: TAbstractDataSetHolder
        ); override;

      public

        function CreateDocumentApprovingListRecordSetHolder: TDocumentApprovingListRecordSetHolder;
        
    end;

implementation

{ TDocumentApprovingListRecordSetHolderFactory }

function TDocumentApprovingListRecordSetHolderFactory
  .CreateDocumentApprovingListRecordSetHolder: TDocumentApprovingListRecordSetHolder;
begin

  Result := TDocumentApprovingListRecordSetHolder(CreateDataSetHolder);

end;

procedure TDocumentApprovingListRecordSetHolderFactory
  .CustomizeDataSetBuilder(
    DataSetBuilder: IDataSetBuilder;
    DataSetHolder: TAbstractDataSetHolder
  );
begin

  inherited CustomizeDataSetBuilder(DataSetBuilder, DataSetHolder);

  with TDocumentApprovingListRecordSetHolder(DataSetHolder)
  do begin

    DataSetBuilder
      .AddField(ListTitleFieldName, ftString, 200)
      .AddField(ApproverNameFieldName, ftString, 250)
      .AddField(ApproverSpecialityFieldName, ftString, 300)
      .AddField(ApprovingPerformingResultFieldName, ftString, 50);

  end;

end;

procedure TDocumentApprovingListRecordSetHolderFactory
  .FillDataSetFieldDefs(FieldDefs: TAbstractDataSetFieldDefs);
begin

  inherited FillDataSetFieldDefs(FieldDefs);

  with TDocumentApprovingListRecordSetFieldDefs(FieldDefs)
  do begin

    ListTitleFieldName := 'list_title';
    ApproverNameFieldName := 'approver_name';
    ApproverSpecialityFieldName := 'approver_speciality';
    ApprovingPerformingResultFieldName := 'approving_result_name';
    
  end;

end;

function TDocumentApprovingListRecordSetHolderFactory
  .InternalCreateDataSetHolderInstance: TAbstractDataSetHolder;
begin

  Result := TDocumentApprovingListRecordSetHolder.Create;
  
end;

end.
