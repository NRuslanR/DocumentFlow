unit DocumentRelationsInfoQueryBuilder;

interface

uses

  DocumentRelationsInfoHolder,
  DocumentRelationsTableDef,
  SysUtils;

type

  IDocumentRelationsInfoQueryBuilder = interface

    function BuildDocumentRelationsInfoQuery(
      FieldNames: TDocumentRelationsInfoFieldNames;
      DocumentIdParamName: String
    ): String;
    
  end;

  TDocumentRelationsInfoQueryBuilder =
    class (TInterfacedObject, IDocumentRelationsInfoQueryBuilder)

      protected

        FDocumentRelationsTableDef: TDocumentRelationsTableDef;

      public

        constructor Create(DocumentRelationsTableDef: TDocumentRelationsTableDef);
        
        function BuildDocumentRelationsInfoQuery(
          FieldNames: TDocumentRelationsInfoFieldNames;
          DocumentIdParamName: String
        ): String; virtual; abstract;

    end;

implementation

{ TDocumentRelationsInfoQueryBuilder }

constructor TDocumentRelationsInfoQueryBuilder.Create(
  DocumentRelationsTableDef: TDocumentRelationsTableDef
);
begin

  inherited Create;

  FDocumentRelationsTableDef := DocumentRelationsTableDef;

end;

end.
