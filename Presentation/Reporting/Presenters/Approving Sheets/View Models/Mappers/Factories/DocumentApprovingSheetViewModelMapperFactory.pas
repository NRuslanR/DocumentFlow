unit DocumentApprovingSheetViewModelMapperFactory;

interface

uses

  DataSetBuilderFactory,
  DocumentApprovingSheetViewModelMapper,
  SysUtils;
  
type

  TDocumentApprovingSheetViewModelMapperFactory = class

    protected

      FDataSetBuilderFactory: IDataSetBuilderFactory;

      function GetDocumentApprovingSheetViewModelMapperClass:
        TDocumentApprovingSheetViewModelMapperClass; virtual;
        
    public

      constructor Create(DataSetBuilderFactory: IDataSetBuilderFactory);
      
      function CreateDocumentApprovingSheetViewModelMapper:
        TDocumentApprovingSheetViewModelMapper; virtual;
    
  end;

implementation

{ TDocumentApprovingSheetViewModelMapperFactory }

constructor TDocumentApprovingSheetViewModelMapperFactory.Create(
  DataSetBuilderFactory: IDataSetBuilderFactory
);
begin

  inherited Create;

  FDataSetBuilderFactory := DataSetBuilderFactory;

end;

function TDocumentApprovingSheetViewModelMapperFactory.
  CreateDocumentApprovingSheetViewModelMapper: TDocumentApprovingSheetViewModelMapper;
begin

  Result :=
    GetDocumentApprovingSheetViewModelMapperClass.Create(
      FDataSetBuilderFactory.CreateDataSetBuilder
    );

end;

function TDocumentApprovingSheetViewModelMapperFactory.
  GetDocumentApprovingSheetViewModelMapperClass: TDocumentApprovingSheetViewModelMapperClass;
begin

  Result := TDocumentApprovingSheetViewModelMapper;

end;

end.
