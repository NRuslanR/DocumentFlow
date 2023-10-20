unit DocumentDataSetHoldersFactory;

interface

uses

  DB,
  DataSetBuilder,
  UIDocumentKinds,
  DocumentFileSetHolder,
  DocumentChargeSetHolder,
  DocumentChargeSheetSetHolder,
  DocumentRelationSetHolder,
  DocumentApprovingCycleSetHolder,
  DocumentFileSetHolderFactory,
  DocumentChargeSetHolderFactory,      
  DocumentChargeSheetSetHolderFactory,
  DocumentApprovingSetHolderFactory,
  DocumentRelationSetHolderFactory,
  DocumentApprovingCycleSetHolderFactory,
  AbstractDataSetHolderFactory,
  AbstractDataSetHolder,
  IGetSelfUnit,
  TypeObjectRegistry,
  DataSetBuilderFactory,
  DocumentApprovingListRecordSetHolder,
  SysUtils;

type

  IDocumentDataSetHoldersFactory = interface (IGetSelf)

    function CreateDocumentChargeSetHolderFactory: IDocumentChargeSetHolderFactory;
    function CreateDocumentChargeSheetSetHolderFactory: IDocumentChargeSheetSetHolderFactory;
    function CreateDocumentApprovingCycleSetHolderFactory: IDocumentApprovingCycleSetHolderFactory;
    function CreateDocumentRelationSetHolderFactory: IDocumentRelationSetHolderFactory;
    function CreateDocumentFileSetHolderFactory: IDocumentFileSetHolderFactory;

  end;

  TDocumentDataSetHoldersFactory = class (TInterfacedObject, IDocumentDataSetHoldersFactory)

    private

      FDataSetBuilderFactory: IDataSetBuilderFactory;
      
      FFactories: TTypeObjectRegistry;

      type

        TDocumentDataSetHolderFactoryCreator =
          procedure (var Factory: IDataSetHolderFactory) of object;

    protected

      function CreateDocumentDataSetHolderFactory(
        FactoryType: TClass;
        FactoryCreator: TDocumentDataSetHolderFactoryCreator
      ): IDataSetHolderFactory;

    protected
    
      procedure InternalCreateDocumentChargeSetHolderFactory(var Factory: IDataSetHolderFactory); virtual;
      procedure InternalCreateDocumentChargeSheetSetHolderFactory(var Factory: IDataSetHolderFactory); virtual;
      procedure InternalCreateDocumentApprovingCycleSetHolderFactory(var Factory: IDataSetHolderFactory); virtual;
      procedure InternalCreateDocumentRelationSetHolderFactory(var Factory: IDataSetHolderFactory); virtual;
      procedure InternalCreateDocumentFileSetHolderFactory(var Factory: IDataSetHolderFactory); virtual;


    public

      destructor Destroy; override;

      constructor Create(DataSetBuilderFactory: IDataSetBuilderFactory);

      function GetSelf: TObject;

      function CreateDocumentChargeSetHolderFactory: IDocumentChargeSetHolderFactory;
      function CreateDocumentChargeSheetSetHolderFactory: IDocumentChargeSheetSetHolderFactory;
      function CreateDocumentApprovingCycleSetHolderFactory: IDocumentApprovingCycleSetHolderFactory;
      function CreateDocumentRelationSetHolderFactory: IDocumentRelationSetHolderFactory;
      function CreateDocumentFileSetHolderFactory: IDocumentFileSetHolderFactory;

  end;

implementation

{ TDocumentDataSetHoldersFactory }

type

  TDocumentChargeSetHolderFactoryType = class

  end;

  TDocumentChargeSheetSetHolderFactoryType = class
  
  end;

  TDocumentApprovingCycleSetHolderFactoryType = class
  
  end;

  TDocumentRelationSetHolderFactoryType = class

  end;

  TDocumentFileSetHolderFactoryType = class

  end;

constructor TDocumentDataSetHoldersFactory.Create(
  DataSetBuilderFactory: IDataSetBuilderFactory
);
begin

  inherited Create;

  FDataSetBuilderFactory := DataSetBuilderFactory;
  FFactories := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  
end;

destructor TDocumentDataSetHoldersFactory.Destroy;
begin

  FreeAndNil(FFactories);
  
  inherited;

end;


function TDocumentDataSetHoldersFactory.GetSelf: TObject;
begin

  Result := Self;

end;

function TDocumentDataSetHoldersFactory
  .CreateDocumentApprovingCycleSetHolderFactory: IDocumentApprovingCycleSetHolderFactory;
var
    Factory: IDataSetHolderFactory;
begin

  Factory :=
    CreateDocumentDataSetHolderFactory(
      TDocumentApprovingCycleSetHolderFactoryType,
      InternalCreateDocumentApprovingCycleSetHolderFactory
    );

  Supports(Factory, IDocumentApprovingCycleSetHolderFactory, Result);

end;

function TDocumentDataSetHoldersFactory
  .CreateDocumentChargeSetHolderFactory: IDocumentChargeSetHolderFactory;
var
    Factory: IDataSetHolderFactory;
begin

  Factory :=
    CreateDocumentDataSetHolderFactory(
      TDocumentChargeSetHolderFactoryType,
      InternalCreateDocumentChargeSetHolderFactory
    );

  Supports(Factory, IDocumentChargeSetHolderFactory, Result);
  
end;

function TDocumentDataSetHoldersFactory
  .CreateDocumentChargeSheetSetHolderFactory: IDocumentChargeSheetSetHolderFactory;
var
    Factory: IDataSetHolderFactory;
begin

  Factory :=
    CreateDocumentDataSetHolderFactory(
      TDocumentChargeSheetSetHolderFactoryType,
      InternalCreateDocumentChargeSheetSetHolderFactory
    );

  Supports(Factory, IDocumentChargeSheetSetHolderFactory, Result);

end;

function TDocumentDataSetHoldersFactory
  .CreateDocumentFileSetHolderFactory: IDocumentFileSetHolderFactory;
var
    Factory: IDataSetHolderFactory;
begin

  Factory :=
    CreateDocumentDataSetHolderFactory(
      TDocumentFileSetHolderFactoryType,
      InternalCreateDocumentFileSetHolderFactory
    );
    
  Supports(Factory, IDocumentFileSetHolderFactory, Result);

end;

function TDocumentDataSetHoldersFactory
  .CreateDocumentRelationSetHolderFactory: IDocumentRelationSetHolderFactory;
var
    Factory: IDataSetHolderFactory;
begin

  Factory :=
    CreateDocumentDataSetHolderFactory(
      TDocumentRelationSetHolderFactoryType,
      InternalCreateDocumentRelationSetHolderFactory
    );

  Supports(Factory, IDocumentRelationSetHolderFactory, Result);
    
end;

procedure TDocumentDataSetHoldersFactory.InternalCreateDocumentApprovingCycleSetHolderFactory(
  var Factory: IDataSetHolderFactory);
begin

  Factory :=
    TDocumentApprovingCycleSetHolderFactory.Create(
      TDocumentApprovingSetHolderFactory.Create(
        FDataSetBuilderFactory.CreateDataSetBuilder,
        TDataSetHolderFactoryOptions
          .Default
            .Clone
              .EnableRecordIdGeneratingOnAdding(True)
              .RecordIdGeneratorFactory(
                TNegativeIntegerDataSetRecordIdGeneratorFactory.Create(
                  TIntegerDataSetRecordIdGeneratorFactory.Create
                )
              )
              .EnableRecordAccessRights(True)
      ),
      FDataSetBuilderFactory.CreateDataSetBuilder,
      TDataSetHolderFactoryOptions
        .Default
          .Clone
            .EnableRecordIdGeneratingOnAdding(True)
            .RecordIdGeneratorFactory(
              TNegativeIntegerDataSetRecordIdGeneratorFactory.Create(
                TIntegerDataSetRecordIdGeneratorFactory.Create
              )
            )
            .EnableRecordAccessRights(True)
    );

end;

procedure TDocumentDataSetHoldersFactory.InternalCreateDocumentChargeSetHolderFactory(
  var Factory: IDataSetHolderFactory);
begin

  Factory :=
    TDocumentChargeSetHolderFactory.Create(
      FDataSetBuilderFactory.CreateDataSetBuilder,
      TDataSetHolderFactoryOptions
        .Default
          .Clone
          .EnableRecordStatus(True)
          .EnableRecordIdGeneratingOnAdding(True)
          .EnableRecordAccessRights(True)
          .RecordIdGeneratorFactory(
            TNegativeIntegerDataSetRecordIdGeneratorFactory.Create(
              TIntegerDataSetRecordIdGeneratorFactory.Create
            )
          )

    );
    
end;

procedure TDocumentDataSetHoldersFactory.InternalCreateDocumentChargeSheetSetHolderFactory(
  var Factory: IDataSetHolderFactory);
var
    InternalFactory: IDataSetHolderFactory;
    ChargeSetHolderFactory: IDocumentChargeSetHolderFactory;
begin

  InternalCreateDocumentChargeSetHolderFactory(InternalFactory);

  Supports(InternalFactory, IDocumentChargeSetHolderFactory, ChargeSetHolderFactory);
      
  Factory :=
    TDocumentChargeSheetSetHolderFactory.Create(
      ChargeSetHolderFactory,
      FDataSetBuilderFactory.CreateDataSetBuilder
    );

end;

procedure TDocumentDataSetHoldersFactory.InternalCreateDocumentFileSetHolderFactory(
  var Factory: IDataSetHolderFactory);
begin

  Factory :=
    TDocumentFileSetHolderFactory.Create(
      FDataSetBuilderFactory.CreateDataSetBuilder,
      TDataSetHolderFactoryOptions
        .Default
          .Clone
            .EnableRecordStatus(True)
    );
    
end;

procedure TDocumentDataSetHoldersFactory.InternalCreateDocumentRelationSetHolderFactory(
  var Factory: IDataSetHolderFactory);
begin

  Factory :=
    TDocumentRelationSetHolderFactory.Create(
      FDataSetBuilderFactory.CreateDataSetBuilder
    );

end;

function TDocumentDataSetHoldersFactory.CreateDocumentDataSetHolderFactory(
  FactoryType: TClass;
  FactoryCreator: TDocumentDataSetHolderFactoryCreator
): IDataSetHolderFactory;
begin

  Result := IDataSetHolderFactory(FFactories.GetInterface(FactoryType));

  if Assigned(Result) then Exit;

  FactoryCreator(Result);

  FFactories.RegisterInterface(FactoryType, Result);
  
end;

end.


