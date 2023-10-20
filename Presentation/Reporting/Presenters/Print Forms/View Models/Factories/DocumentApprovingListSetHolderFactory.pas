unit DocumentApprovingListSetHolderFactory;

interface

uses

  AbstractDataSetHolderFactory,
  AbstractDataSetHolder,
  DocumentApprovingListSetHolder,
  DocumentApprovingListRecordSetHolderFactory,
  DataSetBuilder,
  DB,
  SysUtils,
  Classes;

type

  IDocumentApprovingListSetHolderFactory = interface (IDataSetHolderFactory)

    function CreateDocumentApprovingListSetHolder: TDocumentApprovingListSetHolder;

  end;

  TDocumentApprovingListSetHolderFactory =
    class (TAbstractDataSetHolderFactory, IDocumentApprovingListSetHolderFactory)

      private
      
      protected

        FApprovingListRecordSetHolderFactory: IDocumentApprovingListRecordSetHolderFactory;

        function InternalCreateDataSetHolderInstance: TAbstractDataSetHolder; override;
        procedure FillDataSetFieldDefs(FieldDefs: TAbstractDataSetFieldDefs); override;

        procedure CustomizeDataSetBuilder(
          DataSetBuilder: IDataSetBuilder;
          DataSetHolder: TAbstractDataSetHolder
        ); override;

      public

        constructor Create(
          ApprovingListRecordSetHolderFactory: IDocumentApprovingListRecordSetHolderFactory;
          DataSetBuilder: IDataSetBuilder
        );
        
        function CreateDocumentApprovingListSetHolder: TDocumentApprovingListSetHolder;

    end;
  
implementation

{ TDocumentApprovingListSetHolderFactory }

constructor TDocumentApprovingListSetHolderFactory.Create(
  ApprovingListRecordSetHolderFactory: IDocumentApprovingListRecordSetHolderFactory;
  DataSetBuilder: IDataSetBuilder
);
begin

  inherited Create(DataSetBuilder);

  FApprovingListRecordSetHolderFactory := ApprovingListRecordSetHolderFactory;
  
end;

function TDocumentApprovingListSetHolderFactory
  .CreateDocumentApprovingListSetHolder: TDocumentApprovingListSetHolder;
begin
                        
  Result := TDocumentApprovingListSetHolder(CreateDataSetHolder);

  Result.ApprovingListRecordSetHolder :=
    FApprovingListRecordSetHolderFactory
      .CreateDocumentApprovingListRecordSetHolder;
  
end;

function TDocumentApprovingListSetHolderFactory
  .InternalCreateDataSetHolderInstance: TAbstractDataSetHolder;
begin

  Result := TDocumentApprovingListSetHolder.Create;
  
end;

procedure TDocumentApprovingListSetHolderFactory
  .FillDataSetFieldDefs(FieldDefs: TAbstractDataSetFieldDefs);
begin

  inherited FillDataSetFieldDefs(FieldDefs);

  with TDocumentApprovingListSetFieldDefs(FieldDefs)
  do begin

    TitleFieldName := 'title';

  end;

end;

procedure TDocumentApprovingListSetHolderFactory
  .CustomizeDataSetBuilder(
    DataSetBuilder: IDataSetBuilder;
    DataSetHolder: TAbstractDataSetHolder
  );
begin

  inherited CustomizeDataSetBuilder(DataSetBuilder, DataSetHolder);

  with TDocumentApprovingListSetHolder(DataSetHolder)
  do begin

    DataSetBuilder.AddField(TitleFieldName, ftString, 200);
    
  end;

end;

end.
