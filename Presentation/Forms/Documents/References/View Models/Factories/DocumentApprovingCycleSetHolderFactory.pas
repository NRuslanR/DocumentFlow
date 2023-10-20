unit DocumentApprovingCycleSetHolderFactory;

interface

uses

  DocumentApprovingCycleSetHolder,
  DocumentApprovingSetHolderFactory,
  AbstractDataSetHolder,
  AbstractDataSetHolderFactory,
  DB,
  DataSetBuilder,
  SysUtils,
  Classes;

type

  IDocumentApprovingCycleSetHolderFactory = interface (IDataSetHolderFactory)
    ['{FE9AFE5E-FFFB-44B3-A518-16436B24C5CC}']
    
    function CreateDocumentApprovingCycleSetHolder: TDocumentApprovingCycleSetHolder;
    
  end;

  TDocumentApprovingCycleSetHolderFactory =
    class (TAbstractDataSetHolderFactory, IDocumentApprovingCycleSetHolderFactory)

      private

        FDocumentApprovingSetHolderFactory: IDocumentApprovingSetHolderFactory;
        
      protected

        function InternalCreateDataSetHolderInstance: TAbstractDataSetHolder; override;
        procedure FillDataSetFieldDefs(FieldDefs: TAbstractDataSetFieldDefs); override;

        procedure CustomizeDataSetBuilder(
          DataSetBuilder: IDataSetBuilder;
          DataSetHolder: TAbstractDataSetHolder
        ); override;

      public

        constructor Create(
          DocumentApprovingSetHolderFactory: IDocumentApprovingSetHolderFactory;
          DataSetBuilder: IDataSetBuilder;
          Options: IDataSetHolderFactoryOptions = nil
        );

        function CreateDocumentApprovingCycleSetHolder: TDocumentApprovingCycleSetHolder;
        
    end;

implementation

{ TDocumentApprovingCycleSetHolderFactory }

constructor TDocumentApprovingCycleSetHolderFactory.Create(
  DocumentApprovingSetHolderFactory: IDocumentApprovingSetHolderFactory;
  DataSetBuilder: IDataSetBuilder;
  Options: IDataSetHolderFactoryOptions
);
begin


  inherited Create(DataSetBuilder, Options);

  FDocumentApprovingSetHolderFactory := DocumentApprovingSetHolderFactory;

end;

function TDocumentApprovingCycleSetHolderFactory.CreateDocumentApprovingCycleSetHolder: TDocumentApprovingCycleSetHolder;
begin

  Result := TDocumentApprovingCycleSetHolder(CreateDataSetHolder);

  Result.DocumentApprovingSetHolder :=
    FDocumentApprovingSetHolderFactory.CreateDocumentApprovingSetHolder;
    
end;

function TDocumentApprovingCycleSetHolderFactory.InternalCreateDataSetHolderInstance: TAbstractDataSetHolder;
begin

  Result := TDocumentApprovingCycleSetHolder.Create;
  
end;

procedure TDocumentApprovingCycleSetHolderFactory.FillDataSetFieldDefs(
  FieldDefs: TAbstractDataSetFieldDefs);
begin

  inherited FillDataSetFieldDefs(FieldDefs);

  with TDocumentApprovingCycleSetFieldDefs(FieldDefs) do begin

    CycleNumberFieldName := 'cycle_number';
    CycleNameFieldName := 'cycle_name';
    IsCycleNewFieldName := 'is_new';
    CanBeCompletedFieldName := 'can_be_completed';

  end;
  
end;

procedure TDocumentApprovingCycleSetHolderFactory.CustomizeDataSetBuilder(
  DataSetBuilder: IDataSetBuilder; DataSetHolder: TAbstractDataSetHolder);
begin

  inherited CustomizeDataSetBuilder(DataSetBuilder, DataSetHolder);

  with TDocumentApprovingCycleSetHolder(DataSetHolder).FieldDefs do begin

    DataSetBuilder
      .AddField(CycleNumberFieldName, ftInteger)
      .AddField(CycleNameFieldName, ftString, 200)
      .AddField(IsCycleNewFieldName, ftBoolean)
      .AddField(CanBeCompletedFieldName, ftBoolean);

  end;

end;

end.
